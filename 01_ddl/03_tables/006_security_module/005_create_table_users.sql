CREATE TABLE security.users (
    id  UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    first_name              VARCHAR(100) NOT NULL,
    last_name               VARCHAR(100),
    email                   CITEXT NOT NULL UNIQUE,
    password_hash           VARCHAR(255),
    phone_number            VARCHAR(30)
                                CHECK (phone_number ~ '^\+?[0-9 ()-]{6,30}$'),
    profile_photo_url       VARCHAR(500),
    accepted_terms          BOOLEAN NOT NULL DEFAULT FALSE,
    terms_accepted_at       TIMESTAMPTZ,
    email_verified          BOOLEAN NOT NULL DEFAULT FALSE,
    status                  security.user_status NOT NULL DEFAULT 'ACTIVE',
    is_guest                BOOLEAN NOT NULL DEFAULT FALSE,
    primary_role_id         UUID,
    preferred_language      security.preferred_language NOT NULL DEFAULT 'en',
    ui_theme                security.ui_theme NOT NULL DEFAULT 'system',
    primary_color           VARCHAR(7)
                                CHECK (primary_color ~ '^#[0-9A-Fa-f]{6}$'),
    failed_attempts         INT NOT NULL DEFAULT 0,
    locked_until            TIMESTAMPTZ,
    last_login              TIMESTAMPTZ,
    deletion_requested_at   TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT now()
);
