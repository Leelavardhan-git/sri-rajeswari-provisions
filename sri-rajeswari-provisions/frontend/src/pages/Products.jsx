import React from 'react'
import ProductList from '../components/ProductList'

const Products = () => {
  return (
    <div>
      <h1 style={{ marginBottom: '20px', color: 'white' }}>Products Management</h1>
      <div className="card">
        <ProductList />
      </div>
    </div>
  )
}

export default Products
