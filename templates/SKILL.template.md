---
name: <nombre-en-kebab-case-igual-al-directorio>
description: <Qué hace Y CUÁNDO usarla, en 1-3 frases. Claude decide activarla leyendo solo esto: incluye las palabras que aparecerían en una petición real. Termina con "Usar cuando/al …".>
---

# <Título humano>

<1-3 frases de propósito y contexto. Enlaza a los documentos canónicos del repo
(`docs/`, SAFETY_RULES.md) en lugar de duplicarlos.>

## Inputs

- <Dato imprescindible 1. **Si falta un input crítico, parar y pedirlo**, no inventarlo.>
- <Dato 2…>

## Reglas

- <Límites duros heredados de SAFETY_RULES.md que apliquen aquí (secretos, red, datos…).>
- <Reglas propias de esta skill.>

## Pasos

1. <Orden `lectura → dry-run → mutar`: primero observar el estado real.>
2. <…>
3. <…>

## Checks / evidencia

- <Cómo se sabe que funcionó de verdad (comando + salida esperada), no solo "terminó sin error".>

## Reversión

- <Cómo deshacer cada paso mutante. Si algo no es reversible, decirlo explícitamente.>

## Documentar

<Qué actualizar al terminar (skill `documentar-cambio`: el
`PROJECT_STATE.md`/`TASKS.md` del proyecto afectado).>

<!--
Convenciones (README.md):
- SKILL.md < 500 líneas; si crece, mover detalle a references/ dentro de la skill
  (progressive disclosure) y enlazarlo.
- Scripts en scripts/ solo para operaciones deterministas; indicar si se ejecutan
  o se leen como referencia. Sin dependencias sin fijar.
- En español, rutas absolutas, sin secretos, sin duplicar docs canónicos.
- Antes de darla por buena: probar activación (¿se dispara con una petición realista?)
  y probar el procedimiento con datos ficticios (skill skill-builder).
-->
