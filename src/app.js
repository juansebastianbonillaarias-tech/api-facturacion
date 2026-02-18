const express = require('express')
const cors = require('cors')
require('dotenv').config()

const app = express()
app.use(cors())
app.use(express.json())

// Health check
app.get('/health', (req, res) => res.json({ ok: true }))

// Root: información mínima y accesos rápidos a endpoints
app.get('/', (req, res) => {
	res.json({
		ok: true,
		message: 'API de Facturación',
		endpoints: {
			health: '/health',
			empresas: '/empresas',
			clientes: '/clientes',
			facturas: '/facturas'
		}
	})
})

app.use('/empresas', require('./routes/empresas.routes'))
app.use('/clientes', require('./routes/clientes.routes'))
app.use('/facturas', require('./routes/facturas.routes'))

module.exports = app