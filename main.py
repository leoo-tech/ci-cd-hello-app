from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "A automação é uma miragem. Ela parece distante, mas com paciência e dedicação, você pode alcançá-la."}
