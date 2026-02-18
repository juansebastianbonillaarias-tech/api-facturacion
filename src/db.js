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

module.exports = pool