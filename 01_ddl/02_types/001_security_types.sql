CREATE TYPE security.estado_usuario  AS ENUM ('ACTIVO','INACTIVO','BLOQUEADO','ELIMINADO');
CREATE TYPE security.nivel_error     AS ENUM ('INFO','WARNING','ERROR','CRITICO');
CREATE TYPE security.proveedor_oauth AS ENUM ('google','facebook','github','apple');
CREATE TYPE security.idioma_pref     AS ENUM ('es','en','pt','fr');
CREATE TYPE security.tema_ui         AS ENUM ('claro','oscuro','sistema');
CREATE TYPE security.metodo_2fa      AS ENUM ('totp','sms','email');