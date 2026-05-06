---
name: avoid-design-slop
description: Use when implementing UI screens, components, styles, or landing pages — flags common AI-generated design clichés (overused fonts, generic layouts, low-contrast dark themes, gradient/glow overuse) so Claude proposes more distinctive designs. Sourced from Adrian Krebs' "Design Slop" article.
---

# Avoid Design Slop

Source: https://www.adriankrebs.ch/blog/design-slop (Adrian Krebs)

## How to use this skill

- Before/while writing UI: scan the patterns below and avoid them.
- Tags: `[Web]` = Web-specific (e.g. landing pages); `[Both]` = applies to Web and React Native.
- Do not invent RN-specific anti-patterns; only flag what's listed.

## Fonts

- [Both] Inter used for everything, especially centered hero headlines
- [Both] Default LLM combos: Space Grotesk, Instrument Serif, Geist
- [Both] Serif italic on a single accent word in an otherwise-Inter hero

## Colors

- [Both] "VibeCode Purple" as the brand color
- [Both] Permanent dark mode with medium-grey body text and all-caps section labels
- [Both] Barely-passing body-text contrast in dark themes
- [Both] Gradient everything
- [Both] Large colored glows and colored box-shadows

## Layout quirks

- [Both] Centered hero set in a generic sans
- [Both] Badge directly above the hero H1
- [Both] Colored borders on cards (top or left edge)
- [Both] Identical 3-up feature cards with an icon on top
- [Both] Numbered "1, 2, 3" step sequences
- [Both] Stat banner rows
- [Both] Sidebar/nav with emoji icons
- [Both] All-caps headings and section labels

## CSS patterns

- [Web] Default shadcn/ui look
- [Web] Glassmorphism

## What to do instead

- Pick typography/color choices that reflect the product's identity, not LLM defaults.
- Verify dark-mode contrast against WCAG.
- Question every "centered hero + 3 cards + numbered steps" layout: does it serve the content, or is it filler?
- When using a UI library (shadcn/ui, NativeWind, Tamagui, etc.), customize tokens — don't ship defaults.
