CREATE TABLE security.user_roles (
    user_id     UUID NOT NULL,
    role_id     INT NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, role_id)
);