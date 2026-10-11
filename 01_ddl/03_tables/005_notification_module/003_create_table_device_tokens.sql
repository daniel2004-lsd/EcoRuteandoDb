CREATE TABLE notifications.device_tokens (
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id       UUID NOT NULL REFERENCES security.users(id) ON DELETE CASCADE,
    platform      VARCHAR(10) NOT NULL CHECK (platform IN ('android', 'ios', 'web')),
    expo_push_token TEXT NOT NULL,
    device_id     VARCHAR(255),
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    last_used_at  TIMESTAMPTZ,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT uq_device_tokens_user_platform UNIQUE (user_id, platform)
);
