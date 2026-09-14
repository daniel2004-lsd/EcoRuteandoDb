ALTER TABLE mobility.route_usage
    ADD COLUMN interrupted BOOLEAN NOT NULL DEFAULT FALSE;
