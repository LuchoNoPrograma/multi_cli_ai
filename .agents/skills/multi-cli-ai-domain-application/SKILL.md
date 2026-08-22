---
name: multi-cli-ai-domain-application
description: Crear, corregir o revisar dominio y aplicacion de MultiCLI AI en Dart. Usar al tocar entidades, value objects, invariantes, politicas, fallos tipados, contratos de repository/gateway, commands, resultados o casos de uso dentro de `features/{feature}/domain` y `features/{feature}/application`; no usar para UI Flutter, consultas Drift o procesos aislados.
---

# MultiCLI AI Domain y Application

## Proposito

Modelar reglas independientes de Flutter, Drift, filesystem y proveedores. Leer Domain, Application, contratos y errores en `../../references/architecture.md`.

## Flujo

1. Investigar concepto, invariantes, consumidores, datos y efectos actuales.
2. Definir entradas, resultado, fallos, orden de efectos y limites externos.
3. Presentar archivos, contratos y exclusiones; esperar aprobacion.
4. Implementar entidades/politicas, luego puertos y casos de uso necesarios.
5. Verificar ausencia de imports Flutter, Riverpod, Drift, `dart:io` y adaptadores.
6. Ejecutar formato, analisis y pruebas Dart focalizadas conforme a `AGENTS.md`.

## Artefactos

- **Entidad:** identidad y comportamiento estable.
- **Value object:** valor con validacion o semantica real.
- **Politica/servicio:** regla compleja que no pertenece a una entidad.
- **Puerto:** capacidad externa requerida.
- **Caso de uso:** accion, regla o coordinacion observable.
- **Command/result:** contrato coherente con varios datos.
- **Failure:** condicion esperable que Presentation puede interpretar.

No crear artefactos vacios para completar la arquitectura.

## Reglas

- Domain usa Dart puro y Application recibe puertos por constructor.
- Los puertos expresan capacidades: `watchAccounts()`, no `selectCliProfiles()`.
- Entidades no contienen rows, companions, widgets, `AsyncValue` o `Platform`.
- Mapeos de storage y serializacion viven en Data.
- Casos de uso se nombran por accion y validan antes del primer efecto.
- Definir que ocurre ante fallo parcial y devolver resultados tipados.
- Mantener dinero en unidades menores, fechas UTC y nulabilidad real.
- Usar enums o tipos sellados para estados cerrados.
- Nombrar archivos, clases, metodos y estados tecnicos en ingles.
- Data traduce errores tecnicos; Presentation decide texto y accion.
- Un flujo transversal vive en Application de la feature propietaria de la accion visible y consume puertos de las otras features.

## Compatibilidad legacy

- No mover modelos Drift dentro de un fix no autorizado.
- Migrar mediante puerto, mapper y fachada temporal dentro del corte aprobado.
- No ampliar `account_models.dart` con nuevos tipos Drift.

## Autoevaluacion

- Domain puede probarse sin Flutter, Drift y filesystem?
- El caso de uso expresa una accion real?
- Los puertos describen capacidades estables?
- Entradas, estados, fallos y efectos estan definidos?
- Se mantuvo compatible el legacy fuera del corte?
