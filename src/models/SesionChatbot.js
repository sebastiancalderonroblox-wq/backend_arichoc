import mongoose from 'mongoose';

const mensajeSchema = new mongoose.Schema({
    emisor: {
        type: String,
        enum: ['cliente', 'bot', 'artesano'],
        required: true
    },
    texto: {
        type: String,
        required: true
    },
    intencion_detectada: {
        type: String,
        default: 'consulta_general'
    },
    timestamp: {
        type: Date,
        default: Date.now
    }
}, { _id: false });

/**
 * Esquema de Sesión de Chatbot y Asistencia Conversacional 24/7
 * Permite registrar la bitácora de mensajes y escalar a atención artesanal en vivo.
 */
const sesionChatbotSchema = new mongoose.Schema({
    canal_origen: {
        type: String,
        default: 'Web Widget'
    },
    escalado_admin: {
        type: Boolean,
        default: false
    },
    historial_mensajes: [mensajeSchema],
    fecha_actualizacion: {
        type: Date,
        default: Date.now
    }
}, {
    timestamps: true,
    collection: 'sesiones_chatbot'
});

// Índice compuesto para consultar chats que solicitan atención humana urgente
sesionChatbotSchema.index({ escalado_admin: 1, fecha_actualizacion: -1 });

export const SesionChatbot = mongoose.model('SesionChatbot', sesionChatbotSchema);
export default SesionChatbot;
