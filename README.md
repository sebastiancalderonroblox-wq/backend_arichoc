# 🍫 Plataforma ARICHOC — Backend API RESTful & Persistencia Políglota

Repositorio oficial del backend para la plataforma de **E-Commerce y Personalización de Chocolatería Artesanal ARICHOC**, desarrollada en el marco del programa **Tecnólogo en Análisis y Desarrollo de Software (ADSO - Ficha 3293992)** del **SENA Regional Huila** (Centro Agroempresarial y Desarrollo Pecuario del Huila - Garzón, Huila).

---

## 📌 1. Descripción del Proyecto

**ARICHOC** es una unidad productiva dedicada a la chocolatería artesanal y diseño de detalles personalizados en Garzón, Huila. 

Este backend implementa una **Arquitectura de Persistencia Políglota (Polyglot Persistence)** que orquesta de forma desacoplada dos motores de base de datos según las necesidades del negocio:
- **PostgreSQL 16 (Motor Relacional Transaccional):** Garantiza atomicidad e integridad ACID para la gestión de usuarios, roles, catálogo maestro con inventario físico en tiempo real, órdenes de compra y conciliación de pagos (Nequi, Bancolombia, Efectivo).
- **MongoDB 7.0 / Atlas (Motor Documental No Relacional):** Almacena fichas técnicas flexibles del catálogo, personalizaciones dinámicas en vivo (colores de empaque, toppings, dedicatorias de hasta 150 caracteres con índice TTL a 7 días) y bitácora de mensajes del asistente conversacional (Chatbot 24/7).

---

## 🛠️ 2. Tecnologías Utilizadas

- **Entorno de Ejecución:** [Node.js](https://nodejs.org/) (Arquitectura moderna con ECMAScript Modules `ESM`)
- **Framework Web:** [Express.js](https://expressjs.com/) v5
- **Motor de Base de Datos Relacional:** [PostgreSQL](https://www.postgresql.org/) (driver nativo `pg` con Pool de conexiones singleton)
- **Motor Documental NoSQL:** [MongoDB Atlas](https://www.mongodb.com/atlas) vía [Mongoose ODM](https://mongoosejs.com/)
- **Middlewares & Utilidades:**
  - `cors` (Intercambio de recursos de origen cruzado)
  - `morgan` (Logger de peticiones HTTP en consola)
  - `dotenv` (Gestión segura de variables de entorno)

---

## 📂 3. Estructura del Directorio

El proyecto sigue una arquitectura modular y escalable por capas de responsabilidad:

```text
backend_arichoc/
├── .env.example              # Plantilla pública de variables de entorno requeridas
├── .gitignore                # Reglas de exclusión (node_modules, .env, logs)
├── database.sql              # Script DDL completo de PostgreSQL (tablas, FK, checks, índices, seeds)
├── package.json              # Metadatos del proyecto, dependencias y scripts de arranque
├── README.md                 # Documentación técnica integral del sistema
├── pruebaADSO2/              # Colecciones y evidencias de pruebas HTTP (OpenAPI / YAML)
└── src/
    ├── app.js                # Configuración de Express, middlewares globales y enrutadores
    ├── server.js             # Punto de entrada (bootstrap), inicio de BD y apagado elegante (graceful shutdown)
    ├── config/
    │   ├── db.js             # Singleton del Pool PostgreSQL y conexión Mongoose con eventos de ciclo de vida
    │   └── environment.js    # Validación fail-fast y tipado de variables de entorno
    ├── controllers/
    │   └── healthController.js # Lógica de diagnóstico, latencias y telemetría de BD
    ├── middlewares/          # Interceptores de autenticación, validación y control de acceso
    ├── models/               # Modelos y esquemas de Mongoose para MongoDB
    │   ├── CatalogoFlexible.js      # Catálogo extendido con opciones dinámicas y filtros
    │   ├── PersonalizacionCliente.js# Borradores de personalizaciones con TTL de 7 días
    │   ├── SesionChatbot.js         # Bitácora conversacional escalable a soporte artesanal
    │   └── index.js                 # Exportación centralizada de modelos
    ├── routes/
    │   └── healthRoutes.js   # Enrutador para verificación de salud del sistema
    ├── services/             # Lógica de negocio y orquestación transaccional
    └── utils/                # Funciones auxiliares, formateadores y constantes
```

---

## ⚙️ 4. Requisitos Previos e Instalación

### Prerrequisitos
- **Node.js** v18.x o superior instalado.
- **PostgreSQL 16+** instalado y en ejecución en el puerto `5432` (o servicio cloud).
- **MongoDB Atlas** (clúster configurado con Connection String) o instancia local en puerto `27017`.
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

Edite el archivo `.env` con las credenciales de sus motores de bases de datos:
```ini
PORT=3000
NODE_ENV=development

# PostgreSQL Configuration
PG_HOST=localhost
PG_PORT=5432
PG_DATABASE=adso_polyglot_db
PG_USER=postgres
PG_PASSWORD=su_contraseña_aqui
PG_MAX_POOL=10
PG_IDLE_TIMEOUT=30000

# MongoDB Configuration (Cluster Atlas o Local)
MONGO_URI=mongodb+srv://<usuario>:<password>@cluster.mongodb.net/arichoc_db
```

### Paso 4: Aprovisionar la Base de Datos Relacional (PostgreSQL)
Ejecute el script `database.sql` en su cliente PostgreSQL preferido (pgAdmin 4, DBeaver o CLI psql) para crear las 6 tablas normalizadas en 3FN, las restricciones de integridad de dominio, los índices de optimización B-Tree y los datos semilla (seeds):
```bash
psql -U postgres -d adso_polyglot_db -f database.sql
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

Salida esperada en consola:
```text
🔌 [ADSO DUAL DB] Inicializando conexiones...
🐘 [PostgreSQL] Nuevo cliente físico asignado en el Pool
✅ [PostgreSQL Conectado] Base: "adso_polyglot_db"
🍃 [MongoDB] Conexión establecida exitosamente con el clúster
✅ [MongoDB Atlas Conectado] Base: "arichoc_db"
🚀 Servidor activo en: http://localhost:3000
```

---

## 🩺 5. Endpoints de Verificación (Health Check)

El backend expone endpoints de verificación de salud y telemetría para monitorizar el estado del servidor y la disponibilidad activa de ambos motores de persistencia:

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
  "timestamp": "2026-11-13T03:12:14.214Z",
  "services": {
    "api": {
      "status": "up",
      "uptime_seconds": 15
    },
    "postgres": {
      "status": "healthy",
      "latency_ms": 1,
      "error": null
    },
    "mongodb": {
      "status": "healthy",
      "latency_ms": 93,
      "error": null
    }
  }
}
```

---

## 👥 6. Integrantes del Equipo

Proyecto Formativo desarrollado por aprendices del **SENA Centro Agroempresarial y Desarrollo Pecuario del Huila (Garzón)**:

- **Sebastián Calderón Santana** — *Líder de Desarrollo Backend & Arquitectura de Software* ([@sebastiancalderonroblox-wq](https://github.com/sebastiancalderonroblox-wq))
- **Jhosman** — *Co-desarrollador de Proyecto Formativo*

*Tecnólogo en Análisis y Desarrollo de Software (ADSO) — Ficha: 3293992*  
*Regional Huila — Sede Garzón — 2026*
