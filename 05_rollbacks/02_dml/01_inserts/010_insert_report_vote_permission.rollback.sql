DELETE FROM security.role_permissions
WHERE permission_id IN (SELECT id FROM security.permissions WHERE name = 'reports.vote');

DELETE FROM security.permissions WHERE name = 'reports.vote';
