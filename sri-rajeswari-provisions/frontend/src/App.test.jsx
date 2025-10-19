import { render, screen } from '@testing-library/react'
import { BrowserRouter } from 'react-router-dom'
import App from './App'

test('renders Sri Rajeswari Provisions header', () => {
    render(
        <BrowserRouter>
            <App />
        </BrowserRouter>
    )
    const headerElement = screen.getByText(/Sri Rajeswari Provisions/i)
    expect(headerElement).toBeInTheDocument()
})
