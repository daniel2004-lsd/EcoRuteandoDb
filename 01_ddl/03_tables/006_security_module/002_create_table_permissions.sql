CREATE TABLE security.permissions (
    permission_id SERIAL PRIMARY KEY,
    name          VARCHAR(80) NOT NULL UNIQUE,
    description   VARCHAR(255),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);