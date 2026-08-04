CREATE TABLE admin.system_configuration (
    id           SMALLINT PRIMARY KEY DEFAULT 1,
    app_name            VARCHAR(100) NOT NULL DEFAULT 'EcoRuteando',
    admin_email         VARCHAR(150),
    support_phone       VARCHAR(30),
    terms_version       VARCHAR(20),
    terms_url           VARCHAR(500),
    privacy_version     VARCHAR(20),
    privacy_url         VARCHAR(500),
    enabled_apis        JSONB,
    map_cache_ttl_sec   INT NOT NULL DEFAULT 3600,
    weather_cache_ttl_sec INT NOT NULL DEFAULT 1800,
    primary_color       VARCHAR(7) NOT NULL DEFAULT '#2E7D32'
        CHECK (primary_color ~ '^#[0-9A-Fa-f]{6}$'),
    secondary_color     VARCHAR(7) NOT NULL DEFAULT '#66BB6A'
        CHECK (secondary_color ~ '^#[0-9A-Fa-f]{6}$'),
    logo_url            VARCHAR(500),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_by          UUID,
    CONSTRAINT chk_singleton CHECK (id = 1),
    CHECK (enabled_apis IS NULL OR jsonb_typeof(enabled_apis) = 'object')
);