const db = require('../db')

exports.getAll = async (req, res) => {
  try {
    const [r] = await db.query('SELECT * FROM empresas')
    res.json(r)
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.getById = async (req, res) => {
  try {
    const [r] = await db.query('SELECT * FROM empresas WHERE id_empresa=?', [req.params.id])
    res.json(r[0])
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.create = async (req, res) => {
  try {
    const { nombre, nit, direccion, telefono, email } = req.body
    const [r] = await db.query(
      'INSERT INTO empresas(nombre,nit,direccion,telefono,email) VALUES (?,?,?,?,?)',
      [nombre, nit, direccion, telefono, email]
    )
    res.json({ id: r.insertId })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.update = async (req, res) => {
  try {
    const { nombre, nit, direccion, telefono, email } = req.body
    await db.query(
      'UPDATE empresas SET nombre=?,nit=?,direccion=?,telefono=?,email=? WHERE id_empresa=?',
      [nombre, nit, direccion, telefono, email, req.params.id]
    )
    res.json({ ok: true })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}

exports.remove = async (req, res) => {
  try {
    await db.query('DELETE FROM empresas WHERE id_empresa=?', [req.params.id])
    res.json({ ok: true })
  } catch (err) {
    res.status(500).json({ error: err.message })
  }
}