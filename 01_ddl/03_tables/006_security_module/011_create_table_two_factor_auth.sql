CREATE TABLE security.two_factor_auth (
    two_factor_id      SERIAL PRIMARY KEY,
    user_id            UUID NOT NULL,
    method             security.two_factor_method NOT NULL,
    encrypted_secret   BYTEA,
    is_active          BOOLEAN NOT NULL DEFAULT FALSE,
    created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, method)
);