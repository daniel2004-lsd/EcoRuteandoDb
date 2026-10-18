INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p
ON p.name IN (
    'routes.read',
    'routes.write'
)
WHERE r.name = 'User'
ON CONFLICT (role_id, permission_id) DO NOTHING;