INSERT INTO admin.companies (id, nit, business_name, sector, monthly_co2_budget_kg, contact_email)
VALUES
    ('c0010000-0000-0000-0000-000000000001', '891100299-1', 'Coomotor S.A.', 'passenger_transport', 80000.00, 'sostenibilidad@coomotor.com.co'),
    ('c0010000-0000-0000-0000-000000000002', '891101450-4', 'Cootranshuila Ltda.', 'passenger_transport', 65000.00, 'gestionambiental@cootranshuila.com'),
    ('c0010000-0000-0000-0000-000000000003', '900123456-7', 'Cooperativa de Taxis de Neiva', 'urban_taxi', 35000.00, 'contacto@taxisneiva.co')
ON CONFLICT (nit) DO NOTHING;

INSERT INTO admin.company_fleet_types (company_id, vehicle_type, fuel_type, emission_factor_kg_km, source_reference)
VALUES
    ('c0010000-0000-0000-0000-000000000001', 'Bus Intermunicipal Preferencial', 'diesel', 0.285000, 'Resolución MinAmbiente / UPME'),
    ('c0010000-0000-0000-0000-000000000001', 'Microbús Navette Urbano', 'diesel', 0.210000, 'Resolución MinAmbiente / UPME'),
    ('c0010000-0000-0000-0000-000000000002', 'Bus Escolar / Intermunicipal', 'diesel', 0.275000, 'Guía Factores Emisión IDEAM'),
    ('c0010000-0000-0000-0000-000000000003', 'Automóvil Taxi Urbano', 'gnv', 0.115000, 'UPME Factor GNV Urbano'),
    ('c0010000-0000-0000-0000-000000000003', 'Automóvil Taxi Gasolina', 'gasolina', 0.170000, 'IPCC 2006 Mobile Combustion')
ON CONFLICT DO NOTHING;
