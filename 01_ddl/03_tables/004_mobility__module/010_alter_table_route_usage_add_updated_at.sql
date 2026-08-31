ALTER TABLE mobility.route_usage
    ADD COLUMN updated_at TIMESTAMPTZ NOT NULL DEFAULT now();