import express from 'express';
import cors from 'cors';
import morgan from 'morgan';
import healthRoutes from './routes/healthRoutes.js';

const app = express();

// 1. Middlewares Globales
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// 2. Montaje de Enrutadores (Soporta /api/health y /health según especificación ADSO)
app.use('/api/health', healthRoutes);
app.use('/health', healthRoutes);

// Ruta raíz de bienvenida e identificación
app.get('/', (req, res) => {
  res.status(200).json({
    project: 'ARICHOC - Backend API y Persistencia Políglota',
    status: 'online',
    version: '1.0.0',
    ficha: 'ADSO 3293992 - SENA Garzón, Huila',
    health_check: '/api/health'
  });
});

// 3. Manejador de Rutas No Encontradas (404)
app.use((req, res) => {
  res.status(404).json({ error: 'NotFound', message: `Ruta [${req.method}] ${req.originalUrl} no existe.` });
});

// 4. Manejador Global de Excepciones No Controladas (500)
app.use((err, req, res, next) => {
  console.error('🔥 Error:', err.stack);
  res.status(500).json({ error: 'InternalServerError', message: 'Error interno en el servidor.' });
});

export default app;
