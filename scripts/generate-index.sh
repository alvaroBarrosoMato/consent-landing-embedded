#!/usr/bin/env bash
set -e

OUTPUT="index.html"

cat > "$OUTPUT" <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>HTML files</title>
  <style>
    body { font-family: system-ui, sans-serif; margin: 2rem; }
    ul { line-height: 1.6; }
  </style>
</head>
<body>
  <h1>HTML files in this repository</h1>
  <ul>
HTML

# find html files (exclude node_modules, .git, etc.)
find . -name "*.html" \
  ! -path "./.git/*" \
  ! -path "./index.html" \
  | sort \
  | sed 's|^\./||' \
  | while read -r file; do
      echo "    <li><a href=\"$file\">$file</a></li>" >> "$OUTPUT"
    done

cat >> "$OUTPUT" <<'HTML'
  </ul>
</body>
</html>
HTML
