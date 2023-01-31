from datetime import datetime
from glob import glob
import os

from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import uvicorn


app = FastAPI()

@app.get('/', response_class=HTMLResponse)
def list_experiments():
    experiments = []
    for exp in glob('easy-train-data/experiments/*'):
        exp_name = exp.split('/')[-1]
        exp_last_modified = os.path.getmtime(f'easy-train-data/experiments/{exp_name}/training/out.pgn')
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
            <li><a href="{exp_name}">{exp_name}</a> {exp['last_updated_str']}</li>
        ''')
        print(datetime.now() - timedelta(days = 3))
        print(datetime.fromtimestamp(exp['last_updated']))
        if datetime.now() - timedelta(days = 3) < datetime.fromtimestamp(exp['last_updated']):
            with open(f'easy-train-data/experiments/{exp_name}/training/ordo.out', 'r') as f:
                ordo_out = f.read()
            recent_experiments_html.append(f'''
                <li>
                    <h4>{exp_name}</h4>
                    <pre>{ordo_out}</pre>
                </li>
            ''')
    return f'''
    <html>
        <body>
            <h3>Experiments</h3>
            <ul>
                {''.join(experiment_rows_html)}
            </ul>
            <h3>Recent experiments</h3>
            <ul>
                {''.join(recent_experiments_html)}
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
