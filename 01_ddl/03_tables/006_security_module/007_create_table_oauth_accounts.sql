CREATE TABLE security.oauth_accounts (
    id UUID PRIMARY KEY,
    user_id             UUID NOT NULL,
    provider            security.oauth_provider NOT NULL,
    external_id         VARCHAR(255) NOT NULL,
    encrypted_access_token  BYTEA,
    encrypted_refresh_token BYTEA,
    token_scope         VARCHAR(255),
    token_expires_at    TIMESTAMPTZ,
    oauth_email         VARCHAR(150),
    oauth_name          VARCHAR(200),
    oauth_photo_url     VARCHAR(500),
    created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (provider, external_id),
    UNIQUE (user_id, provider)
);