require('dotenv').config()
const app = require('./app')
const db = require('./db')

const PORT = process.env.PORT || 3000

db.getConnection()
  .then(connection => {
    connection.release()
    app.listen(PORT, () => {
      console.log(`Servidor corriendo en puerto ${PORT}`)
    })
  })
  .catch(err => {
    console.error('Error conectando a la base de datos:', err)
  })