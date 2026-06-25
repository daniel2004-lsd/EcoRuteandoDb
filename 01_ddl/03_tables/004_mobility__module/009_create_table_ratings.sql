CREATE TABLE mobility.ratings (
    rating_id    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id      UUID     NOT NULL,
    route_id     UUID     NOT NULL,
    usage_id     BIGINT,
    rating       SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment      TEXT,
    helpful_count INT NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (user_id, route_id)
);