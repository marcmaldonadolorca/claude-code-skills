---
name: web-auditoria
description: Auditar una web — accesibilidad, SEO técnico, rendimiento, robustez; hallazgos priorizados. Antes de entregar, al heredar, o si «va lenta»/«no sale en Google».
---

# Auditoría web

Auditoría de **solo lectura** sobre una URL o un build local; produce informe priorizado,
no arregla nada sin OK (los arreglos son tarea aparte). Herramientas: las del proyecto +
Lighthouse (Chrome/CLI) y Playwright si está disponible; si no, los checks manuales de abajo.

## Inputs

- URL (o `npm run build && npm start` local) y el objetivo del sitio (¿qué conversión/qué búsquedas importan?). Sin objetivo, la priorización es ciega.

## Pasos

1. **Rendimiento** (Core Web Vitals): Lighthouse en móvil. Mirar LCP (< 2,5 s), CLS (< 0,1), INP, peso total y nº de requests. Sospechosos habituales: imágenes sin optimizar/dimensionar, JS de terceros, fuentes bloqueantes, todo-cliente en React (`"use client"` innecesario).
2. **Accesibilidad**: además del score automático (axe/Lighthouse), los que las herramientas no ven:
   - Navegable **solo con teclado** (foco visible, orden lógico, sin trampas de foco).
   - Imágenes con `alt` útil (o vacío si decorativas); formularios con `label` real; botones que son `<button>`, enlaces que son `<a>`.
   - Contraste AA; zoom 200 % sin romper; `prefers-reduced-motion` respetado si hay animación.
3. **SEO técnico**: `title`/`meta description` únicos y descriptivos por página; un solo `h1` y jerarquía de encabezados sana; `robots.txt` + `sitemap.xml`; canonical; Open Graph básico; datos estructurados (`LocalBusiness` para negocio local); 404 correcta; sin cadenas de redirects; HTTPS sin contenido mixto.
4. **Robustez**: estados de error/carga visibles; formularios validan en cliente Y servidor; sin claves/API keys en el bundle (`grep -riE 'api[_-]?key|secret' .next/static/ dist/` sobre el build); cabeceras de seguridad básicas (CSP aunque sea report-only, `X-Content-Type-Options`).
5. **Smoke e2e** (si Playwright): home renderiza, navegación principal, la conversión clave completa. Guardar el script en el repo del proyecto: la próxima auditoría empieza ganando.
6. **Pre-publicación** (lo que el cliente descubre semanas tarde): el formulario **llega de verdad** (envío de prueba recibido, mirar spam; si no se puede probar, decirlo, no darlo por hecho) · banner de cookies: en incógnito, **rechazar en un clic** y nada se carga antes de elegir (RGPD + LSSI) · restos de plantilla: `grep -riE 'lorem|ipsum|example\.com|ejemplo|your (company|name)'` sobre el build + redes sociales que no son del cliente · `title` propio y **favicon** propio en cada página · imagen OG 1200×630 con logo, probada pegando el enlace en WhatsApp (portada e interior) · ningún recurso por `http://` y redirección única a la versión https canónica con y sin `www` · analítica sin cookies instalada **antes** del lanzamiento, no después.

## Informe (salida)

Tabla priorizada: `hallazgo · evidencia (métrica/captura/línea) · impacto (alto/medio/bajo
respecto al objetivo del sitio) · arreglo propuesto · esfuerzo`. Lo alto-impacto/bajo-esfuerzo
primero. Sin hallazgos vagos: "LCP 4,8 s por hero de 2,3 MB" sí; "va lenta" no.

## Checks / evidencia

- Cada hallazgo es reproducible por el usuario (comando o pasos incluidos).
- Los scores automáticos acompañan pero no sustituyen los checks manuales de a11y.

## Documentar

Informe en `reports/` del proyecto auditado (o del repo de infraestructura si es un servicio propio),
con fecha absoluta — sirve de línea base para medir la mejora tras los arreglos.
