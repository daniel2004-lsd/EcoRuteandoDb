CREATE TYPE security.user_status         AS ENUM ('ACTIVE','INACTIVE','BLOCKED','DELETED');
CREATE TYPE security.error_level         AS ENUM ('INFO','WARNING','ERROR','CRITICAL');
CREATE TYPE security.oauth_provider      AS ENUM ('google','facebook','github','apple');
CREATE TYPE security.preferred_language  AS ENUM ('es','en','pt','fr');
CREATE TYPE security.ui_theme            AS ENUM ('light','dark','system');
CREATE TYPE security.two_factor_method   AS ENUM ('totp','sms','email');