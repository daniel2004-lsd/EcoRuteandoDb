DELETE FROM security.role_permissions
WHERE
(role_id = 1 AND permission_id BETWEEN 1 AND 12)
OR
(role_id = 2 AND permission_id IN (1,5,9));