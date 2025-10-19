import React from 'react'
import { Link, useLocation } from 'react-router-dom'

const Header = () => {
  const location = useLocation()

  const isActive = (path) => location.pathname === path

  return (
    <header className="header">
      <nav className="nav">
        <div className="logo">
          🛒 Sri Rajeswari Provisions
        </div>
        <ul className="nav-links">
          <li>
            <Link to="/" className={isActive('/') ? 'active' : ''}>
              Dashboard
            </Link>
          </li>
          <li>
            <Link to="/products" className={isActive('/products') ? 'active' : ''}>
              Products
            </Link>
          </li>
          <li>
            <Link to="/inventory" className={isActive('/inventory') ? 'active' : ''}>
              Inventory
            </Link>
          </li>
          <li>
            <Link to="/sales" className={isActive('/sales') ? 'active' : ''}>
              Sales
            </Link>
          </li>
        </ul>
      </nav>
    </header>
  )
}

export default Header
