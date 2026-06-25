# Prohibited Patterns

Motion-system enforces its vocabulary through prohibitions. These mirror the "Prohibited Patterns" approach used in the DoneOrPay design system: it's far easier for an agent to obey "never do X" than to follow open-ended positive guidance, and prohibitions are mechanically checkable.

Check for these in feature code (everything outside `src/motion/`) — grep is enough.

## Banned in feature code

| Pattern | Why | Use instead |
|---|---|---|
| `TouchableOpacity`, raw `Pressable` | Bypasses scale + haptic feel | `PressableScale` |
| `Animated.*`, raw `useAnimatedStyle` on a screen | Improvised motion fragments the world | A named primitive in `src/motion/` |
| `PanGestureHandler` directly in a screen | Same — gesture logic belongs in a primitive | `Throwable` / `SpringCard` |
| Literal `duration:`, `damping:`, `stiffness:`, inline easing | Bypasses the token vocabulary | `motion-tokens.ts` values |
| Raw `Haptics.*` calls | Unsemantic, inconsistent intensity | `haptics.*` tokens |

## Allowed (and required) ONLY inside `src/motion/`

The primitive implementations are where the raw Reanimated / Gesture Handler / Haptics code lives. That's the whole design: concentrate the raw, hard-to-review motion code in a handful of audited primitives, so feature code stays a clean vocabulary. Exclude `src/motion/` from the pattern check for this reason.

## Why grep and not just review

Motion can't be reviewed by reading a diff — you have to feel it on a device. So the division of labor is: a **mechanical pattern scan** (grep) catches the violations (raw code, literal values) that *can* be caught statically, freeing the **human** review entirely for the thing only a human can do — judging the feel on-device. Don't spend human review attention on "did they use a raw Pressable"; let the grep own that.
