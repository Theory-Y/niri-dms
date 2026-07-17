#!/usr/bin/env bash
# Snapshot DankMaterialShell (DMS) into a MINIMAL overlay: only settings that
# differ from the installed DMS defaults. Defaults are read live from the
# installed SPEC, so this stays correct across DMS version bumps.
#
# Run after tweaking DMS in the GUI to capture your changes into git.
# Requires: node, a DankMaterialShell install.
set -euo pipefail

SPEC=/usr/share/quickshell/dms/Common/settings/SettingsSpec.js
LIVE="${XDG_CONFIG_HOME:-$HOME/.config}/DankMaterialShell/settings.json"
OUT="$(cd "$(dirname "$0")" && pwd)/settings.json"

[ -f "$SPEC" ] || { echo "DMS SPEC not found at $SPEC - is DankMaterialShell installed?" >&2; exit 1; }
[ -f "$LIVE" ] || { echo "live DMS settings not found at $LIVE" >&2; exit 1; }
command -v node >/dev/null || { echo "node required" >&2; exit 1; }

node - "$SPEC" "$LIVE" "$OUT" <<'NODE'
const fs = require('fs');
const [specPath, livePath, outPath] = process.argv.slice(2);

// SettingsSpec.js is QML-JS: strip .pragma/.import, then eval to grab SPEC.
const src = fs.readFileSync(specPath, 'utf8')
  .split('\n').filter(l => !/^\s*\.(pragma|import)/.test(l)).join('\n');
const SPEC = new Function(src + '\nreturn typeof SPEC!=="undefined"?SPEC:{};')();

const defs = {};
for (const k in SPEC)
  if (Object.prototype.hasOwnProperty.call(SPEC[k], 'def')) defs[k] = SPEC[k].def;

const live = JSON.parse(fs.readFileSync(livePath, 'utf8'));
const DROP = new Set([
  'wifiNetworkPins',          // privacy: home SSIDs
  // inert: feature disabled, value never read (remove from here if you enable the feature)
  'desktopClockCustomColor',  // desktopClockEnabled=false
  'systemMonitorCustomColor', // systemMonitorEnabled=false
  'customAnimationDuration',  // animationSpeed != custom
]);

const overlay = {};
for (const k of Object.keys(live).sort()) {
  if (DROP.has(k)) continue;
  if (k === 'configVersion') { overlay[k] = live[k]; continue; } // keep for migration
  if (!(k in defs) || JSON.stringify(defs[k]) !== JSON.stringify(live[k]))
    overlay[k] = live[k];
}

fs.writeFileSync(outPath, JSON.stringify(overlay, null, 2) + '\n');
console.error(`overlay: ${Object.keys(overlay).length} non-default keys -> ${outPath}`);
NODE
