#!/usr/bin/env bash
# check_motion.sh — static check for motion-system prohibited patterns.
# Scans feature code (everything under SRC except src/motion/) for raw motion
# code and literal motion values. Exits non-zero if any violation is found,
# so it can gate CI. This is the mechanical half of review; feel is judged
# by a human on-device.
#
# Usage: ./check_motion.sh [src_dir]   (default: ./src)

set -uo pipefail

SRC="${1:-./src}"
MOTION_DIR="$SRC/motion"
fail=0

if [ ! -d "$SRC" ]; then
  echo "check_motion: source dir '$SRC' not found" >&2
  exit 2
fi

# Files to scan: .ts/.tsx under SRC, excluding the motion implementation dir.
files=$(find "$SRC" -type f \( -name '*.ts' -o -name '*.tsx' \) \
  -not -path "$MOTION_DIR/*")

report() {
  # $1 = label, $2 = grep pattern
  local label="$1" pattern="$2" hits
  hits=$(echo "$files" | xargs grep -nE "$pattern" 2>/dev/null)
  if [ -n "$hits" ]; then
    echo "✗ $label"
    echo "$hits" | sed 's/^/    /'
    echo
    fail=1
  fi
}

echo "motion-system check — scanning $SRC (excluding $MOTION_DIR)"
echo

report "Raw TouchableOpacity / Pressable (use PressableScale)" \
  '\b(TouchableOpacity|TouchableHighlight)\b|<Pressable\b'

report "Raw Animated / useAnimatedStyle in feature code (use a primitive)" \
  '\bAnimated\.[A-Za-z]|useAnimatedStyle'

report "Raw PanGestureHandler in feature code (use Throwable/SpringCard)" \
  '\bPanGestureHandler\b'

report "Literal motion values (use motion-tokens.ts)" \
  '(duration|damping|stiffness)\s*[:=]\s*[0-9]'

report "Raw Haptics call (use haptics.* tokens)" \
  '\bHaptics\.[A-Za-z]'

if [ "$fail" -eq 0 ]; then
  echo "✓ motion-system: no prohibited patterns found."
  echo "  (Reminder: this only checks mechanics. Feel must be judged on a real device.)"
else
  echo "motion-system: violations found. See references/prohibited-patterns.md."
fi

exit $fail
