CREATE TYPE mobility.tipo_transporte AS ENUM ('bicicleta','transporte_publico','mixto','caminata');
CREATE TYPE mobility.estado_ruta     AS ENUM ('activa','inactiva','en_revision','archivada');
CREATE TYPE mobility.origen_uso      AS ENUM ('web','movil','pwa');
CREATE TYPE mobility.tipo_busqueda   AS ENUM ('busqueda','origen','destino');
 