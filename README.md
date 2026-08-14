# MultiCLI AI

Aplicación de escritorio local para administrar perfiles aislados de CLI de IA,
consultar su disponibilidad y cuotas, y llevar el seguimiento personal de las
suscripciones que los respaldan.

El primer proveedor soportado será OpenAI Codex mediante perfiles de Multi CLI.
La arquitectura quedará preparada para incorporar Claude Code, Kimi, Grok,
Gemini CLI y otros proveedores sin fingir capacidades que sus herramientas no
expongan.

> Estado: MVP funcional para Linux. Descubre perfiles reales de Multi CLI,
> consulta Codex app-server, conserva historial local y permite administrar
> suscripciones, pagos compartidos y notas sin copiar credenciales.

## Implementado

- Descubrimiento del perfil principal y de `~/MultiCliProfiles/codex/*`.
- Creación, renombrado, eliminación y apertura mediante `multi-cli`, en Inicio
  o en una carpeta elegida con el selector nativo del sistema.
- Device auth oficial y consulta individual o paralela con concurrencia acotada.
- Ventanas de cuota, reset credits, uso diario explícito y último éxito separado
  del estado actual.
- Calendario, tendencia de 14 días y logs redactados de comandos.
- Nombre visible, favorito, plan declarado, compra, renovación, moneda, notas y
  participantes del costo.
- Temas oscuro, claro o del sistema, tres colores de énfasis y modo compacto.

La aplicación guarda sólo su índice, historial y metadatos en SQLite dentro del
directorio de soporte de la plataforma. `auth.json` permanece en el perfil que
administra Multi CLI; renombrar un alias mueve el perfil pero no reescribe su
credencial.

## Problema

Una persona puede tener varios perfiles locales, por ejemplo:

```text
codex-tienda
codex-luis
codex-personal
```

Cada perfil puede estar vinculado a una cuenta ChatGPT distinta, tener límites
y fechas de reinicio diferentes, y corresponder a una suscripción comprada en
otra fecha, moneda o junto con otra persona.

Hoy esa información queda separada entre el filesystem, el CLI, consultas de
estado, recordatorios y anotaciones manuales. MultiCLI AI la presenta en una
sola aplicación sin reemplazar al proveedor ni interceptar las conversaciones.

Ejemplo de la información que debe reunir una cuenta:

```text
Tienda · codex-tienda
luisynico@gmail.com · ChatGPT Plus

5 horas: 63% restante
Semanal: 41% restante
Consultado ahora a las 14:32

Renueva: 16 de agosto
Costo: USD 20.00
Nico: pagado
Luis: pendiente

Nota: cuenta comprada juntos el 16 de julio
```

## Principios

- **Local first:** SQLite y los metadatos permanecen en el equipo.
- **El proveedor conserva la autenticación:** MultiCLI AI no guarda tokens,
  contraseñas, cookies, API keys ni copias de `auth.json`.
- **El filesystem es la fuente de perfiles:** la base de datos funciona como
  índice, caché, historial y metadata personal.
- **Estado honesto:** una consulta fallida nunca se presenta como si un valor
  histórico fuera actual.
- **Sin consumo oculto:** las consultas de estado usan únicamente superficies
  de metadata. La aplicación no envía prompts ni inicia ventanas de cuota.
- **Capacidades explícitas:** si un proveedor no expone límites o identidad, la
  interfaz muestra `No disponible`, no inventa datos.
- **MVP pequeño:** Codex primero. Los otros proveedores llegan mediante
  adaptadores después de validar el flujo principal.

## Plataformas

- Linux, con Linux Mint como entorno principal de desarrollo.
- Windows 10 o superior.
- Flutter Desktop como interfaz compartida.
- Sin aplicación móvil ni web en el MVP.

## Alcance del MVP

### Imprescindible

1. Descubrir dinámicamente el perfil principal de Codex y todos los perfiles
   de Multi CLI.
2. Mostrar perfiles vinculados, no vinculados, ausentes o con error.
3. Crear un perfil Codex por medio de Multi CLI.
4. Vincular una cuenta existente mediante el device auth oficial de Codex.
5. Consultar el estado actual de un perfil o de todos los perfiles.
6. Mostrar plan, ventanas de cuota, reinicios y reset credits cuando existan.
7. Diferenciar claramente el resultado actual del último resultado exitoso.
8. Registrar compra, precio, moneda, próxima renovación y notas.
9. Registrar con quién se comparte el costo y los aportes pendientes.
10. Lanzar el perfil seleccionado con su `CODEX_HOME` correspondiente.

Los directorios de trabajo se guardan como workspaces globales, independientes
de las cuentas. El último workspace seleccionado queda activo para todos los
perfiles, incluidos los que se creen después. La acción superior **Lanzar
agente** permite buscar el historial por nombre o ruta, seleccionar, añadir,
renombrar y olvidar workspaces sin modificar las carpetas del sistema, y después
elegir la cuenta que se ejecutará allí. Las cards se reservan para administrar
el estado y la cuota de cada cuenta.

### Conveniente después del primer flujo usable

- Historial y gráficas de cuotas.
- Notificaciones locales de límite bajo y renovación cercana.
- Acciones desde la bandeja del sistema.
- Exportación de historial a CSV.
- Consumo de reset credits con confirmación explícita.
- Perfiles `shared` y plantillas de Multi CLI.

### Futuro

- Adaptadores para Claude Code, Kimi, Grok y Gemini CLI.
- Sincronización opt-in entre equipos.
- Importación de facturas o capturas.
- Conversión de moneda con tasas registradas por fecha.
- Recomendación del perfil con mayor disponibilidad.

## Fuera de alcance

- Crear cuentas de OpenAI, Anthropic u otros proveedores.
- Compartir credenciales entre personas.
- Invitar participantes a la aplicación.
- Enviar mensajes a las personas registradas en un reparto de costo.
- Copiar o rotar automáticamente tokens.
- Interceptar prompts, respuestas, herramientas o sesiones del CLI.
- Unir cuotas artificialmente o actuar como proxy/load balancer.
- Enviar un prompt para iniciar una ventana de cuota.
- Firebase, PostgreSQL o un backend remoto en el MVP.

Las personas asociadas a una compra son anotaciones privadas. No son usuarios
de la aplicación y no reciben acceso al perfil ni a la cuenta.

## Terminología

- **Provider:** empresa que ofrece el servicio, por ejemplo OpenAI.
- **CLI tool:** herramienta instalada, por ejemplo `codex`.
- **Profile:** directorio local aislado, por ejemplo `codex-tienda`.
- **Provider account:** identidad observada mediante la herramienta oficial.
- **Account link:** relación histórica entre un perfil y una cuenta.
- **Usage check:** intento real de consultar metadata en un momento específico.
- **Subscription:** acuerdo comercial que el usuario registra manualmente.
- **Renewal cycle:** un periodo concreto que debe pagarse o ya fue pagado.
- **Cost share:** parte acordada con otra persona; no implica membresía real.

## Integración con Multi CLI

La raíz se resuelve así:

```text
MULTICLI_HOME, si existe
~/MultiCliProfiles, en caso contrario
```

Para Codex deben descubrirse:

```text
~/.codex                              perfil principal
<MULTICLI_HOME>/codex/*               perfiles Multi CLI
```

El perfil debe aparecer aunque todavía no tenga `auth.json`, porque ese es el
estado correcto para ofrecer la acción **Vincular cuenta**. Un `auth.json`
existente indica que puede haber autenticación, pero no prueba por sí solo que
la sesión siga siendo válida.

Ejemplo:

```text
profile_name: tienda
command_name: codex-tienda
profile_home: /home/nini/MultiCliProfiles/codex/tienda
```

Para crear un perfil limpio:

```bash
multi-cli new codex/tienda --no-seed
```

La aplicación debe invocar procesos con una lista de argumentos y un mapa de
entorno, nunca concatenando comandos recibidos del usuario. Los nombres de
perfil deben aceptar únicamente un conjunto seguro de caracteres y deben
rechazar separadores de ruta y traversal.

En Windows se resolverán las rutas desde el perfil del usuario y se localizará
el ejecutable o wrapper apropiado sin asumir sintaxis de Bash.

## Device auth de Codex

Device auth sigue siendo un inicio de sesión, pero MultiCLI AI solo presenta el
código. Codex/OpenAI poseen el flujo y persisten la sesión.

Flujo:

1. Iniciar `codex app-server --stdio` con `CODEX_HOME` apuntando al perfil.
2. Enviar `initialize`.
3. Enviar `account/read` para comprobar si ya existe una sesión válida.
4. Si hace falta vincular, enviar:

   ```json
   {
     "method": "account/login/start",
     "id": 4,
     "params": { "type": "chatgptDeviceCode" }
   }
   ```

5. Mostrar `verificationUrl` y `userCode`.
6. Esperar `account/login/completed` y permitir cancelar mediante
   `account/login/cancel`.
7. Tomar `success` de esa notificación como resultado autoritativo. Para
   versiones antiguas que no lo incluyan, confirmar con `account/read`.
8. Cerrar limpiamente el proceso app-server.

Referencia oficial:
[Codex app-server auth endpoints](https://learn.chatgpt.com/docs/app-server#auth-endpoints).

El código de dispositivo es temporal y no se persiste en SQLite.

## Consulta de estado

El prototipo actual es `~/MultiCliProfiles/bin/codex-status`. MultiCLI AI debe
reproducir su comportamiento mediante un cliente JSON-RPC tipado, no ejecutando
y parseando la salida visual del script.

Para cada perfil:

1. Iniciar app-server con el `CODEX_HOME` correcto.
2. Inicializar la sesión JSON-RPC.
3. Enviar `account/read`.
4. Enviar `account/rateLimits/read`.
5. Registrar éxito, respuesta parcial, falta de autenticación, timeout o error.
6. Guardar todas las cuotas devueltas, no solamente la primera.
7. Cerrar el proceso aunque la consulta falle.

El timeout inicial será de 15 segundos por perfil y será configurable. La
consulta de todos los perfiles usará concurrencia acotada para no iniciar una
cantidad ilimitada de procesos. El valor inicial recomendado es dos perfiles a
la vez.

### Reglas de frescura

- Cada pulsación de **Actualizar** crea un nuevo `usage_check`.
- La interfaz muestra la hora exacta de la consulta actual.
- Un timeout se muestra como `No disponible ahora: tiempo de espera agotado`.
- Un dato anterior puede mostrarse debajo como `Último éxito`, con fecha y hora.
- Nunca se sustituye silenciosamente un error actual con información anterior.
- `Actualizar todas` intenta consultar todos los perfiles, incluido el perfil
  principal de Codex.
- No hay polling automático en el MVP. El polling futuro será opt-in,
  configurable y solo de metadata.

Estados normalizados:

```text
success
partial
unavailable
timeout
auth_required
tool_missing
profile_missing
error
```

## Arquitectura propuesta

```text
Flutter UI
  └── Application controllers / use cases
       ├── ProfileDiscoveryService
       ├── ProfileManagementService
       ├── AccountLinkService
       ├── UsageRefreshService
       ├── SubscriptionService
       └── NotificationService
            ├── MultiCliGateway
            ├── ProviderAdapter registry
            │    └── CodexAdapter
            │         └── CodexAppServerClient
            ├── LocalDatabase (SQLite/Drift)
            └── LocalNotificationGateway
```

Separación recomendada dentro de `lib/`:

```text
lib/
  app/
  core/
    database/
    process/
    paths/
  features/
    profiles/
    accounts/
    usage/
    subscriptions/
    notifications/
  providers/
    codex/
  main.dart
```

La UI no debe conocer JSON-RPC, rutas concretas ni estructuras de
`auth.json`. Los adaptadores traducen cada proveedor al dominio común.

## Capacidades por proveedor

No todos los proveedores tendrán las mismas funciones. Cada adaptador declara
sus capacidades:

```text
profileDiscovery
profileCreation
deviceAuth
accountIdentity
usageLimits
resetCredits
launch
logout
```

La interfaz habilita acciones según esas capacidades. En el MVP solo se
implementa `CodexAdapter`.

## Persistencia

SQLite será la única base de datos. Se recomienda Drift para consultas tipadas,
migraciones y soporte compartido entre Linux y Windows.

### Convenciones

- IDs internos: UUID almacenado como `TEXT`.
- Timestamps: milisegundos Unix UTC almacenados como `INTEGER`.
- Fechas civiles, como renovación: ISO `YYYY-MM-DD` almacenado como `TEXT`.
- Dinero: unidades menores almacenadas como `INTEGER`.
- Monedas: código ISO 4217 de tres letras, por ejemplo `USD` o `BOB`.
- Booleanos SQLite: `INTEGER` restringido a `0` o `1`.
- Los porcentajes guardan uso, no el valor restante derivado.

Ejemplos de dinero:

```text
USD 20.00  -> amount_minor = 2000, currency_code = USD
BOB 140.00 -> amount_minor = 14000, currency_code = BOB
```

## Modelo de datos

```text
ai_providers
  └── cli_tools
       └── cli_profiles
            ├── profile_account_links ── provider_accounts
            │                               ├── subscriptions
            │                               │    ├── cost_shares ── people
            │                               │    ├── renewal_cycles
            │                               │    │    └── contribution_payments
            │                               │    └── subscription_reminders
            │                               └── account_notes
            └── usage_checks
                 ├── quota_windows
                 └── reset_credit_snapshots
```

### `ai_providers`

Catálogo de proveedores.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID local |
| `provider_key` | TEXT UNIQUE | `openai`, `anthropic`, `moonshot`, `xai` |
| `display_name` | TEXT | Nombre visible |
| `is_enabled` | INTEGER | Proveedor habilitado |
| `created_at` | INTEGER | Creación |

### `cli_tools`

Herramientas administradas por proveedor.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID local |
| `provider_id` | TEXT FK | Proveedor |
| `tool_key` | TEXT UNIQUE | `codex`, `claude`, `kimi`, `grok` |
| `display_name` | TEXT | Nombre visible |
| `executable_name` | TEXT | Ejecutable esperado |
| `is_enabled` | INTEGER | Herramienta habilitada |

### `cli_profiles`

Perfiles físicos descubiertos en el equipo.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID estable de la aplicación |
| `tool_id` | TEXT FK | Herramienta |
| `profile_name` | TEXT | `tienda` |
| `command_name` | TEXT NULL | `codex-tienda` |
| `display_name` | TEXT | `Tienda` |
| `profile_home` | TEXT UNIQUE | Ruta absoluta |
| `profile_source` | TEXT | `default` o `multicli` |
| `profile_type` | TEXT | `base`, `full` o `shared` |
| `has_auth_file` | INTEGER | Pista local, no validación de sesión |
| `is_available` | INTEGER | La ruta existe |
| `is_favorite` | INTEGER | Preferencia local |
| `created_at` | INTEGER | Alta local |
| `last_discovered_at` | INTEGER | Último escaneo |
| `last_launched_at` | INTEGER NULL | Último lanzamiento |

Restricción única recomendada: `(tool_id, profile_name)`.

### `provider_accounts`

Identidades observadas mediante el proveedor.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID local |
| `provider_id` | TEXT FK | Proveedor |
| `external_account_id` | TEXT NULL | ID estable solo si una superficie soportada lo entrega |
| `email` | TEXT NULL | Email informado por el proveedor |
| `display_name` | TEXT | Alias definido por el usuario |
| `plan_type` | TEXT NULL | Plan observado |
| `account_status` | TEXT | `active`, `expired`, `unknown` |
| `first_seen_at` | INTEGER | Primera detección |
| `last_seen_at` | INTEGER | Última confirmación |
| `created_at` | INTEGER | Creación local |
| `updated_at` | INTEGER | Modificación |

No se deben fusionar automáticamente cuentas usando solo el email. Cuando no
exista un ID externo fiable, se conserva una identidad local por vínculo hasta
que el usuario decida asociarla.

### `profile_account_links`

Historial de las cuentas vinculadas a cada perfil.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `profile_id` | TEXT FK | Perfil |
| `account_id` | TEXT FK | Cuenta observada |
| `auth_mode` | TEXT NULL | `chatgptDeviceCode`, `chatgpt`, etc. |
| `link_status` | TEXT | `linked`, `unlinked`, `expired`, `unknown`, `error` |
| `linked_at` | INTEGER | Inicio |
| `last_verified_at` | INTEGER NULL | Última verificación |
| `unlinked_at` | INTEGER NULL | Fin del vínculo |
| `last_error` | TEXT NULL | Error sanitizado |

Solo puede existir un vínculo activo por perfil. Una cuenta puede aparecer en
varios perfiles.

### `usage_checks`

Una fila por cada intento real de consulta.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `profile_id` | TEXT FK | Perfil consultado |
| `account_id` | TEXT FK NULL | Cuenta identificada |
| `query_method` | TEXT | `account/rateLimits/read` |
| `status` | TEXT | Estado normalizado |
| `started_at` | INTEGER | Inicio |
| `completed_at` | INTEGER NULL | Fin |
| `duration_ms` | INTEGER NULL | Duración |
| `plan_type` | TEXT NULL | Plan de esa lectura |
| `error_code` | TEXT NULL | Código normalizado |
| `error_message` | TEXT NULL | Mensaje sanitizado |

Los errores también se guardan. Esto permite explicar qué ocurrió hoy sin
perder el último éxito.

### `quota_windows`

Todas las ventanas devueltas por una consulta.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `check_id` | TEXT FK | Consulta |
| `limit_id` | TEXT | `codex`, `codex_other`, etc. |
| `limit_name` | TEXT NULL | Etiqueta del proveedor |
| `window_type` | TEXT | `primary` o `secondary` |
| `used_percent` | REAL | Porcentaje consumido |
| `window_duration_minutes` | INTEGER | Duración |
| `resets_at` | INTEGER NULL | Reinicio |
| `reached_type` | TEXT NULL | Límite alcanzado |
| `plan_type` | TEXT NULL | Plan asociado |

Restricción única recomendada: `(check_id, limit_id, window_type)`.

### `reset_credit_snapshots`

Resumen de reset credits observado en una consulta.

| Columna | Tipo | Uso |
|---|---:|---|
| `check_id` | TEXT PK/FK | Consulta |
| `available_count` | INTEGER | Cantidad disponible |
| `next_expires_at` | INTEGER NULL | Vencimiento más cercano |

Los detalles individuales pueden añadirse posteriormente en `reset_credits`
usando el ID opaco que entregue el proveedor.

### `subscriptions`

Información comercial ingresada por el usuario.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `account_id` | TEXT FK | Cuenta respaldada |
| `plan_name` | TEXT | `ChatGPT Plus` |
| `purchased_on` | TEXT | Fecha de compra |
| `started_on` | TEXT | Inicio del servicio |
| `next_renewal_on` | TEXT | Próxima renovación |
| `billing_interval` | TEXT | `monthly`, `yearly`, `custom` |
| `expected_amount_minor` | INTEGER | Precio esperado |
| `currency_code` | TEXT | `USD`, `BOB`, etc. |
| `auto_renew` | INTEGER | Renovación automática |
| `subscription_status` | TEXT | `active`, `paused`, `cancelled`, `expired` |
| `purchased_from` | TEXT NULL | Vendedor o plataforma |
| `payment_method_label` | TEXT NULL | Etiqueta no sensible |
| `notes` | TEXT NULL | Nota general |
| `created_at` | INTEGER | Creación |
| `updated_at` | INTEGER | Modificación |

Nunca se almacenan números completos de tarjeta, CVV ni credenciales
financieras.

### `people`

Personas anotadas localmente para repartir costos.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `display_name` | TEXT | `Luis` |
| `email` | TEXT NULL | Dato opcional |
| `phone` | TEXT NULL | Dato opcional |
| `notes` | TEXT NULL | Nota privada |
| `created_at` | INTEGER | Creación |

### `cost_shares`

Acuerdo de reparto, sin crear usuarios ni invitaciones.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `subscription_id` | TEXT FK | Suscripción |
| `person_id` | TEXT FK | Persona |
| `share_percent` | REAL NULL | Porcentaje acordado |
| `fixed_amount_minor` | INTEGER NULL | Alternativa de monto fijo |
| `currency_code` | TEXT NULL | Requerida para monto fijo |
| `started_on` | TEXT | Inicio |
| `ended_on` | TEXT NULL | Fin |
| `notes` | TEXT NULL | Nota |

Debe usarse porcentaje o monto fijo, no ambos simultáneamente.

### `renewal_cycles`

Cada renovación concreta. Conserva el historial aunque cambie el precio.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `subscription_id` | TEXT FK | Suscripción |
| `period_start` | TEXT | Inicio del periodo |
| `period_end` | TEXT | Fin del periodo |
| `due_on` | TEXT | Fecha límite |
| `expected_amount_minor` | INTEGER | Monto esperado |
| `expected_currency_code` | TEXT | Moneda esperada |
| `cycle_status` | TEXT | `upcoming`, `due`, `paid`, `overdue`, `skipped` |
| `paid_on` | TEXT NULL | Fecha real de pago |
| `paid_amount_minor` | INTEGER NULL | Monto real |
| `paid_currency_code` | TEXT NULL | Moneda real |
| `notes` | TEXT NULL | Nota del periodo |
| `created_at` | INTEGER | Creación |

### `contribution_payments`

Aportes de cada persona para una renovación.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `renewal_cycle_id` | TEXT FK | Renovación |
| `person_id` | TEXT FK | Persona |
| `expected_amount_minor` | INTEGER | Parte esperada |
| `paid_amount_minor` | INTEGER | Parte recibida |
| `currency_code` | TEXT | Moneda |
| `payment_status` | TEXT | `pending`, `partial`, `paid` |
| `paid_on` | TEXT NULL | Fecha del aporte |
| `notes` | TEXT NULL | Nota |

### `subscription_reminders`

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `subscription_id` | TEXT FK | Suscripción |
| `days_before` | INTEGER | Anticipación |
| `reminder_time` | TEXT | Hora local `HH:mm` |
| `is_enabled` | INTEGER | Activo |
| `last_triggered_at` | INTEGER NULL | Último aviso |

### `account_notes`

Notas con historial y posibilidad de fijarlas.

| Columna | Tipo | Uso |
|---|---:|---|
| `id` | TEXT PK | UUID |
| `account_id` | TEXT FK | Cuenta |
| `title` | TEXT NULL | Título |
| `content` | TEXT | Contenido |
| `is_pinned` | INTEGER | Fijada |
| `created_at` | INTEGER | Creación |
| `updated_at` | INTEGER | Modificación |

### `app_settings`

Preferencias locales como `profiles_root_path`, timeout, tema y concurrencia.

| Columna | Tipo | Uso |
|---|---:|---|
| `setting_key` | TEXT PK | Clave estable |
| `setting_value` | TEXT | Valor serializado |
| `updated_at` | INTEGER | Modificación |

## Experiencia de usuario

### Pantalla principal

- Lista compacta de perfiles y estado actual.
- Filtros por proveedor, disponibilidad y renovación.
- Acción **Actualizar todas** con progreso por perfil.
- Hora visible de la consulta actual.
- Próxima renovación y monto junto al estado técnico.
- Acción de lanzamiento por perfil.

### Detalle de perfil

- Identidad observada y plan.
- Cuotas actuales y último éxito.
- Historial de errores sin exponer datos sensibles.
- Suscripción, ciclos, reparto, notas y recordatorios.
- Acciones de vincular, desvincular y abrir CLI.

### Crear y vincular

1. Solicitar nombre y tipo de perfil.
2. Crear mediante Multi CLI.
3. Mostrar inmediatamente el perfil como no vinculado.
4. Iniciar device auth.
5. Mostrar URL y código con acciones de abrir y copiar.
6. Confirmar la cuenta observada.
7. Permitir añadir metadata de compra de forma opcional.

### Eliminar

Desvincular, eliminar el perfil local y borrar metadata son acciones diferentes.
Toda eliminación destructiva debe explicar qué se borrará y requerir
confirmación.

## Seguridad y privacidad

- No leer el contenido de `auth.json` para copiar tokens.
- No persistir device codes.
- No registrar líneas JSON-RPC que puedan contener datos sensibles.
- Sanitizar errores antes de guardarlos o mostrarlos.
- No usar `runInShell` cuando pueda evitarse.
- Validar que las rutas resueltas permanezcan dentro de la raíz esperada.
- Mantener los procesos app-server asociados al perfil correcto.
- Cerrar stdin, stdout y el proceso en éxito, cancelación, error y timeout.
- Proteger las migraciones de SQLite con transacciones.
- No incluir telemetría ni sincronización remota por defecto.

## Estrategia de pruebas

Las pruebas automatizadas no deben consultar cuentas reales ni ejecutar una
llamada que consuma uso.

### Requeridas

- Fixture de app-server falso con respuestas JSON-RPC deterministas.
- Device auth exitoso, cancelado, con error y timeout.
- Consultas con primary, secondary, múltiples `limit_id` y datos ausentes.
- Confirmar que un error actual no se sustituye por el último éxito.
- Descubrimiento de perfil principal y perfiles Multi CLI agregados después.
- Perfiles sin `auth.json`, rutas desaparecidas y nombres inválidos.
- Aislamiento correcto de `CODEX_HOME` por proceso.
- Conversión y formato de montos `USD` y `BOB`.
- Renovaciones mensuales, vencidas, pagadas y compartidas.
- Migraciones SQLite y borrado en cascada.
- Pruebas de rutas para Linux y Windows.

Las verificaciones manuales con una cuenta real se reservan para el propietario
del proyecto y no forman parte de la suite automática.

## Roadmap

### Fase 1: base local

- Estructura por features.
- Drift y primera migración.
- Descubrimiento dinámico de perfiles.
- Lista y detalle con datos locales.

### Fase 2: integración Codex

- Cliente JSON-RPC para app-server.
- `account/read` y device auth.
- `account/rateLimits/read` para un perfil y para todos.
- Estados de frescura, timeout y error.
- Lanzamiento del perfil.

### Fase 3: suscripciones

- Compra, moneda y próxima renovación.
- Ciclos de pago.
- Personas, reparto de costo y aportes.
- Notas y recordatorios locales.

### Fase 4: historial

- Gráficas de cuotas.
- Alertas de límite bajo y reinicio.
- Bandeja del sistema y exportación.

### Fase 5: otros proveedores

- Validar qué metadata expone cada CLI.
- Implementar un adaptador a la vez.
- Mostrar `No disponible` para capacidades ausentes.

## Criterios de aceptación del MVP

- En Linux y Windows la aplicación descubre perfiles existentes sin cargarlos
  manualmente en la base.
- Un perfil nuevo puede crearse y vincularse por device auth.
- `codex-tienda` y el perfil principal se consultan con su propio `CODEX_HOME`.
- **Actualizar todas** termina con un resultado visible para cada perfil.
- Un timeout se presenta como indisponibilidad actual, con el último éxito
  separado y fechado.
- La aplicación no envía prompts ni copia credenciales.
- Se puede registrar una suscripción en USD o BOB con renovación y notas.
- Se puede repartir el costo y marcar aportes pendientes o pagados.
- Se puede lanzar el CLI usando el perfil elegido.
- La suite principal funciona con un app-server falso, sin API real.

## Referentes y diferenciación

Existen herramientas cercanas como
[AI Account Hub](https://github.com/AlexC1991/AI_Account_Hub),
[onWatch](https://github.com/onllm-dev/onwatch),
[CC Switch](https://github.com/farion1231/cc-switch),
[Codex Profile Manager](https://pypi.org/project/codex-profile-manager/),
[How Much Codex](https://howmuchcodex.com/) y
[SubHorizon](https://subhorizon.app/).

MultiCLI AI no busca ser otro router de modelos. Su diferencia es unir en una
aplicación local para Linux y Windows:

```text
perfiles oficiales aislados
+ estado técnico actual
+ renovaciones y monedas
+ costos compartidos
+ notas y recordatorios
```

## Desarrollo

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d linux
flutter build linux
```

El build de Windows debe ejecutarse y validarse en Windows:

```powershell
flutter run -d windows
flutter build windows
```

Antes de añadir dependencias o infraestructura, debe demostrarse su valor para
el MVP. Las decisiones todavía abiertas se documentarán conforme aparezca una
necesidad real.
