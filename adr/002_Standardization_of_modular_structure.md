# ADR-002: Estandarización de estructura modular para base de datos con Liquibase (EcoRuteandoDb)

## Estado
Aceptado

---

## Contexto

El proyecto **EcoRuteandoDb** utiliza Liquibase para la gestión de la base de datos PostgreSQL.  
La estructura actual está organizada en capas y módulos con el objetivo de separar responsabilidades y facilitar el mantenimiento.

Las capas principales son:

- `01_ddl/` → creación de estructuras base (schemas, extensiones)
- `02_types/` → tipos de datos personalizados
- `03_tables/` → creación de tablas por módulo
- `04_constraints/` → llaves foráneas y restricciones
- `05_rollbacks/` → scripts de reversión

Cada capa está dividida por módulos de dominio como:

- security
- mobility
- community
- notifications
- admin
- integrations

Durante el desarrollo se han presentado problemas de orden de ejecución, dependencias cruzadas y errores de constraints.

---

## Problema

Sin una estructura estricta:

- Las foreign keys pueden ejecutarse antes de la creación de tablas
- Los módulos pueden depender entre sí sin control explícito
- Se generan errores en Liquibase por orden incorrecto
- Dificultad para escalar en CI/CD (Dev → QA → PROD)
- Inconsistencias entre nombres de entidades y referencias SQL

---

## Decisión

Se adopta una estructura modular estricta basada en capas y dominios.

### Estructura del repositorio

---

## Orden de ejecución en Liquibase

El orden obligatorio es:

1. Extensiones / schemas (`01_ddl`)
2. Tipos (`02_types`)
3. Tablas (`03_tables`)
4. Constraints (`04_constraints`)
5. Rollbacks (`05_rollbacks`)

---

## Justificación

Esta estructura permite:

- Separación clara por dominio (arquitectura tipo DDD)
- Control estricto de dependencias entre tablas
- Ejecución determinística en Liquibase
- Mejor mantenimiento del esquema
- Escalabilidad para CI/CD (Dev → QA → PROD)
- Reducción de errores por orden de ejecución

---

## Consecuencias positivas

- Menos errores de foreign keys
- Mejor organización del proyecto
- Facilita auditoría de cambios
- Permite crecimiento modular del sistema
- Mejora la estabilidad en pipelines automatizados

---

## Riesgos

- Requiere disciplina estricta en naming y estructura
- Posibles errores si se rompe el orden de capas
- Mayor control necesario en pull requests
- Posible duplicación si no se respetan módulos

---

## Alternativas evaluadas

### 1. Estructura monolítica de changelog
❌ Rechazada: difícil de mantener y escalar

### 2. Sin separación por módulos
❌ Rechazada: genera alto acoplamiento entre dominios

### 3. Estructura modular por capas (actual)
✔ Aceptada: balance entre orden, escalabilidad y control

---

## Decisión final

Se adopta una arquitectura de base de datos basada en:

- capas numeradas
- módulos por dominio
- orden estricto de ejecución en Liquibase
- separación clara entre tablas, constraints y rollbacks

---

## Firmado

Arquitectura de Datos – EcoRuteandoDb  
Fecha: 2026-06-24