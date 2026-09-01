CREATE TABLE notifications.notification_templates (
    id   UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name           VARCHAR(100) NOT NULL UNIQUE,
    notification_type notifications.notification_type NOT NULL,
    subject        VARCHAR(200),
    html_body      TEXT,
    text_body      TEXT,
    is_active      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now()
);