-- HU-16 / CU07: Reporte ciudadano de obstáculos.
-- Se crean los permisos 'reports.*' y se asignan a los roles.
--   reports.create  -> Usuario (reporta) + Admin (gestión)
--   reports.read    -> Usuario (propios reportes) + Admin (validación)
--   reports.validate-> Admin (validar/rechazar reportes)
INSERT INTO security.permissions (name, description)
VALUES
('reports.create', 'Reportar obstáculos o problemas en las rutas'),
('reports.read', 'Consultar reportes de obstáculos'),
('reports.validate', 'Validar o rechazar reportes de obstáculos')
ON CONFLICT (name) DO NOTHING;

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p
ON p.name IN ('reports.create', 'reports.read')
WHERE r.name = 'User'
ON CONFLICT (role_id, permission_id) DO NOTHING;

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p
ON p.name IN ('reports.create', 'reports.read', 'reports.validate')
WHERE r.name = 'Admin'
ON CONFLICT (role_id, permission_id) DO NOTHING;