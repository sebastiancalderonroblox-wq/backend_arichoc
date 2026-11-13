import mongoose from 'mongoose';

/**
 * Esquema de Personalización en Vivo elegida por el Cliente
 * Guarda dedicatorias, colores, toppings y sobrecostos.
 * Vincula su _id (ObjectId) como personalizacion_mongo_id en PostgreSQL.
 * Cuenta con índice TTL de 7 días (604800s) para limpiar borradores huérfanos.
 */
const personalizacionClienteSchema = new mongoose.Schema({
    catalogo_doc_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'CatalogoFlexible',
        required: true
    },
    id_usuario_pg: {
        type: Number,
        required: true
    },
    seleccion_cliente: {
        color_elegido: {
            type: String,
            default: null
        },
        mensaje_dedicatoria: {
            type: String,
            maxlength: [150, 'El mensaje no puede superar 150 caracteres']
        },
        toppings_aplicados: [{
            type: String
        }],
        sobrecosto_total_cop: {
            type: Number,
            default: 0,
            min: 0
        }
    },
    fecha_creacion: {
        type: Date,
        default: Date.now,
        expires: 604800 // TTL Index: 7 días
    }
}, {
    collection: 'personalizaciones_clientes'
});

export const PersonalizacionCliente = mongoose.model('PersonalizacionCliente', personalizacionClienteSchema);
export default PersonalizacionCliente;
