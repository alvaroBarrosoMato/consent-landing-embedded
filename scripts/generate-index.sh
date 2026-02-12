#!/usr/bin/env bash
set -euo pipefail

OUTPUT="index.html"

# Collect html files (exclude index.html itself and common junk paths)
mapfile -t FILES < <(
  find . -type f -name "*.html" \
    ! -path "./.git/*" \
    ! -path "./node_modules/*" \
    ! -path "./dist/*" \
    ! -path "./build/*" \
    ! -path "./.github/*" \
    ! -path "./index.html" \
  | sort \
  | sed 's|^\./||'
)

COUNT="${#FILES[@]}"
GENERATED_AT="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

# Build grouped list: folder -> files
# We'll treat "a/b/c.html" as folder "a/b" and name "c.html"
# Root-level files go under "(root)"
declare -A GROUPS
declare -a ORDERED_GROUPS

for f in "${FILES[@]}"; do
  dir="$(dirname "$f")"
  base="$(basename "$f")"
  if [[ "$dir" == "." ]]; then dir="(root)"; fi
  key="$dir"

  if [[ -z "${GROUPS[$key]+x}" ]]; then
    GROUPS[$key]=""
    ORDERED_GROUPS+=("$key")
  fi

  # Append a line with full path and base name (tab-separated)
  GROUPS[$key]+="${f}"$'\t'"${base}"$'\n'
done

cat > "$OUTPUT" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>HTML Directory</title>
  <meta name="description" content="Browsable index of HTML files in this repository." />
  <style>
    :root{
      --bg: #0b1220;
      --panel: rgba(255,255,255,.06);
      --panel2: rgba(255,255,255,.08);
      --text: rgba(255,255,255,.92);
      --muted: rgba(255,255,255,.65);
      --border: rgba(255,255,255,.10);
      --accent: #7c3aed; /* violet */
      --accent2: #22c55e; /* green */
      --shadow: 0 10px 30px rgba(0,0,0,.35);
      --radius: 16px;
      --mono: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;
      --sans: ui-sans-serif, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple Color Emoji", "Segoe UI Emoji";
    }
    @media (prefers-color-scheme: light){
      :root{
        --bg:#f7f8fb;
        --panel:#ffffff;
        --panel2:#f3f4f6;
        --text:#0f172a;
        --muted:#475569;
        --border:rgba(15,23,42,.12);
        --shadow: 0 10px 30px rgba(15,23,42,.10);
      }
    }
    *{ box-sizing:border-box; }
    body{
      margin:0;
      font-family: var(--sans);
      color: var(--text);
      background:
        radial-gradient(1200px 800px at 10% -10%, rgba(124,58,237,.35), transparent 60%),
        radial-gradient(900px 600px at 90% 0%, rgba(34,197,94,.22), transparent 55%),
        var(--bg);
      min-height: 100vh;
    }
    a{ color: inherit; text-decoration:none; }
    a:hover{ text-decoration:underline; }

    .wrap{ max-width: 1100px; margin: 0 auto; padding: 32px 18px 60px; }

    header{
      display:flex;
      flex-wrap:wrap;
      gap:16px;
      align-items:flex-end;
      justify-content:space-between;
      margin-bottom: 20px;
    }
    .title{
      display:flex; flex-direction:column; gap:8px;
    }
    h1{
      margin:0;
      font-size: clamp(26px, 3.4vw, 42px);
      letter-spacing:-.03em;
      line-height:1.1;
    }
    .meta{
      display:flex; flex-wrap:wrap; gap:10px;
      color: var(--muted);
      font-size: 14px;
    }
    .pill{
      display:inline-flex; align-items:center; gap:8px;
      background: var(--panel);
      border: 1px solid var(--border);
      padding: 8px 12px;
      border-radius: 999px;
      box-shadow: var(--shadow);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }
    .dot{
      width:10px;height:10px;border-radius:50%;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      box-shadow: 0 0 0 3px rgba(124,58,237,.18);
    }

    .controls{
      display:flex;
      flex-wrap:wrap;
      gap:10px;
      align-items:center;
      justify-content:flex-end;
      min-width: 280px;
    }
    .search{
      flex: 1 1 280px;
      max-width: 460px;
      position: relative;
    }
    .search input{
      width:100%;
      padding: 12px 14px 12px 40px;
      border-radius: 999px;
      border: 1px solid var(--border);
      background: var(--panel);
      color: var(--text);
      outline: none;
      box-shadow: var(--shadow);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }
    .search input::placeholder{ color: var(--muted); }
    .search svg{
      position:absolute; left: 14px; top: 50%; transform: translateY(-50%);
      opacity: .7;
    }
    .btn{
      border: 1px solid var(--border);
      background: var(--panel);
      color: var(--text);
      border-radius: 999px;
      padding: 10px 12px;
      cursor:pointer;
      box-shadow: var(--shadow);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }
    .btn:hover{ background: var(--panel2); }

    .grid{
      display:grid;
      grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
      gap: 14px;
      margin-top: 18px;
    }
    .card{
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      box-shadow: var(--shadow);
      overflow:hidden;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }
    .card .head{
      padding: 14px 14px 10px;
      border-bottom: 1px solid var(--border);
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:10px;
    }
    .folder{
      font-weight: 650;
      letter-spacing: -.01em;
      display:flex; align-items:center; gap:10px;
      min-width: 0;
    }
    .folder code{
      font-family: var(--mono);
      font-size: 12.5px;
      color: var(--muted);
      background: rgba(0,0,0,.10);
      border: 1px solid var(--border);
      padding: 3px 8px;
      border-radius: 999px;
      white-space: nowrap;
      overflow:hidden;
      text-overflow: ellipsis;
      max-width: 100%;
    }
    @media (prefers-color-scheme: light){
      .folder code{ background: rgba(15,23,42,.04); }
    }
    .count{
      font-size: 12.5px;
      color: var(--muted);
      white-space: nowrap;
    }
    ul{
      list-style:none;
      margin:0;
      padding: 10px 10px 12px;
      display:flex;
      flex-direction:column;
      gap:8px;
    }
    li a{
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:12px;
      padding: 10px 10px;
      border-radius: 12px;
      border: 1px solid transparent;
    }
    li a:hover{
      background: var(--panel2);
      border-color: var(--border);
      text-decoration:none;
    }
    .name{
      display:flex; align-items:center; gap:10px;
      min-width:0;
    }
    .badge{
      font-family: var(--mono);
      font-size: 11.5px;
      color: var(--muted);
      border: 1px solid var(--border);
      border-radius: 999px;
      padding: 2px 8px;
      background: rgba(0,0,0,.10);
      white-space:nowrap;
    }
    @media (prefers-color-scheme: light){
      .badge{ background: rgba(15,23,42,.04); }
    }
    .file{
      white-space:nowrap;
      overflow:hidden;
      text-overflow: ellipsis;
      max-width: 100%;
    }
    .arrow{
      opacity:.6;
      flex: 0 0 auto;
    }
    .empty{
      margin-top: 26px;
      padding: 18px;
      border-radius: var(--radius);
      border: 1px dashed var(--border);
      color: var(--muted);
      text-align:center;
      background: rgba(255,255,255,.03);
    }
    footer{
      margin-top: 28px;
      color: var(--muted);
      font-size: 13px;
      display:flex;
      justify-content:space-between;
      flex-wrap:wrap;
      gap:10px;
    }
  </style>
</head>
<body>
  <div class="wrap">
    <header>
      <div class="title">
        <h1>HTML Directory</h1>
        <div class="meta">
          <span class="pill"><span class="dot"></span><strong>${COUNT}</strong> files</span>
          <span class="pill">Generated: <span style="font-family:var(--mono)">${GENERATED_AT}</span></span>
        </div>
      </div>

      <div class="controls">
        <div class="search">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden="true">
            <path d="M21 21l-4.3-4.3m1.8-5.2a7 7 0 11-14 0 7 7 0 0114 0z"
              stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
          </svg>
          <input id="q" type="search" placeholder="Filter files… (e.g. demo, landing, v2)" autocomplete="off" />
        </div>
        <button class="btn" id="expand">Expand all</button>
        <button class="btn" id="collapse">Collapse all</button>
      </div>
    </header>
HTML

if [[ "$COUNT" -eq 0 ]]; then
  cat >> "$OUTPUT" <<'HTML'
    <div class="empty">No <code class="badge">*.html</code> files found (after exclusions).</div>
HTML
else
  echo '    <div class="grid" id="grid">' >> "$OUTPUT"

  for group in "${ORDERED_GROUPS[@]}"; do
    # Count files in group
    group_count="$(printf "%s" "${GROUPS[$group]}" | grep -c $'\t' || true)"

    # Use <details> to allow collapse/expand
    cat >> "$OUTPUT" <<HTML
      <div class="card" data-folder="${group}">
        <div class="head">
          <div class="folder">
            <span style="width:10px;height:10px;border-radius:50%;background:linear-gradient(135deg,var(--accent),var(--accent2));display:inline-block;"></span>
            <code>${group}</code>
          </div>
          <div class="count">${group_count} file(s)</div>
        </div>
        <ul>
HTML

    # Emit links
    while IFS=$'\t' read -r full base; do
      [[ -z "${full:-}" ]] && continue
      cat >> "$OUTPUT" <<HTML
          <li data-file="${full}">
            <a href="${full}">
              <span class="name">
                <span class="badge">HTML</span>
                <span class="file">${base}</span>
              </span>
              <span class="arrow">↗</span>
            </a>
          </li>
HTML
    done < <(printf "%s" "${GROUPS[$group]}")

    cat >> "$OUTPUT" <<'HTML'
        </ul>
      </div>
HTML
  done

  echo '    </div>' >> "$OUTPUT"
fi

cat >> "$OUTPUT" <<'HTML'
    <footer>
      <span>Tip: use the filter box to quickly find a page.</span>
      <span style="font-family:var(--mono)">index.html</span>
    </footer>
  </div>

  <script>
    // Simple client-side filter (no dependencies)
    const q = document.getElementById('q');
    const grid = document.getElementById('grid');
    const expand = document.getElementById('expand');
    const collapse = document.getElementById('collapse');

    function normalize(s){ return (s || '').toLowerCase(); }

    function applyFilter(){
      const term = normalize(q.value);
      if(!grid) return;

      const cards = Array.from(grid.querySelectorAll('.card'));
      cards.forEach(card => {
        const folder = normalize(card.getAttribute('data-folder'));
        const items = Array.from(card.querySelectorAll('li'));

        let anyVisible = false;
        items.forEach(li => {
          const file = normalize(li.getAttribute('data-file'));
          const visible = !term || folder.includes(term) || file.includes(term);
          li.style.display = visible ? '' : 'none';
          if(visible) anyVisible = true;
        });

        card.style.display = anyVisible ? '' : 'none';
      });
    }

    q?.addEventListener('input', applyFilter);
    applyFilter();

    // Expand/collapse controls work by toggling each card's list visibility
    expand?.addEventListener('click', () => {
      document.querySelectorAll('.card ul').forEach(ul => ul.style.display = '');
    });
    collapse?.addEventListener('click', () => {
      document.querySelectorAll('.card ul').forEach(ul => ul.style.display = 'none');
    });
  </script>
</body>
</html>
HTML
