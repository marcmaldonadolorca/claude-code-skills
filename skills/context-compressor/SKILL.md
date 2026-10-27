---
name: context-compressor
description: Destilar insumos grandes (conversación, repo, docs, logs kilométricos) sin perder decisiones ni estado. Comprime entrada; la salida es caveman-token-economy.
---

# Context compressor

Comprime **entrada** (historial, archivos, docs, logs); para comprimir el estilo de
**salida** está `caveman-token-economy` (sus modos resumen-continuación y resumen-handoff
usan los formatos de aquí). Regla madre: se comprime la prosa, **nunca la evidencia** —
las líneas decisivas se citan textuales.

## Qué debe sobrevivir SIEMPRE a una compresión

1. Decisiones tomadas **con su motivo** (una decisión sin motivo se rediscute).
2. Restricciones y reglas duras vigentes (SAFETY_RULES, solo-lectura, no-commit, checkpoints pactados).
3. Estado actual exacto: qué está hecho (con evidencia), qué quedó a medias, qué está roto.
4. Rutas de archivos tocados y comandos que costó averiguar.
5. El siguiente paso acordado.
6. Errores: el mensaje decisivo **verbatim** (la línea de la excepción, no el stacktrace entero).

Lo primero que muere: cortesía, exploración descartada (basta "se descartó X por Y" en una línea), salidas de comandos ya superadas, idas y venidas que acabaron en una decisión (queda solo la decisión).

## Formatos según objeto

- **Conversación → continuar en sesión nueva**: `objetivo · decisiones+motivo · hecho/pendiente/roto · rutas · siguiente paso`. Máximo ~1 pantalla.
- **Conversación → handoff a otro agente**: lo anterior pero autocontenido — sin "como dijimos antes", con las reglas duras dentro y el criterio de éxito explícito (el receptor no vio nada).
- **Repo grande**: no resumir archivo a archivo; usar `repo-intake` (stack, entradas, riesgos) y comprimir su salida.
- **Documentación extensa**: extraer solo lo accionable para la tarea concreta (comandos, límites, versiones) con referencia a la sección original por si hay que volver; no parafrasear teoría.
- **Error largo**: primera causa raíz + línea exacta del error + contexto mínimo (comando, versión) + qué se probó ya. Los stacktraces repetidos de un mismo error cuentan una vez.

## Pasos

1. Identifica el objeto y el destinatario (¿yo en sesión nueva, otro agente, un humano?). El destinatario decide cuánto contexto implícito se puede asumir.
2. Pasa la lista "qué debe sobrevivir" y extrae esos puntos primero; después comprime el resto o elimínalo.
3. Contrasta contra la fuente: ¿alguna decisión, restricción o error quedó fuera? (releer buscando "decidimos", "no toques", "falla", "pendiente").
4. Entrega el resumen y, si sustituye a contexto que se va a descartar, dilo explícitamente para que el usuario confirme.

## Checks

- Test de reanudación: ¿podría una sesión limpia continuar el trabajo solo con el resumen, sin re-preguntar nada crítico ni violar una regla pactada? Si duda, faltó un "sobreviviente".

## Documentar

Resúmenes de cierre de sesiones de trabajo relevantes → nota nueva en tu sistema
de notas o informe en `reports/` si la operación lo merece.
