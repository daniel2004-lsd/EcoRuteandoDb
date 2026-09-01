CREATE TABLE community.report_votes (
    user_id     UUID NOT NULL,
    report_id   UUID NOT NULL,
    confirms    BOOLEAN NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, report_id)
);
