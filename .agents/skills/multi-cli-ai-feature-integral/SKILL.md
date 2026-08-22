---
name: multi-cli-ai-feature-integral
description: Orquestar features completas de MultiCLI AI que creen un flujo nuevo o modifiquen realmente dos o mas capas entre domain/application, data e integraciones desktop, presentation Flutter y composition root. Usar para coordinar contratos, alcance, compatibilidad y ejecucion incremental; no usar para un widget, caso de uso, repository, migracion o fix aislado.
---

# MultiCLI AI Feature Integral

## Proposito

Coordinar features transversales mediante un delta aprobado y contratos estables. Leer `../../references/architecture.md` antes de delimitar.

## Skills de capa

| Capa | Skill |
|---|---|
| Entidades, reglas, casos de uso, puertos o fallos | `$multi-cli-ai-domain-application` |
| Drift, filesystem, procesos, terminales o proveedores | `$multi-cli-ai-data-desktop-integrations` |
| Riverpod, estado, views, widgets o dialogs | `$multi-cli-ai-presentation-flutter-desktop` |
| Incidente sin causa conocida | `$multi-cli-ai-diagnostico-incidentes` |

Consultar una capa no la incorpora al delta.

## Flujo

1. Investigar solo en lectura el objetivo, precondiciones, invariantes, estado, efectos, datos, consumidores y capacidades Linux/Windows.
2. Presentar y obtener aprobacion del delta:

```text
Objetivo y reglas:
Agrega:
Modifica:
Elimina: ninguno | detalle
No cambia:
Contratos entre capas:
Datos e integraciones:
Orden de ejecucion:
Riesgos y compatibilidad:
Validacion prevista:
```

3. Congelar contratos:
   - Presentation -> application: accion, command, estado, progreso y fallos.
   - Application -> domain: invariantes, entidades, puertos y orden de efectos.
   - Domain -> data: operaciones, nulabilidad, IDs, transaccion y errores.
   - Data -> desktop: esquema, rutas, ejecutable, argumentos, timeout y redaccion.
4. Ejecutar solo capas necesarias:

```text
domain -> application -> data -> presentation -> app composition
```

5. Mantener fachadas legacy cuando sean necesarias; no ampliar `DashboardController` con otro dominio.
6. Para un flujo transversal, ubicar la orquestacion en Application de la feature propietaria de la accion visible y consumir puertos de las demas.
7. Detenerse ante otro archivo, capa, migracion, dependencia, plataforma, contrato o efecto no aprobado.
8. Ejecutar formato, analisis y pruebas focalizadas permitidas por `AGENTS.md`; comparar delta aprobado con ejecutado.

## Autoevaluacion

- La coordinacion involucra realmente dos o mas capas?
- El usuario aprobo el delta exacto?
- Domain permanece puro y Presentation desconoce Data?
- Cada contrato se congelo antes de implementar su consumidor?
- La feature propietaria del flujo y los puertos cruzados quedaron claros?
- Se controlaron plataforma, timeouts, datos y secretos?
- Se evito una migracion mayor no autorizada?
