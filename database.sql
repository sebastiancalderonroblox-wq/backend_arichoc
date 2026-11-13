-- Script de Creación de Base de Datos y Tablas (PostgreSQL)
-- Proyecto: Backend Arichoc / Polyglot

CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    correo VARCHAR(100),
    ciudad VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS videojuegos (
    id_videojuego INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    genero VARCHAR(50) NOT NULL,
    plataforma VARCHAR(50) NOT NULL,
    precio NUMERIC(12,2) NOT NULL,
    stock INT NOT NULL
);

CREATE TABLE IF NOT EXISTS consola (
    id_consola INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    marca VARCHAR(50) NOT NULL,
    precio NUMERIC(12,2) NOT NULL,
    stock INT NOT NULL
);
