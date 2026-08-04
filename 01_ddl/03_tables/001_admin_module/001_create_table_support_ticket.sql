CREATE TABLE admin.support_tickets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    user_id UUID,
    admin_id UUID,

    subject VARCHAR(200) NOT NULL,

    status admin.support_status NOT NULL DEFAULT 'pending',

    priority SMALLINT NOT NULL DEFAULT 2
        CHECK (priority BETWEEN 1 AND 4),

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),

    closed_at TIMESTAMPTZ
);