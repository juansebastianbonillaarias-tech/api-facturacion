-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-02-2026 a las 06:20:54
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `facturacion`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `documento` varchar(20) NOT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `id_empresa` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`id_cliente`, `nombre`, `documento`, `direccion`, `telefono`, `email`, `id_empresa`) VALUES
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_factura`
--

CREATE TABLE `detalle_factura` (
  `id_detalle` int(11) NOT NULL,
  `id_factura` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_factura`
--

INSERT INTO `detalle_factura` (`id_detalle`, `id_factura`, `id_producto`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1, 1, 1, 1, 3200000.00, 3200000.00),
(2, 2, 2, 2, 80000.00, 160000.00),
(3, 3, 3, 1, 250000.00, 250000.00),
(4, 4, 4, 1, 900000.00, 900000.00),
(5, 5, 5, 1, 700000.00, 700000.00),
(6, 6, 6, 1, 600000.00, 600000.00),
(7, 7, 7, 1, 400000.00, 400000.00),
(8, 8, 8, 3, 50000.00, 150000.00),
(9, 9, 9, 1, 850000.00, 850000.00),
(10, 10, 10, 1, 300000.00, 300000.00),
(11, 11, 2, 4, 80000.00, 0.00),
(12, 11, 4, 2, 900000.00, 0.00),
(13, 12, 6, 5, 600000.00, 0.00),
(14, 12, 4, 4, 900000.00, 0.00),
(15, 12, 8, 4, 50000.00, 0.00),
(16, 13, 6, 3, 600000.00, 0.00),
(17, 13, 7, 1, 400000.00, 0.00),
(18, 13, 2, 2, 80000.00, 0.00),
(19, 14, 9, 2, 850000.00, 0.00),
(20, 14, 5, 3, 700000.00, 0.00),
(21, 14, 8, 1, 50000.00, 0.00),
(22, 14, 1, 5, 3200000.00, 0.00),
(23, 15, 3, 5, 250000.00, 0.00),
(24, 15, 2, 3, 80000.00, 0.00),
(25, 15, 1, 4, 3200000.00, 0.00),
(26, 15, 3, 4, 250000.00, 0.00),
(27, 16, 8, 5, 50000.00, 0.00),
(28, 16, 8, 1, 50000.00, 0.00),
(29, 16, 1, 2, 3200000.00, 0.00),
(30, 16, 7, 3, 400000.00, 0.00),
(31, 17, 3, 1, 250000.00, 0.00),
(32, 18, 7, 2, 400000.00, 0.00),
(33, 19, 2, 3, 80000.00, 0.00),
(34, 20, 9, 4, 850000.00, 0.00),
(35, 20, 7, 3, 400000.00, 0.00),
(36, 21, 1, 2, 3200000.00, 0.00),
(37, 21, 3, 3, 250000.00, 0.00),
(38, 21, 8, 5, 50000.00, 0.00),
(39, 21, 3, 1, 250000.00, 0.00),
(40, 22, 7, 5, 400000.00, 0.00),
(41, 22, 7, 2, 400000.00, 0.00),
(42, 23, 2, 5, 80000.00, 0.00),
(43, 23, 5, 1, 700000.00, 0.00),
(44, 24, 6, 2, 600000.00, 0.00),
(45, 24, 1, 1, 3200000.00, 0.00),
(46, 24, 7, 1, 400000.00, 0.00),
(47, 24, 4, 2, 900000.00, 0.00),
(48, 25, 5, 5, 700000.00, 0.00),
(49, 26, 1, 3, 3200000.00, 0.00),
(50, 26, 1, 2, 3200000.00, 0.00),
(51, 26, 7, 5, 400000.00, 0.00),
(52, 26, 3, 4, 250000.00, 0.00),
(53, 27, 5, 4, 700000.00, 0.00),
(54, 27, 7, 1, 400000.00, 0.00),
(55, 27, 5, 3, 700000.00, 0.00),
(56, 28, 5, 5, 700000.00, 0.00),
(57, 28, 3, 3, 250000.00, 0.00),
(58, 28, 9, 2, 850000.00, 0.00),
(59, 29, 6, 1, 600000.00, 0.00),
(60, 29, 7, 4, 400000.00, 0.00),
(61, 30, 4, 1, 900000.00, 0.00),
(62, 30, 10, 2, 300000.00, 0.00),
(63, 30, 9, 3, 850000.00, 0.00),
(64, 31, 4, 3, 900000.00, 0.00),
(65, 31, 10, 4, 300000.00, 0.00),
(66, 31, 10, 2, 300000.00, 0.00),
(67, 31, 6, 3, 600000.00, 0.00),
(68, 32, 7, 5, 400000.00, 0.00),
(69, 33, 3, 2, 250000.00, 0.00),
(70, 33, 7, 5, 400000.00, 0.00),
(71, 33, 1, 1, 3200000.00, 0.00),
(72, 34, 3, 2, 250000.00, 0.00),
(73, 35, 3, 4, 250000.00, 0.00),
(74, 35, 10, 1, 300000.00, 0.00),
(75, 36, 9, 5, 850000.00, 0.00),
(76, 36, 6, 1, 600000.00, 0.00),
(77, 36, 9, 2, 850000.00, 0.00),
(78, 37, 1, 2, 3200000.00, 0.00),
(79, 38, 1, 2, 3200000.00, 0.00),
(80, 38, 4, 4, 900000.00, 0.00),
(81, 38, 1, 1, 3200000.00, 0.00),
(82, 38, 2, 3, 80000.00, 0.00),
(83, 39, 8, 5, 50000.00, 0.00),
(84, 39, 7, 1, 400000.00, 0.00),
(85, 39, 7, 4, 400000.00, 0.00),
(86, 40, 1, 2, 3200000.00, 0.00),
(87, 41, 3, 2, 250000.00, 0.00),
(88, 42, 5, 3, 700000.00, 0.00),
(89, 42, 2, 3, 80000.00, 0.00),
(90, 42, 8, 1, 50000.00, 0.00),
(91, 42, 6, 2, 600000.00, 0.00),
(92, 43, 1, 2, 3200000.00, 0.00),
(93, 43, 1, 1, 3200000.00, 0.00),
(94, 43, 2, 3, 80000.00, 0.00),
(95, 43, 10, 4, 300000.00, 0.00),
(96, 44, 4, 3, 900000.00, 0.00),
(97, 44, 9, 4, 850000.00, 0.00),
(98, 45, 8, 2, 50000.00, 0.00),
(99, 45, 9, 2, 850000.00, 0.00),
(100, 45, 3, 4, 250000.00, 0.00),
(101, 46, 3, 3, 250000.00, 0.00),
(102, 46, 7, 1, 400000.00, 0.00),
(103, 46, 2, 1, 80000.00, 0.00),
(104, 47, 9, 2, 850000.00, 0.00),
(105, 47, 7, 2, 400000.00, 0.00),
(106, 47, 10, 1, 300000.00, 0.00),
(107, 48, 4, 1, 900000.00, 0.00),
(108, 48, 1, 5, 3200000.00, 0.00),
(109, 49, 2, 4, 80000.00, 0.00),
(110, 49, 7, 2, 400000.00, 0.00),
(111, 49, 2, 2, 80000.00, 0.00),
(112, 49, 8, 3, 50000.00, 0.00),
(113, 50, 6, 2, 600000.00, 0.00),
(114, 50, 10, 5, 300000.00, 0.00),
(115, 50, 9, 5, 850000.00, 0.00),
(116, 50, 3, 4, 250000.00, 0.00),
(117, 51, 1, 3, 3200000.00, 0.00),
(118, 51, 6, 3, 600000.00, 0.00),
(119, 52, 7, 3, 400000.00, 0.00),
(120, 53, 2, 5, 80000.00, 0.00),
(121, 53, 1, 4, 3200000.00, 0.00),
(122, 53, 7, 3, 400000.00, 0.00),
(123, 53, 8, 2, 50000.00, 0.00),
(124, 54, 10, 1, 300000.00, 0.00),
(125, 55, 5, 1, 700000.00, 0.00),
(126, 55, 2, 2, 80000.00, 0.00),
(127, 56, 5, 4, 700000.00, 0.00),
(128, 56, 2, 2, 80000.00, 0.00),
(129, 56, 1, 4, 3200000.00, 0.00),
(130, 56, 2, 1, 80000.00, 0.00),
(131, 57, 8, 2, 50000.00, 0.00),
(132, 57, 1, 3, 3200000.00, 0.00),
(133, 58, 1, 2, 3200000.00, 0.00),
(134, 59, 2, 4, 80000.00, 0.00),
(135, 60, 7, 2, 400000.00, 0.00),
(136, 60, 1, 5, 3200000.00, 0.00),
(137, 60, 6, 5, 600000.00, 0.00),
(138, 60, 2, 5, 80000.00, 0.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_impuesto`
--

CREATE TABLE `detalle_impuesto` (
  `id_detalle` int(11) NOT NULL,
  `id_impuesto` int(11) NOT NULL,
  `valor_impuesto` decimal(12,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalle_impuesto`
--

INSERT INTO `detalle_impuesto` (`id_detalle`, `id_impuesto`, `valor_impuesto`) VALUES
(1, 1, 608000.00),
(2, 1, 30400.00),
(3, 1, 47500.00),
(4, 1, 171000.00),
(5, 1, 133000.00),
(6, 2, 30000.00),
(7, 3, 32000.00),
(8, 1, 28500.00),
(9, 4, 21250.00),
(10, 5, 12000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `empresas`
--

CREATE TABLE `empresas` (
  `id_empresa` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `nit` varchar(20) NOT NULL,
  `direccion` varchar(150) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `empresas`
--

INSERT INTO `empresas` (`id_empresa`, `nombre`, `nit`, `direccion`, `telefono`, `email`) VALUES
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id_factura` int(11) NOT NULL,
  `id_empresa` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `estado` varchar(20) DEFAULT 'emitida',
  `subtotal` decimal(12,2) DEFAULT 0.00,
  `total_impuestos` decimal(12,2) DEFAULT 0.00,
  `total` decimal(12,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`id_factura`, `id_empresa`, `id_cliente`, `fecha`, `estado`, `subtotal`, `total_impuestos`, `total`) VALUES
(1, 1, 1, '2026-01-01', 'emitida', 3200000.00, 608000.00, 3808000.00),
(2, 2, 2, '2026-01-02', 'pagada', 160000.00, 30400.00, 190400.00),
(3, 3, 3, '2026-01-03', 'emitida', 250000.00, 47500.00, 297500.00),
(4, 4, 4, '2026-01-04', 'pagada', 900000.00, 171000.00, 1071000.00),
(5, 5, 5, '2026-01-05', 'emitida', 700000.00, 133000.00, 833000.00),
(6, 6, 6, '2026-01-06', 'emitida', 600000.00, 114000.00, 714000.00),
(7, 7, 7, '2026-01-07', 'pagada', 400000.00, 76000.00, 476000.00),
(8, 8, 8, '2026-01-08', 'emitida', 150000.00, 28500.00, 178500.00),
(9, 9, 9, '2026-01-09', 'pagada', 850000.00, 161500.00, 1011500.00),
(10, 10, 10, '2026-01-10', 'emitida', 300000.00, 57000.00, 357000.00),
(11, 1, 1, '2025-12-30', 'emitida', 2120000.00, 402800.00, 2522800.00),
(12, 1, 1, '2026-01-30', 'emitida', 6800000.00, 1292000.00, 8092000.00),
(13, 1, 1, '2026-01-01', 'emitida', 2360000.00, 448400.00, 2808400.00),
(14, 1, 1, '2026-02-07', 'emitida', 19850000.00, 3771500.00, 23621500.00),
(15, 1, 1, '2026-01-15', 'emitida', 15290000.00, 2905100.00, 18195100.00),
(16, 2, 2, '2026-01-02', 'emitida', 7900000.00, 1501000.00, 9401000.00),
(17, 2, 2, '2026-01-01', 'emitida', 250000.00, 47500.00, 297500.00),
(18, 2, 2, '2026-01-19', 'emitida', 800000.00, 152000.00, 952000.00),
(19, 2, 2, '2025-12-15', 'emitida', 240000.00, 45600.00, 285600.00),
(20, 2, 2, '2026-02-09', 'emitida', 4600000.00, 874000.00, 5474000.00),
(21, 3, 3, '2026-01-22', 'emitida', 7650000.00, 1453500.00, 9103500.00),
(22, 3, 3, '2026-02-17', 'emitida', 2800000.00, 532000.00, 3332000.00),
(23, 3, 3, '2025-11-27', 'emitida', 1100000.00, 209000.00, 1309000.00),
(24, 3, 3, '2025-11-28', 'emitida', 6600000.00, 1254000.00, 7854000.00),
(25, 3, 3, '2025-12-29', 'emitida', 3500000.00, 665000.00, 4165000.00),
(26, 4, 4, '2025-12-17', 'emitida', 19000000.00, 3610000.00, 22610000.00),
(27, 4, 4, '2026-02-12', 'emitida', 5300000.00, 1007000.00, 6307000.00),
(28, 4, 4, '2026-01-02', 'emitida', 5950000.00, 1130500.00, 7080500.00),
(29, 4, 4, '2025-12-29', 'emitida', 2200000.00, 418000.00, 2618000.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `impuestos`
--

CREATE TABLE `impuestos` (
  `id_impuesto` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `porcentaje` decimal(5,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `impuestos`
--

INSERT INTO `impuestos` (`id_impuesto`, `nombre`, `porcentaje`) VALUES
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `descripcion`, `precio`, `stock`) VALUES
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

--
-- Índices para tablas volcadas
--

ALTER TABLE `clientes`
  ADD PRIMARY KEY (`id_cliente`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD KEY `id_empresa` (`id_empresa`);

ALTER TABLE `detalle_factura`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_factura` (`id_factura`),
  ADD KEY `id_producto` (`id_producto`);

ALTER TABLE `detalle_impuesto`
  ADD PRIMARY KEY (`id_detalle`,`id_impuesto`),
  ADD KEY `id_impuesto` (`id_impuesto`);

ALTER TABLE `empresas`
  ADD PRIMARY KEY (`id_empresa`),
  ADD UNIQUE KEY `nit` (`nit`);

ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id_factura`),
  ADD KEY `id_empresa` (`id_empresa`),
  ADD KEY `id_cliente` (`id_cliente`);

ALTER TABLE `impuestos`
  ADD PRIMARY KEY (`id_impuesto`);

ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`);

-- AUTO_INCREMENT values
ALTER TABLE `clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
ALTER TABLE `detalle_factura`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=139;
ALTER TABLE `empresas`
  MODIFY `id_empresa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
ALTER TABLE `facturas`
  MODIFY `id_factura` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;
ALTER TABLE `impuestos`
  MODIFY `id_impuesto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

-- Foreign keys
ALTER TABLE `clientes`
  ADD CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresas` (`id_empresa`) ON DELETE CASCADE;

ALTER TABLE `detalle_factura`
  ADD CONSTRAINT `detalle_factura_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `facturas` (`id_factura`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_factura_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);

ALTER TABLE `detalle_impuesto`
  ADD CONSTRAINT `detalle_impuesto_ibfk_1` FOREIGN KEY (`id_detalle`) REFERENCES `detalle_factura` (`id_detalle`) ON DELETE CASCADE,
  ADD CONSTRAINT `detalle_impuesto_ibfk_2` FOREIGN KEY (`id_impuesto`) REFERENCES `impuestos` (`id_impuesto`);

ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`id_empresa`) REFERENCES `empresas` (`id_empresa`),
  ADD CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
