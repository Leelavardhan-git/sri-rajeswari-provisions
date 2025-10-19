from fastapi import FastAPI

app = FastAPI(title="Customer Service")

@app.get("/")
def root():
    return {"message": "Customer Service - Sri Rajeswari Provisions"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
