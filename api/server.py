from datetime import datetime, timedelta
from glob import glob
import os

from fastapi import FastAPI, HTTPException
from fastapi.responses import HTMLResponse, Response
import uvicorn

from ordo_graphs import ordo_plot_png_image


API_KEY = '4d60dd83233bfade6fa30c4ec16aa033'  # import secrets; secrets.token_hex(16)
app = FastAPI()


def experiment_path(exp_name: str):
    return f'../easy-train-data/experiments/{exp_name}'


@app.get('/experiments', response_class=HTMLResponse)
def list_experiments(api_key: str = ''):
    if api_key != API_KEY:
        return "Unauthorized"
    experiments = []
    for exp in glob('../easy-train-data/experiments/*'):
        exp_name = exp.split('/')[-1]
        exp_last_modified = os.path.getmtime(f'{experiment_path(exp_name)}/training/out.pgn')
        experiments.append({
            'name': exp_name,
            'last_updated': exp_last_modified,
            'last_updated_str': datetime.fromtimestamp(exp_last_modified).strftime("%b %-d")
        })
    experiments = sorted(experiments, key=lambda exp: -exp['last_updated'])
    experiment_rows_html = []
    recent_experiments_html = []
    for exp in experiments:
        exp_name = exp['name']
        experiment_rows_html.append(f'''
            <li class="exp-link"><a href="{exp_name}">{exp_name}</a> {exp['last_updated_str']}</li>
        ''')
        if datetime.now() - timedelta(days = 3) < datetime.fromtimestamp(exp['last_updated']):
            with open(f'{experiment_path(exp_name)}/training/ordo.out', 'r') as f:
                ordo_out = '\n'.join(f.read().split("\n")[:20])
            recent_experiments_html.append(f'''
                <li>
                    <h4>{exp_name}</h4>
                    <pre>{ordo_out}</pre>
                </li>
            ''')
    return f'''
    <html lang="en">
        <head><style>body {{ font-family: Helvetica; }} .exp-link {{ line-height: 1.2rem; }}</style></head>
        <body>
            <h3>Experiments</h3>
            <ul>
                {''.join(experiment_rows_html)}
            </ul>
            <h3>Recent experiments</h3>
            <img src="/graphs?api_key={api_key}" />
            <ul>
                {''.join(recent_experiments_html)}
            </ul>
        </body>
    </html>
    '''


@app.get('/graphs')
def recent_experiment_graphs(api_key: str = ''):
    if api_key != API_KEY:
        return "Unauthorized"
    experiments = []
    for exp in glob('../easy-train-data/experiments/*'):
        exp_name = exp.split('/')[-1]
        exp_last_modified = os.path.getmtime(f'{experiment_path(exp_name)}/training/out.pgn')
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
    uvicorn.run('server:app', host="127.0.0.1", port=58000, reload=True)
