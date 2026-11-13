# Backend Arichoc - Proyecto Polyglot

Backend desarrollado con Node.js y Express, con soporte para bases de datos relacionales (PostgreSQL) y no relacionales (MongoDB).

---

## 🛠️ Tecnologías

- **Node.js** (ES Modules)
- **Express 5**
- **PostgreSQL** (`pg`)
- **MongoDB** (`mongoose`)
- **Morgan** (Logger HTTP)
- **CORS** & **Dotenv**

---

## 📂 Estructura del Proyecto

```text
backend/
├── .env.example
├── .gitignore
├── database.sql
├── package.json
└── src/
    ├── app.js
    ├── server.js
    ├── config/
    │   ├── db.js
    │   └── environment.js
    ├── controllers/
    │   └── healthController.js
    ├── middlewares/
    ├── models/
    ├── routes/
    │   └── healthRoutes.js
    ├── services/
    └── utils/
```

---

## ⚙️ Instalación y Configuración

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/sebastiancalderonroblox-wq/backend_arichoc.git
   cd backend_arichoc
   ```

2. Instalar dependencias:
   ```bash
   npm install
   ```

3. Configurar variables de entorno:
   Copiar `.env.example` a `.env` y configurar las credenciales:
   ```bash
   cp .env.example .env
   ```

4. Ejecutar el servidor en modo desarrollo:
   ```bash
   npm run dev
   ```

---

## 🩺 Endpoints Base

- `GET /api/health` - Comprueba el estado del servidor y la conexión a las bases de datos.

---

## 👥 Integrantes del Equipo

- **Sebastián Calderón Santana** - *Desarrollador Full-Stack / Backend* ([@sebastiancalderonroblox-wq](https://github.com/sebastiancalderonroblox-wq))
- **Jhosman** - *Co-desarrollador del Proyecto*
