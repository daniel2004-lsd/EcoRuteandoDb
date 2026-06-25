CREATE TABLE security.roles (
    role_id      SERIAL PRIMARY KEY,
    name         VARCHAR(50) NOT NULL UNIQUE,
    description  VARCHAR(255),
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);