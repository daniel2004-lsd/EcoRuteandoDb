CREATE TABLE mobility.rating_votes (
    user_id    UUID NOT NULL,
    rating_id  UUID NOT NULL,
    is_helpful BOOLEAN NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, rating_id)
);