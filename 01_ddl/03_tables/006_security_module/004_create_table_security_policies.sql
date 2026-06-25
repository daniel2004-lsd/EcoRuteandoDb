CREATE TABLE security.security_policies (
    policy_id                SERIAL PRIMARY KEY,
    min_password_length      INT     NOT NULL DEFAULT 8,
    require_uppercase        BOOLEAN NOT NULL DEFAULT TRUE,
    require_numbers          BOOLEAN NOT NULL DEFAULT TRUE,
    require_special_chars    BOOLEAN NOT NULL DEFAULT TRUE,
    password_expiration_days INT     NOT NULL DEFAULT 90,
    max_failed_attempts      INT     NOT NULL DEFAULT 5,
    lockout_time_minutes     INT     NOT NULL DEFAULT 30,
    max_active_sessions      INT     NOT NULL DEFAULT 5,
    updated_at               TIMESTAMPTZ NOT NULL DEFAULT now()
);
