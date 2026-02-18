const mysql = require('mysql2/promise')
require('dotenv').config()

const port = process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 3306

const poolConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port
}

// Optional SSL support for providers like PlanetScale
if (process.env.DB_SSL === 'true') {
  poolConfig.ssl = { rejectUnauthorized: true }
}

const pool = mysql.createPool(poolConfig)

module.exports = pool