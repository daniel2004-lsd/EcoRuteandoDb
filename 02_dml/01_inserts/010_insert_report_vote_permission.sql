-- HU-22 / CU22: validación comunitaria de reportes.
-- reports.vote -> Usuario (confirmar/rechazar reportes cercanos) + Admin.
INSERT INTO security.permissions (name, description)
VALUES
('reports.vote', 'Confirmar o rechazar reportes de obstáculos cercanos')
ON CONFLICT (name) DO NOTHING;

INSERT INTO security.role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM security.roles r
JOIN security.permissions p
ON p.name = 'reports.vote'
WHERE r.name IN ('User', 'Admin')
ON CONFLICT (role_id, permission_id) DO NOTHING;
