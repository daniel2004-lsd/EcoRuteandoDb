CREATE TABLE community.alert_route (
    alert_id UUID NOT NULL,
    route_id UUID NOT NULL,
    PRIMARY KEY (alert_id, route_id)
);