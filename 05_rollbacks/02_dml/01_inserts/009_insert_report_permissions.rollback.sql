DELETE FROM security.role_permissions
WHERE permission_id IN (SELECT id FROM security.permissions
  WHERE name IN ('reports.create', 'reports.read', 'reports.validate'));

DELETE FROM security.permissions
WHERE name IN ('reports.create', 'reports.read', 'reports.validate');