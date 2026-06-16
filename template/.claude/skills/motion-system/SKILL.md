---
name: motion-system
description: Design and implement tactile, physical-feeling motion and interaction in React Native / Expo apps. Use this skill whenever an Issue or task involves animation, gestures, transitions, haptics, draggable or throwable UI, card stacks, scrubbing, list entrance, or any "how should this move / feel" question — even when the user only describes a static screen, because the felt quality of motion never appears in a PNG or design mock and must be specified separately. Also use when initializing a new app's motion foundation (motion tokens + interaction primitives), or when reviewing whether an implementation uses motion correctly. Do NOT skip this skill just because a screen "looks simple" — simple-looking screens are exactly where raw Animated/Pressable code sneaks in and breaks the world.
---

# motion-system

A skill for giving React Native / Expo apps a consistent, intentional, **physical** sense of touch — inertia, weight, snap — instead of generic AI-default animation.

The core problem this skill solves: **motion is invisible to static design tooling.** A Stitch PNG, a DESIGN.md, a theme.ts — these capture layout, color, type. They cannot capture how a card decelerates after your finger leaves it, or whether a sheet feels heavy or weightless. So motion gets improvised per-Issue, every duration and easing is different, and the app's feel fragments. This skill converts motion from a creative judgment made fresh each time into a **vocabulary of tokens and primitives** that Issues reference by name.

This skill is **instruction-first**: it does NOT ship primitive source code. It defines the *contract* (the props, the names, the expected behavior) and tells you how to build the implementation in the host app. Implementation may vary per app; the contract does not.

## When to apply this skill

- An Issue touches animation, gesture, transition, haptics, or anything draggable/throwable
- A screen is described only as a static layout (you must add the motion layer it implies)
- A new app needs its motion foundation set up (run "Initialization" below)
- You're reviewing whether code respects the motion system (run `scripts/check_motion.sh`)

If in doubt, apply it. The failure mode this skill exists to prevent is raw `Animated`/`Pressable`/`PanGestureHandler` code leaking in on a "simple" screen.

## The two hard rules

These are prohibitions, not suggestions. Prohibitions are easier for an agent to obey and easier to verify mechanically than positive style guidance.

**Rule 1 — No raw motion code.** Never write `Animated.*`, `useAnimatedStyle` on a raw view, `PanGestureHandler`, `TouchableOpacity`, or `Pressable` directly in a screen or feature component. All motion and touch must go through a named primitive (see Contracts). Raw primitives are allowed *only inside* the primitive implementations in `src/motion/`.

**Rule 2 — No literal motion values.** Never write a literal `duration: 300`, `damping: 15`, an inline easing curve, or a hardcoded haptic call in feature code. Every motion value comes from `motion-tokens.ts`. A literal is a sign the vocabulary was bypassed.

`scripts/check_motion.sh` greps for violations of both rules so they can fail CI. This is the "AI clarifies, human judges" split: the script catches the mechanical violations; the human judges feel on-device.

## Motion tokens

The host app must have `src/motion/motion-tokens.ts` exporting exactly these groups. Keep the set SMALL — a small vocabulary is what keeps the world coherent. Do not add a fourth spring because one screen "wants" it; bend the screen to the vocabulary.

- **duration**: `instant` (~120ms), `fast` (~200ms), `normal` (~320ms), `deliberate` (~480ms)
- **easing**: `standard`, `decelerate` (entering), `accelerate` (exiting), `sharp` (snap)
- **spring**: exactly three presets, each is the *character* of an object:
  - `snappy` — light, quick to settle, minimal overshoot (taps, toggles, small UI)
  - `weighty` — heavy, slow settle, low bounce (cards, sheets, anything with "mass")
  - `bouncy` — playful overshoot (success, celebration, rare)
- **haptics**: `light`, `medium`, `success`, `warning` — semantic, never called raw

See `references/motion-principles.md` for *why* these and the one rule that ties them together (don't mix `snappy` and `weighty` on the same surface).

## Interaction primitives (contract — implementation lives in the host app)

Build these in `src/motion/primitives/`. The **contract below is fixed**; the implementation is yours and may differ per app. Issues reference these by name and props, so the names and props must not drift.

- **`<PressableScale haptic? scale?>`** — replaces every tap target. Scales to 0.97 on press, fires `light` haptic by default.
- **`<Throwable onSettle velocity bounds?>`** — draggable object that, on release, carries finger velocity into a `withDecay` inertia glide and settles. The feel of "let go and it keeps going."
- **`<SpringCard threshold spring="weighty" onCommit onReject>`** — a card you can fling. Past `threshold` it commits (flies off, `success` haptic); short of it, it springs back with `weighty` character. The heart of the card-stack test app.
- **`<StackLayer index depth>`** — renders a card's place in a z-stack; animates promotion as the top card leaves (the next card rises with `weighty`).
- **`<ListItemEntrance index>`** — staggered fade+translate entrance for list items; stagger step comes from tokens.

When an Issue needs a NEW interaction not covered here, add a primitive (with a contract) rather than inlining raw code. Note it in the app's `src/motion/README.md` so the vocabulary stays discoverable.

## Native-feel completion criteria

Every screen-building Issue is NOT done until it satisfies `references/native-feel-checklist.md`. Pull that checklist into the Issue's acceptance criteria. It covers the things agents reliably forget: safe-area insets, keyboard avoidance, haptics on commit, swipe-to-dismiss conventions, and the three required states — loading, empty, error — never just the happy path.

## Initialization (new app)

When setting up a new app's motion foundation, in order:
1. Create `src/motion/motion-tokens.ts` with the groups above, values tuned to the app's world (a brutalist app wants short durations + sharp easing + stiff springs; read `references/motion-principles.md`).
2. Build the primitives your MVP needs (not all of them) per the contracts.
3. Add `src/motion/README.md` listing the vocabulary in use.
4. Wire `scripts/check_motion.sh` into the lint/CI step.
5. Build ONE screen, then **stop and put it on a real device.** Motion cannot be reviewed any other way. Tune the spring presets once, at the token level, and the fix propagates everywhere.

## What this skill cannot do

Be honest about the boundary: the skill makes motion *consistent and reviewable*, not automatically *good*. The 60fps "this feels right" judgment is human and on-device only. The skill's job is to make that human judgment cheap to apply (one token edit re-tunes every screen) and hard to bypass (the two rules + the check script). Don't pretend a green check script means the feel is good.
