CREATE TABLE security.email_verifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL,
    token_hash      VARCHAR(64) UNIQUE NOT NULL,
    expires_at      TIMESTAMPTZ NOT NULL,
    is_verified     BOOLEAN NOT NULL DEFAULT FALSE,
    verified_at     TIMESTAMPTZ,
    request_ip      INET,
    updated_at TIMESTAMPTZ  NULL ,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);