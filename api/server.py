from glob import glob
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import uvicorn


app = FastAPI()

@app.get('/', response_class=HTMLResponse)
def list_experiments():
    experiments_list = glob('easy-train-data/experiments/*')
    experiment_links = []
    for exp in experiments_list:
        exp_name = exp.split('/')[-1]
        experiment_links.append(f'<li><a href="{exp_name}">{exp_name}</a></li>')
    return f'''
    <html>
        <body>
            <h3>Experiments</h3>
            <ul>
                {''.join(experiment_links)}
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
