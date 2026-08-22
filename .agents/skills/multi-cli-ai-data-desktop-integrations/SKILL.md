---
name: multi-cli-ai-data-desktop-integrations
description: Crear, corregir o revisar Data e integraciones desktop de MultiCLI AI. Usar al tocar Drift/SQLite, tablas, migraciones, repository implementations, mappers, filesystem, `ProcessRunner`, terminales Linux/Windows, Multi CLI, Codex app-server JSON-RPC, logs, timeouts o credenciales; no usar para UI Flutter o reglas de dominio aisladas.
---

# MultiCLI AI Data e Integraciones Desktop

## Proposito

Implementar puertos protegiendo datos locales y encapsulando infraestructura. Leer Data, persistencia, integraciones y rendimiento en `../../references/architecture.md`.

## Flujo

1. Investigar puerto, esquema, datos, consulta, proceso o protocolo.
2. Confirmar entrada, salida, nulabilidad, volumen, transaccion, plataforma, timeout, logging y fallos.
3. Presentar tablas/migraciones, archivos, contratos e integraciones; esperar aprobacion.
4. Implementar infraestructura y mapper sin exponer tipos concretos.
5. Revisar compatibilidad, rendimiento, seguridad y traduccion de errores.
6. Ejecutar formato, analisis y pruebas focalizadas conforme a `AGENTS.md`.

## Drift

- Rows y companions permanecen en Data y se mapean a entidades.
- Mientras dure la migracion, `core/database` es infraestructura Data compartida y no autoriza imports desde Domain o Presentation.
- Preservar PK, FK, nulabilidad, dinero y fechas.
- Incrementar `schemaVersion` y agregar `onUpgrade` compatible.
- No borrar datos como atajo ni editar `app_database.g.dart`.
- Usar transacciones para efectos inseparables.
- Evitar queries por fila, tablas completas y consultas duplicadas.
- Filtrar, agregar, limitar y ordenar en SQLite; usar `watch()` cuando corresponda.

## Filesystem, procesos y terminales

- Normalizar rutas y validar existencia/tipo al ejecutar.
- Considerar separadores y mayusculas de Windows.
- Separar ejecutable y argumentos; no interpolar entrada en shell.
- Controlar environment, stdin, timeout, cancelacion, exit code y salida.
- Redactar tokens y contenido privado antes de persistir logs.
- Encapsular Linux/Windows tras un puerto comun; no asumir Android.

## Multi CLI y proveedores

- Mantener validacion de nombres y profile specs en el adaptador.
- Modelar capacidades de uso, device auth, perfil principal y lanzamiento.
- Conservar JSON-RPC y codigos tecnicos dentro del cliente Codex.
- Traducir proceso, protocolo, auth y disponibilidad a fallos del contrato.

## Validacion

- Usar Drift en memoria para repositories cuando este autorizado.
- Usar fakes de procesos que registren ejecutable, argumentos y environment.
- Probar migraciones con datos representativos.
- No ejecutar CLI real, abrir terminales o modificar perfiles en tests.

## Autoevaluacion

- Data implementa un puerto sin filtrar tipos concretos?
- La migracion conserva datos?
- La query evita N+1 y cargas amplias?
- Procesos y rutas son seguros para Linux/Windows?
- Timeouts, fallos, logs y credenciales estan controlados?
