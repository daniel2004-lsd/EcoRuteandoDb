INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p
ON p.name IN (
    'users.read',
    'users.create',
    'users.update',
    'users.delete',
    'roles.read',
    'roles.create',
    'roles.update',
    'roles.delete',
    'permissions.read',
    'permissions.create',
    'permissions.update',
    'permissions.delete'
)
WHERE r.name = 'Admin';