const db = require('../db')

exports.getAll = async (req, res) => {
  try {
    const [r] = await db.query('SELECT * FROM clientes')
    res.json(r)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.getById = async (req, res) => {
  try {
    const [r] = await db.query('SELECT * FROM clientes WHERE id_cliente=?', [req.params.id])
    res.json(r[0])
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.create = async (req, res) => {
  try {
    const { id_empresa, nombre, documento, direccion, telefono, email } = req.body
    const [r] = await db.query(
      'INSERT INTO clientes(id_empresa,nombre,documento,direccion,telefono,email) VALUES (?,?,?,?,?,?)',
      [id_empresa, nombre, documento, direccion, telefono, email]
    )
    res.json({ id: r.insertId })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.update = async (req, res) => {
  try {
    const { id_empresa, nombre, documento, direccion, telefono, email } = req.body
    await db.query(
      'UPDATE clientes SET id_empresa=?,nombre=?,documento=?,direccion=?,telefono=?,email=? WHERE id_cliente=?',
      [id_empresa, nombre, documento, direccion, telefono, email, req.params.id]
    )
    res.json({ ok: true })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.remove = async (req, res) => {
  try {
    await db.query('DELETE FROM clientes WHERE id_cliente=?', [req.params.id])
    res.json({ ok: true })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}