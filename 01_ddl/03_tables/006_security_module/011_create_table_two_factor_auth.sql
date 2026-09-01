CREATE TABLE security.two_factor_auth (
    id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id            UUID NOT NULL,
    method             security.two_factor_method NOT NULL,
    encrypted_secret   BYTEA,
    is_active          BOOLEAN NOT NULL DEFAULT FALSE,
    updated_at TIMESTAMPTZ  NULL ,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, method)
);