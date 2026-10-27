---
name: prompt-improver
description: Convertir un prompt vago en instrucciones completas (contexto, restricciones, entregables, criterios) antes de enviarlo a Claude, Codex o modelos locales.
---

# Prompt improver

Mejora prompts **antes** de gastarlos. Un prompt caro de escribir es barato comparado con
una sesión larga mal dirigida. Los prompts que funcionaron se guardan en
una carpeta `prompts/` del repo: son el mejor ejemplo del estilo que funciona.

## Inputs

- El prompt original y a qué motor va (Claude Code, Codex, modelo local qwen3/qwen2.5-coder, otro). Si el objetivo real no se entiende, **preguntar antes de adornar**: mejorar un prompt no es inflarlo.

## Estructura objetivo

1. **Rol/encuadre** (solo si aporta): "actúa como X" cuando el dominio lo necesite.
2. **Contexto vinculante**: qué existe ya, qué documentos manda leer primero, qué NO debe recrearse. Si el repo tiene CLAUDE.md y SAFETY_RULES.md, decir explícitamente que aplican en prompts que ejecutará otra sesión.
3. **Objetivo final** en una frase medible.
4. **Forma de trabajar**: fases, checkpoints donde esperar OK, qué decide el modelo vs el humano.
5. **Restricciones duras**: seguridad, secretos, commits, qué es solo-lectura, presupuesto (tiempo/tokens).
6. **Entregables** enumerados y dónde deben quedar (rutas).
7. **Criterios de éxito / evidencia**: cómo se comprueba que está bien, no solo hecho.

## Ajustes por motor

- **Claude Code**: puede decidir con ambigüedad razonable; darle contexto y límites, no micro-pasos. Referenciar skills/agentes disponibles por nombre.
- **Codex u otros CLI**: más literal; pasos numerados, rutas absolutas, comandos exactos, criterios de parada explícitos.
- **Modelos locales (14B)**: una sola tarea por prompt, contexto mínimo imprescindible, formato de salida rígido (JSON/plantilla), sin ironía ni instrucciones implícitas.

## Anti-patrones (quitar, no añadir)

- Cortesía y relleno ("por favor, si no es molestia") — tokens sin efecto.
- Instrucciones contradictorias o duplicadas en secciones distintas.
- "Hazlo perfecto/profesional/robusto" sin criterio verificable que lo defina.
- Pedir a la vez investigación abierta y ejecución cerrada sin checkpoint entre ambas.
- Prompts-monstruo para tareas simples: si cabe en dos frases claras, son dos frases.

## Pasos

1. Extrae del prompt original: objetivo real, restricciones implícitas, qué falta (pregunta lo crítico).
2. Reescribe con la estructura objetivo, en español, con rutas absolutas y fechas absolutas.
3. Contrasta: ¿cada entregable tiene criterio de éxito? ¿cada fase sabe cuándo parar? ¿las reglas duras están dentro del prompt (no solo en tu cabeza)?
4. Si va a guardarse para una sesión futura: cabecera de contexto ("qué existe ya, dónde, decisión registrada").

## Checks / evidencia

- Prueba de lectura fría: alguien sin este chat, ¿sabría qué hacer, qué no tocar y cuándo ha terminado? Si no, falta contexto o criterio de éxito.
