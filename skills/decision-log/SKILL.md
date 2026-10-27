---
name: decision-log
description: Registrar una decisión irreversible o arquitectónica como ADR en DECISIONS.md con el formato de casa. Usar al tomar o detectar una decisión sin registrar.
---

# Decision log

Formato ADR ligero que uso en todos mis repos; esta skill lo aplica a cualquiera de ellos. El objetivo no es burocracia: es que dentro de un año la
decisión no se rediscuta desde cero ni se deshaga por accidente.

## ¿Merece ADR?

**Sí:** irreversible o cara de revertir (reformateos, migraciones, borrados), arquitectónica
(dónde vive algo, qué tecnología, qué convención), de seguridad/permisos, o que futuras
sesiones necesitarán respetar sin re-preguntar.
**No:** detalles de implementación cambiables, elecciones obvias sin alternativa real,
estado (eso es PROJECT_STATE) ni evidencia de operaciones (eso es reports/). Si dudas
entre registrar o no: registra corto — rediscutir cuesta más que cuatro líneas. Router
general de información: `project-memory`.

## Formato (bloque a añadir en DECISIONS.md)

```markdown
## <Título con verbo> — AAAA-MM-DD

- **Estado:** propuesta | aceptada | aceptada y ejecutada | revertida (AAAA-MM-DD)
- **Contexto:** qué problema/situación fuerza a decidir; qué alternativas reales había.
- **Decisión:** qué se decide, concreto (rutas, nombres, versiones), y quién la tomó
  si no fue el usuario directamente.
- **Consecuencias:** qué cambia a partir de ahora, qué queda pendiente por ella,
  qué otras opciones cierra.
- **Reversión:** cómo se deshace, o "irreversible" con el motivo (y qué copia/backup
  existe si aplica).
```

## Reglas

- Fechas absolutas, español, sin secretos (nombres lógicos sí).
- Una decisión = un bloque; si la decisión sustituye a otra anterior, marcar la vieja como `revertida`/superada con enlace a la nueva, no borrarla (el historial es el valor).
- El detalle extenso (evidencia, comandos) va al informe de `reports/` y se enlaza; el ADR queda corto.
- Decisiones de infraestructura compartida → el `DECISIONS.md` del repo de infraestructura; de un proyecto → el suyo. Si afecta a ambos, canónica en infraestructura y enlace en el proyecto.
- Si el repo tiene sección "Pendientes de decidir", revisar si esta decisión cierra alguna entrada y quitarla.

## Pasos

1. Confirma que es decisión aceptada (no propuesta del modelo sin OK del usuario — en ese caso, estado `propuesta`).
2. Escribe el bloque al final de DECISIONS.md (orden cronológico del archivo).
3. Enlaza informe/evidencia si existe; actualiza "Pendientes de decidir" si aplica.

## Checks

- Test del futuro lector: con solo el bloque, ¿entiende por qué se hizo y cómo deshacerlo? ¿La "reversión" es un procedimiento real, no un deseo?

## Documentar

El ADR **es** la documentación; solo queda la casilla en TASKS.md si la decisión cierra
una tarea (`documentar-cambio`).
