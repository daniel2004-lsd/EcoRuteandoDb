# ADR-004 — Migración de `mobility.ratings.usage_id` de BIGINT a UUID

## Control del documento

| Campo | Valor |
|---|---|
| **Proyecto** | EcoRuteando |
| **Área** | Arquitectura y persistencia de datos |
| **Identificador** | ADR-004 |
| **Hallazgo relacionado** | H-52 |
| **Estado** | Aprobado / Implementado |
| **Fecha** | 2026-10-24 |
| **Repositorios afectados** | `EcoRuteandoDb` y `EcoRuteandoBackend` |

---

## 1. Contexto

Durante la auditoría del módulo de movilidad (`mobility`) y la persistencia relacional en PostgreSQL, se identificó una inconsistencia de modelado de datos:

1. La tabla particionada de trayectos [`mobility.route_usage`](file:///home/daniel-pc/Escritorio/EcoRuteandoDb/01_ddl/03_tables/004_mobility__module/004_create_table_route_usage.sql) utiliza `usage_id UUID NOT NULL` como clave primaria compuesta junto con `created_at`.
2. La tabla de calificaciones [`mobility.ratings`](file:///home/daniel-pc/Escritorio/EcoRuteandoDb/01_ddl/03_tables/004_mobility__module/009_create_table_ratings.sql) definía la columna `usage_id BIGINT NULL`.
3. En el backend .NET 9, el comando `RateRouteCommand` y la entidad de dominio `Rating` utilizaban tipos desalineados (`long?` vs `Guid?`), imposibilitando el enlace relacional entre una calificación y el trayecto específico que la motivó.

---

## 2. Decisión

Se adopta **`UUID`** como el tipo canónico de datos para `mobility.ratings.usage_id`, manteniendo paridad exacta entre PostgreSQL 16 y el backend .NET 9 (`Guid?`).

### 2.1 Especificaciones de la decisión
1. **Esquema de Base de Datos:**
   - La columna `mobility.ratings.usage_id` es de tipo `UUID` y permite valores nulos (`NULL`).
   - Las calificaciones pueden existir sin un trayecto asociado (calificación directa de ruta en la interfaz web/móvil).
2. **Backend .NET 9:**
   - Propiedad de dominio: `public Guid? UsageId { get; private set; }`.
   - Contratos CQRS: `RateRouteCommand.UsageId` de tipo `Guid?`.
   - Mapeo EF Core en `RatingConfiguration`: columna `usage_id` de tipo `uuid`.
3. **Estrategia de Rollback Seguro:**
   - Dado que la conversión de un `UUID` arbitrario (con caracteres hexadecimales y guiones) hacia `BIGINT` es matemáticamente imposible sin pérdida y produce errores de sintaxis en PostgreSQL (`invalid input syntax for type bigint`), el script de reversión en Liquibase utiliza una cláusula condicional resiliente:
     ```sql
     ALTER TABLE mobility.ratings
         ALTER COLUMN usage_id TYPE BIGINT
         USING (
             CASE 
                 WHEN usage_id IS NULL THEN NULL
                 WHEN usage_id::text ~ '^[0-9]+$' THEN usage_id::text::bigint
                 ELSE NULL
             END
         );
     ```
   - Si se requiere restaurar el estado original en un incidente productivo, la contingencia operativa primaria es la restauración de backup/snapshot previo (`pg_dump`) y no la conversión hacia atrás de tipos.

---

## 3. Consecuencias y Compatibilidad

### Positivas
- **Alineación de Tipos:** Se elimina el riesgo de excepciones `InvalidCastException` en Npgsql y EF Core.
- **Trazabilidad Funcional:** Permite a los usuarios calificar rutas asociadas a un trayecto real con identificador global único.
- **Resiliencia Operativa:** El script de reversión de Liquibase no falla ante la presencia de UUIDs reales.

### Negativas / Mitigaciones
- La migración es conceptualmente unidireccional (*one-way*) para identificadores UUID genuinos; los datos históricos que se registren como UUID perderán su enlace si se fuerza una reversión a BIGINT (quedarán en `NULL` operacionalmente).
