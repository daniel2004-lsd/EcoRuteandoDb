CREATE TABLE notifications.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id         UUID NOT NULL,
    notification_type notifications.notification_type NOT NULL,
    title           VARCHAR(200) NOT NULL,
    message         TEXT NOT NULL,
    action_url      VARCHAR(500),
    extra_data      JSONB,
    is_read         BOOLEAN NOT NULL DEFAULT FALSE,
    read_at         TIMESTAMPTZ,
    channel         notifications.notification_channel NOT NULL DEFAULT 'inapp',
    is_sent         BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at         TIMESTAMPTZ,
    template_id     UUID,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (extra_data IS NULL OR jsonb_typeof(extra_data) = 'object')
);