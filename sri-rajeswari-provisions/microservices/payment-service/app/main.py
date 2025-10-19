from fastapi import FastAPI

app = FastAPI(title="Payment Service")

@app.get("/")
def root():
    return {"message": "Payment Service - Sri Rajeswari Provisions"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
