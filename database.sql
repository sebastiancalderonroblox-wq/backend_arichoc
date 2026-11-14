-- ============================================================================
-- SCRIPT DDL: BASE DE DATOS TRANSACCIONAL ARICHOC (PostgreSQL 16)
-- Nombre de Base de Datos: ARICHOC
-- Proyecto: Plataforma E-Commerce y Personalización de Detalles ARICHOC
-- Programa: Tecnólogo en Análisis y Desarrollo de Software (ADSO) - Ficha 3293992
-- Centro: Centro Agroempresarial y Desarrollo Pecuario del Huila (Garzón, Huila)
-- ============================================================================

-- INSTRUCCIÓN DE CREACIÓN DE BASE DE DATOS (Ejecutar si no ha sido creada):
-- CREATE DATABASE "ARICHOC";
-- \c "ARICHOC";

-- 1. TABLA: ROLES (Catálogo de perfiles y permisos)
CREATE TABLE IF NOT EXISTS roles (
    id_rol SMALLSERIAL PRIMARY KEY,
    nombre_rol VARCHAR(30) NOT NULL UNIQUE
);

-- 2. TABLA: USUARIOS (Clientes, artesanos y administradores)
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario SERIAL PRIMARY KEY,
    id_rol SMALLINT NOT NULL DEFAULT 1 REFERENCES roles(id_rol) ON UPDATE CASCADE,
    correo VARCHAR(120) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nombre_completo VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. TABLA: PRODUCTOS_DETALLES (Catálogo maestro relacional con stock físico)
CREATE TABLE IF NOT EXISTS productos_detalles (
    id_detalle SERIAL PRIMARY KEY,
    codigo_sku VARCHAR(25) NOT NULL UNIQUE,
    nombre_detalle VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio_base_cop NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    stock_actual INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT chk_stock_positivo CHECK (stock_actual >= 0),
    CONSTRAINT chk_precio_base_positivo CHECK (precio_base_cop > 0)
);

-- 4. TABLA: PEDIDOS (Órdenes de compra transaccionales)
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id_usuario) ON UPDATE CASCADE,
    estado_pedido VARCHAR(25) NOT NULL DEFAULT 'PENDIENTE',
    total_cop NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_total_positivo CHECK (total_cop >= 0),
    CONSTRAINT chk_estado_pedido CHECK (estado_pedido IN (
        'PENDIENTE', 
        'CONFIRMADO', 
        'EN_PREPARACION', 
        'LISTO_DESPACHO', 
        'ENTREGADO', 
        'CANCELADO'
    ))
);

-- 5. TABLA: DETALLE_PEDIDO (Líneas de la orden e interoperabilidad con MongoDB)
CREATE TABLE IF NOT EXISTS detalle_pedido (
    id_detalle_pedido SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    id_detalle INTEGER NOT NULL REFERENCES productos_detalles(id_detalle) ON UPDATE CASCADE,
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario_historico NUMERIC(10,2) NOT NULL CHECK (precio_unitario_historico >= 0),
    personalizacion_mongo_id CHAR(24) -- Puntero ObjectId inmutable a la colección de personalizaciones
);

-- 6. TABLA: PAGOS (Conciliación financiera y pasarela)
CREATE TABLE IF NOT EXISTS pagos (
    id_pago SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL UNIQUE REFERENCES pedidos(id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    metodo_pago VARCHAR(30) NOT NULL,
    ref_transaccion VARCHAR(50) NOT NULL UNIQUE,
    total_pagado_cop NUMERIC(10,2) NOT NULL CHECK (total_pagado_cop >= 0),
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_metodo_pago CHECK (metodo_pago IN ('NEQUI', 'BANCOLOMBIA', 'EFECTIVO_GARZON'))
);

-- ============================================================================
-- ÍNDICES DE RENDIMIENTO (OPTIMIZACIÓN DE CONSULTAS B-TREE)
-- ============================================================================

-- Acelera el rastreo del cliente y filtros por estado en el panel de artesano
CREATE INDEX IF NOT EXISTS idx_pedidos_usuario_estado 
    ON pedidos (id_usuario, estado_pedido);

-- Optimiza la consulta del catálogo público excluyendo productos agotados
CREATE INDEX IF NOT EXISTS idx_detalles_stock_disp 
    ON productos_detalles (precio_base_cop) 
    WHERE stock_actual > 0;

-- ============================================================================
-- DATOS SEMILLA (SEEDS) INICIALES DE PRUEBA Y OPERACIÓN
-- ============================================================================

-- Roles estándar
INSERT INTO roles (nombre_rol) VALUES 
    ('CLIENTE'),
    ('ARTESANO'),
    ('ADMINISTRADOR')
ON CONFLICT (nombre_rol) DO NOTHING;

-- Usuario inicial administrador/artesano de pruebas
INSERT INTO usuarios (id_rol, correo, password_hash, nombre_completo, telefono) VALUES 
    (3, 'admin@arichoc.com', '$2b$10$wE8Fz79kH0e65qK9bS51x.Vl9wT2k43U7bQ8dE1fZ4HjP0wV8mCfa', 'Administrador ARICHOC', '3101234567'),
    (1, 'cliente.demo@garzon.com', '$2b$10$wE8Fz79kH0e65qK9bS51x.Vl9wT2k43U7bQ8dE1fZ4HjP0wV8mCfa', 'Cliente Garzoneño Demo', '3209876543')
ON CONFLICT (correo) DO NOTHING;

-- Catálogo maestro de arreglos y chocolates artesanales
INSERT INTO productos_detalles (codigo_sku, nombre_detalle, descripcion, precio_base_cop, stock_actual) VALUES 
    ('ARIC-001', 'Caja Corazón con Fresas Achocolatadas', 'Caja artesanal en forma de corazón con 12 fresas bañadas en chocolate semiamargo y blanco.', 45000.00, 20),
    ('ARIC-002', 'ChocoMensaje Personalizado en Cobertura', 'Caja con letras de chocolate artesanal para mensajes dedicatorios personalizados.', 38000.00, 25),
    ('ARIC-003', 'Ramillete Gourmet con Rosas y Bombones', 'Combinación floral con bombones rellenos de frutos del Huila y licor artesanal.', 65000.00, 15),
    ('ARIC-004', 'Arreglo Premium Aniversario Garzón', 'Arreglo de lujo con botella mini, fresas premium decoradas y globo personalizado.', 85000.00, 10)
ON CONFLICT (codigo_sku) DO NOTHING;
