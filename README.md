# Plataforma de Facturación — API

API RESTful en Node.js + Express. Esta versión usa PostgreSQL (soporta `DATABASE_URL` para providers como Supabase).

Base URL (ejemplo en producción):

```
https://api-facturacion-0b4m.onrender.com
```

Resumen rápido
- Endpoints para `empresas`, `clientes`, `facturas` y `/health`.
- Soporta Postgres (Supabase) mediante `pg` y variable `DATABASE_URL`.

Endpoints (HTTP)

**Health**
- `GET /health` — comprobación de estado

**Empresas**
- `GET /empresas` — listar todas
- `GET /empresas/:id` — obtener por id
- `POST /empresas` — crear (JSON body)
- `PUT /empresas/:id` — actualizar (JSON body)
- `DELETE /empresas/:id` — eliminar

**Clientes**
- `GET /clientes` — listar todas
- `GET /clientes/:id` — obtener por id
- `POST /clientes` — crear (JSON body)
- `PUT /clientes/:id` — actualizar (JSON body)
- `DELETE /clientes/:id` — eliminar

**Facturas**
- `GET /facturas` — listar (soporta query params `estado`, `id_empresa`, `desde`, `hasta`)
- `GET /facturas/:id` — obtener factura básica
- `GET /facturas/:id/detalle` — obtener factura + cliente + empresa + detalle
- `GET /facturas/empresa/:id` — facturas por empresa
- `GET /facturas/empresa/:id/total` — totales por empresa
- `GET /facturas/empresa/:id/mensual` — facturación mensual por empresa
- `GET /facturas/mensual` — facturación mensual general
- `POST /facturas` — crear factura (JSON body con `detalles` array)
- `PUT /facturas/:id` — actualizar
- `DELETE /facturas/:id` — eliminar

Ejemplos curl

- Health:
```
curl https://api-facturacion-0b4m.onrender.com/health
```
- Listar empresas:
```
curl https://api-facturacion-0b4m.onrender.com/empresas
```
- Obtener empresa por id (ej: 1):
```
curl https://api-facturacion-0b4m.onrender.com/empresas/1
```
- Crear empresa (ejemplo):
```
curl -X POST https://api-facturacion-0b4m.onrender.com/empresas -H "Content-Type: application/json" -d '{"nombre":"ACME","nit":"123","direccion":"Calle 1","telefono":"555","email":"acme@example.com"}'
```

Variables de entorno
- `DATABASE_URL` — (recomendado) cadena de conexión Postgres (ej: Supabase Pooler). Ej: `postgresql://postgres:PASS@host:6543/postgres?sslmode=require`
- `PORT` — puerto (Render provee esto automáticamente)
- `SKIP_DB_CHECK` — si `true`, el servidor no fallará si la DB no responde en arranque (útil para debugging)

Ejecución local (con Postgres)

1. Instala dependencias:
```bash
npm install
```
2. Crea una base Postgres y ejecuta el SQL en `sql/schema.sql` (archivo adaptado a Postgres).
3. Configura `.env` o exporta `DATABASE_URL` apuntando a la DB.
4. Inicia:
```bash
npm start
```

Despliegue en Render (resumen rápido)

1. En Supabase: usa el **Pooler** y copia la connection string.
2. En Render → Service → Environment:
   - `DATABASE_URL` = (la connection string del Pooler de Supabase)
   - (opcional) `PGSSLMODE=require` o añadir `?sslmode=require` en la URL
3. Manual Deploy → `Deploy latest commit`.
4. Revisar logs; usar `/health` para checks.

Notas para colaboradores
- El código fue adaptado desde MySQL a Postgres: el wrapper en `src/db.js` convierte placeholders `?` a `$1..` y devuelve `[rows, fields]` para mantener compatibilidad con controladores existentes.
- Los directorios de frontend y scripts de prueba se removieron para mantener el repo orientado a la API.

Archivo SQL
- `sql/schema.sql` contiene el esquema y puede ser usado en Supabase (Postgres).

Contribuir
- Haz forks, PR y describe claramente los cambios. Para cambios que afecten la DB, incluye migraciones o instrucciones.

Licencia
- (añade tu licencia aquí)
