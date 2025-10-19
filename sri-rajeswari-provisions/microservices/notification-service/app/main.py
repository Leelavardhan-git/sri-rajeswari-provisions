from fastapi import FastAPI

app = FastAPI(title="Notification Service")

@app.get("/")
def root():
    return {"message": "Notification Service - Sri Rajeswari Provisions"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
