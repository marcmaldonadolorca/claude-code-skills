---
name: orquestador
description: Carga bajo demanda las skills de biblioteca (no listadas) que necesita la tarea — decisiones (ADR), dónde guardar información, prompts, compresión de contexto, elección de modelo y esfuerzo, repos externos, buscar o refinar skills, web (Next.js, landing, auditoría, motion), RAG y entrenamiento en GPU. Usar al empezar cualquier tarea que toque uno de esos temas.
---

# Orquestador de skills

Para no pagar en cada turno la descripción de todas las skills, solo unas pocas están
cargadas siempre; el resto es **biblioteca** (`skillOverrides` → `user-invocable-only` en
`~/.claude/settings.json`). Claude no las ve en su listado, pero el usuario puede teclear
`/nombre` y tú las cargas leyéndolas.

## Pasos
1. Elige **como máximo 2** skills de la tabla que encajen con la tarea (si ninguna encaja, no cargues nada).
2. `Read ~/.claude/skills/<nombre>/SKILL.md` y sigue sus pasos al pie de la letra (rutas `references/` y `scripts/` relativas a esa carpeta). **No** uses la herramienta `Skill` para estas: no están registradas para ti.
3. Una skill no listada aquí ni entre las cargadas siempre no existe: no la inventes; `skill-finder` busca en el ecosistema y `skill-auditor` audita antes de adoptar.
4. Si el tema es seguridad de datos (backup, credenciales, borrado), carga la skill **antes** de actuar, no después.

## Biblioteca (generada; no editar a mano: `tools/gen-orquestador.py`)
| Skill | Cuándo |
|---|---|
<!-- tabla:inicio -->
| `context-compressor` | Destilar insumos grandes (conversación, repo, docs, logs kilométricos) sin perder decisiones ni estado. |
| `decision-log` | Registrar una decisión irreversible o arquitectónica como ADR en DECISIONS.md con el formato de casa. |
| `dl-entrenamiento-gpu` | Entrenar, fine-tuning (LoRA/PEFT) o evaluar modelos PyTorch/HF en una GPU local de 16 GB (ROCm o CUDA), reproducible — contenedor, seeds,… |
| `dl-rag-agentes` | Diseñar y construir RAG o agentes con infra local (Qdrant, embeddings de Ollama, chunking, evaluación, citación). |
| `elegir-modelo` | Recomienda qué modelo (Opus, Sonnet o Haiku) y qué nivel de esfuerzo usar para cada tarea según su dificultad y el razonamiento que exige, y avisa… |
| `project-memory` | Decidir dónde vive una información — CLAUDE.md, skill, notas, docs del repo, DECISIONS, reports o ningún sitio. |
| `prompt-improver` | Convertir un prompt vago en instrucciones completas (contexto, restricciones, entregables, criterios) antes de enviarlo a Claude, Codex o modelos… |
| `repo-intake` | Analizar un repo nuevo o desconocido antes de trabajar — stack, estructura, riesgos, puntos de entrada, plan. |
| `skill-finder` | Buscar skills, agentes o plugins útiles en el ecosistema y clasificarlos por utilidad, riesgo y madurez. |
| `skill-refiner` | Mejorar una skill existente — activación que falla, cuerpo largo, temas mezclados, duplicación — sin cambiar su propósito. |
| `web-auditoria` | Auditar una web — accesibilidad, SEO técnico, rendimiento, robustez; hallazgos priorizados. |
| `web-landing-cliente` | Convertir el briefing de un cliente en una landing profesional — persuasiva, accesible y rápida, lista para iterar. |
| `web-motion` | Construye e integra motion web scroll-driven a partir de una referencia que aportas en el momento (URL, vídeo, capturas o descripción). |
| `web-proyecto-nextjs` | Crear o trabajar un proyecto Next.js/React con Tailwind y shadcn/ui según convenciones — TS estricto, App Router, testing, manifiesto reproducible. |
<!-- tabla:fin -->

Cargadas siempre (úsalas con `Skill`): arrancar-sesion, documentar-cambio, nuevo-proyecto, skill-auditor,
skill-builder, debug-sistematico, codigo-minimo, diseno-fundamentos, portfolio-tecnico, caveman-token-economy,
orquestador.
