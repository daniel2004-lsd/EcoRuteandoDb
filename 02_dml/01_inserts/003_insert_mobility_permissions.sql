INSERT INTO security.permissions (name, description)
VALUES
('routes.read', 'Consultar rutas');

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p
ON p.name IN (
    'routes.read'
)
WHERE r.name = 'Admin';
