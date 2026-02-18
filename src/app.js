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
			health: { method: 'GET', path: '/health' },

			empresas: {
				list: { method: 'GET', path: '/empresas' },
				get: { method: 'GET', path: '/empresas/:id' },
				create: { method: 'POST', path: '/empresas' },
				update: { method: 'PUT', path: '/empresas/:id' },
				delete: { method: 'DELETE', path: '/empresas/:id' }
			},

			clientes: {
				list: { method: 'GET', path: '/clientes' },
				get: { method: 'GET', path: '/clientes/:id' },
				create: { method: 'POST', path: '/clientes' },
				update: { method: 'PUT', path: '/clientes/:id' },
				delete: { method: 'DELETE', path: '/clientes/:id' }
			},

			facturas: {
				list: { method: 'GET', path: '/facturas', notes: 'query params: estado,id_empresa,desde,hasta' },
				get: { method: 'GET', path: '/facturas/:id' },
				detalle: { method: 'GET', path: '/facturas/:id/detalle' },
				byEmpresa: { method: 'GET', path: '/facturas/empresa/:id' },
				totalByEmpresa: { method: 'GET', path: '/facturas/empresa/:id/total' },
				mensualByEmpresa: { method: 'GET', path: '/facturas/empresa/:id/mensual' },
				mensual: { method: 'GET', path: '/facturas/mensual' },
				create: { method: 'POST', path: '/facturas', notes: 'JSON body with detalles array' },
				update: { method: 'PUT', path: '/facturas/:id' },
				delete: { method: 'DELETE', path: '/facturas/:id' }
			}
		}
	})
})

app.use('/empresas', require('./routes/empresas.routes'))
app.use('/clientes', require('./routes/clientes.routes'))
app.use('/facturas', require('./routes/facturas.routes'))

module.exports = app