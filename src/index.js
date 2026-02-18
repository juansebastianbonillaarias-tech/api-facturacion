require('dotenv').config()
const app = require('./app')
const db = require('./db')

const PORT = process.env.PORT || 3000

async function start() {
  try {
    const connection = await db.getConnection()
    connection.release()
    console.log('Conexión a la base de datos establecida')
  } catch (err) {
    console.error('Error conectando a la base de datos:', err)
    if (!process.env.SKIP_DB_CHECK || process.env.SKIP_DB_CHECK === 'false') {
      console.error('La aplicación abortará porque la base de datos no está disponible. Para omitir esta verificación temporalmente, establece SKIP_DB_CHECK=true en las variables de entorno.')
      process.exit(1)
    } else {
      console.warn('SKIP_DB_CHECK=true — iniciando servidor sin conexión a la base de datos')
    }
  }

  app.listen(PORT, () => {
    console.log(`Servidor corriendo en puerto ${PORT}`)
  })
}

start()