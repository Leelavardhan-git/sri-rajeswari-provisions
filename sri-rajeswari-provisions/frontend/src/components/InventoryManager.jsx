import React, { useState, useEffect } from 'react'
import axios from 'axios'

const InventoryManager = () => {
  const [lowStockProducts, setLowStockProducts] = useState([])
  const [stockUpdate, setStockUpdate] = useState({ productId: '', quantity: '' })

  useEffect(() => {
    fetchLowStockProducts()
  }, [])

  const fetchLowStockProducts = async () => {
    try {
      const response = await axios.get('/api/low-stock')
      setLowStockProducts(response.data)
    } catch (error) {
      console.error('Error fetching low stock products:', error)
    }
  }

  const handleStockUpdate = async (e) => {
    e.preventDefault()
    try {
      await axios.put(`/api/products/${stockUpdate.productId}/stock`, null, {
        params: { quantity: parseInt(stockUpdate.quantity) }
      })
      alert('Stock updated successfully!')
      setStockUpdate({ productId: '', quantity: '' })
      fetchLowStockProducts()
    } catch (error) {
      console.error('Error updating stock:', error)
      alert('Error updating stock')
    }
  }

  return (
    <div className="grid grid-2">
      <div className="card">
        <h3>Low Stock Alerts</h3>
        {lowStockProducts.length === 0 ? (
          <p>No low stock products 🎉</p>
        ) : (
          <table className="data-table">
            <thead>
              <tr>
                <th>Product</th>
                <th>Current Stock</th>
                <th>Min Required</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {lowStockProducts.map(product => (
                <tr key={product.id}>
                  <td>{product.name}</td>
                  <td>{product.stock_quantity}</td>
                  <td>{product.min_stock_level}</td>
                  <td>
                    <span style={{ color: '#dc2626', fontWeight: 'bold' }}>
                      ⚠️ Reorder Needed
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      <div className="card">
        <h3>Update Stock</h3>
        <form onSubmit={handleStockUpdate}>
          <div className="form-group">
            <label>Product ID</label>
            <input
              type="number"
              value={stockUpdate.productId}
              onChange={(e) => setStockUpdate({ ...stockUpdate, productId: e.target.value })}
              required
            />
          </div>
          <div className="form-group">
            <label>Quantity to Add</label>
            <input
              type="number"
              value={stockUpdate.quantity}
              onChange={(e) => setStockUpdate({ ...stockUpdate, quantity: e.target.value })}
              required
            />
          </div>
          <button type="submit" className="btn btn-primary">
            Update Stock
          </button>
        </form>
      </div>
    </div>
  )
}

export default InventoryManager
