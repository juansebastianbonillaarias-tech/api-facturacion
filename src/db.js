const { Pool } = require('pg')
require('dotenv').config()

// Prefer DATABASE_URL (Supabase). If not provided, fall back to individual vars.
const connectionString = process.env.DATABASE_URL || null

const poolOptions = connectionString
  ? {
      connectionString,
      ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false
    }
  : {
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_NAME,
      port: process.env.DB_PORT ? parseInt(process.env.DB_PORT, 10) : 5432,
      ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false
    }

const pool = new Pool(poolOptions)

// Convert MySQL `?` placeholders to Postgres `$1`, `$2`, etc.
function convertPlaceholders(sql) {
  let counter = 0
  return sql.replace(/\?/g, () => `$${++counter}`)
}

// Wrapper to return results in mysql2-like format [rows, fields]
// This allows existing controllers to work without changes
module.exports = {
  query: async (sql, params) => {
    // Convert ? placeholders to $1, $2, etc. for Postgres
    const convertedSql = convertPlaceholders(sql)
    const result = await pool.query(convertedSql, params)
    // Return [rows, fields] to match mysql2 destructuring in controllers
    return [result.rows, result.fields]
  },
  connect: async () => {
    // Get a client from the pool to test connection
    return await pool.connect()
  },
  pool
}