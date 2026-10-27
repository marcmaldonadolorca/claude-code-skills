---
name: elegir-modelo
description: Recomienda qué modelo (Opus, Sonnet o Haiku) y qué nivel de esfuerzo usar para cada tarea según su dificultad y el razonamiento que exige, y avisa cuando conviene subir o bajar de modelo a mitad de trabajo. Usar al empezar una tarea de análisis profundo, un workflow multiagente, una decisión con dinero o con consecuencias, código crítico o una revisión adversarial; también cuando un agente falla por límite de sesión, cuando la tarea resulta rutinaria y se está gastando un modelo caro, o cuando el usuario pregunta qué modelo usar.
---

# Elegir modelo y esfuerzo

Decide **antes de gastar** qué modelo y esfuerzo merece una tarea, y avisa al usuario
cuando el modelo actual sobra o no alcanza. Las suscripciones tienen **límite de sesión**: un
workflow de 20 agentes en un modelo caro lo agota (me ocurrió: 7 de 20 agentes
cayeron por límite). Gastar menos donde basta es parte del trabajo, no un extra.

Esta skill **recomienda**; no cambia el modelo por su cuenta. El cambio lo hace el usuario
(`/model <nombre>`) o, dentro de un workflow, el `model` por agente.

## Inputs

- La tarea en una frase y el proyecto (`PROJECTS.md`) o el contexto de la sesión.
- Si es un workflow: número de agentes previsto y si hay verificación adversarial.
- Si falta algo crítico para decidir (p. ej. no se sabe si hay dinero real en juego), **preguntarlo**, no suponerlo.

## Reglas

- **Dinero real, decisiones irreversibles o código que toca producción** → nunca bajar de
  Opus. Un error ahí cuesta más que todo el ahorro de tokens.
- **Revisión adversarial** (refutar, auditar, verificar cifras) → Opus en el verificador;
  los agentes de recogida de datos pueden ser más baratos.
- **Rutina** (formatear, renombrar, buscar un dato, resumir un fichero ya leído) → Haiku o Sonnet.
- El **esfuerzo** (`low`/`medium`/`high`/`max`) se sube cuando el razonamiento es el cuello de
  botella, no cuando hay mucho texto: 200 páginas de datos rutinarios no piden `max`.
- Un workflow con muchos agentes **multiplica** el coste: preferir menos agentes con
  mejor verificación antes que muchos agentes baratos sin control.
- No recomendar un modelo que el usuario no tenga (comprobar la suscripción si hay duda).

## Tabla de decisión

| Tipo de tarea | Modelo | Esfuerzo | Ejemplos reales |
|---|---|---|---|
| Rutina mecánica, búsqueda, formato, resumen de un fichero | Haiku | low | renombrar, grep, pasar un CSV a tabla |
| Código normal, documentación, edición con criterio medio | Sonnet | medium | añadir un test, actualizar un README, una función |
| Análisis con datos, backtest, diagnóstico de un bug con causa no obvia | Sonnet o Opus | high | depurar un fallo de una cola de jobs, leer un informe técnico largo |
| Decisión con dinero, auditoría adversarial, síntesis de un workflow, código de producción crítico | **Opus** | high o max | aprobar un cambio que mueve dinero, refutar una cifra, cerrar un ADR |
| Workflow multiagente completo (20+ agentes) | Sonnet en recogida, **Opus solo en verificación y síntesis** | medium en recogida, high/max en verificación | auditoría con refutación de cifras |

Regla práctica: si la respuesta equivocada costaría dinero, reputación o una semana, sube un
escalón. Si la respuesta se puede comprobar en un minuto, baja un escalón.

## Pasos

1. **Clasificar la tarea** con la tabla: tipo, reversibilidad, cuánto razonamiento se necesita
   y si hay dinero o un tercero en juego.
2. **Proponer modelo + esfuerzo** en una línea y el motivo en otra, con la alternativa más
   barata si existe. Ejemplo: «Opus, high: hay dinero real y una cifra que refutar. Si solo
   fuese recogida de datos, Sonnet medium».
3. **Vigilar a mitad de tarea** y avisar explícitamente en estos casos:
   - Un agente o llamada falla por **límite de sesión** → proponer reanudar el resto con
     menos agentes o en otro momento, sin reejecutar lo caído a ciegas.
   - La tarea resulta **más difícil de lo previsto** (contradicciones, cifras que no cuadran)
     → subir a Opus para el paso crítico.
   - La tarea es **rutinaria** pero se está en Opus → bajar a Sonnet o Haiku para lo que resta.
4. **Nunca cambiar en silencio**: cada cambio de modelo se comunica al usuario con su
   motivo, y él decide.

## Checks / evidencia

- La recomendación cita el tipo de tarea de la tabla y la razón concreta (no un genérico).
- Tras un workflow: anotar qué agentes fallaron por límite y cuál era su modelo, para
  calibrar la siguiente vez (en el informe o en `PROJECT_STATE.md` del proyecto).

## Reversión

- Nada que deshacer: es una recomendación. Si el usuario fija un modelo, eso prevalece.

## Documentar

- Si una recomendación de modelo cambia el método de un proyecto (p. ej. «workflows de
  auditoría siempre con Opus en verificación»), registrarlo como decisión en el `DECISIONS.md`
  del proyecto (skill `decision-log`).
- Al cerrar un workflow con fallos por límite, una línea en `PROJECT_STATE.md` del proyecto.
