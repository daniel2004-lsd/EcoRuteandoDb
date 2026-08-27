DELETE FROM security.role_permissions
WHERE permission_id IN (
    SELECT id FROM security.permissions
    WHERE name = 'routes.read'
);

DELETE FROM security.permissions
WHERE name = 'routes.read';
