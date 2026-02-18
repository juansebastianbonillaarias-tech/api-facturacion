# Plataforma de Facturación — API

API RESTful en Node.js + Express que usa PostgreSQL (soporta `DATABASE_URL` para providers como Supabase).

Base URL (ejemplo en producción):

```
https://api-facturacion-0b4m.onrender.com
```

Resumen rápido
- Recursos principales: `empresas`, `clientes`, `facturas` y `/health`.
- Usa Postgres; la conexión se configura con `DATABASE_URL`.

Endpoints

- **GET /health**
   - Check de estado (200 OK)

Empresas
- **GET /empresas** — listar todas las empresas
- **GET /empresas/:id** — obtener una empresa por su id
- **POST /empresas** — crear empresa (JSON body con campos: `nombre`, `nit`, `direccion`, `telefono`, `email`)
- **PUT /empresas/:id** — actualizar empresa (JSON body con campos a cambiar)
- **DELETE /empresas/:id** — eliminar empresa

Clientes
- **GET /clientes** — listar todos los clientes
- **GET /clientes/:id** — obtener un cliente por su id
- **POST /clientes** — crear cliente (JSON body con `nombre`, `documento`, `direccion`, `telefono`, `email`, `id_empresa`)
- **PUT /clientes/:id** — actualizar cliente
- **DELETE /clientes/:id** — eliminar cliente

Facturas
- **GET /facturas** — listar facturas (opcionalmente filtrar con query params: `estado`, `id_empresa`, `desde`, `hasta`)
- **GET /facturas/:id** — obtener factura básica por id
- **GET /facturas/:id/detalle** — obtener factura con cliente, empresa y detalle de líneas
- **GET /facturas/empresa/:id** — listar facturas de una empresa
- **GET /facturas/empresa/:id/total** — totales por empresa
- **GET /facturas/empresa/:id/mensual** — facturación mensual para una empresa
- **GET /facturas/mensual** — facturación mensual general
- **POST /facturas** — crear factura. Body JSON: campos de factura + `detalles` (array de objetos `{ id_producto, cantidad, precio_unitario }`).
- **PUT /facturas/:id** — actualizar factura
- **DELETE /facturas/:id** — eliminar factura

Nota sobre `:id`
- En todas las rutas que usan `:id` debes reemplazarlo por el identificador numérico del recurso (por ejemplo `1`, `42`).
- Ejemplo correcto: `GET /empresas/1` — no envíes comillas, ni texto; el servidor espera un número.

Ejemplos curl

```
curl https://api-facturacion-0b4m.onrender.com/health
```

Listar empresas:

```
curl https://api-facturacion-0b4m.onrender.com/empresas
```

Obtener empresa por id (ej: 1):

```
curl https://api-facturacion-0b4m.onrender.com/empresas/1
```

Crear empresa (ejemplo):

```
curl -X POST https://api-facturacion-0b4m.onrender.com/empresas \
   -H "Content-Type: application/json" \
   -d '{"nombre":"ACME","nit":"123","direccion":"Calle 1","telefono":"555","email":"acme@example.com"}'
```

Variables de entorno
- `DATABASE_URL` — cadena de conexión Postgres (ej: Supabase Pooler). Ej: `postgresql://postgres:PASS@host:6543/postgres?sslmode=require`
- `PORT` — puerto (Render provee esto automáticamente)
- `SKIP_DB_CHECK` — si `true`, el servidor no fallará si la DB no responde en arranque (útil para debugging)

Ejecución local (con Postgres)

1. Instala dependencias:

```bash
npm install
```

2. Crea una base Postgres y ejecuta el SQL en `sql/schema_postgres.sql` (este repo usa `sql/schema_postgres.sql` como esquema canónico para Postgres).

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
- `sql/schema_postgres.sql` es el esquema canónico para Postgres y contiene las instrucciones para crear tablas y datos de ejemplo.

Contribuir
- Haz forks, PR y describe claramente los cambios. Para cambios que afecten la DB, incluye migraciones o instrucciones.

Licencia
- (añade tu licencia aquí)
