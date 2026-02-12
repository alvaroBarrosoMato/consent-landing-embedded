#!/usr/bin/env bash
set -euo pipefail

OUTPUT="index.html"

# --- Configure exclusions here ---
EXCLUDES=(
  "./.git/*"
  "./node_modules/*"
  "./dist/*"
  "./build/*"
  "./.github/*"
  "./vendor/*"
)

# HTML escape for safe injection into index.html
html_escape() {
  local s="${1:-}"
  s="${s//&/&amp;}"
  s="${s//</&lt;}"
  s="${s//>/&gt;}"
  s="${s//\"/&quot;}"
  s="${s//\'/&#39;}"
  printf '%s' "$s"
}

# Extract description from the first commented line that starts with "Description:"
# Expected format near top of file: <!-- Description: something here -->
extract_description() {
  local file="$1"
  local line desc
  # look at the first 40 lines only; grab first match
  line="$(
    awk 'NR<=40 { print } NR==40 { exit }' "$file" \
    | tr -d '\r' \
    | grep -m1 -E '<!--[[:space:]]*Description:[[:space:]]*' \
    || true
  )"

  if [[ -z "$line" ]]; then
    printf '—'
    return 0
  fi

  desc="${line#*Description:}"
  desc="${desc%-->*}"
  desc="$(printf '%s' "$desc" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

  [[ -z "$desc" ]] && desc="—"
  printf '%s' "$desc"
}

# Collect html files (exclude index.html itself + excluded paths)
FIND_CMD=(find . -type f -name "*.html" ! -path "./index.html")
for p in "${EXCLUDES[@]}"; do
  FIND_CMD+=(! -path "$p")
done

mapfile -t FILES < <("${FIND_CMD[@]}" | sort | sed 's|^\./||')

COUNT="${#FILES[@]}"
GENERATED_AT="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"

# Group by directory
declare -A FILE_GROUPS
declare -a ORDERED_GROUPS

for f in "${FILES[@]}"; do
  dir="$(dirname "$f")"
  base="$(basename "$f")"
  [[ "$dir" == "." ]] && dir="(root)"

  if [[ -z "${FILE_GROUPS[$dir]+x}" ]]; then
    FILE_GROUPS[$dir]=""
    ORDERED_GROUPS+=("$dir")
  fi

  desc="$(extract_description "$f")"
  # store: fullpath<TAB>basename<TAB>description
  FILE_GROUPS[$dir]+="${f}"$'\t'"${base}"$'\t'"${desc}"$'\n'
done

# --- Write HTML ---
cat > "$OUTPUT" <<HTML
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>UCPM Banners Library</title>
  <meta name="description" content="Auto-generated library of UCPM banner HTML files in this repository." />
  <style>
    :root{
      --bg: #0b1020;
      --panel: rgba(255,255,255,.06);
      --panel2: rgba(255,255,255,.10);
      --text: rgba(255,255,255,.92);
      --muted: rgba(255,255,255,.68);
      --border: rgba(255,255,255,.10);
      --accent: #7c3aed; /* violet */
      --accent2:#22c55e; /* green */
      --shadow: 0 16px 40px rgba(0,0,0,.35);
      --radius: 18px;
      --mono: ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace;
      --sans: ui-sans-serif,system-ui,-apple-system,"Segoe UI",Roboto,Helvetica,Arial;
    }
    @media (prefers-color-scheme: light){
      :root{
        --bg:#f6f7fb;
        --panel:#ffffff;
        --panel2:#f2f4f7;
        --text:#0f172a;
        --muted:#475569;
        --border: rgba(15,23,42,.10);
        --shadow: 0 16px 40px rgba(15,23,42,.12);
      }
    }

    *{ box-sizing:border-box; }
    body{
      margin:0;
      font-family: var(--sans);
      color: var(--text);
      background:
        radial-gradient(1200px 800px at 10% -10%, rgba(124,58,237,.25), transparent 60%),
        radial-gradient(900px 600px at 90% 0%, rgba(34,197,94,.16), transparent 55%),
        var(--bg);
      min-height:100vh;
    }

    a{ color:inherit; text-decoration:none; }
    a:hover{ text-decoration:none; }

    .wrap{ max-width: 1120px; margin: 0 auto; padding: 28px 18px 64px; }

    /* Header (no shaded overlay) */
    .top{
      position: static; /* remove sticky shading effect */
      padding: 6px 0 14px;
      background: none;
      backdrop-filter: none;
      -webkit-backdrop-filter: none;
    }

    .hero{
      display:flex;
      flex-wrap:wrap;
      gap:14px 16px;
      align-items:flex-end;
      justify-content:space-between;
    }

    h1{
      margin:0;
      font-size: clamp(24px, 3.2vw, 42px);
      letter-spacing:-.035em;
      line-height:1.05;
    }

    .sub{
      margin-top: 8px;
      color: var(--muted);
      font-size: 14px;
      display:flex;
      flex-wrap:wrap;
      gap:10px;
      align-items:center;
    }

    .pill{
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding: 8px 12px;
      border-radius: 999px;
      border: 1px solid var(--border);
      background: var(--panel);
      box-shadow: none; /* remove shading */
    }
    .dot{
      width:10px;height:10px;border-radius:50%;
      background: linear-gradient(135deg, var(--accent), var(--accent2));
      box-shadow: 0 0 0 3px rgba(124,58,237,.18);
    }
    .mono{ font-family: var(--mono); }

    .controls{
      display:flex;
      flex-wrap:wrap;
      gap:10px;
      align-items:center;
      justify-content:flex-end;
      min-width: 260px;
    }

    .search{ position:relative; flex: 1 1 260px; max-width: 520px; }
    .search input{
      width:100%;
      padding: 12px 14px 12px 40px;
      border-radius: 999px;
      border: 1px solid var(--border);
      background: var(--panel);
      color: var(--text);
      outline:none;
      box-shadow: var(--shadow);
    }
    .search input::placeholder{ color: var(--muted); }
    .search svg{
      position:absolute;
      left: 14px; top: 50%;
      transform: translateY(-50%);
      opacity:.75;
    }

    .btn{
      border: 1px solid var(--border);
      background: var(--panel);
      color: var(--text);
      border-radius: 999px;
      padding: 10px 12px;
      cursor:pointer;
      box-shadow: none; /* less shading */
      transition: transform .08s ease, background .15s ease;
      user-select:none;
      white-space: nowrap;
    }
    .btn:hover{ background: var(--panel2); }
    .btn:active{ transform: translateY(1px) scale(.99); }

    .section{
      margin-top: 18px;
      border: 1px solid var(--border);
      border-radius: var(--radius);
      background: var(--panel);
      overflow: hidden;
      box-shadow: var(--shadow);
    }

    .section-head{
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:12px;
      padding: 14px 14px 12px;
      border-bottom: 1px solid var(--border);
    }
    .folder{
      display:flex;
      gap:10px;
      align-items:center;
      min-width:0;
      font-weight: 700;
      letter-spacing: -.01em;
    }
    .folder code{
      font-family: var(--mono);
      font-size: 12.5px;
      color: var(--muted);
      border: 1px solid var(--border);
      background: rgba(0,0,0,.10);
      padding: 3px 8px;
      border-radius: 999px;
      max-width: 100%;
      overflow:hidden;
      text-overflow: ellipsis;
      white-space:nowrap;
    }
    @media (prefers-color-scheme: light){
      .folder code{ background: rgba(15,23,42,.04); }
    }
    .count{
      font-size: 12.5px;
      color: var(--muted);
      white-space: nowrap;
      margin-top: 2px;
    }

    .table-wrap{
      width:100%;
      overflow:auto;
    }

    table{
      width:100%;
      border-collapse: separate;
      border-spacing: 0;
      min-width: 760px;
    }
    thead th{
      text-align:left;
      font-size: 12px;
      letter-spacing: .06em;
      text-transform: uppercase;
      color: var(--muted);
      padding: 12px 14px;
      border-bottom: 1px solid var(--border);
      background: rgba(0,0,0,.06);
    }
    @media (prefers-color-scheme: light){
      thead th{ background: rgba(15,23,42,.03); }
    }

    tbody td{
      padding: 12px 14px;
      border-bottom: 1px solid var(--border);
      vertical-align: top;
    }
    tbody tr:hover td{
      background: rgba(255,255,255,.05);
    }
    @media (prefers-color-scheme: light){
      tbody tr:hover td{ background: rgba(15,23,42,.03); }
    }

    .name{
      font-weight: 650;
      letter-spacing: -.01em;
      white-space: nowrap;
    }
    .path{
      font-family: var(--mono);
      font-size: 12px;
      color: var(--muted);
      white-space: nowrap;
      overflow:hidden;
      text-overflow: ellipsis;
      max-width: 44ch;
      display:block;
      margin-top: 4px;
    }
    .desc{
      color: var(--text);
      opacity: .92;
      max-width: 70ch;
      line-height: 1.35;
    }
    .badge{
      display:inline-block;
      font-family: var(--mono);
      font-size: 11px;
      color: var(--muted);
      border: 1px solid var(--border);
      border-radius: 999px;
      padding: 2px 8px;
      background: rgba(0,0,0,.10);
      margin-right: 8px;
    }
    @media (prefers-color-scheme: light){
      .badge{ background: rgba(15,23,42,.04); }
    }

    .open a{
      display:inline-flex;
      align-items:center;
      gap:8px;
      padding: 8px 10px;
      border-radius: 999px;
      border: 1px solid var(--border);
      background: var(--panel);
      white-space: nowrap;
    }
    .open a:hover{ background: var(--panel2); }

    .empty{
      margin-top: 22px;
      padding: 18px;
      border-radius: var(--radius);
      border: 1px dashed var(--border);
      color: var(--muted);
      text-align:center;
      background: rgba(255,255,255,.03);
    }

    footer{
      margin-top: 26px;
      color: var(--muted);
      font-size: 13px;
      display:flex;
      justify-content:space-between;
      flex-wrap:wrap;
      gap:10px;
      border-top: 1px solid var(--border);
      padding-top: 14px;
    }
    footer .disclaimer{
      flex: 1 1 100%;
      font-style: italic;
      opacity: .9;
    }

    .toast{
      position: fixed;
      left: 50%;
      bottom: 18px;
      transform: translateX(-50%);
      padding: 10px 14px;
      border-radius: 999px;
      border: 1px solid var(--border);
      background: var(--panel);
      box-shadow: var(--shadow);
      color: var(--text);
      opacity: 0;
      pointer-events: none;
      transition: opacity .2s ease, transform .2s ease;
      font-size: 13px;
    }
    .toast.show{
      opacity: 1;
      transform: translateX(-50%) translateY(-2px);
    }

    /* ✅ Responsive: turn table into stacked cards on small screens */
    @media (max-width: 820px){
      table{ min-width: 0; }
      thead{ display:none; }
      table, tbody, tr, td{ display:block; width:100%; }
      tbody tr{
        border-bottom: 10px solid transparent;
      }
      tbody td{
        border-bottom: 1px solid var(--border);
        display:flex;
        gap: 12px;
        justify-content: space-between;
        align-items:flex-start;
      }
      tbody td:last-child{ border-bottom:none; }
      tbody td::before{
        content: attr(data-label);
        font-weight: 650;
        color: var(--muted);
        flex: 0 0 120px;
        max-width: 120px;
      }
      .path{ max-width: 100%; }
    }

    /* Header responsiveness */
    @media (max-width: 560px){
      .controls{ width:100%; justify-content:flex-start; }
      .search{ max-width: 100%; }
      .btn{ width:auto; }
    }
  </style>
</head>
<body>
  <div class="wrap">

    <div class="top">
      <div class="hero">
        <div>
          <h1>UCPM Banners Library</h1>
          <div class="sub">
            <span class="pill"><span class="dot"></span><strong>${COUNT}</strong> file(s)</span>
            <span class="pill">Generated: <span class="mono">${GENERATED_AT}</span></span>
          </div>
        </div>

        <div class="controls">
          <div class="search">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" aria-hidden="true">
              <path d="M21 21l-4.3-4.3m1.8-5.2a7 7 0 11-14 0 7 7 0 0114 0z"
                stroke="currentColor" stroke-width="2" stroke-linecap="round"/>
            </svg>
            <input id="q" type="search" placeholder="Filter by folder, filename, path, or description…" autocomplete="off" />
          </div>
          <button class="btn" id="expand">Expand</button>
          <button class="btn" id="collapse">Collapse</button>
        </div>
      </div>
    </div>
HTML

if [[ "$COUNT" -eq 0 ]]; then
  cat >> "$OUTPUT" <<'HTML'
    <div class="empty">No <span class="badge">*.html</span> files found (after exclusions).</div>
HTML
else
  for group in "${ORDERED_GROUPS[@]}"; do
    group_count="$(printf "%s" "${FILE_GROUPS[$group]}" | grep -c $'\t' || true)"

    esc_group="$(html_escape "$group")"

    cat >> "$OUTPUT" <<HTML
    <section class="section" data-folder="${esc_group}">
      <div class="section-head">
        <div class="folder">
          <span class="dot"></span>
          <code title="${esc_group}">${esc_group}</code>
        </div>
        <div class="count">${group_count} item(s)</div>
      </div>

      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Banner</th>
              <th>Description</th>
              <th>Path</th>
              <th>Open</th>
            </tr>
          </thead>
          <tbody>
HTML

    while IFS=$'\t' read -r full base desc; do
      [[ -z "${full:-}" ]] && continue

      esc_full="$(html_escape "$full")"
      esc_base="$(html_escape "$base")"
      esc_desc="$(html_escape "${desc:-—}")"

      cat >> "$OUTPUT" <<HTML
            <tr data-file="${esc_full}" data-desc="${esc_desc}" data-folder="${esc_group}">
              <td data-label="Banner">
                <span class="badge">HTML</span>
                <span class="name">${esc_base}</span>
              </td>
              <td data-label="Description">
                <div class="desc">${esc_desc}</div>
              </td>
              <td data-label="Path">
                <span class="path">${esc_full}</span>
              </td>
              <td class="open" data-label="Open">
                <a href="${esc_full}" title="Open file">Open ↗</a>
              </td>
            </tr>
HTML
    done < <(printf "%s" "${FILE_GROUPS[$group]}")

    cat >> "$OUTPUT" <<'HTML'
          </tbody>
        </table>
      </div>
    </section>
HTML
  done
fi

cat >> "$OUTPUT" <<'HTML'
    <footer>
      <span>Tip: Use search to filter by description, filename, folder, or path.</span>
      <span class="mono">index.html</span>
      <span class="disclaimer">Created by Alvaro Barroso in Madrid, Españita.</span>
    </footer>
  </div>

  <div class="toast" id="toast">Copied</div>

  <script>
    const q = document.getElementById('q');
    const toast = document.getElementById('toast');
    const expand = document.getElementById('expand');
    const collapse = document.getElementById('collapse');

    function normalize(s){ return (s || '').toLowerCase(); }

    function applyFilter(){
      const term = normalize(q.value);
      const rows = Array.from(document.querySelectorAll('tbody tr'));
      const sections = Array.from(document.querySelectorAll('.section'));

      rows.forEach(tr => {
        const file = normalize(tr.getAttribute('data-file'));
        const desc = normalize(tr.getAttribute('data-desc'));
        const folder = normalize(tr.getAttribute('data-folder'));
        const visible = !term || file.includes(term) || desc.includes(term) || folder.includes(term);
        tr.style.display = visible ? '' : 'none';
      });

      // Hide whole sections if none of their rows are visible
      sections.forEach(sec => {
        const visibleRows = Array.from(sec.querySelectorAll('tbody tr'))
          .some(tr => tr.style.display !== 'none');
        sec.style.display = visibleRows ? '' : 'none';
      });
    }

    q?.addEventListener('input', applyFilter);
    applyFilter();

    // Expand/Collapse: show/hide tables within sections
    expand?.addEventListener('click', () => {
      document.querySelectorAll('.table-wrap').forEach(w => w.style.display = '');
    });
    collapse?.addEventListener('click', () => {
      document.querySelectorAll('.table-wrap').forEach(w => w.style.display = 'none');
    });

    // Ctrl/Cmd-click Open button copies the href instead of navigating
    document.addEventListener('click', async (e) => {
      const a = e.target.closest('a[href]');
      if(!a) return;

      const isCopy = e.metaKey || e.ctrlKey;
      if(!isCopy) return;

      e.preventDefault();
      const href = a.getAttribute('href');
      try{
        await navigator.clipboard.writeText(href);
        toast.textContent = "Copied: " + href;
        toast.classList.add('show');
        setTimeout(() => toast.classList.remove('show'), 1200);
      }catch(err){
        // ignore
      }
    });
  </script>
</body>
</html>
HTML
