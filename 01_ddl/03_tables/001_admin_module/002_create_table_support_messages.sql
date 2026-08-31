CREATE TABLE admin.support_messages (
    id      UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ticket_id       UUID NOT NULL,
    sender_id       UUID,
    is_admin        BOOLEAN NOT NULL DEFAULT FALSE,
    message         TEXT NOT NULL,
    attachment_url  VARCHAR(500),
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);