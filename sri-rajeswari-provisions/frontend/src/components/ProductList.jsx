import React, { useState, useEffect } from 'react'
import axios from 'axios'

const ProductList = () => {
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchProducts()
  }, [])

  const fetchProducts = async () => {
    try {
      const response = await axios.get('/api/products')
      setProducts(response.data)
    } catch (error) {
      console.error('Error fetching products:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return <div className="text-center">Loading products...</div>
  }

  return (
    <div className="product-grid">
      {products.map(product => (
        <div key={product.id} className="product-card">
          <div className="product-name">{product.name}</div>
          <div className="product-category" style={{ color: '#666', fontSize: '0.9rem' }}>
            {product.category}
          </div>
          <div className="product-price">₹{product.price}</div>
          <div className={`product-stock ${product.stock_quantity <= product.min_stock_level ? 'stock-low' : ''}`}>
            Stock: {product.stock_quantity} {product.unit}
          </div>
          {product.stock_quantity <= product.min_stock_level && (
            <div style={{ color: '#dc2626', fontWeight: 'bold', fontSize: '0.8rem' }}>
              ⚠️ Low Stock Alert!
            </div>
          )}
        </div>
      ))}
    </div>
  )
}

export default ProductList
