CREATE TABLE security.sessions (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id             UUID NOT NULL,
    refresh_token_hash  VARCHAR(64) UNIQUE NOT NULL,
    source_ip           INET,
    user_agent          TEXT,
    device              VARCHAR(100),
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ  NULL ,
    last_used_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at          TIMESTAMPTZ NOT NULL,
    revoked_at          TIMESTAMPTZ
);
