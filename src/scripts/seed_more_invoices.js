const db = require('../db')

function randInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min
}

async function seed() {
  try {
    const [empresas] = await db.query('SELECT id_empresa FROM empresas')
    const [productos] = await db.query('SELECT id_producto, precio FROM productos')
    if (!productos || productos.length === 0) {
      console.log('No hay productos para crear facturas. Ejecuta normalize_db primero.')
      process.exit(1)
    }

    // detect detalle_factura columns
    const [detailCols] = await db.query('SHOW COLUMNS FROM detalle_factura')
    const detailFields = new Set(detailCols.map(d => d.Field))
    const hasImpuesto = detailFields.has('impuesto')
    const hasTotalLinea = detailFields.has('total_linea')
    const hasPrecioUnitario = detailFields.has('precio_unitario')

    for (const e of empresas) {
      const idE = e.id_empresa
      // obtener clientes de la empresa o crear uno si none
      const [clients] = await db.query('SELECT id_cliente FROM clientes WHERE id_empresa=?', [idE])
      let clientIds = clients.map(c => c.id_cliente)
      if (clientIds.length === 0) {
        const [r] = await db.query('INSERT INTO clientes(id_empresa,nombre,documento,direccion,telefono,email) VALUES (?,?,?,?,?,?)', [idE, `Cliente Empresa ${idE}`, `D-${randInt(1000,9999)}`, 'Dir', '3000000000', `c${idE}@test.com`])
        clientIds = [r.insertId]
      }

      // crear 5 facturas por empresa
      for (let i = 0; i < 5; i++) {
        const idC = clientIds[randInt(0, clientIds.length - 1)]
        await db.query('INSERT INTO facturas(id_empresa,id_cliente,fecha,estado,subtotal,total_impuestos,total) VALUES (?,?,DATE_SUB(CURDATE(), INTERVAL ? DAY),?,?,?,?)', [idE, idC, randInt(0, 90), 'emitida', 0, 0, 0])
        const [fres] = await db.query('SELECT LAST_INSERT_ID() AS id')
        const idF = fres[0].id

        // agregar 1-4 lineas
        const lines = randInt(1, 4)
        let subtotal = 0
        let total = 0
        for (let l = 0; l < lines; l++) {
          const prod = productos[randInt(0, productos.length - 1)]
          const cantidad = randInt(1, 5)
          const pu = Number(prod.precio)
          const impuesto = pu * 0.19
          const totalLinea = (pu + impuesto) * cantidad

          try {
            if (hasImpuesto && hasTotalLinea && hasPrecioUnitario) {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario,impuesto,total_linea) VALUES (?,?,?,?,?,?)', [idF, prod.id_producto, cantidad, pu, 19, totalLinea])
            } else if (hasTotalLinea && hasPrecioUnitario) {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario,total_linea) VALUES (?,?,?,?,?)', [idF, prod.id_producto, cantidad, pu, totalLinea])
            } else if (hasPrecioUnitario) {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario) VALUES (?,?,?,?)', [idF, prod.id_producto, cantidad, pu])
            } else {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad) VALUES (?,?,?)', [idF, prod.id_producto, cantidad])
            }
          } catch (err) {
            console.warn('Error insert detalle:', err.message)
          }

          subtotal += pu * cantidad
          total += totalLinea
        }

        const impuestos = total - subtotal
        await db.query('UPDATE facturas SET subtotal=?, total_impuestos=?, total=? WHERE id_factura=?', [subtotal, impuestos, total, idF])
        console.log(`Empresa ${idE} -> factura ${idF} creada (subtotal=${subtotal.toFixed(2)} total=${total.toFixed(2)})`)
      }
    }

    console.log('Seed completo.')
    process.exit(0)
  } catch (err) {
    console.error('Error en seed_more_invoices:', err.message)
    process.exit(1)
  }
}

seed()
