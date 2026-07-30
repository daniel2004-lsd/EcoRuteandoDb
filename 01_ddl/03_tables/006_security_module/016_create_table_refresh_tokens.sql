CREATE TABLE security.refresh_tokens
(
    refresh_token_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    user_id UUID NOT NULL,

    token_hash TEXT NOT NULL,

    expires_at TIMESTAMPTZ NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    updated_at TIMESTAMPTZ  NULL ,

    revoked_at TIMESTAMPTZ NULL,

    replaced_by_refresh_token_hash TEXT NULL,

    created_by_ip VARCHAR(45) NULL,

    revoked_by_ip VARCHAR(45) NULL,

    CONSTRAINT fk_refresh_tokens_user
        FOREIGN KEY (user_id)
        REFERENCES security.users(user_id)
        ON DELETE CASCADE
);

CREATE INDEX idx_refresh_tokens_user_id
ON security.refresh_tokens(user_id);

CREATE INDEX idx_refresh_tokens_hash
ON security.refresh_tokens(token_hash);

CREATE INDEX idx_refresh_tokens_expires_at
ON security.refresh_tokens(expires_at);