import React, { useState, useEffect } from 'react'
import axios from 'axios'

const SalesDashboard = () => {
  const [salesData, setSalesData] = useState({
    todaySales: 0,
    todayRevenue: 0,
    totalProducts: 0
  })
  const [recentSales, setRecentSales] = useState([])

  useEffect(() => {
    fetchSalesData()
  }, [])

  const fetchSalesData = async () => {
    try {
      // Mock data for demonstration
      setSalesData({
        todaySales: 15,
        todayRevenue: 12500,
        totalProducts: 45
      })
      
      setRecentSales([
        { id: 1, product: 'Basmati Rice', quantity: 2, amount: 170, time: '10:30 AM' },
        { id: 2, product: 'Sunflower Oil', quantity: 1, amount: 180, time: '11:15 AM' },
        { id: 3, product: 'Wheat Atta', quantity: 3, amount: 135, time: '12:00 PM' }
      ])
    } catch (error) {
      console.error('Error fetching sales data:', error)
    }
  }

  return (
    <div className="grid grid-2">
      <div className="card">
        <h3>Today's Overview</h3>
        <div className="stats-grid">
          <div className="stat-card">
            <div className="stat-label">Today's Sales</div>
            <div className="stat-value">{salesData.todaySales}</div>
          </div>
          <div className="stat-card">
            <div className="stat-label">Revenue</div>
            <div className="stat-value">₹{salesData.todayRevenue}</div>
          </div>
          <div className="stat-card">
            <div className="stat-label">Products</div>
            <div className="stat-value">{salesData.totalProducts}</div>
          </div>
        </div>
      </div>

      <div className="card">
        <h3>Recent Sales</h3>
        <table className="data-table">
          <thead>
            <tr>
              <th>Product</th>
              <th>Qty</th>
              <th>Amount</th>
              <th>Time</th>
            </tr>
          </thead>
          <tbody>
            {recentSales.map(sale => (
              <tr key={sale.id}>
                <td>{sale.product}</td>
                <td>{sale.quantity}</td>
                <td>₹{sale.amount}</td>
                <td>{sale.time}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  )
}

export default SalesDashboard
