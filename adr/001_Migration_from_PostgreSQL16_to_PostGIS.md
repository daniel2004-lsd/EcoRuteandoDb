# ADR-001: Migración de PostgreSQL 16 a PostGIS-enabled image (postgis/postgis:16-3.5)

## Estado
Aceptado

---

## Contexto

El proyecto **EcoRuteando** utiliza PostgreSQL como base de datos principal para gestionar usuarios, rutas, reportes comunitarios y datos de movilidad.

Durante el desarrollo del sistema se incorporaron funcionalidades geoespaciales como:

- Áreas de impacto de alertas
- Geometría de rutas
- Análisis de proximidad entre eventos y usuarios
- Consultas espaciales avanzadas

La imagen estándar de PostgreSQL 16 no incluye soporte nativo para extensiones geoespaciales como **PostGIS**, lo cual limita estas funcionalidades.

---

## Problema

Con `postgres:16` no es posible:

- Usar tipos de datos `GEOGRAPHY` y `GEOMETRY`
- Ejecutar funciones espaciales (`ST_Intersects`, `ST_Distance`, etc.)
- Realizar análisis geoespacial eficiente
- Implementar geofencing o cálculos de proximidad

Esto afecta directamente módulos como:

- community.alerts (áreas de impacto)
- mobility.routes (geometría de rutas)
- análisis de cercanía entre entidades del sistema

---

## Decisión

Se reemplaza la imagen base de Docker:

```yaml
postgres:16