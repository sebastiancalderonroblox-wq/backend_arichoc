import mongoose from 'mongoose';

const opcionCintaSchema = new mongoose.Schema({
    hex: { type: String, required: true },
    nombre: { type: String, required: true }
}, { _id: false });

const toppingExtraSchema = new mongoose.Schema({
    nombre: { type: String, required: true },
    costo: { type: Number, required: true, min: 0 }
}, { _id: false });

/**
 * Esquema para Catálogo Extendido y Flexible de ARICHOC
 * Contiene opciones dinámicas de personalización (colores, cintas, tipos de cacao, formas, toppings)
 */
const catalogoFlexibleSchema = new mongoose.Schema({
    sku_postgres_ref: {
        type: String,
        required: true,
        unique: true,
        trim: true
    },
    nombre: {
        type: String,
        required: true,
        trim: true
    },
    descripcion: {
        type: String,
        default: ''
    },
    es_best_seller: {
        type: Boolean,
        default: false
    },
    galeria_urls: [{
        type: String,
        trim: true
    }],
    opciones_personalizacion: {
        colores_cinta: [opcionCintaSchema],
        tipos_cacao: [{ type: String, trim: true }],
        formas: [{ type: String, trim: true }],
        max_caracteres_mensaje: { type: Number, default: 150 },
        toppings_extra: [toppingExtraSchema]
    }
}, {
    timestamps: true,
    collection: 'catalogo_flexible'
});

// Índice compuesto para acelerar el renderizado del catálogo y filtros multifactoriales
catalogoFlexibleSchema.index({
    es_best_seller: 1,
    'opciones_personalizacion.tipos_cacao': 1,
    'opciones_personalizacion.formas': 1
});

export const CatalogoFlexible = mongoose.model('CatalogoFlexible', catalogoFlexibleSchema);
export default CatalogoFlexible;
