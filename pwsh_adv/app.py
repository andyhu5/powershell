from fastapi import FastAPI
from fastapi.responses import FileResponse
import uvicorn


app = FastAPI()
@app.get("/")
async def root():
    # return file main.ps1
    return {"message": "Hello World"}
@app.get("/hello")
async def hello():
    return FileResponse("main.ps1", media_type="text/plain", filename="main.ps1")

@app.get("/dll")
async def dll():
    return FileResponse("Hello.dll", media_type="application/octet-stream", filename="Hello.dll")

# run app
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
    