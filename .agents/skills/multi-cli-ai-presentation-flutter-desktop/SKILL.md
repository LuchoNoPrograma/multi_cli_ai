---
name: multi-cli-ai-presentation-flutter-desktop
description: Crear, corregir o revisar Presentation de MultiCLI AI con Flutter Desktop y Riverpod. Usar al tocar controllers/notifiers, view states, vistas, widgets, dialogs, filtros, navegacion, loading, errores, layouts Linux/Windows o interacciones de teclado y mouse dentro de `features/{feature}/presentation`; no usar para dominio, Drift, filesystem o procesos aislados.
---

# MultiCLI AI Presentation Flutter Desktop

## Proposito

Construir UI de escritorio comunicada con Application mediante Riverpod y sin conocer infraestructura. Leer Presentation y estado reactivo en `../../references/architecture.md`.

## Flujo

1. Investigar flujo visible, controller, caso de uso, estados y consumidores.
2. Definir estado inicial, loading, progreso, exito, vacio, error y recuperacion.
3. Presentar archivos, contrato de Application y validacion; esperar aprobacion.
4. Implementar state/controller antes de conectar widgets en flujos nuevos.
5. Verificar que Presentation no acceda a database, rows, filesystem, procesos o JSON-RPC.
6. Revisar ciclo de vida, concurrencia, accesibilidad y layout desktop.

## Estado y Riverpod

- Preferir `Notifier` o `AsyncNotifier` por feature con estado inmutable.
- Mantener `ChangeNotifier` legacy sin agregarle otro dominio.
- Inyectar casos de uso; solo composition root conoce implementaciones Data.
- Observar providers focalizados o usar `select`.
- No usar `reload()` global; actualizar el estado afectado o consumir un stream.
- Enviar commands, IDs o tipos del dominio y recibir resultados/fallos tipados.

## Concurrencia y ciclo de vida

- Impedir doble envio cuando la operacion no sea idempotente.
- Correlacionar solicitudes y actualizar loading/error solo para la vigente.
- Comprobar `mounted` despues de `await`.
- Liberar controllers, subscriptions, timers y sesiones.
- No ocultar fallos asincronos con `unawaited` sin control.

## UX desktop

- Disenar para Linux/Windows, teclado, mouse y ventanas redimensionables.
- Usar 900x600 como superficie minima principal y comprobar dialogs limitados.
- Mantener acciones frecuentes visibles y secundarias en menus cuando corresponda.
- Usar focus, tooltips, constraints y scroll para evitar overflow.
- No asumir patrones Android.
- Mantener el dialog recuperable ante fallo.
- No leer `controller.database` para precargar formularios.
- Mantener simbolos tecnicos en ingles y textos visibles en espanol.

## Validacion

- Revisar loading, vacio, parcial, error y reintento.
- Ejecutar formato, analisis y widget tests focalizados con providers reemplazados conforme a `AGENTS.md`.
- Comprobar superficie minima y un ancho reducido relevante.
- No ejecutar builds desktop por defecto.

## Autoevaluacion

- Presentation depende solo de Application/Domain y UI?
- El estado es inmutable y propietario de una feature?
- Loading, errores y solicitudes estan correlacionados?
- El flujo funciona con mouse, teclado y ventana limitada?
- Se evito ampliar el controller global?
