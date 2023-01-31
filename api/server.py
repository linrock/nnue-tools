from glob import glob
from fastapi import FastAPI
from fastapi.responses import HTMLResponse
import uvicorn


app = FastAPI()

@app.get('/')
def list_experiments():
    return glob('easy-train-data/experiments/*')


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=58000)
