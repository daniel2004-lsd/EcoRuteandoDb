-- HU-12 / CU03: el actor de la historia es el Usuario, que debe poder
-- eliminar rutas que él mismo creó. La eliminación está protegida a nivel
-- de aplicación (solo el creador o un Admin pueden borrar), por lo que
-- conceder 'routes.delete' al rol User no abre un agujero de seguridad.
INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p ON p.name = 'routes.delete'
WHERE r.name = 'User'
ON CONFLICT (role_id, permission_id) DO NOTHING;