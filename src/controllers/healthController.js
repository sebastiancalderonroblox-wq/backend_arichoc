import { pool, mongoose } from '../config/db.js';

/**
 * Controlador de Verificación de Salud del Sistema (Health Check)
 * Endpoint: GET /api/health y GET /health
 * Diagnostica conectividad y latencia hacia PostgreSQL y MongoDB Atlas
 */
export async function getHealthStatus(req, res) {
    const services = {
        api: {
            status: 'up',
            uptime_seconds: Math.floor(process.uptime())
        },
        postgres: {
            status: 'down',
            latency_ms: null,
            error: null
        },
        mongodb: {
            status: 'down',
            latency_ms: null,
            error: null
        }
    };

    // 1. Evaluar PostgreSQL Pool
    const pgStart = Date.now();
    try {
        await pool.query('SELECT NOW()');
        services.postgres.latency_ms = Date.now() - pgStart;
        services.postgres.status = 'healthy';
    } catch (err) {
        services.postgres.latency_ms = Date.now() - pgStart;
        services.postgres.error = err.message;
    }

    // 2. Evaluar MongoDB Atlas
    const mongoStart = Date.now();
    try {
        if (mongoose.connection.readyState === 1 && mongoose.connection.db) {
            await mongoose.connection.db.admin().ping();
            services.mongodb.latency_ms = Date.now() - mongoStart;
            services.mongodb.status = 'healthy';
        }
    } catch (err) {
        services.mongodb.latency_ms = Date.now() - mongoStart;
        services.mongodb.error = err.message;
    }

    const isHealthy = services.postgres.status === 'healthy' && services.mongodb.status === 'healthy';

    // Responde 200 OK confirmando que el servidor está activo y detallando el estado de servicios
    return res.status(200).json({
        status: isHealthy ? 'healthy' : 'degraded',
        server: 'active',
        project: 'ARICHOC - Plataforma de Chocolatería Artesanal y Detalles Personalizados',
        environment: process.env.NODE_ENV || 'development',
        ficha: '3293992 - ADSO SENA Huila',
        timestamp: new Date().toISOString(),
        services
    });
}
