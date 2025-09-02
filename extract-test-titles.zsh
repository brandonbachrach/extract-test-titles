#!/usr/bin/env zsh
set -euo pipefail

# Usage: ./extract-test-titles.zsh [root_dir] [output_file] [file_pattern]
# Example: ./extract-test-titles.zsh ./cypress/e2e test_titles.txt *.cy.ts
# Default root_dir: .
# Default output_file: test_titles.txt
# Default file_pattern: *.cy.ts
# TODO support it.each

ROOT_DIR="${1:-.}"
OUT_FILE="${2:-test_titles.txt}"
FILE_PATTERN="${3:-*.cy.ts}"

: > "$OUT_FILE"

printf 'Writing test titles to: %s\n' "$OUT_FILE..."

LC_ALL=C grep -R -H -Eo \
  --include='*.cy.ts' \
  "^[[:space:]]*(describe|it|test)[[:space:]]*(\.skip)?[[:space:]]*\([[:space:]]*['\"\`][^'\"\`]+['\"\`]" \
  "$ROOT_DIR" \
| awk '
  BEGIN{ first=1 }
  {
    i         = index($0,":")
    file_path = substr($0, 1, i-1)
    m         = substr($0, i+1)

    if (!(file_path in seen)) {
      if (!first) print ""
      print file_path
      seen[file_path]=1
      first=0
    }

    # Preserves whitespace to reflect test nesting
    indentation = m
    sub(/(describe|it|test).*/, "", indentation)

    # Extract test type (describe, it, test)
    test_type = m
    sub(/^[[:space:]]*/, "", test_type) # Trim
    sub(/\(.*/, "", test_type)
    
    skipped = ""
    if (test_type ~ /\.skip$/) { sub(/\.skip$/, "", test_type); skipped=" SKIPPED" }

    title = m
    sub(/^[^(]*\([[:space:]]*["\047`]/, "", title)
    sub(/["\047`].*$/, "", title)

    printf "%s%s%s: %s\n", indentation, test_type, skipped, title
  }
' >> "$OUT_FILE"

printf 'Wrote test titles to: %s\n' "$OUT_FILE"