from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime

app = FastAPI(title="Sales Service")

class Sale(BaseModel):
    id: int
    product_id: int
    quantity: int
    amount: float
    sale_date: datetime

@app.get("/")
def root():
    return {"message": "Sales Service - Sri Rajeswari Provisions"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
