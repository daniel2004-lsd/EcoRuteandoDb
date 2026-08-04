CREATE TABLE security.role_permissions (
    role_id     UUID NOT NULL,
    permission_id UUID NOT NULL,
    PRIMARY KEY (role_id, permission_id)
);