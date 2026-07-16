ALTER TABLE security.users
ADD CONSTRAINT chk_users_status
CHECK (
    status IN (
        'active',
        'inactive',
        'blocked',
        'deleted'
    )
);

ALTER TABLE security.users
ADD CONSTRAINT chk_users_preferred_language
CHECK (
    preferred_language IN (
        'es',
        'en',
        'pt',
        'fr'
    )
);

ALTER TABLE security.users
ADD CONSTRAINT chk_users_ui_theme
CHECK (
    ui_theme IN (
        'light',
        'dark',
        'system'
    )
);