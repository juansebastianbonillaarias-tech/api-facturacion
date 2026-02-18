-- Converted MySQL dump -> PostgreSQL compatible schema
BEGIN;

-- Table: empresas
DROP TABLE IF EXISTS empresas CASCADE;
CREATE TABLE empresas (
  id_empresa SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  nit VARCHAR(20) NOT NULL,
  direccion VARCHAR(150),
  telefono VARCHAR(20),
  email VARCHAR(100)
);

-- Table: clientes
DROP TABLE IF EXISTS clientes CASCADE;
CREATE TABLE clientes (
  id_cliente SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  documento VARCHAR(20) NOT NULL UNIQUE,
  direccion VARCHAR(150),
  telefono VARCHAR(20),
  email VARCHAR(100),
  id_empresa INT NOT NULL REFERENCES empresas(id_empresa) ON DELETE CASCADE
);

-- Table: productos
DROP TABLE IF EXISTS productos CASCADE;
CREATE TABLE productos (
  id_producto SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  precio NUMERIC(10,2) NOT NULL,
  stock INT DEFAULT 0
);

-- Table: facturas
DROP TABLE IF EXISTS facturas CASCADE;
CREATE TABLE facturas (
  id_factura SERIAL PRIMARY KEY,
  id_empresa INT NOT NULL REFERENCES empresas(id_empresa),
  id_cliente INT NOT NULL REFERENCES clientes(id_cliente),
  fecha DATE NOT NULL,
  estado VARCHAR(20) DEFAULT 'emitida',
  subtotal NUMERIC(12,2) DEFAULT 0.00,
  total_impuestos NUMERIC(12,2) DEFAULT 0.00,
  total NUMERIC(12,2) DEFAULT 0.00
);

-- Table: detalle_factura
DROP TABLE IF EXISTS detalle_factura CASCADE;
CREATE TABLE detalle_factura (
  id_detalle SERIAL PRIMARY KEY,
  id_factura INT NOT NULL REFERENCES facturas(id_factura) ON DELETE CASCADE,
  id_producto INT NOT NULL REFERENCES productos(id_producto),
  cantidad INT NOT NULL,
  precio_unitario NUMERIC(10,2) NOT NULL,
  subtotal NUMERIC(12,2) NOT NULL
);

-- Table: impuestos
DROP TABLE IF EXISTS impuestos CASCADE;
CREATE TABLE impuestos (
  id_impuesto SERIAL PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  porcentaje NUMERIC(5,2) NOT NULL
);

-- Table: detalle_impuesto
DROP TABLE IF EXISTS detalle_impuesto CASCADE;
CREATE TABLE detalle_impuesto (
  id_detalle INT NOT NULL,
  id_impuesto INT NOT NULL REFERENCES impuestos(id_impuesto),
  valor_impuesto NUMERIC(12,2) NOT NULL,
  PRIMARY KEY (id_detalle, id_impuesto)
);

-- Insert sample data (from provided dump)
-- empresas
INSERT INTO empresas(id_empresa,nombre,nit,direccion,telefono,email) VALUES
(1, 'Tech Solutions SAS', '900111111-1', 'Calle 1 #10-20', '3000000001', 'tech1@mail.com'),
(2, 'Distribuciones Pro', '900222222-2', 'Calle 2 #10-20', '3000000002', 'tech2@mail.com'),
(3, 'Servicios Globales', '900333333-3', 'Calle 3 #10-20', '3000000003', 'tech3@mail.com'),
(4, 'Comercial Andina', '900444444-4', 'Calle 4 #10-20', '3000000004', 'tech4@mail.com'),
(5, 'Inversiones Alfa', '900555555-5', 'Calle 5 #10-20', '3000000005', 'tech5@mail.com'),
(6, 'Grupo Beta', '900666666-6', 'Calle 6 #10-20', '3000000006', 'tech6@mail.com'),
(7, 'Soluciones Delta', '900777777-7', 'Calle 7 #10-20', '3000000007', 'tech7@mail.com'),
(8, 'Corporación Omega', '900888888-8', 'Calle 8 #10-20', '3000000008', 'tech8@mail.com'),
(9, 'Negocios Sigma', '900999999-9', 'Calle 9 #10-20', '3000000009', 'tech9@mail.com'),
(10, 'Empresa Zeta', '901000000-0', 'Calle 10 #10-20', '3000000010', 'tech10@mail.com');

-- clientes (partial from dump)
INSERT INTO clientes(id_cliente,nombre,documento,direccion,telefono,email,id_empresa) VALUES
(1, 'Juan Pérez', '1001', 'Dir 1', '3101', 'c1@mail.com', 1),
(2, 'Laura Gómez', '1002', 'Dir 2', '3102', 'c2@mail.com', 2),
(3, 'Carlos Ruiz', '1003', 'Dir 3', '3103', 'c3@mail.com', 3),
(4, 'Ana Torres', '1004', 'Dir 4', '3104', 'c4@mail.com', 4),
(5, 'Pedro Díaz', '1005', 'Dir 5', '3105', 'c5@mail.com', 5),
(6, 'Sofía León', '1006', 'Dir 6', '3106', 'c6@mail.com', 6),
(7, 'Mario Rojas', '1007', 'Dir 7', '3107', 'c7@mail.com', 7),
(8, 'Lucía Castro', '1008', 'Dir 8', '3108', 'c8@mail.com', 8),
(9, 'Diego Mora', '1009', 'Dir 9', '3109', 'c9@mail.com', 9),
(10, 'Elena Gil', '1010', 'Dir 10', '3110', 'c10@mail.com', 10);

-- productos (partial)
INSERT INTO productos(id_producto,nombre,descripcion,precio,stock) VALUES
(1, 'Laptop', 'Portátil 16GB', 3200000.00, 10),
(2, 'Mouse', 'Mouse inalámbrico', 80000.00, 50),
(3, 'Teclado', 'Teclado mecánico', 250000.00, 30),
(4, 'Monitor', 'Monitor 24 pulgadas', 900000.00, 15),
(5, 'Impresora', 'Multifuncional', 700000.00, 20),
(6, 'Tablet', 'Tablet 10 pulgadas', 600000.00, 25),
(7, 'Disco SSD', 'SSD 1TB', 400000.00, 40),
(8, 'Memoria USB', 'USB 64GB', 50000.00, 100),
(9, 'Silla Gamer', 'Ergonómica', 850000.00, 12),
(10, 'Router', 'WiFi 6', 300000.00, 18);

-- impuestos
INSERT INTO impuestos(id_impuesto,nombre,porcentaje) VALUES
(1, 'IVA 19%', 19.00),
(2, 'IVA 5%', 5.00),
(3, 'Consumo 8%', 8.00),
(4, 'Retención 2.5%', 2.50),
(5, 'Retención 4%', 4.00),
(6, 'Retención 6%', 6.00),
(7, 'ICA 1%', 1.00),
(8, 'ICA 2%', 2.00),
(9, 'IVA 0%', 0.00),
(10, 'Impuesto especial 10%', 10.00);

-- facturas (partial)
INSERT INTO facturas(id_factura,id_empresa,id_cliente,fecha,estado,subtotal,total_impuestos,total) VALUES
(1, 1, 1, '2026-01-01', 'emitida', 3200000.00, 608000.00, 3808000.00),
(2, 2, 2, '2026-01-02', 'pagada', 160000.00, 30400.00, 190400.00),
(3, 3, 3, '2026-01-03', 'emitida', 250000.00, 47500.00, 297500.00),
(4, 4, 4, '2026-01-04', 'pagada', 900000.00, 171000.00, 1071000.00),
(5, 5, 5, '2026-01-05', 'emitida', 700000.00, 133000.00, 833000.00),
(6, 6, 6, '2026-01-06', 'emitida', 600000.00, 114000.00, 714000.00),
(7, 7, 7, '2026-01-07', 'pagada', 400000.00, 76000.00, 476000.00),
(8, 8, 8, '2026-01-08', 'emitida', 150000.00, 28500.00, 178500.00),
(9, 9, 9, '2026-01-09', 'pagada', 850000.00, 161500.00, 1011500.00),
(10, 10, 10, '2026-01-10', 'emitida', 300000.00, 57000.00, 357000.00);

-- detalle_factura (partial)
INSERT INTO detalle_factura(id_detalle,id_factura,id_producto,cantidad,precio_unitario,subtotal) VALUES
(1, 1, 1, 1, 3200000.00, 3200000.00),
(2, 2, 2, 2, 80000.00, 160000.00),
(3, 3, 3, 1, 250000.00, 250000.00),
(4, 4, 4, 1, 900000.00, 900000.00),
(5, 5, 5, 1, 700000.00, 700000.00),
(6, 6, 6, 1, 600000.00, 600000.00),
(7, 7, 7, 1, 400000.00, 400000.00),
(8, 8, 8, 3, 50000.00, 150000.00),
(9, 9, 9, 1, 850000.00, 850000.00),
(10, 10, 10, 1, 300000.00, 300000.00);

-- detalle_impuesto (partial)
INSERT INTO detalle_impuesto(id_detalle,id_impuesto,valor_impuesto) VALUES
(1, 1, 608000.00),(2, 1, 30400.00),(3, 1, 47500.00),(4, 1, 171000.00),(5, 1, 133000.00),(6, 2, 30000.00),(7, 3, 32000.00),(8, 1, 28500.00),(9, 4, 21250.00),(10, 5, 12000.00);

-- Reset sequences to match inserted IDs
SELECT setval(pg_get_serial_sequence('empresas', 'id_empresa'), COALESCE((SELECT MAX(id_empresa) FROM empresas), 1));
SELECT setval(pg_get_serial_sequence('clientes', 'id_cliente'), COALESCE((SELECT MAX(id_cliente) FROM clientes), 1));
SELECT setval(pg_get_serial_sequence('productos', 'id_producto'), COALESCE((SELECT MAX(id_producto) FROM productos), 1));
SELECT setval(pg_get_serial_sequence('facturas', 'id_factura'), COALESCE((SELECT MAX(id_factura) FROM facturas), 1));
SELECT setval(pg_get_serial_sequence('detalle_factura', 'id_detalle'), COALESCE((SELECT MAX(id_detalle) FROM detalle_factura), 1));
SELECT setval(pg_get_serial_sequence('impuestos', 'id_impuesto'), COALESCE((SELECT MAX(id_impuesto) FROM impuestos), 1));

COMMIT;
