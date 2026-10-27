---
name: web-landing-cliente
description: Convertir el briefing de un cliente en una landing profesional — persuasiva, accesible y rápida, lista para iterar. Webs de negocio local y prototipos.
---

# Landing para cliente

Objetivo: que un negocio pequeño parezca serio y **convierta** (llamada, formulario,
reserva). Base técnica: `web-proyecto-nextjs` (o HTML/CSS estático si el proyecto no
justifica un framework — decidirlo explícitamente y anotarlo).

## Inputs (briefing mínimo — si falta, preguntar antes de diseñar)

- Negocio y qué vende, público objetivo, **la acción única** que debe hacer el visitante (CTA), 3 referencias que le gusten al cliente, materiales reales (logo, fotos, textos legales) y dominio/hosting previsto.
- Sin materiales reales: construir con placeholders marcados `TODO-cliente`, nunca inventar datos del negocio (teléfonos, direcciones, reseñas).

## Estructura que funciona (adaptar, no rellenar como formulario)

1. **Hero**: qué es + para quién + CTA visible sin scroll. Titular de beneficio, no de nombre de empresa.
2. **Prueba social**: reseñas/clientes/números reales (si no hay, se omite la sección — jamás inventarla).
3. **Servicios/oferta**: 3-6 bloques escaneables, cada uno con beneficio, no solo característica.
4. **Cómo funciona / sobre nosotros**: reducir fricción y desconfianza (fotos reales > stock).
5. **CTA repetido** + contacto (formulario corto: cada campo extra baja conversión) + mapa/horario si es negocio local.
6. **Footer legal**: aviso legal, privacidad, cookies si aplica (RGPD: solo placeholder señalado; el texto final lo pone el cliente/su asesor).

## Calidad de diseño (lo que separa "profesional" de "plantilla")

- Un solo tipo de letra display + uno de texto; escala tipográfica consistente; espaciado generoso y regular (el aire es diseño).
- Paleta corta derivada del logo/marca (definida como tokens, ver `web-proyecto-nextjs`); contraste AA mínimo.
- Jerarquía: en cada pantalla debe estar claro qué mirar primero; si todo grita, nada se lee.
- Móvil primero de verdad: la mayoría del tráfico de negocio local es móvil.
- Rendimiento: imágenes optimizadas, sin librerías para lo que hace CSS; objetivo LCP < 2,5 s.

## Pasos

1. Briefing → mapa de secciones y textos borrador (el copy es el 70 % de la landing: escribirlo primero, diseñar después).
2. Prototipo funcional completo con contenido real o `TODO-cliente`.
3. Autochequeo con `web-auditoria` (a11y + SEO + rendimiento) antes de enseñarla.
4. Ronda con el cliente: recoger cambios por escrito, iterar una vez con criterio (no obedecer píxel a píxel lo que rompa jerarquía — explicar el porqué y ofrecer alternativa).

## Checks / evidencia

- La acción única se puede completar en < 10 s desde la llegada, en móvil.
- Cero contenido inventado sin marcar; Lighthouse (o equivalente) sin rojos en Performance/A11y/SEO.

## Documentar

Proyecto según `nuevo-proyecto`; decisiones de alcance con el cliente (qué entra y qué
no) por escrito en el repo del proyecto — evita el "scope creep" clásico de cliente pequeño.
