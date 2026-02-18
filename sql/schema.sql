-- Schema para la plataforma de facturación (Grupo 5)
-- Crear base de datos y tablas mínimas necesarias

USE railway;

CREATE TABLE IF NOT EXISTS empresas (
  id_empresa INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL,
  nit VARCHAR(50),
  direccion VARCHAR(255),
  telefono VARCHAR(50),
  email VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  id_empresa INT NOT NULL,
  nombre VARCHAR(200) NOT NULL,
  documento VARCHAR(100),
  direccion VARCHAR(255),
  telefono VARCHAR(50),
  email VARCHAR(100),
  FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(200) NOT NULL,
  descripcion TEXT,
  precio DECIMAL(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS facturas (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_empresa INT NOT NULL,
  id_cliente INT NOT NULL,
  fecha DATE NOT NULL,
  estado VARCHAR(50) DEFAULT 'emitida',
  subtotal DECIMAL(12,2) DEFAULT 0,
  total_impuestos DECIMAL(12,2) DEFAULT 0,
  total DECIMAL(12,2) DEFAULT 0,
  FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa) ON DELETE CASCADE,
  FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS detalle_factura (
  id_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT NOT NULL,
  id_producto INT NOT NULL,
  cantidad INT NOT NULL,
  precio_unitario DECIMAL(12,2) NOT NULL,
  impuesto DECIMAL(6,2) DEFAULT 0,
  total_linea DECIMAL(12,2) DEFAULT 0,
  FOREIGN KEY (id_factura) REFERENCES facturas(id_factura) ON DELETE CASCADE,
  FOREIGN KEY (id_producto) REFERENCES productos(id_producto) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Datos de ejemplo (puedes ajustar o eliminar)
INSERT INTO empresas(nombre,nit,direccion,telefono,email) VALUES
('Tech Solutions SAS','900111111-1','Calle 1 #10-20','3000000001','tech1@mail.com');

INSERT INTO clientes(id_empresa,nombre,documento,direccion,telefono,email) VALUES
(1,'Juan Pérez','1001','Dir 1','3101','c1@mail.com');

INSERT INTO productos(nombre,descripcion,precio) VALUES
('Producto A','Descripción A',100.00),
('Producto B','Descripción B',200.00);

-- Ejemplo: crear una factura y su detalle
INSERT INTO facturas(id_empresa,id_cliente,fecha,estado,subtotal,total_impuestos,total) VALUES
(1,1,CURDATE(),'emitida',300.00,57.00,357.00);

INSERT INTO detalle_factura(id_factura,id_producto,cantidad,precio_unitario,impuesto,total_linea) VALUES
(1,1,1,100.00,19,119.00),
(1,2,1,200.00,38,238.00);
