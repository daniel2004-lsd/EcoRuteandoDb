CREATE TABLE mobility.favorite_routes (
    user_id    UUID NOT NULL,
    route_id   UUID NOT NULL,
    label      VARCHAR(80),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (user_id, route_id)
);