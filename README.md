# 🍫 Plataforma ARICHOC — Backend API RESTful & Base de Datos

Repositorio oficial del backend para la plataforma de **E-Commerce y Personalización de Chocolatería Artesanal ARICHOC**, desarrollada en el marco del programa **Tecnólogo en Análisis y Desarrollo de Software (ADSO - Ficha 3293992)** del **SENA Regional Huila** (Centro Agroempresarial y Desarrollo Pecuario del Huila - Garzón, Huila).

---

## 📌 1. Descripción del Proyecto

**ARICHOC** es una unidad productiva dedicada a la chocolatería artesanal y diseño de detalles personalizados en el municipio de Garzón, Huila.

Este backend provee una arquitectura modular, escalable y robusta basada en **Node.js** y **Express.js**, integrando la persistencia de datos relacional para el manejo estricto de transacciones, inventario en tiempo real, pedidos y pagos, junto con soporte para persistencia documental:
- **PostgreSQL 16 (Motor Relacional Transaccional - Base `ARICHOC`):** Garantiza cumplimiento ACID para la gestión de usuarios, roles, catálogo maestro de productos con control de stock físico, órdenes de compra y conciliación financiera de pagos (Nequi, Bancolombia, Efectivo).
- **MongoDB Atlas (Persistencia Documental - Base `ARICHOC`):** Conexión activa y configurada para catálogo dinámico y registros flexibles.

---

## 🛠️ 2. Tecnologías Utilizadas

- **Entorno de Ejecución:** [Node.js](https://nodejs.org/) (Arquitectura moderna con ECMAScript Modules `ESM`)
- **Framework Web:** [Express.js](https://expressjs.com/) v5
- **Motor de Base de Datos Relacional:** [PostgreSQL](https://www.postgresql.org/) (driver nativo `pg` con Pool de conexiones singleton hacia la base `ARICHOC`)
- **Motor Documental NoSQL:** [MongoDB Atlas](https://www.mongodb.com/atlas) vía [Mongoose](https://mongoosejs.com/) (hacia la base `ARICHOC`)
- **Middlewares & Utilidades:**
  - `cors` (Intercambio de recursos de origen cruzado)
  - `morgan` (Logger de peticiones HTTP en consola)
  - `dotenv` (Gestión segura de variables de entorno)

---

## 📂 3. Estructura del Directorio

El proyecto sigue una organización modular sin carpetas vacías ni archivos residuales, manteniendo únicamente los directorios activos del servidor:

```text
backend_arichoc/
├── .env.example              # Plantilla pública de variables de entorno requeridas
├── .gitignore                # Reglas de exclusión (node_modules, .env, logs)
├── database.sql              # Script DDL de creación de la base de datos ARICHOC
├── package.json              # Metadatos del proyecto, dependencias y scripts de arranque
├── README.md                 # Documentación técnica integral del sistema
├── pruebaADSO2/              # Colecciones y evidencias de pruebas HTTP (OpenAPI / YAML)
└── src/
    ├── app.js                # Configuración de Express, middlewares globales y enrutadores
    ├── server.js             # Punto de entrada (bootstrap), inicio de BD y apagado elegante
    ├── config/
    │   ├── db.js             # Singleton del Pool PostgreSQL y conexión a bases de datos
    │   └── environment.js    # Validación fail-fast y tipado de variables de entorno
    ├── controllers/
    │   └── healthController.js # Lógica de diagnóstico, latencias y telemetría de BD
    └── routes/
        └── healthRoutes.js   # Enrutador para verificación de salud del sistema (/api/health, /health)
```

---

## 🗄️ 4. Persistencia y Base de Datos (Script DDL)

El entregable de base de datos se encuentra completamente definido en el script SQL **`database.sql`**, el cual crea y deja estructurada la base de datos **`ARICHOC`**:

1. **Tablas Normalizadas (1FN, 2FN y 3FN):**
   - `roles`: Catálogo de perfiles del sistema (`CLIENTE`, `ARTESANO`, `ADMINISTRADOR`).
   - `usuarios`: Cuentas registradas, credenciales encriptadas y asociación de rol.
   - `productos_detalles`: Catálogo de arreglos y chocolates con control de `stock_actual` y `precio_base_cop`.
   - `pedidos`: Órdenes transaccionales con control de estados (`PENDIENTE`, `CONFIRMADO`, `EN_PREPARACION`, etc.).
   - `detalle_pedido`: Ítems asociados a la orden, cantidad, precio histórico y enlace políglota.
   - `pagos`: Conciliación bancaria con referencia única (`ref_transaccion`) y métodos admitidos (`NEQUI`, `BANCOLOMBIA`, `EFECTIVO_GARZON`).

2. **Restricciones de Integridad y Reglas de Negocio:**
   - `CONSTRAINT chk_stock_positivo CHECK (stock_actual >= 0)`
   - `CONSTRAINT chk_precio_base_positivo CHECK (precio_base_cop > 0)`
   - `CONSTRAINT chk_total_positivo CHECK (total_cop >= 0)`
   - `CONSTRAINT chk_metodo_pago CHECK (metodo_pago IN ('NEQUI', 'BANCOLOMBIA', 'EFECTIVO_GARZON'))`

3. **Optimización con Índices B-Tree:**
   - `idx_pedidos_usuario_estado`: Acelera la búsqueda de pedidos por cliente y filtros por estado.
   - `idx_detalles_stock_disp`: Índice parcial que optimiza las consultas del catálogo público solo con stock disponible.

4. **Datos Semilla (Seeds):**
   - Inserción inicial de roles del sistema, usuarios de prueba y productos emblemáticos de chocolatería artesanal de Garzón, Huila.

---

## ⚙️ 5. Requisitos Previos e Instalación

### Prerrequisitos
- **Node.js** v18.x o superior instalado.
- **PostgreSQL 16+** instalado y en ejecución en el puerto `5432` (o servicio cloud).
- **MongoDB Atlas** (o instancia local) con la base de datos `ARICHOC`.
- **Git** instalado en el sistema.

### Paso 1: Clonar el Repositorio
```bash
git clone https://github.com/sebastiancalderonroblox-wq/backend_arichoc.git
cd backend_arichoc
```

### Paso 2: Instalar Dependencias
```bash
npm install
```

### Paso 3: Configurar las Variables de Entorno
Cree un archivo `.env` en la raíz del proyecto a partir de la plantilla `.env.example`:

En Windows (PowerShell):
```powershell
Copy-Item .env.example .env
```

En Linux / macOS:
```bash
cp .env.example .env
```

Edite el archivo `.env` con las credenciales de sus motores de bases de datos (ambas apuntando a la base **`ARICHOC`**):
```ini
PORT=3000
NODE_ENV=development

# PostgreSQL Configuration
PG_HOST=localhost
PG_PORT=5432
PG_DATABASE=ARICHOC
PG_USER=postgres
PG_PASSWORD=su_contraseña_aqui
PG_MAX_POOL=10
PG_IDLE_TIMEOUT=30000

# MongoDB Configuration
MONGO_URI=mongodb+srv://<usuario>:<password>@cluster.mongodb.net/ARICHOC?retryWrites=true&w=majority
```

### Paso 4: Aprovisionar la Base de Datos Relacional (PostgreSQL)
Cree la base de datos `ARICHOC` y ejecute el script `database.sql` en su cliente PostgreSQL preferido (pgAdmin 4, DBeaver o CLI psql):
```bash
createdb -U postgres ARICHOC
psql -U postgres -d ARICHOC -f database.sql
```

### Paso 5: Iniciar el Servidor Backend

Modo Desarrollo (con reinicio automático `--watch`):
```bash
npm run dev
```

Modo Producción:
```bash
npm start
```

Salida esperada en consola (validación de conexión con ambas bases `ARICHOC` al iniciar):
```text
🔌 [ADSO DUAL DB] Inicializando conexiones...
🐘 [PostgreSQL] Nuevo cliente físico asignado en el Pool
✅ [PostgreSQL Conectado] Base: "ARICHOC"
🍃 [MongoDB] Conexión establecida exitosamente con el clúster
✅ [MongoDB Atlas Conectado] Base: "ARICHOC"
🚀 Servidor activo en: http://localhost:3000
```

---

## 🩺 6. Endpoints de Verificación (Health Check)

El backend implementa la ruta inicial de salud para validar que el servidor está activo y diagnosticar la conexión con los motores de base de datos:

### `GET /api/health` o `GET /health`
- **Código de Respuesta:** `200 OK`
- **Formato:** JSON

#### Ejemplo de Respuesta:
```json
{
  "status": "healthy",
  "server": "active",
  "project": "ARICHOC - Plataforma de Chocolatería Artesanal y Detalles Personalizados",
  "environment": "development",
  "ficha": "3293992 - ADSO SENA Huila",
  "timestamp": "2026-11-14T00:58:37.809Z",
  "services": {
    "api": {
      "status": "up",
      "uptime_seconds": 12
    },
    "postgres": {
      "status": "healthy",
      "latency_ms": 1,
      "error": null
    },
    "mongodb": {
      "status": "healthy",
      "latency_ms": 98,
      "error": null
    }
  }
}
```

---

## 👥 7. Integrantes del Equipo

Proyecto Formativo desarrollado por aprendices del **SENA Centro Agroempresarial y Desarrollo Pecuario del Huila (Garzón)**:

- **Sebastián Calderón Santana** — *Líder de Desarrollo Backend & Arquitectura de Software* ([@sebastiancalderonroblox-wq](https://github.com/sebastiancalderonroblox-wq))
- **Jhosman** — *Co-desarrollador de Proyecto Formativo*

*Tecnólogo en Análisis y Desarrollo de Software (ADSO) — Ficha: 3293992*  
*Regional Huila — Sede Garzón — 2026*
