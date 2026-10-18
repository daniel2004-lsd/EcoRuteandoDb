INSERT INTO security.permissions (name, description)
VALUES
    ('routes.write', 'Crear y modificar rutas'),
    ('routes.delete', 'Eliminar rutas'),
    ('rolepermissions.read', 'Consultar permisos de roles'),
    ('rolepermissions.assign', 'Asignar permisos a roles'),
    ('rolepermissions.remove', 'Quitar permisos de roles'),
    ('userroles.read', 'Consultar roles de usuarios'),
    ('userroles.assign', 'Asignar roles a usuarios'),
    ('userroles.remove', 'Quitar roles de usuarios'),
    ('securitypolicies.read', 'Consultar políticas de seguridad'),
    ('securitypolicies.update', 'Actualizar políticas de seguridad')
ON CONFLICT (name) DO NOTHING;

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p ON p.name = 'routes.write'
WHERE r.name IN ('Admin', 'User')
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p ON p.name = 'routes.delete'
WHERE r.name = 'Admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p
ON p.name IN (
    'rolepermissions.read',
    'rolepermissions.assign',
    'rolepermissions.remove',
    'userroles.read',
    'userroles.assign',
    'userroles.remove',
    'securitypolicies.read',
    'securitypolicies.update'
)
WHERE r.name = 'Admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;