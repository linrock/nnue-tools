from glob import glob
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import uvicorn


app = FastAPI()

@app.get('/', response_class=HTMLResponse)
def list_experiments():
    experiments_list = glob('easy-train-data/experiments/*')
    return f'''
    <html>
        <body>
            <ul>
                {''.join([f'<li>{experiment}</li>' for experiment in experiments_list])}
            </ul>
        </body>
    </html>
    '''


if __name__ == "__main__":
    uvicorn.run('api:app', host="127.0.0.1", port=58000, reload=True)
