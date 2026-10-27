---
name: web-proyecto-nextjs
description: Crear o trabajar un proyecto Next.js/React con Tailwind y shadcn/ui según convenciones — TS estricto, App Router, testing, manifiesto reproducible.
---

# Proyecto web Next.js

Stack por defecto para webs propias y de clientes: **Next.js (App Router) + TypeScript
estricto + Tailwind + shadcn/ui**. Se aparta de este stack solo con motivo registrado
(`decision-log`). Estructura de proyecto y disciplina documental: skill `nuevo-proyecto`.

## Inputs

- Qué se construye (app, web de cliente, landing → para landings ver `web-landing-cliente`) y si tiene requisitos que rompan el default (CMS, i18n, auth).

## Setup (proyecto nuevo)

1. `npx create-next-app@latest <nombre> --typescript --tailwind --eslint --app --src-dir` — versión que fije el lockfile; el entorno siempre se recrea desde `package.json`, nunca se copia `node_modules`.
2. `tsconfig.json` con `strict: true` (no rebajarlo para callar errores; tipar).
3. shadcn/ui: `npx shadcn@latest init` y añadir componentes **uno a uno** cuando se necesiten (`npx shadcn@latest add button …`); el código queda en `src/components/ui/` y es nuestro: se puede editar. Existen skills oficiales de shadcn (ui.shadcn.com/docs/skills) — si se quieren adoptar, antes `skill-auditor`.
4. Testing desde el inicio: **Vitest** (unidad/componentes) + **Playwright** (e2e mínimo: home renderiza, navegación básica, formulario clave). Un test que falla en CI vale más que diez manuales.
5. `.env.example` con nombres lógicos y valores ficticios; secretos reales fuera de Git (gestor de secretos). `NEXT_PUBLIC_` solo para lo que de verdad puede ser público.

## Convenciones de trabajo

- **Server Components por defecto**; `"use client"` solo donde haya interactividad real (estado, eventos). No convertir árboles enteros a cliente por comodidad.
- Datos: fetch en el servidor cuando se pueda; estados de carga/errores explícitos (`loading.tsx`, `error.tsx`).
- Componentes reutilizables en `src/components/` con props tipadas; los de `ui/` (shadcn) no se duplican: se componen.
- Componentes **animados** (texto, fondos, hover elaborado): mirar antes el catálogo de React Bits (`reactbits.dev`; revisa su licencia) — se **copia** el componente a `src/components/` y desde ahí es código nuestro (props tipadas, `"use client"` si toca), igual que con shadcn. Sin su CLI: fija `three@^0.180.0` y te bajaría la versión del proyecto. La elección de la pieza sale del spec, no de navegar el catálogo.
- Tailwind: clases utilitarias directas; extraer a componente cuando un patrón se repite ~3 veces, no antes. Tokens de diseño (colores/espaciado del cliente) en `tailwind.config` / CSS vars, no hardcodeados por archivo.
- Imágenes con `next/image`, fuentes con `next/font` — rendimiento por defecto, no como parche final.
- Accesibilidad desde el primer componente (labels, foco, contraste); auditoría completa: `web-auditoria`.

## Checks / evidencia

- `npm run build` limpio + `npm run lint` + tests pasando: los tres, no uno.
- Página clave revisada en móvil (viewport ~375px) además de escritorio.

## Reversión

- Todo vive en Git sin commitear hasta autorización; `git diff` para revisar, descartar con OK del usuario.

## Documentar

Proyecto nuevo → estructura estándar y registro según `nuevo-proyecto`. Elecciones que
rompan el stack por defecto → `DECISIONS.md` del proyecto.
