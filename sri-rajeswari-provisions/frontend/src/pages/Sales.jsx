import React, { useState } from 'react'
import axios from 'axios'

const Sales = () => {
  const [saleForm, setSaleForm] = useState({
    productId: '',
    quantity: '',
    customerId: ''
  })

  const handleSaleSubmit = async (e) => {
    e.preventDefault()
    try {
      // Mock sale creation
      alert('Sale recorded successfully!')
      setSaleForm({ productId: '', quantity: '', customerId: '' })
    } catch (error) {
      console.error('Error recording sale:', error)
      alert('Error recording sale')
    }
  }

  return (
    <div>
      <h1 style={{ marginBottom: '20px', color: 'white' }}>Sales Management</h1>
      
      <div className="grid grid-2">
        <div className="card">
          <h3>Record New Sale</h3>
          <form onSubmit={handleSaleSubmit}>
            <div className="form-group">
              <label>Product ID</label>
              <input
                type="number"
                value={saleForm.productId}
                onChange={(e) => setSaleForm({ ...saleForm, productId: e.target.value })}
                required
              />
            </div>
            <div className="form-group">
              <label>Quantity</label>
              <input
                type="number"
                value={saleForm.quantity}
                onChange={(e) => setSaleForm({ ...saleForm, quantity: e.target.value })}
                required
              />
            </div>
            <div className="form-group">
              <label>Customer ID (Optional)</label>
              <input
                type="number"
                value={saleForm.customerId}
                onChange={(e) => setSaleForm({ ...saleForm, customerId: e.target.value })}
              />
            </div>
            <button type="submit" className="btn btn-primary">
              Record Sale
            </button>
          </form>
        </div>

        <div className="card">
          <h3>Sales Analytics</h3>
          <div className="stats-grid">
            <div className="stat-card">
              <div className="stat-label">Today's Revenue</div>
              <div className="stat-value">₹12,500</div>
            </div>
            <div className="stat-card">
              <div className="stat-label">Total Sales</div>
              <div className="stat-value">156</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Sales
