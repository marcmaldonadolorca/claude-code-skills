---
name: debug-sistematico
description: Metodología de debugging con causa raíz obligatoria antes de cualquier arreglo. Usar ante cualquier bug, test que falla, error inesperado, build roto o comportamiento raro — especialmente bajo presión, cuando el arreglo «obvio» ya falló una vez, o cuando llevas varios parches acumulados sin entender el problema.
---

# Debug sistemático

Los arreglos aleatorios queman tiempo y crean bugs nuevos. **Ley de hierro: ningún
arreglo sin investigar la causa raíz primero.** Arreglar el síntoma es fallar.
(Idea recreada de `systematic-debugging` de [obra/superpowers](https://github.com/obra/superpowers), MIT; versión propia adaptada a las reglas de casa.)

Aplica a todo: tests, bugs, rendimiento, builds, infra. **Sobre todo** cuando parece
que no hace falta: urgencias, «un arreglo rápido», o cuando ya probaste algo y no funcionó.

## Inputs

- El síntoma exacto (mensaje de error completo, no un resumen).
- Cómo reproducirlo — si aún no se sabe, ese es el primer paso, no un opcional.

## Reglas

- **Sin causa raíz identificada no se propone ningún arreglo.** «Probablemente es X,
  déjame tocarlo» está prohibido.
- Un cambio cada vez. Nunca varios arreglos juntos «para ahorrar tiempo»: no sabrás
  cuál funcionó y habrás creado bugs nuevos.
- En infraestructura (servidores, contenedores) manda `SAFETY_RULES.md`: observar antes de mutar, y ningún
  comando que cambie estado (restart, delete, edición de config) por pattern-matching
  — la evidencia debe apoyar esa acción concreta, no un fallo «parecido».
- Decir «no entiendo X» está permitido y es más barato que fingir que sí.

## Pasos

1. **Causa raíz (obligatoria antes de nada):**
   - Lee el error **completo**: stack trace entero, números de línea, códigos. A menudo
     contiene la solución exacta.
   - Reproduce de forma fiable. ¿Pasa siempre? Si no es reproducible → más datos, no
     conjeturas.
   - Cambios recientes: `git diff`, últimos commits, dependencias nuevas, config,
     diferencias de entorno.
   - En sistemas multi-capa (workflow → script → servicio → datos): instrumenta cada
     frontera (qué entra, qué sale, qué env/config llega) y ejecuta UNA vez para ver
     **dónde** se rompe; después investiga esa capa. En servidores: `journalctl -u X`,
     `docker logs`, `ss -tlnp`, montajes — estado vivo, no docs.
   - Traza hacia atrás: ¿de dónde sale el valor malo? ¿quién llamó con él? Arregla en
     el origen, no donde explota.
2. **Patrón:** busca un ejemplo que funcione (mismo repo u referencia) y lista TODAS
   las diferencias con lo roto, por pequeñas que sean. «Eso no puede importar» no existe.
   Si sigues una referencia, léela completa, no en diagonal.
3. **Hipótesis única y prueba mínima:** escribe «creo que X es la causa porque Y»;
   haz el cambio MÁS PEQUEÑO que la pruebe, una variable cada vez. ¿No se confirma?
   Nueva hipótesis — **no** apiles otro arreglo encima.
4. **Implementación:**
   - Primero una reproducción que falla (test automatizado si hay framework; script
     suelto si no). Sin reproducción que falle, no hay arreglo.
   - Un solo cambio dirigido a la causa raíz. Sin «ya que estoy» ni refactors de paso.
   - Verifica: ¿pasa la reproducción? ¿no se rompió nada más? ¿el problema original
     desapareció de verdad?
5. **Freno de emergencia:** si llevas **3 arreglos fallidos**, el problema no es la
   hipótesis: es el diseño o el diagnóstico. PARA, resume qué se investigó y qué
   reveló cada intento, y plantéaselo al usuario antes del intento nº 4. Cada
   arreglo que destapa un problema nuevo en otro sitio es la firma de este caso.

## Señales rojas (si te pillas pensándolo, vuelve al paso 1)

«Arreglo rápido ahora e investigo luego» · «prueba a cambiar X a ver» · «meto varios
cambios y corro los tests» · «me salto el test, verifico a mano» · «es probablemente
X» · «no lo entiendo del todo pero esto podría funcionar» · proponer soluciones antes
de trazar el flujo de datos · «un intento más» cuando ya van 2+.

## Checks / evidencia

- La causa raíz está escrita en una frase («X porque Y») **antes** del arreglo.
- Existe una reproducción que fallaba y ahora pasa; la suite/el servicio siguen sanos.
- Si fue «no hay causa raíz» (entorno, timing, externo): investigación documentada +
  manejo apropiado (retry/timeout/mensaje) + logging para la próxima. El 95 % de los
  «sin causa raíz» son investigación incompleta.

## Reversión

- Metodología de solo lectura hasta el paso 4; el arreglo en sí sigue las reglas del
  repo/host donde se aplique (backup antes de mutar datos, sin commits sin autorización).

## Documentar

Bug con lección → nota nueva en tu sistema de notas. Si tocó infra:
`documentar-cambio`. Si reveló un problema de arquitectura: ADR con `decision-log`.
