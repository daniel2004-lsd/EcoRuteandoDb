CREATE TYPE admin.formato_export AS ENUM ('PDF','XLSX','CSV','JSON');
CREATE TYPE admin.estado_export  AS ENUM ('generando','listo','error');
CREATE TYPE admin.estado_soporte AS ENUM ('pendiente','en_proceso','resuelto','cerrado');
 