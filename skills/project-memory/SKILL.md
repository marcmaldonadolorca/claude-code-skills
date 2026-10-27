---
name: project-memory
description: Decidir dónde vive una información — CLAUDE.md, skill, notas, docs del repo, DECISIONS, reports o ningún sitio. Usar ante «esto habría que guardarlo».
---

# Project memory

Router de información del método de trabajo. Principio: **cada dato tiene una ubicación
canónica única**; el resto enlaza. Guardar de más cuesta contexto en cada sesión; guardar de
menos cuesta re-descubrir.

## Tabla de decisión

| La información es… | Va a… | Ejemplo |
|---|---|---|
| Inventario/ciclo de vida de todos los proyectos | `PROJECTS.md` (raíz del workspace) | "Proyecto A activo; proyecto B aparcado" |
| Regla/convención que TODA sesión de Claude debe cargar (corta, estable) | `CLAUDE.md` (del repo, o del workspace si es transversal) | "Docker en el servidor requiere sudo" |
| Procedimiento reutilizable que se activa por resultado | Skill de la biblioteca (`skill-builder`) | "Cómo desplegar un servicio" |
| Conocimiento personal, ideas, aprendizajes, material de estudio | Sistema de notas — nota nueva en `Inbox/` | "Lo aprendido sobre ROCm hoy" |
| Detalle técnico de UN proyecto (setup, API interna, troubleshooting) | `docs/` del propio repo | "Cómo regenerar los fixtures" |
| Decisión irreversible o arquitectónica con motivo | `DECISIONS.md` del repo afectado (`decision-log`) | "El disco de datos pasa a ext4" |
| Evidencia de una operación ejecutada | `reports/<host|tema>/` (`documentar-cambio`) | "Qué comandos se corrieron y qué salió" |
| Estado vivo (qué está hecho, qué sigue) | `PROJECT_STATE.md` / `TASKS.md` | — |
| Contexto de una sola conversación, exploración descartada, obviedades | **Ningún sitio** (o resumen de cierre si la sesión lo merece: `context-compressor`) | "Probamos X, no era" |

Desempates rápidos: ¿lo necesitará **otra sesión**? si no → no se guarda. ¿Lo necesita
**toda** sesión o solo cuando se hace cierta tarea? toda → CLAUDE.md; cierta tarea → skill.
¿Es **procedimiento** (skill) o **hecho/decisión** (docs/DECISIONS)? ¿Es personal y
reflexivo más que operativo? → notas.

## Reglas

- `CLAUDE.md` es el recurso más caro (se carga siempre): frases cortas, sin duplicar lo que
  ya está en SAFETY_RULES/docs — enlazar. Si supera ~60 líneas, algo sobra: mover a docs o skill.
- Notas: la IA **solo crea notas nuevas en `Inbox/`**; jamás edita notas canónicas.
- No guardar lo que el repo ya registra por sí mismo (git log, código, estructura).
- Las notas no replican estados ni tareas de los repos: conservan aprendizaje y contexto
  duradero; `PROJECTS.md` solo enlaza al detalle canónico.
- Secretos: en ningún destino de esta tabla. Van al gestor de secretos, y en los docs solo
  el nombre lógico.

## Pasos

1. Formula la información en una frase; decide destino con la tabla (si encaja en dos, el
   más específico gana y el otro enlaza).
2. Escribe en el destino con su formato propio (skill → plantilla; decisión → formato ADR;
   nota → plantilla de captura).
3. Si había copias de esa información en otros sitios, sustitúyelas por enlaces al canónico.

## Checks

- Releer el destino elegido en frío: ¿alguien la buscaría ahí primero? Si no, es el destino
  equivocado.
