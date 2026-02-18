const db = require('../db')

async function seedIfEmpty() {
  // Añadir productos de ejemplo si no existen
  const [pCount] = await db.query('SELECT COUNT(*) AS c FROM productos')
  if (pCount[0].c == 0) {
    console.log('Insertando productos de ejemplo...')
    await db.query("INSERT INTO productos(nombre,descripcion,precio) VALUES ?", [[
      ['Laptop','Laptop de prueba',3200000.00],
      ['Monitor','Monitor 24"',600000.00],
      ['Mouse','Mouse óptico',25000.00]
    ]])
  }

  // Añadir empresa/cliente ejemplo si no existen
  const [eCount] = await db.query('SELECT COUNT(*) AS c FROM empresas')
  if (eCount[0].c == 0) {
    console.log('Insertando empresa y cliente de ejemplo...')
    const [er] = await db.query("INSERT INTO empresas(nombre,nit,direccion,telefono,email) VALUES (?,?,?,?,?)", ['Seed Co','900000000-0','Seed','3000000000','seed@mail.com'])
    const idE = er.insertId
    await db.query("INSERT INTO clientes(id_empresa,nombre,documento,direccion,telefono,email) VALUES (?,?,?,?,?,?)", [idE,'Cliente Seed','5000','Dir','312312','c@seed.com'])
  }
}

async function normalize() {
  try {
    await seedIfEmpty()

    // Asegurar que las columnas necesarias existan en facturas
    const [cols] = await db.query("SHOW COLUMNS FROM facturas")
    const colNames = new Set(cols.map(c => c.Field))
    if (!colNames.has('subtotal')) {
      console.log('Agregando columna subtotal a facturas...')
      await db.query('ALTER TABLE facturas ADD COLUMN subtotal DECIMAL(12,2) DEFAULT 0')
    }
    if (!colNames.has('total_impuestos')) {
      console.log('Agregando columna total_impuestos a facturas...')
      await db.query('ALTER TABLE facturas ADD COLUMN total_impuestos DECIMAL(12,2) DEFAULT 0')
    }
    if (!colNames.has('total')) {
      console.log('Agregando columna total a facturas...')
      await db.query('ALTER TABLE facturas ADD COLUMN total DECIMAL(12,2) DEFAULT 0')
    }

    console.log('Normalizando totales de facturas a partir de detalle_factura...')

    // Obtener todas las facturas
    const [facturas] = await db.query('SELECT id_factura FROM facturas')

    // Cache de precios de productos
    const productPriceCache = new Map()

    for (const f of facturas) {
      const id = f.id_factura
      // Traer todos los campos que existan en detalle_factura
      const [detalles] = await db.query('SELECT * FROM detalle_factura WHERE id_factura=?', [id])
      if (!detalles || detalles.length === 0) continue

      let subtotal = 0
      let total = 0

      for (const d of detalles) {
        const cant = Number(d.cantidad || 0)

        let pu = d.precio_unitario ? Number(d.precio_unitario) : 0

        // Si no hay precio unitario buscar en productos por id_producto
        if ((!pu || pu === 0) && d.id_producto) {
          if (productPriceCache.has(d.id_producto)) {
            pu = productPriceCache.get(d.id_producto)
          } else {
            const [pp] = await db.query('SELECT precio FROM productos WHERE id_producto=?', [d.id_producto])
            const found = pp && pp[0] && pp[0].precio ? Number(pp[0].precio) : 0
            productPriceCache.set(d.id_producto, found)
            pu = found
          }
        }

        let tl = d.total_linea ? Number(d.total_linea) : 0
        if (!tl) {
          if (pu && pu > 0) {
            const imp = pu * 0.19
            tl = (pu + imp) * cant
          } else {
            // como último recurso asumir 0
            tl = 0
          }
        }

        if (pu && pu > 0) subtotal += pu * cant
        total += tl
      }

      const impuestos = total - subtotal
      await db.query('UPDATE facturas SET subtotal=?, total_impuestos=?, total=? WHERE id_factura=?', [subtotal, impuestos, total, id])
      console.log(`Factura ${id} -> subtotal=${subtotal.toFixed(2)} impuestos=${impuestos.toFixed(2)} total=${total.toFixed(2)}`)
    }

    // Crear una factura ejemplo si no hay muchas
    const [countRes] = await db.query('SELECT COUNT(*) AS c FROM facturas')
    if (countRes[0].c < 5) {
      console.log('Insertando facturas de prueba adicionales...')
        // obtener ids de empresa, cliente y producto para crear facturas
        const [e] = await db.query('SELECT id_empresa FROM empresas LIMIT 1')
        const [c] = await db.query('SELECT id_cliente FROM clientes LIMIT 1')
        const [prod] = await db.query('SELECT id_producto, precio FROM productos LIMIT 3')
        if (e.length && c.length && prod.length) {
          const idE = e[0].id_empresa
          const idC = c[0].id_cliente

          // detectar columnas de detalle_factura para usar el INSERT correcto
          const [detailCols] = await db.query('SHOW COLUMNS FROM detalle_factura')
          const detailFields = new Set(detailCols.map(d => d.Field))
          const hasImpuesto = detailFields.has('impuesto')
          const hasTotalLinea = detailFields.has('total_linea')
          const hasPrecioUnitario = detailFields.has('precio_unitario')

          for (let i = 0; i < 3; i++) {
            await db.query('INSERT INTO facturas(id_empresa,id_cliente,fecha,estado,subtotal,total_impuestos,total) VALUES (?,?,CURDATE(),?,?,?,?)', [idE, idC, 'emitida', 0, 0, 0])
            const [f2] = await db.query('SELECT LAST_INSERT_ID() AS id')
            const idF = f2[0].id
            // insertar 1-2 detalles
            const p = prod[i % prod.length]
            const pu = Number(p.precio)
            const cantidad = i + 1
            const imp = pu * 0.19
            const totalLinea = (pu + imp) * cantidad

            if (hasImpuesto && hasTotalLinea && hasPrecioUnitario) {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario,impuesto,total_linea) VALUES (?,?,?,?,?,?)', [idF, p.id_producto, cantidad, pu, 19, totalLinea])
            } else if (hasTotalLinea && hasPrecioUnitario) {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario,total_linea) VALUES (?,?,?,?,?)', [idF, p.id_producto, cantidad, pu, totalLinea])
            } else if (hasPrecioUnitario) {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario) VALUES (?,?,?,?)', [idF, p.id_producto, cantidad, pu])
            } else {
              await db.query('INSERT INTO detalle_factura(id_factura,id_producto,cantidad) VALUES (?,?,?)', [idF, p.id_producto, cantidad])
            }
          }
        }
    }

    console.log('Segundo pase de normalización después de insertar facturas de prueba...')
    // Re-run normalization to update newly creadas
    const [facturas2] = await db.query('SELECT id_factura FROM facturas')
    for (const f of facturas2) {
      const id = f.id_factura
      const [detalles] = await db.query('SELECT * FROM detalle_factura WHERE id_factura=?', [id])
      if (!detalles || detalles.length === 0) continue

      let subtotal = 0
      let total = 0
      for (const d of detalles) {
        const cant = Number(d.cantidad || 0)
        let pu = d.precio_unitario ? Number(d.precio_unitario) : 0
        if ((!pu || pu === 0) && d.id_producto) {
          if (productPriceCache.has(d.id_producto)) {
            pu = productPriceCache.get(d.id_producto)
          } else {
            const [pp] = await db.query('SELECT precio FROM productos WHERE id_producto=?', [d.id_producto])
            const found = pp && pp[0] && pp[0].precio ? Number(pp[0].precio) : 0
            productPriceCache.set(d.id_producto, found)
            pu = found
          }
        }
        let tl = d.total_linea ? Number(d.total_linea) : 0
        if (!tl) {
          if (pu && pu > 0) {
            const imp = pu * 0.19
            tl = (pu + imp) * cant
          } else {
            tl = 0
          }
        }
        if (pu && pu > 0) subtotal += pu * cant
        total += tl
      }
      const impuestos = total - subtotal
      await db.query('UPDATE facturas SET subtotal=?, total_impuestos=?, total=? WHERE id_factura=?', [subtotal, impuestos, total, id])
    }

    console.log('Normalización completada.')
    process.exit(0)
  } catch (err) {
    console.error('Error normalizando DB:', err.message)
    process.exit(1)
  }
}

normalize()
