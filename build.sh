#!/usr/bin/env bash
# ==============================================================================
# UI Themes Distribution Bundler (build.sh)
# Author: Yuvanesh KS (@North-Abyss)
# License: MIT
# Compiles src/ tokens and presets into production CSS bundles in dist/
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🎨 Bundling Universal UI Themes (North-Abyss/ui-themes)..."
mkdir -p dist

cat src/tokens/primitives.css \
    src/presets/01_material3.css \
    src/presets/02_minimal_mono.css \
    src/presets/03_glassmorphism.css \
    src/presets/04_claymorphism.css \
    src/presets/05_neobrutalism.css \
    src/presets/06_neumorphism.css \
    src/presets/07_cyberpunk.css \
    src/presets/08_bento_modern.css \
    src/presets/09_retro_90s.css \
    src/presets/10_oled_pure_black.css \
    src/presets/11_aurora_glow.css \
    src/presets/12_frutiger_aero.css \
    src/presets/13_phosphor_terminal.css \
    src/presets/14_nord_frost.css \
    src/presets/15_papercraft.css \
    src/presets/16_github_dark.css \
    src/presets/17_vscode_modern.css \
    src/presets/18_tokyo_night.css \
    src/presets/19_catppuccin_mocha.css \
    src/presets/20_dracula.css \
    src/presets/21_one_dark_pro.css \
    src/presets/22_solarized_dark.css > dist/universal-themes.css

python3 -c "
import re
with open('dist/universal-themes.css', 'r', encoding='utf-8') as f:
    css = f.read()

css = re.sub(r'/\*[\s\S]*?\*/', '', css)
css = re.sub(r'\s+', ' ', css)
css = re.sub(r'\s*([\{\}:;,])\s*', r'\1', css)
css = re.sub(r';\}', '}', css)

with open('dist/universal-themes.min.css', 'w', encoding='utf-8') as f:
    f.write(css.strip())
"

chmod +x build.sh 2>/dev/null || true
echo "✅ Generated dist/universal-themes.css ($(wc -c < dist/universal-themes.css) bytes)"
echo "✅ Generated dist/universal-themes.min.css ($(wc -c < dist/universal-themes.min.css) bytes)"
echo "✨ Distribution build complete!"
