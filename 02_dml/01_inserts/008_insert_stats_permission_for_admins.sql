-- HU-13 / CU08: Portal de estadísticas (solo Administradores).
-- Se crea el permiso 'stats.read' y se asigna exclusivamente al rol Admin.
INSERT INTO security.permissions (name, description)
VALUES
('stats.read', 'Consultar estadísticas del sistema')
ON CONFLICT (name) DO NOTHING;

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p ON p.name = 'stats.read'
WHERE r.name = 'Admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;