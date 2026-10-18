INSERT INTO admin.transport_factors (transport_type, co2_factor_kg_km, calorie_factor_km, valid_from, valid_until, source)
VALUES
    ('walking',         0.000000, 0.50, now(), NULL, 'seed'),
    ('bike',            0.000000, 0.33, now(), NULL, 'seed'),
    ('public_transport',0.060000, 0.10, now(), NULL, 'seed'),
    ('mixed',           0.050000, 0.30, now(), NULL, 'seed'),
    ('car',             0.170000, 0.05, now(), NULL, 'seed');