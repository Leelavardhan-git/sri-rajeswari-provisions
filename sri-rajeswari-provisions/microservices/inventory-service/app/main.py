from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import List

app = FastAPI(title="Inventory Service")

class Product(BaseModel):
    id: int
    name: str
    category: str
    price: float
    stock: int

products_db = [
    {"id": 1, "name": "Basmati Rice", "category": "Rice", "price": 85.0, "stock": 100},
    {"id": 2, "name": "Sunflower Oil", "category": "Oil", "price": 180.0, "stock": 50}
]

@app.get("/")
def root():
    return {"message": "Inventory Service - Sri Rajeswari Provisions"}

@app.get("/products", response_model=List[Product])
def get_products():
    return products_db

@app.get("/products/{product_id}")
def get_product(product_id: int):
    product = next((p for p in products_db if p["id"] == product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

@app.get("/health")
def health_check():
    return {"status": "healthy"}
