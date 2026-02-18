const db = require('../db')

// Total de facturación por empresa
exports.totalPorEmpresa = async (req, res) => {
  try {
    const { id } = req.params;
    // Intento 1: usar columnas totals en facturas
    try {
      const [r] = await db.query(
        'SELECT SUM(subtotal) AS subtotal, SUM(total_impuestos) AS impuestos, SUM(total) AS total FROM facturas WHERE id_empresa=?',
        [id]
      );
      // Si devuelve valores (aunque 0) lo retornamos
      if (r && r[0] && (r[0].total !== null || r[0].subtotal !== null || r[0].impuestos !== null)) {
        return res.json(r[0]);
      }
    } catch (err) {
      // seguir a siguientes métodos
    }

    // Intento 2: sumar desde detalle_factura (total_linea)
    try {
      const [r2] = await db.query(
        `SELECT
           COALESCE(SUM(df.total_linea),0) AS total,
           COALESCE(SUM(df.precio_unitario * df.cantidad),0) AS subtotal
         FROM detalle_factura df
         JOIN facturas f ON f.id_factura = df.id_factura
         WHERE f.id_empresa = ?`,
        [id]
      );
      if (r2 && r2[0]) {
        const total = Number(r2[0].total || 0);
        const subtotal = Number(r2[0].subtotal || 0);
        const impuestos = total - subtotal;
        return res.json({ subtotal, impuestos, total });
      }
    } catch (err) {
      // seguir
    }

    // Intento 3: fallback: contar facturas
    const [r3] = await db.query('SELECT COUNT(*) AS total_facturas FROM facturas WHERE id_empresa=?', [id]);
    return res.json({ warning: 'No se pudo calcular totales; retornando conteo de facturas', data: r3[0] });
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
};

exports.getById = async (req, res) => {
  const [r] = await db.query('SELECT * FROM facturas WHERE id_factura=?', [req.params.id])
  res.json(r[0])
}

// Detalle relacional: factura + cliente + empresa + detalle con producto
exports.getDetalle = async (req, res) => {
  try {
    const id = req.params.id;
    const [[factura]] = await db.query(
      'SELECT f.*, c.nombre AS cliente_nombre, e.nombre AS empresa_nombre FROM facturas f JOIN clientes c ON f.id_cliente=c.id_cliente JOIN empresas e ON f.id_empresa=e.id_empresa WHERE f.id_factura=?',
      [id]
    );

    if (!factura) return res.status(404).json({ error: 'Factura no encontrada' });

    const [detalles] = await db.query(
      'SELECT df.*, p.nombre AS producto_nombre, p.precio AS producto_precio FROM detalle_factura df JOIN productos p ON df.id_producto=p.id_producto WHERE df.id_factura=?',
      [id]
    );

    res.json({ factura, detalles });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}
exports.update = async (req, res) => {
  const { id_empresa, id_cliente, fecha, subtotal, total_impuestos, total } = req.body
  await db.query(
    'UPDATE facturas SET id_empresa=?,id_cliente=?,fecha=?,subtotal=?,total_impuestos=?,total=? WHERE id_factura=?',
    [id_empresa, id_cliente, fecha, subtotal, total_impuestos, total, req.params.id]
  )
  res.json({ ok: true })
}

exports.remove = async (req, res) => {
  // eliminar detalle antes de la factura
  await db.query('DELETE FROM detalle_factura WHERE id_factura=?', [req.params.id])
  await db.query('DELETE FROM facturas WHERE id_factura=?', [req.params.id])
  res.json({ ok: true })
}

exports.getAll = async (req, res) => {
  try {
    // Soporte de filtros por query params: estado, id_empresa, desde, hasta
    const filters = []
    const params = []

    if (req.query.estado) {
      filters.push('estado = ?')
      params.push(req.query.estado)
    }
    if (req.query.id_empresa) {
      filters.push('id_empresa = ?')
      params.push(req.query.id_empresa)
    }
    if (req.query.desde) {
      filters.push('fecha >= ?')
      params.push(req.query.desde)
    }
    if (req.query.hasta) {
      filters.push('fecha <= ?')
      params.push(req.query.hasta)
    }

    const where = filters.length ? (' WHERE ' + filters.join(' AND ')) : ''
    const sql = `SELECT * FROM facturas${where}`
    const [r] = await db.query(sql, params)
    res.json(r)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.byEmpresa = async (req, res) => {
  try {
    const [r] = await db.query('SELECT * FROM facturas WHERE id_empresa=?', [req.params.id])
    if (r && r.length) return res.json(r)

    // Si no hay facturas directas, intentar buscar por join con detalle (por si hay datos en detalle)
    try {
      const [r2] = await db.query(
        'SELECT f.* FROM facturas f JOIN detalle_factura df ON f.id_factura=df.id_factura WHERE f.id_empresa=? GROUP BY f.id_factura',
        [req.params.id]
      )
      return res.json(r2)
    } catch (err) {
      return res.json([])
    }
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.mensual = async (req, res) => {
  try {
    // Intento 1: usar total en facturas
    try {
      const [r] = await db.query('SELECT EXTRACT(MONTH FROM fecha)::int AS mes, SUM(total) AS total FROM facturas GROUP BY EXTRACT(MONTH FROM fecha) ORDER BY mes')
      if (r && r.length) return res.json(r)
    } catch (err) {
      // continuar a siguiente intento
    }

    // Intento 2: sumar por detalle_factura
    try {
      const [r2] = await db.query(
        'SELECT EXTRACT(MONTH FROM f.fecha)::int AS mes, SUM(df.total_linea) AS total FROM facturas f JOIN detalle_factura df ON f.id_factura=df.id_factura GROUP BY EXTRACT(MONTH FROM f.fecha) ORDER BY mes'
      )
      if (r2 && r2.length) return res.json(r2)
    } catch (err) {
      // continuar
    }

    // Intento 3: fallback: conteo por mes
    const [r3] = await db.query('SELECT EXTRACT(MONTH FROM fecha)::int AS mes, COUNT(*) AS total FROM facturas GROUP BY EXTRACT(MONTH FROM fecha) ORDER BY mes')
    return res.json({ warning: 'No se pudo calcular totales; retornando conteo por mes', data: r3 })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.create = async (req, res) => {
  const { id_empresa, id_cliente, detalles } = req.body
  let conn;
  try {
    conn = await db.getConnection();
    await conn.beginTransaction();

    let subtotal = 0;
    let impuestos = 0;

    for (const d of detalles) {
      const [p] = await conn.query('SELECT precio FROM productos WHERE id_producto=?', [d.id_producto]);
      if (!p[0]) throw new Error('Producto no encontrado: ' + d.id_producto);
      const precio = p[0].precio;
      const imp = precio * 0.19;
      subtotal += precio * d.cantidad;
      impuestos += imp * d.cantidad;
    }

    const total = subtotal + impuestos;

    const [f] = await conn.query(
      'INSERT INTO facturas(id_empresa,id_cliente,fecha,subtotal,total_impuestos,total) VALUES (?,?,CURDATE(),?,?,?)',
      [id_empresa, id_cliente, subtotal, impuestos, total]
    );

    for (const d of detalles) {
      const [p] = await conn.query('SELECT precio FROM productos WHERE id_producto=?', [d.id_producto]);
      const precio = p[0].precio;
      const imp = precio * 0.19;
      const totalLinea = (precio + imp) * d.cantidad;

      await conn.query(
        'INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario,impuesto,total_linea) VALUES (?,?,?,?,?,?)',
        [f.insertId, d.id_producto, d.cantidad, precio, 19, totalLinea]
      );
    }

    await conn.commit();
    conn.release();

    res.json({ id_factura: f.insertId, subtotal, impuestos, total });
  } catch (err) {
    if (conn) {
      await conn.rollback();
      conn.release();
    }
    res.status(500).json({ error: err.message });
  }
}

// Facturación mensual por empresa
exports.mensualPorEmpresa = async (req, res) => {
  try {
    const id = req.params.id
    // Intento 1: usar total en facturas
    try {
      const [r] = await db.query('SELECT EXTRACT(MONTH FROM fecha)::int AS mes, SUM(total) AS total FROM facturas WHERE id_empresa = $1 GROUP BY EXTRACT(MONTH FROM fecha) ORDER BY mes', [id])
      if (r && r.length) return res.json(r)
    } catch (err) {
      // continuar
    }

    // Intento 2: sumar por detalle_factura
    try {
      const [r2] = await db.query(
        'SELECT EXTRACT(MONTH FROM f.fecha)::int AS mes, SUM(df.total_linea) AS total FROM facturas f JOIN detalle_factura df ON f.id_factura=df.id_factura WHERE f.id_empresa = $1 GROUP BY EXTRACT(MONTH FROM f.fecha) ORDER BY mes',
        [id]
      )
      if (r2 && r2.length) return res.json(r2)
    } catch (err) {
      // continuar
    }

    // Fallback: conteo por mes
    const [r3] = await db.query('SELECT EXTRACT(MONTH FROM fecha)::int AS mes, COUNT(*) AS total FROM facturas WHERE id_empresa = $1 GROUP BY EXTRACT(MONTH FROM fecha) ORDER BY mes', [id])
    return res.json({ warning: 'No se pudo calcular totales; retornando conteo por mes', data: r3 })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}