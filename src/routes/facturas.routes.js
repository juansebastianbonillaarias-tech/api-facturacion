const router = require('express').Router()
const c = require('../controllers/facturas.controller')

router.get('/', c.getAll)
router.get('/empresa/:id', c.byEmpresa)
router.get('/empresa/:id/total', c.totalPorEmpresa)
router.get('/empresa/:id/mensual', c.mensualPorEmpresa)
router.get('/mensual', c.mensual)
router.get('/:id/detalle', c.getDetalle)
router.get('/:id', c.getById)
router.put('/:id', c.update)
router.delete('/:id', c.remove)
router.post('/', c.create)

module.exports = router