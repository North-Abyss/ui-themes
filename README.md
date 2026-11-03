<div align="center">

# 🎨 Universal UI Themes
### Zero-Dependency Design Tokens & 26+ Production Theme Presets in Pure Vanilla CSS

[![GitHub Pages](https://img.shields.io/badge/Live_Demo-GitHub_Pages-8A2BE2?style=for-the-badge&logo=github)](https://north-abyss.github.io/ui-themes/)
[![Presets](https://img.shields.io/badge/Themes-26+_Presets_(Expanding)-blue?style=for-the-badge)](https://north-abyss.github.io/ui-themes/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-0_(Vanilla_CSS)-green?style=for-the-badge)](#)
[![Author](https://img.shields.io/badge/Author-Yuvanesh_KS_(@North--Abyss)-purple?style=for-the-badge&logo=github)](https://github.com/North-Abyss)

<p align="center">
  <b>A single CSS file that gives your web apps 26+ state-of-the-art visual styles.</b><br>
  No Tailwind. No PostCSS. No npm dependencies. Pure standard CSS custom properties.<br>
  <i>Complete Morphisms UI Suite (Skeuomorphism, Neumorphism, Glassmorphism, Claymorphism, Neo-Brutalism) with paired Light & Dark variants + built-in Auto System mode.</i>
</p>

[**🚀 Live Interactive Showcase & Kitchen Sink**](https://north-abyss.github.io/ui-themes/)

</div>

---

## ✨ Features

- **26+ Production-Ready Presets:** Complete Morphisms Suite (*Skeuomorphism, Neumorphism, Glassmorphism 2.0, Claymorphism 3D, Neo-Brutalism, Minimal 2D Mono*) + famous developer color schemes (*GitHub Primer, VS Code, Tokyo Night, Catppuccin, Dracula, One Dark, Solarized*).
- **Built-in Dynamic Family Pairing & Auto Mode:** Seamlessly switch between Light and Dark mode while preserving your active aesthetic family (e.g. `claymorphism` $\leftrightarrow$ `clay-dark`, `neumorphism` $\leftrightarrow$ `neu-dark`, `skeuomorphism` $\leftrightarrow$ `skeuo-dark`). System mode automatically syncs with OS `prefers-color-scheme` in real-time.
- **Component-Level Tactile Fidelity:** Tactile beveled calculator buttons, extruded soft toggle switches, 3D squishy inflatable clay forms, and visionOS frosted glass panels matching modern UI design standards.
- **Interactive UI Modular Studio:** Real-time token customizer (colors, radii, padding, glow), live HTML & CSS component editor with on-page element inspection, and one-click export to standalone custom CSS bundles or HTML showcases.
- **Zero Runtime & Zero Dependencies:** 100% compliant Vanilla CSS custom properties.
- **1-Line Dynamic Switching:** Switch the entire look and feel of your application instantly by changing one attribute:
  ```html
  <html data-theme="tokyo-night">
  ```
- **Universal Framework Portability:** Works in Vanilla HTML, React, Vue, Svelte, Solid, Astro, Next.js, and maps 1:1 to Flutter and mobile design tokens.
- **3-Tier Token Architecture:**
  1. *Primitives:* 0–100 raw tonal palettes, 4px grid spacing, radii, cubic-bezier easings.
  2. *Semantic Themes:* Functional UI tokens (`--theme-primary`, `--theme-surface`, `--theme-border`).
  3. *Components:* Buttons, inputs, switches, bento cards, and telemetry charts.
- **Google Material Symbols & Icons:** Pre-integrated with accessible semantic attributes.

---

## ⚡ 1-Line Quick Start (CDN)

Drop the Universal Themes stylesheet into your `<head>` tag:

```html
<!-- Production minified bundle via jsDelivr CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/North-Abyss/ui-themes@main/dist/universal-themes.min.css">

<!-- Or unminified -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/North-Abyss/ui-themes@main/dist/universal-themes.css">
```

Then choose your active theme on `<html>`:

```html
<html data-theme="github-dark">
```

---

## 📦 Local Installation

Clone or copy the files directly into your project:

```bash
git clone https://github.com/North-Abyss/ui-themes.git
```

Import `dist/universal-themes.min.css` or the modular source files:

```html
<link rel="stylesheet" href="path/to/dist/universal-themes.min.css">
```

---

## 🎨 Complete Theme Catalog (26+ Presets)

### Part 1: Design System Morphisms & Modern Aesthetics

| # | Theme Key | Name | Visual Philosophy | Primary Color |
|---|---|---|---|---|
| **01** | `material3` | **Google Material 3** | Official Material You tonal surface containers and pill buttons. | `#00639B` |
| **01b**| `material3-dark` | **Google Material 3 (Dark)** | Dark neutral tonal elevation with accessible contrast. | `#93CCFF` |
| **02** | `minimal-mono` | **Minimal 2D Mono (Light)** | Stark black and white line art, 1px outlines, 16px dot matrix. | `#000000` |
| **02b**| `minimal-dark` | **Minimal 2D Mono (Dark)** | High-contrast white line art over an obsidian charcoal canvas. | `#FFFFFF` |
| **03** | `glassmorphism` | **Glassmorphism 2.0 (Dark)** | Frosted translucent panels, `backdrop-filter: blur`, ambient glows. | `#38BDF8` |
| **03b**| `glass-light` | **Glassmorphism (Light)** | Floating glass panels over soft rose/indigo ambient gradients. | `#6366F1` |
| **04** | `claymorphism` | **3D Puffy Claymorphism** | Inflatable squishy matte clay with tactile dual inset highlights. | `#7C4DFF` |
| **04b**| `clay-dark` | **Claymorphism Dark** | Deep inflatable plum & slate clay with triple-shadow volume depth. | `#A78BFA` |
| **05** | `neobrutalism` | **Neo-Brutalism & Retrobento** | 2.5px solid black borders, 4px hard drop shadow, pop yellow. | `#FFE600` |
| **05b**| `neobrutalism-dark`| **Neo-Brutalism Dark** | Obsidian canvas, 2.5px white outlines, electric pop yellow offset shadows. | `#FFE600` |
| **06** | `neumorphism` | **Neumorphism / Soft UI** | Seamless monochromatic extruded plastic with opposing dual shadows. | `#E0E5EC` |
| **06b**| `neu-dark` | **Neumorphism Dark** | Monochromatic extruded dark plane with deep void and light opposing shadows. | `#38BDF8` |
| **23** | `skeuomorphism` | **Skeuomorphism Light** | Dieter Rams & Braun brushed aluminum, tactile cream buttons, orange accent. | `#FF9500` |
| **23b**| `skeuo-dark` | **Skeuomorphism Dark** | Tactile matte charcoal calculator body, beveled keys, glowing amber LCD display. | `#FF8C00` |
| **07** | `cyberpunk` | **Cyberpunk / Synthwave** | Neon cyan/magenta glow borders, angled HUD polygons, CRT scanlines. | `#00F0FF` |
| **08** | `bento-modern` | **Bento Modern Dark** | Linear & Vercel style dark mode, modular bento card grids. | `#5E6AD2` |
| **09** | `retro-90s` | **Retro 90s OS** | Classic Windows 95 battleship gray with 3D beveled chrome buttons. | `#000080` |
| **10** | `oled-black` | **OLED Pure Black** | True `#000000` pitch black background, zero light bleed. | `#FFFFFF` |
| **11** | `aurora-glow` | **Aurora Mesh Glow (Spatial)** | iOS 18 Siri / Apple Intelligence, radiant violet/cyan ambient mesh. | `#A855F7` |
| **12** | `frutiger-aero` | **Frutiger Aero (Y2K Liquid)** | Glossy sky blue gradient, specular top highlight glares, aqua glass. | `#0284C7` |
| **13** | `phosphor-terminal`| **Phosphor CRT Terminal** | Cathode ray tube dark canvas, vintage P1 green phosphor bloom. | `#00FF66` |
| **14** | `nord-frost` | **Nord Arctic Frost** | Polar Night slate, glacial ice blue, frozen mint accents. | `#88C0D0` |
| **15** | `papercraft` | **Papercraft & Origami** | Handmade fibrous parchment canvas, layered paper shadows, terracotta. | `#C25E3E` |

---

### Part 2: Famous Developer & Platform Themes

| # | Theme Key | Name | Visual Philosophy | Primary Color |
|---|---|---|---|---|
| **16** | `github-dark` | **GitHub Primer Dark** | Canonical GitHub dark theme (`#0D1117`), Primer green `#238636`. | `#238636` |
| **17** | `vscode-dark` | **VS Code Modern Dark+** | Microsoft Visual Studio Code IDE theme (`#1E1E1E`), blue `#007ACC`. | `#007ACC` |
| **18** | `tokyo-night` | **Tokyo Night (Folke)** | Iconic Neovim/terminal theme (`#1A1B26`), Tokyo blue `#7AA2F7`. | `#7AA2F7` |
| **19** | `catppuccin-mocha`| **Catppuccin Mocha** | Global community favorite pastel dark theme, Mauve `#CBA6F7`. | `#CBA6F7` |
| **20** | `dracula` | **Dracula Official** | Zeno Rocha's gothic dark theme (`#282A36`), vibrant purple `#BD93F9`. | `#BD93F9` |
| **21** | `one-dark` | **One Dark Pro** | Classic Atom & JetBrains dark palette (`#282C34`), blue `#61AFEF`. | `#61AFEF` |
| **22** | `solarized-dark` | **Solarized Dark** | Ethan Schoonover's precision LAB color space theme (`#002B36`). | `#268BD2` |

---

### Part 3: 🚀 Upcoming Themes Pipeline (+ More Being Added)

We have **22 production themes active now**, and are continuously expanding our token engine with canonical additions:

| Status | Theme Key | Name | Visual Philosophy | Primary Color |
|---|---|---|---|---|
| ⏳ *In Pipeline* | `synthwave-84` | **Synthwave '84** | Robb Owen's neon glow retro-futuristic purple HUD & electric cyan. | `#FF7EDB` |
| ⏳ *In Pipeline* | `monokai-pro` | **Monokai Pro** | Wimer Hazenberg's Filter Octagon spectrum & matte dark ergonomics. | `#FFD866` |
| ⏳ *In Pipeline* | `gruvbox-dark` | **Gruvbox Dark** | Retro groove warm autumnal brown, forest green, and amber gold. | `#FABD2F` |
| ⏳ *In Pipeline* | `gruvbox-light`| **Gruvbox Light** | Retro groove warm parchment background and rich book ink contrast. | `#B57614` |
| ⏳ *In Pipeline* | `rose-pine` | **Rosé Pine** | All natural pine needles, soft muted rose, gold, and foam accents. | `#EB6F92` |
| ⏳ *In Pipeline* | `shades-purple`| **Shades of Purple** | Ahmad Awais's high-voltage purple canvas with electric neon yellow. | `#FAD000` |
| ⏳ *In Pipeline* | `ayu-mirage` | **Ayu Mirage** | Warm slate modern developer theme with golden sunset orange. | `#FFCC66` |
| ⏳ *In Pipeline* | `kanagawa` | **Kanagawa** | Hokusai woodblock print palette: sumi ink, wave blue, autumn leaf red. | `#7E9CD8` |
| ⏳ *In Pipeline* | `github-light` | **GitHub Primer Light** | Canonical GitHub white desktop canvas with crisp slate borders. | `#0969DA` |
| ⏳ *In Pipeline* | `solarized-light`|**Solarized Light** | Ethan Schoonover's precision daylight LAB color space theme. | `#268BD2` |
| ⏳ *In Pipeline* | `cyberpunk-2077`|**Night City Yellow** | High-energy yellow hazard UI, glitch cyan, and dark alloy panels. | `#FCEE0A` |

> 💡 **Want to request or contribute a theme?** Submit an issue or PR to [`North-Abyss/ui-themes`](https://github.com/North-Abyss/ui-themes). Any new preset automatically works with all components and the UI Modular Studio!

---

## 🎛️ Dynamic Switching in JavaScript

To switch themes dynamically at runtime (via select menu, toggle, or settings):

```javascript
function setTheme(themeName) {
  document.documentElement.setAttribute('data-theme', themeName);
  localStorage.setItem('user-theme', themeName);
}

// Load saved user theme on page startup
const savedTheme = localStorage.getItem('user-theme') || 'github-dark';
setTheme(savedTheme);
```

---

## 🛠️ Building Distribution Bundles

To recompile `dist/universal-themes.css` and `dist/universal-themes.min.css`:

```bash
chmod +x build.sh
./build.sh
```

---

## 🔄 Keeping Other Projects Updated (`sync-ui-themes.sh`)

Any external project can install or stay updated with the latest Universal UI Themes CSS bundles (22 presets + tokens) using the one-line updater:

```bash
# In your downstream repo:
curl -fsSL https://raw.githubusercontent.com/North-Abyss/ui-themes/main/sync-ui-themes.sh | bash
```

Or run locally if this template is on your machine:
```bash
./sync-ui-themes.sh --dest src/themes
```

---

## 🚀 GitHub Pages & Deployment

To publish this showcase to GitHub Pages with zero overhead:
```bash
# Commit and deploy in one unified command:
./git-sync.sh --deploy-gh-pages
```
Or directly:
```bash
./scripts/deployment/deploy_gh_pages.sh
```

---

## 👤 Author

**Yuvanesh KS**
- GitHub: [@North-Abyss](https://github.com/North-Abyss)
- Project: [ui-themes](https://github.com/North-Abyss/ui-themes)

---

## 📄 License

This project is licensed under the **MIT License** — feel free to use it in personal, open-source, or commercial applications with zero restrictions.
