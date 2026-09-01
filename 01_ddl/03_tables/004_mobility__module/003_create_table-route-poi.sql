CREATE TABLE mobility.route_poi (
    route_id UUID NOT NULL,
    poi_id   UUID  NOT NULL,
    sort_order SMALLINT,
    PRIMARY KEY (route_id, poi_id)
);