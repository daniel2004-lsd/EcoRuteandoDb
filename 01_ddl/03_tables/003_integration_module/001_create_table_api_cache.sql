CREATE TABLE integrations.api_cache (
    cache_id         BIGSERIAL PRIMARY KEY,
    provider         VARCHAR(60)  NOT NULL,
    endpoint         VARCHAR(200) NOT NULL,
    parameters       JSONB        NOT NULL,
    parameters_hash  VARCHAR(64) GENERATED ALWAYS AS (
                        encode(sha256(parameters::text::bytea), 'hex')
                     ) STORED,
    response         JSONB NOT NULL,
    is_valid         BOOLEAN NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at       TIMESTAMPTZ NOT NULL,
    CHECK (jsonb_typeof(parameters) = 'object')
);