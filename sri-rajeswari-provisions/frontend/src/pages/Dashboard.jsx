import React from 'react'
import SalesDashboard from '../components/SalesDashboard'
import ProductList from '../components/ProductList'

const Dashboard = () => {
  return (
    <div>
      <h1 style={{ marginBottom: '20px', color: 'white' }}>
        Dashboard - Sri Rajeswari Provisions
      </h1>
      <SalesDashboard />
      <div className="card">
        <h2>Products Overview</h2>
        <ProductList />
      </div>
    </div>
  )
}

export default Dashboard
