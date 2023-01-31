from datetime import datetime
from glob import glob
import os

from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import uvicorn


app = FastAPI()

@app.get('/', response_class=HTMLResponse)
def list_experiments():
    experiments_list = glob('easy-train-data/experiments/*')
    experiments = []
    experiment_rows = []
    for exp in experiments_list:
        exp_name = exp.split('/')[-1]
        exp_last_modified = os.path.getmtime(f'easy-train-data/experiments/{exp_name}/training/out.pgn')
        experiments.append({
            'name': exp_name,
            'last_updated': exp_last_modified,
            'last_updated_str': datetime.fromtimestamp(exp_last_modified).strftime("%b %-d")
        })
    experiments = sorted(experiments, key=lambda exp: -exp['last_updated'])
    for exp in experiments:
        experiment_rows.append(f'''
            <li><a href="{exp['name']}">{exp['name']}</a> {exp['last_updated_str']}</li>
        ''')
    return f'''
    <html>
        <body>
            <h3>Experiments</h3>
            <ul>
                {''.join(experiment_rows)}
            </ul>
        </body>
    </html>
    '''

@app.get('/{exp_name}', response_class=HTMLResponse)
def view_experiment(exp_name: str):
    with open(f'easy-train-data/experiments/{exp_name}/training/ordo.out', 'r') as f:
        ordo_out = f.read()
    return f'''
    <html>
        <body>
            <h3>Experiment</h3>
            <h4>{exp_name}</h4>
            <pre>{ordo_out}</pre>
        </body>
    </html>
    '''


if __name__ == "__main__":
    uvicorn.run('api:app', host="127.0.0.1", port=58000, reload=True)
