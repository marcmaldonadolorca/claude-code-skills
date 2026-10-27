---
name: skill-builder
description: Convertir una necesidad recurrente en skill nueva de la biblioteca — plantilla, description que activa, progressive disclosure y test de activación.
---

# Skill builder

Crea skills para la biblioteca canónica (`skills/` de este repo).
Convenciones completas: `README.md`; plantilla: `templates/SKILL.template.md`.

## Inputs

- La necesidad en una frase y 2-3 ejemplos reales de peticiones que deberían activarla.
- Confirmación de que **no existe ya**: `./install.sh list` + el catálogo del `README.md` (si existe algo parecido, usar `skill-refiner` en vez de duplicar).

## Antes de escribir: ¿de verdad es una skill?

- **Skill** = procedimiento reutilizable entre proyectos que se activa por el resultado deseado.
- Regla/convención que aplica a *todas* las sesiones → `CLAUDE.md` (skill `project-memory`).
- Rol con contexto propio que revisa/produce → agente (`.claude/agents/`).
- Conocimiento extenso de fondo → documento en `docs/`, y la skill lo enlaza.
- Solución de una sola vez → no se guarda.

## Pasos

1. **Baseline** (idea adaptada del método TDD de obra/superpowers, MIT): plantea una de las peticiones de ejemplo a una sesión sin la skill y anota qué hace mal o qué le falta. Eso define qué debe enseñar la skill; si el resultado ya es bueno, la skill sobra.
2. **Borrador** desde la plantilla, en el directorio kebab-case (= `name` del frontmatter):
   - `description`: qué hace **y cuándo usarla**, con las palabras de las peticiones reales — es lo único que Claude ve para decidir activarla.
   - Cuerpo: propósito → inputs (si falta uno crítico, parar) → reglas → pasos `lectura → dry-run → mutar` → checks/evidencia → reversión → documentar.
   - Enlaza documentos canónicos (SAFETY_RULES, runbooks, docs/) en lugar de copiarlos.
3. **Progressive disclosure**: cuerpo < 500 líneas (ideal < 150). Detalle extenso u opcional → `references/*.md` dentro de la skill; operaciones deterministas → `scripts/` (indicando si se ejecutan o se leen), sin dependencias sin fijar.
4. **Prueba de activación**: con la skill instalada, lanza las peticiones de ejemplo en una sesión nueva y comprueba que se activa y que los pasos se sostienen con datos ficticios. Si no se activa, reescribe la `description` (síntomas y arreglos: `skill-refiner`).
5. **Registro e instalación**: fila en el catálogo del `README.md` + `./install.sh install --global <nombre>` (o `--project <ruta>` si es de un proyecto).

## Checks / evidencia

- `install.sh status` muestra el symlink sano; la petición de ejemplo activa la skill; el frontmatter `name` coincide con el directorio.

## Reversión

- `./install.sh uninstall --global <nombre>` y borrar el directorio (está en Git: recuperable hasta el próximo commit autorizado).

## Documentar

Skill nueva en la biblioteca global → casilla en `TASKS.md` de la biblioteca; si cambia el
método de trabajo, `DECISIONS.md` (skill `decision-log`). Sin commit sin autorización.
