# ms-devices-db

Repositorio de **base de datos** del dominio de Dispositivos (BC-03) de **Sy Water**. Administra el schema `devices` de `sy-water-db` con **Liquibase**, y es la única fuente de verdad del schema: device-service solo se conecta, no crea tablas.

Tiene la misma estructura que `ms-iam-db` y `ms-places-db` (`01-ddl` … `06-releases`). La guía completa está en `claude/guia-device-service-completa.md` del proyecto.

## Requisitos

- `ms-iam-db` aplicado (`security.users`) y el contenedor `sy_water_db_dev` arriba (puerto 1433).
- `ms-places-db` aplicado (`places.places`): los FKs de este repo apuntan a esa tabla.

## Puesta en marcha

```powershell
Copy-Item .env.example .env        # fill in passwords (same sa as ms-iam-db)
docker compose run --rm liquibase --defaultsFile=/workspace/liquibase.properties --searchPath=/workspace update-sql   # dry run
docker compose up                  # sqlserver-init + liquibase update
```

## Releases

| Tag | Contenido | Ubicación |
|-----|-----------|-----------|
| `v1.0-baseline` | `devices.devices` (id UUID, registro de fábrica con hashes), `devices.device_link_history`, FKs a `places.places` y `security.users`, índices, 5 dispositivos de prueba (context `dev`), rol `devices_rw` | `01-ddl/` … `04-tcl/` |

## Reglas

- No editar un changeset ya aplicado. Todo cambio nuevo va en `06-releases/vX.Y/`.
- Nunca subir `.env`.
- Los dispositivos reales se registran con `scripts/new-device.ps1`; su token y código nunca entran a git.
- device-service se conecta con `devices_app`, que no puede insertar dispositivos ni borrar nada.
