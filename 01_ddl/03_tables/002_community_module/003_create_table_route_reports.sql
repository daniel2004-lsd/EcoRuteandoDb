CREATE TABLE community.route_reports (
    route_id    UUID NOT NULL,
    report_id   UUID NOT NULL,
    PRIMARY KEY (route_id, report_id)
);