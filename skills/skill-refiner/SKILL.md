---
name: skill-refiner
description: Mejorar una skill existente — activación que falla, cuerpo largo, temas mezclados, duplicación — sin cambiar su propósito.
---

# Skill refiner

Opera sobre `skills/` de este repo (fuente canónica; los symlinks de `install.sh`
propagan el cambio al instante). Convenciones: `README.md` y `templates/SKILL.template.md`.

## Inputs

- Qué skill y qué síntoma (con un ejemplo real: la petición que no la activó, la sesión donde estorbó, la sección que nadie usa).

## Diagnóstico → arreglo

| Síntoma | Causa típica | Arreglo |
|---|---|---|
| No se activa cuando debería | `description` describe qué hace, no **cuándo usarla**; faltan las palabras de la petición real | Reescribir description con vocabulario del usuario ("Usar cuando…"); añadir los disparadores que fallaron |
| Se activa cuando no toca | Description demasiado genérica; solapa con otra skill | Acotar el "cuándo"; deslindar explícitamente ("para X usa la skill Y") |
| Cuerpo largo, Claude se pierde | Todo en `SKILL.md`, sin progressive disclosure | Mover detalle/casos raros a `references/*.md` y enlazar; objetivo < 150 líneas, máximo 500 |
| Temas mezclados | Dos procedimientos en una skill | Dividir en dos skills (`skill-builder`) y dejar en cada una un enlace a la otra |
| Duplica docs del repo | Se copió en vez de enlazar | Sustituir por enlace al canónico (`docs/`, SAFETY_RULES) |
| Pasos que ya no reflejan la realidad | El entorno cambió (rutas, servicios, versiones) | Verificar contra el estado vivo y corregir; fechas absolutas |
| Scripts frágiles u opacos | Dependencias flotantes, sin indicar si se ejecutan o se leen | Fijar versiones, documentar el modo de uso, o convertir a instrucciones |

## Pasos

1. Reproduce el síntoma (petición real en sesión limpia) — no refinar de oído.
2. Aplica el arreglo mínimo de la tabla; no aproveches para reescribir todo.
3. Re-testa con la misma petición que falló y con una que ya funcionaba (no romper lo que iba bien).
4. Actualiza el catálogo del `README.md` si cambió el "cuándo usarla".

## Checks / evidencia

- El síntoma original ya no se reproduce; `wc -l SKILL.md` dentro de objetivo; `name` = directorio; ninguna otra skill quedó solapada.

## Reversión

- `git diff skills/<nombre>/` y descartar con autorización si el refino empeora.

## Documentar

Refinos menores: nada. Cambios de alcance o división de skills: casilla en `TASKS.md`
y fila actualizada en el catálogo del `README.md`.
