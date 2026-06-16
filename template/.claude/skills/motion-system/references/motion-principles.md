# Motion Principles

The *why* behind the tokens. Read this when tuning `motion-tokens.ts` for a new app, or when tempted to add a value outside the vocabulary.

## 1. A small vocabulary is the whole point

Three springs, four durations, four easings. The temptation is always to add "just one more" because a specific screen seems to want it. Resist. The moment the set grows, the app's motion stops feeling like one designed object and starts feeling improvised — which is exactly the AI-default feel this skill exists to escape. If a screen seems to need a fourth spring, the real fix is almost always to bend the screen to an existing one. Constraint is what reads as taste.

## 2. Spring presets ARE objects, not settings

Don't think of `snappy`/`weighty`/`bouncy` as "animation speeds." Think of them as the physical character of a thing:

- `snappy` is a light switch — quick, certain, no drama.
- `weighty` is a heavy drawer — it has mass, it takes a moment to settle, it does not bounce around.
- `bouncy` is a toy — playful overshoot, used sparingly so it stays special.

When you pick a spring for an element, you're answering "what kind of object is this?" A card has mass → `weighty`. A toggle is weightless → `snappy`. This framing is what makes a gesture feel physical rather than animated.

## 3. Don't mix masses on one surface

The one composition rule: **a single surface should not mix `snappy` and `weighty`.** If the card moves with weight but its buttons snap, the surface feels incoherent — like objects from two different physical worlds sharing a screen. Pick the dominant character per surface. (A `bouncy` success moment is allowed as a brief punctuation, because it's clearly a separate event, not part of the surface's resting behavior.)

## 4. Velocity must survive the gesture

The single biggest "cheap vs. physical" tell: when a finger releases a dragged object, does the object remember how fast the finger was moving? Cheap animation snaps to a target and ignores release velocity. Physical motion carries that velocity into the settle (`withDecay` for free glide, velocity-seeded `withSpring` for a target). Every `Throwable`/`SpringCard` implementation MUST pass gesture velocity into the settling animation. If it doesn't, it will feel dead no matter how nice the spring is.

## 5. Tune at the token, never at the call site

When something feels off on device — "this spring is too stiff," "this is too slow" — the fix goes in `motion-tokens.ts`, never in the screen. One edit re-tunes every screen using that token. This is the property that makes review cost independent of screen count, and it only holds if rule 2 (no literal values) is obeyed.

## Per-world starting points

Tune tokens to the app's visual world. Rough starting points:

- **Brutalist / retro-computing** (sharp, industrial): short durations, `sharp`/`accelerate` easing, stiff springs (high stiffness, high damping → little bounce). Motion should feel mechanical and decisive, not soft.
- **Soft / friendly / rounded**: longer durations, `decelerate` easing, lower damping (a little more give and overshoot).
- **Editorial / minimal**: restrained — `instant`/`fast` only, almost no bounce; let typography carry the feel and keep motion quiet.

These are starting points, not rules. Build one screen, put it on a device, adjust.
