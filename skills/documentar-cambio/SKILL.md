---
name: documentar-cambio
description: Actualizar la fuente de verdad tras un cambio aceptado — STATE, HISTORIAL, TASKS, DECISIONS, SERVICES y report. Usar al cerrar toda tarea con efecto real.
---

# Documentar cambio

Actualiza la fuente de verdad del **proyecto afectado**, no la del repo de infraestructura
por defecto. La disciplina común es: una casilla marcada implica evidencia y
`PROJECT_STATE.md` actualizado, no solo un comando ejecutado.

## Localizar la fuente de verdad

1. Leer `PROJECTS.md` (índice del workspace) y determinar el proyecto.
2. Preferir el directorio más cercano que contenga `PROJECT_STATE.md`, `TASKS.md` y
   `DECISIONS.md`.
3. Casos transversales:
   - Infraestructura compartida (servidores, servicios) → su propio repo.
   - Un repo que agrupa varios subproyectos → el control global y, además, el historial
     propio de cada subproyecto.
   - Ciclo de vida general de proyectos → `PROJECTS.md`.
4. Si no existe memoria estándar, crearla con `nuevo-proyecto` o pedir decisión; no
   registrar el cambio en otro repo solo porque ese tenga documentación.

## Inputs

- Qué cambió, dónde, con qué evidencia (comandos y resultados reales, no supuestos).
- Si el cambio fue aprobado por el usuario o era una acción segura/reversible.

## Pasos

1. **`PROJECT_STATE.md` del proyecto**: estado actual, próxima acción, riesgos y fecha
   absoluta. Sin narración histórica.
2. **`TASKS.md`**: marca la casilla correspondiente con fecha y, si procede, referencia al
   informe. Si el trabajo hecho no tenía casilla, añádela ya marcada (deja rastro de lo que
   realmente se hizo). **STATE y TASKS se reconcilian a la vez**: si uno dice «sin commit» o
   «pendiente» y la realidad cambió, corrige los dos en la misma pasada (patrón real de deriva:
   se corrigió TASKS y el STATE quedó desfasado semanas).
3. **`DECISIONS.md`**: solo si la decisión es irreversible o arquitectónica. Formato y
   criterio: skill `decision-log`.
4. **Historial/evidencia del proyecto:** si tiene `HISTORIAL.md`, añadir una entrada;
   operaciones relevantes van a `reports/` (en infraestructura, `reports/<host>/`).
5. **Solo infraestructura:** si cambian servicios, automatizaciones, puertos o URLs,
   actualizar el inventario de servicios (un manifiesto JSON/YAML del que se genera la tabla
   legible) y regenerarlo. La tabla legible no es una segunda fuente de estado.
6. **`PROJECTS.md`:** actualizar si cambia el ciclo de vida, el propósito, el siguiente hito
   global o **el registro**: un frente nuevo o cerrado, su programa, una dependencia nueva
   (fila en «Relaciones» con evidencia), un recurso compartido que pasa a usar, algo nuevo que
   existe (fila en «Inventario»). No copiar todas las tareas. **Cerrar un frente incluye
   decidir qué se hace con sus timers y servicios**: los one-shots vencidos se desarman; los
   que capturan datos se proponen al usuario (desarmarlos por error pierde datos).
7. **Notas — lo descubierto se captura siempre:** cada descubrimiento, lección, medida o idea
   de la sesión va como nota nueva a la bandeja de entrada (`Inbox/`) del sistema de notas,
   una idea por nota y con fuentes. Antes, buscar si ya hay una nota vigente: si la hay, la
   captura dice que la amplía y la enlaza en vez de duplicarla. Las **tareas futuras** van al
   `TASKS.md` de su proyecto. El estado no se copia a mano a las notas: se deriva de
   TASKS/DECISIONS/PROJECT_STATE. Sin nada nuevo: «sin aprendizaje nuevo» en una línea.
8. **Aprendizaje:** ¿qué falló, o estuvo a punto de fallar, en esta tarea? Si hubo algo:
   primero la **guarda** (test, check, hook o timer) que impida repetirlo, y en el **sitio
   hermano** («¿dónde más pasa lo mismo?»); después, si procede, la nota de memoria. Sin
   fallos, basta «sin incidentes» en una línea. **Nada de lo aprendido se retira por no
   usarse**: una guarda que no salta está cumpliendo. Si el cambio tocó un hook, un timer o
   un script de servidor: revisión de infraestructura antes del commit.
9. **Cierre:** si el workspace tiene un check de coherencia (tablero, registro, enlaces),
   correrlo y dejarlo en verde; un aviso (WARN) se corrige o se explica en el cierre, nunca
   se ignora en silencio.

## Reglas

- No inventes evidencia ni marques casillas sin ella; si algo quedó a medias, documéntalo
  como limitación, no como hecho.
- «Sin commit» siempre **fechado** («sin commit a AAAA-MM-DD»); al commitear después, busca
  y reconcilia esa frase en STATE y TASKS.
- No dupliques contenido que ya tiene ubicación canónica: enlaza.
- Nada de secretos (ni valores, ni tokens, ni rutas de claves privadas con contenido) en
  ningún documento.
- Todo en español, tono factual, distinguiendo hechos observados de hipótesis.

## Checks / evidencia

- **Ticket legible:** un ticket nuevo o reescrito empieza, tras el ID y la prioridad, por
  **un título en negrita de ≤ 100 caracteres** que diga qué hay que lograr; la bitácora va
  en sub-líneas. Si el control crece demasiado, se rota la bitácora a `HISTORIAL.md`.
- **Higiene del tablero:** «ahora» ≤ 3, tickets únicos, el frente colocado en
  `PROJECTS.md`. Un ticket nuevo entra con dueño, escritor, salida y bloqueo; lo ya resuelto
  se mueve a «Hecho»/«Aparcado», no se deja en «Esperando».
- `PROJECTS.md`, la memoria del proyecto y el estado vivo no se contradicen.
- El repo de infraestructura no recibe tareas o decisiones que pertenecen únicamente a otro
  proyecto.

## Reversión

- Cambios de texto en Git sin commitear: `git diff` para revisar, `git checkout -- <archivo>`
  solo con autorización.
