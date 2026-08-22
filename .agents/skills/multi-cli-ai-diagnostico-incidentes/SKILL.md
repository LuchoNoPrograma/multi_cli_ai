---
name: multi-cli-ai-diagnostico-incidentes
description: Investigar incidentes de MultiCLI AI con bugs, lentitud, bloqueos, cargas infinitas, estado obsoleto, resultados incorrectos, operaciones duplicadas, fallos intermitentes o problemas Drift, filesystem, procesos, terminales y Codex app-server cuando aun no se conoce la causa. Trazar solo las capas necesarias y no proponer ni implementar el fix durante el diagnostico.
---

# MultiCLI AI Diagnostico de Incidentes

## Proposito

Encontrar donde y por que ocurre un incidente desktop con evidencia y sin mezclar diagnostico con implementacion. Consultar `../../references/architecture.md` sin asumir que legacy ya fue migrado.

## Flujo

### 1. Delimitar

Identificar esperado/observado, accion, frecuencia, impacto, plataforma, perfil/workspace y reproduccion. Descubrir en el repositorio lo que no requiera preguntar.

### 2. Seguir el recorrido

- **Presentation:** evento, rebuild, dialog, `mounted`, filtros, loading y solicitud vigente.
- **Riverpod/controller:** provider, ciclo de vida, doble ejecucion, timer y recarga.
- **Application/domain:** precondicion, capacidad, efectos, fallo parcial e invariante.
- **Data/Drift:** query, transaccion, migracion, N+1, stream y mapeo.
- **Filesystem/proceso:** ruta, executable, argumentos, timeout, salida y sanitizacion.
- **Proveedor:** JSON-RPC, auth, notificacion, respuesta parcial y concurrencia.
- **Plataforma:** diferencias Linux/Windows, terminal y permisos.

### 3. Reconstruir tiempo y estado

- Ordenar eventos, awaits, timers, streams, notificaciones y escrituras.
- Identificar quien abre y cierra loading.
- Localizar todos los disparadores de una operacion duplicada.
- Comparar solicitud, persistencia, emision y render para estado obsoleto.
- Ubicar el tiempo en UI, query, filesystem, proceso o proveedor.

### 4. Comprobar

- Separar hecho verificado, hipotesis y causa descartada.
- Comparar entrada, transformacion y salida en cada limite.
- No ejecutar CLI real, abrir terminales, escribir SQLite o usar credenciales sin autorizacion.
- No presentar correlacion como causa.

### 5. Informar

```text
Sintoma:
Flujo recorrido:
Causa comprobada:
Evidencia:
Causas descartadas:
Hipotesis pendientes: ninguna | detalle
Comprobacion pendiente: ninguna | detalle
```

### 6. Separar el fix

Al encontrar la causa, detenerse. No recomendar ni editar. El fix inicia despues como fase separada con alcance aprobado.

## Autoevaluacion

- Se siguio el flujo real?
- Se reconstruyo el orden temporal?
- Evidencia, hipotesis y descartes estan separados?
- El diagnostico termino sin adelantar el fix?
