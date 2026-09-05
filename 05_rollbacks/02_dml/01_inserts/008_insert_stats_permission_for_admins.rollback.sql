-- Rollback HU-13 / CU08: retira el permiso 'stats.read' y su asignación al rol Admin.
DELETE FROM security.role_permissions
WHERE permission_id IN (
    SELECT id FROM security.permissions
    WHERE name = 'stats.read'
);

DELETE FROM security.permissions
WHERE name = 'stats.read';