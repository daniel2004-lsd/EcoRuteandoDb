INSERT INTO security.roles (name, description)
VALUES
    ('Admin', 'Administrador del sistema'),
    ('User', 'Usuario estándar')
ON CONFLICT (name) DO NOTHING;