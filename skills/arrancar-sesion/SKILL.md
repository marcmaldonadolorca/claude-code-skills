---
name: arrancar-sesion
description: Arrancar sesión sin re-explicar contexto — briefing desde la fuente de verdad + estado vivo. Se activa con «continúa», «arranca», «¿dónde estamos?», «¿qué toca?».
---

# Arrancar sesión

El usuario **no repite contexto**. Esta skill enruta primero al proyecto correcto,
lee su fuente canónica y solo después consulta estado vivo o notas. La salida es un
briefing corto, no un volcado de documentos.

## Jerarquía de verdad

```text
PROJECTS.md (índice del workspace)
  → <proyecto>/PROJECT_STATE.md
  → <proyecto>/TASKS.md + DECISIONS.md
  → estado vivo
  → notas revisadas (contexto, nunca estado)
  → HISTORIAL/reports bajo demanda
```

- **Estado actual y prioridad:** documentos del workspace/proyecto.
- **Realidad ejecutándose:** Git, procesos, servicios y datos observados.
- **Conocimiento duradero:** notas revisadas (p. ej. un vault de Obsidian).
- **Nunca fuente de verdad:** la bandeja de entrada de notas sin revisar, papeleras,
  chats antiguos o el nombre de una carpeta como `-final`.

## Pasos

1. **Enrutar:**
   - Identificar el proyecto por la petición y el directorio actual.
   - De `PROJECTS.md`, leer solo la fila del proyecto (estado, ticket vigente, fuente). Si el
     workspace tiene un índice o buscador propio, usarlo antes que leer documentos enteros:
     el contexto es caro y un control de 20.000 tokens leído entero no aporta más que su esquema.
   - Si está aparcado, abandonado o pendiente de decisión, decirlo antes de proponer trabajo.
   - **El orden de prioridad lo manda el índice** (máx. 3 frentes en «ahora»). El briefing abre
     con lo que está en «ahora» y solo después con el proyecto pedido; si la petición es de un
     frente aparcado o cerrado, decirlo antes de empezar. No reordenar por iniciativa propia.
2. **Memoria canónica del proyecto:**
   - De `PROJECT_STATE.md`, solo los campos vivos (propósito, VCS, ahora, próxima acción,
     esperando); en ficheros grandes, por rangos (`sed -n 'A,Bp' <ruta>`). La bitácora vieja
     vive en `HISTORIAL.md`, no en el control.
   - De `TASKS.md`, los tickets abiertos que importan para la petición.
   - De `DECISIONS.md`, **Pendientes de decidir** y las decisiones relacionadas con la tarea.
   - Si falta alguno, declararlo; no sustituirlo silenciosamente por notas o historial.
3. **Estado vivo mínimo y específico:**
   - Consultar primero el campo `VCS` del control; solo si declara una ruta Git, ejecutar
     `git -C <ruta-vcs> status --short --branch`. Si declara `ninguno`, no inicializar ni
     reclamar un repo por inferencia.
   - Código: tests/build solo si son baratos y relevantes.
   - Infraestructura (Docker, montajes, SSH): únicamente si la tarea toca esos recursos.
   - Procesos de larga duración (colectores de datos, jobs programados): verificarlos solo si se va
     a afirmar que están corriendo.
   - Si un hook de arranque inyecta un resumen (pendientes por proyecto, alertas rojas),
     usarlo como radar para enrutar y avisar, **nunca** como estado canónico: si contradice a
     los controles del proyecto, mandan los controles.
4. **Notas como contexto opcional:**
   - Las notas no están en el prompt: hay que ir a buscarlas. Cuando la tarea tenga fondo
     técnico o histórico (una lección, una decisión vieja, un patrón ya vivido), consultarlas
     **antes** de reconstruir el contexto desde cero.
   - Búsqueda literal primero: `rg -i "<término>" <carpeta-de-notas> --glob '!Inbox'`. Con
     nombres propios, el léxico gana a la búsqueda semántica.
   - «¿Ya lo hemos visto / decidido / medido?» → buscar en memoria, DECISIONS, controles,
     informes y notas, y decir cuánto se escaneó: una búsqueda sin cobertura no prueba ausencia.
   - Una nota nunca corrige por sí sola el estado canónico; si contradice a los docs,
     señalar la discrepancia.
5. **Briefing** (máx. ~15 líneas):
   - Proyecto y estado real.
   - Trabajo local o divergencias detectadas.
   - Próxima acción vigente o petición concreta del usuario.
   - Bloqueos/decisiones humanas.
6. **Propuesta:** 1-3 opciones concretas, recomendada primero. Si el usuario ya eligió
   una tarea, empezar sin volver a preguntar.

Para relevar a otro agente (otra sesión de Claude, Codex…), preferir un traspaso generado
desde los controles (`caveman-token-economy`, modo resumen-handoff) antes que reconstruir
una conversación previa.

## Reglas

- Los documentos pueden ir por detrás: si el estado vivo los contradice, decirlo y
  corregir la fuente del **proyecto afectado** con `documentar-cambio`.
- No re-preguntar lo que la fuente de verdad ya responde; no pedir al usuario que
  «resuma el contexto».
- Sesión de proyecto nuevo → skill `nuevo-proyecto`; repo desconocido → `repo-intake`.
- No arrancar siempre desde el repo de infraestructura: solo es la fuente de verdad de
  la infraestructura.
- `PROJECTS.md` enruta; no duplica el detalle de cada proyecto.

## Cierre de sesión (simétrico)

Al terminar trabajo con efecto real: `documentar-cambio` sobre el proyecto afectado
y, si quedó conocimiento reutilizable, una nota nueva en la bandeja de entrada de notas.
Si queda a medias: resumen de continuación (`context-compressor`) en la próxima acción
de su `PROJECT_STATE.md`.

## Checks

- El usuario puede continuar cualquier proyecto sin volver a explicar su contexto.
- Una consulta de estado nunca se responde solo con búsquedas en documentos.
