# Native-Feel Checklist

Pull this into every screen-building Issue's acceptance criteria. These are the things agents reliably forget because they don't show up in a happy-path render. A screen is not "done" until every applicable item is satisfied.

## Layout & safe areas
- [ ] Respects safe-area insets (notch, home indicator, status bar) — no content under the system UI
- [ ] Keyboard avoidance: inputs are not covered by the keyboard; the view scrolls or shifts
- [ ] Works on a small device (SE-class) and a large one — no clipping or overflow

## Touch & feedback
- [ ] Every tap target goes through `PressableScale` (no raw `TouchableOpacity`/`Pressable`)
- [ ] Haptic feedback on meaningful commits (the `success`/`medium` token, not raw calls)
- [ ] Hit targets are at least ~44pt; small icons have padded touch areas
- [ ] Gesture-driven elements carry release velocity into their settle (see motion-principles §4)

## States (never just the happy path)
- [ ] **Loading** state exists (skeleton or spinner, not a blank screen)
- [ ] **Empty** state exists and says something — what to do, not just "no items"
- [ ] **Error** state exists and is recoverable (retry, not a dead end)

## Platform conventions
- [ ] Modals/sheets use the platform sheet convention (swipe-down to dismiss where appropriate)
- [ ] Scroll has correct overscroll/bounce behavior for the platform
- [ ] Back/dismiss gestures don't conflict with in-screen horizontal gestures

## Motion coherence
- [ ] One dominant spring character per surface (no `snappy`+`weighty` mix — see principles §3)
- [ ] No literal durations/easings/springs anywhere in the screen (all from tokens)
- [ ] `scripts/check_motion.sh` passes

Mark non-applicable items as N/A explicitly rather than silently skipping — that's how you know they were considered.
