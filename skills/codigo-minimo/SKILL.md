---
name: codigo-minimo
description: >
  Disciplina de código mínimo al escribir, añadir, refactorizar o revisar código:
  cuestiona si la tarea necesita existir (YAGNI), tira de la stdlib y de features
  nativas antes que de dependencias, una línea antes que cincuenta, borrar antes que
  añadir. Úsala al programar cualquier cosa y cuando pidan "código mínimo", "la
  solución más simple", "menos código", "yagni", "hazlo con lo que ya hay", o se
  quejen de sobre-ingeniería, over-engineering, bloat, boilerplate o dependencias
  innecesarias. Modos: lite | full | ultra. Distinta de `simplify` (que arregla
  código ya escrito): esta guía la escritura y sirve también como revisión
  anti-complejidad. No usar en peticiones que no sean de código.
---

# Código mínimo

Programas como un senior perezoso: perezoso = eficiente, no descuidado. El mejor código
es el que no se escribe. Adaptado del plugin `ponytail` (DietrichGebert, MIT) a la
biblioteca: solo la disciplina, sin hooks ni instaladores. Complementa a `debug-sistematico`
(causa raíz) y a `caveman-token-economy` (que rige la prosa, no el código). Los límites de
"cuándo NO simplificar" heredan de `SAFETY_RULES.md`.

## Inputs

- El problema entendido de verdad: **lee el flujo entero y todos los ficheros que toca el
  cambio antes de elegir peldaño**. La pereza acorta la solución, nunca la comprensión. Si
  no entiendes el flujo, para y léelo.
- Modo opcional: `lite | full | ultra` (por defecto **full**).

## La escalera (para en el primer peldaño que aguante)

1. **¿Esto necesita existir?** Necesidad especulativa = no lo hagas, dilo en una línea. (YAGNI)
2. **¿Ya está en este repo?** Helper, util, tipo o patrón que ya vive aquí → reúsalo. Mira
   antes de escribir; reimplementar lo que está unos ficheros más allá es el error más común.
   Si tienes un índice de tus otros repos (grep o búsqueda semántica sobre tu código), consúltalo también.
3. **¿Lo hace la stdlib?** Úsala.
4. **¿Lo cubre una feature nativa?** `<input type="date">` antes que una lib de picker, CSS
   antes que JS, constraint de BD antes que código de app.
5. **¿Lo resuelve una dependencia ya instalada?** Úsala. Nunca añadas una nueva para lo que
   resuelven unas líneas.
6. **¿Puede ser una línea?** Una línea.
7. **Solo entonces:** el mínimo código que funciona.

Dos peldaños valen → coge el más alto y sigue. La primera solución perezosa que funciona es
la correcta, una vez sabes qué toca el cambio.

**Bug = causa raíz, no síntoma.** Antes de editar, `grep` de todos los llamadores de la
función que vas a tocar: un guard en la función compartida es un diff más pequeño que un
guard en cada llamador, y arreglar solo la ruta del ticket deja rotos a los hermanos. Ver
`debug-sistematico`.

## Reglas

- Sin abstracciones no pedidas: nada de interfaz con una implementación, factory para un
  producto, config para un valor que nunca cambia.
- Sin boilerplate ni andamiaje "para luego". Borrar antes que añadir. Aburrido antes que
  ingenioso (lo ingenioso es lo que alguien descifra a las 3am).
- Menos ficheros. El diff más corto que funciona gana — pero solo tras entender el problema;
  el cambio más pequeño en el sitio equivocado no es pereza, es un segundo bug.
- Petición compleja: entrega la versión perezosa y cuestiónala en la misma respuesta
  ("Hecho X; Y lo cubre. ¿Necesitas X completo? Dilo.").
- Marca un recorte deliberado con techo conocido (lock global, escaneo O(n²), heurística
  naíf) con un comentario que nombre el techo y la vía de mejora.

## Modo revisión (anti-complejidad)

Una línea por hallazgo: `L<línea>: <tag> <qué>. <reemplazo>.` Tags:

- `borrar:` código muerto, flexibilidad sin uso, feature especulativa. Reemplazo: nada.
- `stdlib:` algo hecho a mano que la stdlib ya trae. Nombra la función.
- `nativo:` dependencia/código que hace lo que la plataforma ya hace. Nombra la feature.
- `yagni:` abstracción con una implementación, config que nadie pone, capa con un llamador.
- `encoger:` misma lógica, menos líneas. Muestra la forma corta.

Cierra con `neto: -<N> líneas posibles.` Si no hay nada que cortar: `Ya está magro. Adelante.`
Solo cubre complejidad; bugs, seguridad y rendimiento van a una revisión normal.

## Intensidad

| Modo | Cambio |
|---|---|
| **lite** | Construye lo pedido, pero nombra en una línea la alternativa más perezosa. Decide el usuario. |
| **full** | La escalera en vigor. Stdlib y nativo primero. Diff y explicación más cortos. Por defecto. |
| **ultra** | YAGNI extremista. Borrar antes que añadir. Entrega el one-liner y cuestiona el resto del requisito en la misma respuesta. |

## Cuándo NO ser perezoso

Nunca simplifiques: validación en fronteras de confianza, manejo de errores que evita
pérdida de datos, seguridad, accesibilidad básica, ni nada pedido explícitamente
(`SAFETY_RULES.md`). Nunca perezoso con **entender** el problema. Deja **un** check runnable
en lógica no trivial (un `assert`/self-check o un `test_*` pequeño; sin frameworks salvo que
se pidan). Hardware real necesita su knob de calibración que un modelo mínimo no ve.

## Salida

Código primero. Luego como mucho tres líneas: qué se saltó, cuándo añadirlo. Patrón:
`[código] → saltado: [X], añadir cuando [Y].` Si la explicación es más larga que el código,
sobra (salvo informe/walkthrough pedido). La prosa la rige `caveman-token-economy`; esto
rige el código.

## Reversión

No muta infraestructura. Se desactiva en la conversación con "modo normal" / "para
código-mínimo". Para quitar la skill: `./install.sh uninstall --global codigo-minimo`.

## Documentar

Skill nueva → casilla en `TASKS.md` de la biblioteca y fila en el catálogo del `README.md`. Si cambia el método de
trabajo, ADR con `decision-log`.

<!-- Adaptado del plugin ponytail (© 2026 DietrichGebert, licencia MIT): se extrae la
disciplina (la escalera, el vocabulario de revisión, los niveles de intensidad), sin sus
hooks / instaladores / MCP. Atribución conservada según la licencia. -->
