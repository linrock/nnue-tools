from datetime import datetime, timedelta
from glob import glob
import hashlib
import os
import re
import socket
import sys

from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import FileResponse, HTMLResponse, Response
from fastapi.templating import Jinja2Templates
import uvicorn

from ordo_graphs import ordo_plot_png_image


API_KEY = '4d60dd83233bfade6fa30c4ec16aa033'  # import secrets; secrets.token_hex(16)
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_credentials=True,
    allow_headers=["*"],
    allow_methods=["get"],
    allow_origins=["*"],
)
templates = Jinja2Templates(directory="./")


def experiment_path(exp_name: str):
    return f'../easy-train-data/experiments/{exp_name}'


@app.get('/experiments', response_class=HTMLResponse)
def list_experiments(request: Request, api_key: str = ''):
    if api_key != API_KEY:
        return "Unauthorized"
    experiments = []
    for exp in glob('../easy-train-data/experiments/*'):
        exp_name = exp.split('/')[-1]
        pgn_file = f'{experiment_path(exp_name)}/training/out.pgn'
        if os.path.isfile(pgn_file):
            exp_last_modified = os.path.getmtime(pgn_file)
            experiments.append({
                'name': exp_name,
                'last_updated': exp_last_modified,
                'last_updated_str': datetime.fromtimestamp(exp_last_modified).strftime("%b %-d"),
                'ordo_rows': [],
            })
    experiments = sorted(experiments, key=lambda exp: -exp['last_updated'])
    recent_experiments = []
    for exp in experiments:
        exp_name = exp['name']
        if datetime.now() - timedelta(days = 3) < datetime.fromtimestamp(exp['last_updated']):
            with open(f'{experiment_path(exp_name)}/training/ordo.out', 'r') as f:
                ordo_out = '\n'.join(f.read().split("\n")[:20])
            ordo_rows = []
            for ordo_row in ordo_out.split('\n'):
                epoch_match = re.search(r'(run_\d/nn-epoch[\d]+\.nnue)', ordo_row)
                if epoch_match:
                    nn_name = epoch_match[0]
                    ordo_rows.append({
                        'nn_name': nn_name,
                        'text': ordo_row
                    })
                else:
                    ordo_rows.append({
                        'text': ordo_row
                    })
            recent_experiments.append({
                'name': exp_name,
                'ordo_rows': ordo_rows
            })
    return templates.TemplateResponse('experiments.jinja', {
        'request': request,
        'server_name': socket.gethostname(),
        'experiments': experiments,
        'recent_experiments': recent_experiments,
        'api_key': api_key,
    })


@app.get('/graphs')
def recent_experiment_graphs(api_key: str = ''):
    if api_key != API_KEY:
        return "Unauthorized"
    experiments = []
    for exp in glob('../easy-train-data/experiments/*'):
        exp_name = exp.split('/')[-1]
        pgn_file = f'{experiment_path(exp_name)}/training/out.pgn'
        if os.path.isfile(pgn_file):
            exp_last_modified = os.path.getmtime(pgn_file)
            experiments.append({
                'name': exp_name,
                'last_updated': exp_last_modified,
                'last_updated_str': datetime.fromtimestamp(exp_last_modified).strftime("%b %-d")
            })
    experiments = sorted(experiments, key=lambda exp: -exp['last_updated'])
    experiment_rows_html = []
    recent_experiments = []
    for exp in experiments:
        exp_name = exp['name']
        experiment_rows_html.append(f'''
            <li class="exp-link"><a href="{exp_name}">{exp_name}</a> {exp['last_updated_str']}</li>
        ''')
        if datetime.now() - timedelta(days = 3) < datetime.fromtimestamp(exp['last_updated']):
            recent_experiments.append(experiment_path(exp_name))
    return Response(content=ordo_plot_png_image(recent_experiments), media_type="image/png")


@app.get('/nn', response_class=HTMLResponse)
def download_nnue_datafile(path: str, api_key: str = ''):
    if api_key != API_KEY:
        return "Unauthorized"
    path_to_nnue = f'../easy-train-data/experiments/{path}'
    if os.path.isfile(path_to_nnue):
        return FileResponse(path_to_nnue,
            media_type='application/octet-stream',
            filename=path.split('/')[-1])
    else:
        raise HTTPException(status_code=404, detail="File not found")


@app.get('/nn-sha256', response_class=HTMLResponse)
def download_nnue_datafile(path: str, api_key: str = ''):
    if api_key != API_KEY:
        return "Unauthorized"
    path_to_nnue = f'../easy-train-data/experiments/{path}'
    if os.path.isfile(path_to_nnue):
        with open(path_to_nnue, 'rb') as f:
            h = hashlib.sha256()
            h.update(bytearray(f.read()))
            sha256 = h.hexdigest()
        return f"nn-{sha256[:12]}.nnue"
    else:
        raise HTTPException(status_code=404, detail="File not found")


@app.get('/favicon.ico')
def return_404():
    raise HTTPException(status_code=404)


@app.get('/{exp_name}', response_class=HTMLResponse)
def view_experiment(exp_name: str, api_key: str = ''):
    if api_key != API_KEY:
        return "Unauthorized"
    with open(f'{experiment_path(exp_name)}/training/ordo.out', 'r') as f:
        ordo_out = f.read()
    return f'''
    <html lang="en">
        <body>
            <h3>Experiment</h3>
            <h4>{exp_name}</h4>
            <pre>{ordo_out}</pre>
        </body>
    </html>
    '''

if __name__ == "__main__":
    host = '127.0.0.1'
    if len(sys.argv) == 2:
        host = sys.argv[1]
    uvicorn.run('server:app', host=host, port=58000, reload=True,
                ssl_keyfile='./key.pem', ssl_certfile='./cert.pem')
