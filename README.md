# Plataforma de Facturación Electrónica — Grupo 5

Este repositorio contiene la API RESTful de la plataforma de facturación electrónica (Node.js + Express + MySQL) desarrollada para el Taller Integrador.

Requisitos cubiertos:
- Conexión a MySQL
- CRUD para `empresas`, `clientes`, `facturas`
- Endpoints relacionales (factura + cliente + detalle)
- Filtros por query params en `GET /facturas`
- Estructura mínima del proyecto y `.env`
- Frontend simple en `src/diseño` que consume al menos 4 endpoints

Archivos nuevos importantes:
- `sql/schema.sql` — script SQL para crear la base de datos y tablas (incluye datos de ejemplo)
- `src/test-endpoints.js` — script de prueba ampliado

Rutas principales
- `GET /empresas` — listar empresas
- `GET /empresas/:id` — obtener empresa
- `POST /empresas` — crear empresa
- `PUT /empresas/:id` — actualizar
- `DELETE /empresas/:id` — eliminar

- `GET /clientes` — listar clientes
- `GET /clientes/:id` — obtener cliente
- `POST /clientes` — crear cliente
- `PUT /clientes/:id` — actualizar
- `DELETE /clientes/:id` — eliminar

- `GET /facturas` — listar facturas (soporta query params `estado`, `id_empresa`, `desde`, `hasta`)
- `GET /facturas/:id` — obtener factura básica
- `GET /facturas/:id/detalle` — obtener factura con cliente, empresa y detalle (JOINs)
- `GET /facturas/empresa/:id` — facturas por empresa
- `GET /facturas/empresa/:id/total` — totales por empresa
- `GET /facturas/mensual` — facturación mensual
- `POST /facturas` — crear factura (con `detalles` array)

Instalación y ejecución local
1. Instalar dependencias:

```bash
npm install
```

2. Crear la base de datos (usar MySQL local). Por ejemplo desde terminal MySQL:

```sql
SOURCE sql/schema.sql;
```

3. Configurar `.env` con credenciales MySQL (ya existe `.env` para desarrollo local con `DB_NAME=facturacion`)

4. Iniciar servidor:

```bash
npm start
```

5. Opcional: abrir el frontend simple en `src/diseño/index.html` (servirlo con un servidor estático o abrir el archivo en el navegador y asegurarse de que la API esté accesible en `http://localhost:3000`).

Pruebas automatizadas rápidas
```bash
node src/test-endpoints.js
```

Notas y recomendaciones
- El archivo `sql/schema.sql` crea tablas y datos de ejemplo; ajustar credenciales antes de ejecutar.
- Para despliegue en la nube, exportar variables de entorno y ejecutar en el servicio elegido.

Despliegue (opciones rápidas)

1) Deploy con Render (recomendado)
- Crear una cuenta en https://render.com
- Crear un "Web Service" y conectar el repositorio (GitHub/GitLab). Selecciona "Docker" como método de despliegue o usa el `Dockerfile` incluido.
- Configura variables de entorno en Render: `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`, `PORT` (Render normalmente usa `PORT` dinámico, mantén `process.env.PORT`).
- Añade un servicio de base de datos MySQL en Render o usa un proveedor externo y configura las credenciales.

2) Deploy con Railway
- Crear cuenta en https://railway.app
- Desplegar desde GitHub siguiendo el asistente; añadir un plugin MySQL (Railway provee bases de datos administradas). Actualiza variables de entorno con la URL y credenciales que Railway ofrezca.

3) Deploy con Heroku (método legacy)
- Crear app en Heroku, conectar repo y usar buildpack de Docker o Node.js.
- Añadir un add-on MySQL (ClearDB u otro proveedor) y configurar `CLEARDB_DATABASE_URL` o las variables `DB_HOST`, `DB_USER`, `DB_PASSWORD`, `DB_NAME` en las Config Vars.

Recomendaciones al desplegar
- Asegúrate de no subir el archivo `.env` con credenciales.
- Usa el endpoint `/health` para configurar checks en el proveedor de nube.
- Si tu proveedor no ofrece MySQL, considera usar una DB externa (Cloud SQL, PlanetScale, Amazon RDS) y configurar la conexión mediante variables de entorno.

Archivos añadidos para despliegue
- `Dockerfile` — contenedor para la API
- `.dockerignore` — para el build de Docker
- `src/app.js` — nuevo endpoint `/health` disponible

