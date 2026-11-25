<div align="center">

# 🎨 Universal UI Themes
### Public UI Template of PT · Zero-Dependency Design Tokens, 34 Themes & 11 Palettes in Pure Vanilla CSS

[![GitHub Pages](https://img.shields.io/badge/Live_Showcase-GitHub_Pages-8A2BE2?style=for-the-badge&logo=github)](https://north-abyss.github.io/ui-themes/)
[![Presets](https://img.shields.io/badge/Themes-34_Active_Presets-blue?style=for-the-badge)](https://north-abyss.github.io/ui-themes/)
[![Palettes](https://img.shields.io/badge/Palettes-11_Curated_Swaps-teal?style=for-the-badge)](docs/THEMES_AND_PALETTES.md)
[![Zero Dependencies](https://img.shields.io/badge/Dependencies-0_(Vanilla_CSS)-green?style=for-the-badge)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Author](https://img.shields.io/badge/Maintainer-@North--Abyss-purple?style=for-the-badge&logo=github)](https://github.com/North-Abyss)

<p align="center">
  <b>Public UI Template of PT — a single CSS file giving any web app 34 production-ready themes &amp; 11 swappable palettes.</b><br>
  No Tailwind. No PostCSS. No npm dependencies. Pure standard CSS custom properties.<br>
  <i>Full Morphisms UI Suite (Skeuomorphism, Neumorphism, Glassmorphism 2.0, Claymorphism 3D, Neo-Brutalism, Spatial visionOS) + 8 Developer Syntax Themes with Light/Dark pairing &amp; Auto System mode.</i>
</p>

[**🚀 Live Showcase & UI Modular Studio**](https://north-abyss.github.io/ui-themes/) · [**🎨 Full Palette Reference**](docs/THEMES_AND_PALETTES.md) · [**🌐 Portfolio**](https://north-abyss.github.io/Portfolio)

</div>

---

## ✨ Key Features

- **34 Production-Ready Theme Presets:** Complete Morphisms Suite (*Material 3, Minimal 2D Mono, Glassmorphism 2.0, Claymorphism 3D, Neo-Brutalism, Neumorphism, Skeuomorphism, Spatial visionOS 2.0, Vaporwave, E-Ink, Swiss Modernism, Papercraft, Frutiger Aero, Retro 90s, Aurora Mesh, OLED Black, Phosphor CRT*) + 8 Developer Syntax schemes (*Nord Frost, GitHub Dark, VS Code Dark+, Tokyo Night, Catppuccin Mocha, Dracula, One Dark Pro, Solarized Dark*).
- **11 Famous Website & Retro Palettes:** Instantly swap color palettes from **Linear, Stripe, Vercel, Supabase, Notion, Raycast, ChatGPT, Figma, Spotify, Discord, and Resurrect-64** on top of any morphism without altering its shadow depth or geometry.
- **Left Theme Explorer (`⌘B` / `⌘K`):** Live theme & tag search, Light/Dark mode filters, archetype dropdown, **Surprise Me** randomizer, **High-Contrast Mode**, **Compact Density**, **Copy CSS Variables**, and **Export Tokens JSON**.
- **Interactive UI Modular Studio:** Live color pickers, geometry & spacing sliders, live HTML/CSS component editor, click-to-inspect mode, and 1-click export of custom standalone CSS or HTML.
- **Built-in Family Pairing & Auto Mode:** Seamlessly toggles Light ↔ Dark while preserving aesthetic families (e.g. `claymorphism` ↔ `clay-dark`, `neumorphism` ↔ `neu-dark`, `skeuomorphism` ↔ `skeuo-dark`) and syncs with `prefers-color-scheme`.
- **Zero Runtime & Universal Portability:** Works in Vanilla HTML, React, Vue, Svelte, Solid, Astro, Angular, and Next.js.

---

## ⚡ Easy Access & Quick Start

### Option 1 — 1-Line CDN (Fastest)
Add the stylesheet to your `<head>` and set `data-theme` on `<html>`:

```html
<!-- Production minified bundle via jsDelivr CDN -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/North-Abyss/ui-themes@main/dist/universal-themes.min.css">

<!-- Or unminified -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/North-Abyss/ui-themes@main/dist/universal-themes.css">

<!-- Activate any of the 34 themes -->
<html data-theme="tokyo-night">
```

### Option 2 — Use as a GitHub Template or Clone
Click **"Use this template"** on GitHub or clone directly:

```bash
git clone https://github.com/North-Abyss/ui-themes.git
```

Import `dist/universal-themes.min.css` or modular presets from `src/index.css`:

```css
/* Modular CSS import */
@import "./src/index.css";
```

### Option 3 — Sync Into Another Project (`sync-ui-themes.sh`)
Install or update `universal-themes.css` inside any external project with one command:

```bash
curl -fsSL https://raw.githubusercontent.com/North-Abyss/ui-themes/main/sync-ui-themes.sh | bash
# Or specify destination directory:
./sync-ui-themes.sh --dest src/themes
```

---

## 🎨 Complete Theme Catalog & Palette Colors (34 Presets)

> See [docs/THEMES_AND_PALETTES.md](docs/THEMES_AND_PALETTES.md) for alias keys, muted text tokens, and Tier 1 primitive color scales.

### Part 1 — Light Morphisms, Retro & Editorial (12 Presets)

| # | Theme Key | Name | Visual Philosophy | Background | Surface | Primary | Accent | Text |
|---|---|---|---|---|---|---|---|---|
| **01** | `material3` | **Google Material 3** | Dynamic Material You tonal containers & pill actions | `#fdf8fd` | `#fffbfe` | `#294ede` | `#715573` | `#1b1b1f` |
| **02** | `minimal-mono` | **Minimal 2D Mono (Light)** | Stark black & white line art, 1px borders, dot matrix | `#FFFFFF` | `#FFFFFF` | `#000000` | `#000000` | `#000000` |
| **03** | `glass-light` | **Glassmorphism (Light)** | Frosted translucent glass over indigo/rose gradients | `#E0E7FF` | `rgba(255,255,255,0.45)` | `#4F46E5` | `#DB2777` | `#1E293B` |
| **04** | `claymorphism` | **Claymorphism 3D** | Squishy matte 3D clay with dual inset highlights | `#F4F0FD` | `#E8DFF5` | `#8B5CF6` | `#10B981` | `#4C1D95` |
| **05** | `neobrutalism` | **Neo-Brutalism Pop** | Thick black borders, 4px hard drop shadow, pop yellow | `#FFFDF8` | `#FFFFFF` | `#FFE600` | `#D6B4FC` | `#000000` |
| **06** | `neumorphism` | **Neumorphism Soft UI** | Monochromatic extruded plastic with opposing dual shadows | `#E0E5EC` | `#E0E5EC` | `#3B82F6` | `#8B5CF6` | `#3D4451` |
| **09** | `retro-90s` | **Retro 90s OS (Win95)** | Classic battleship gray chrome & 3D beveled buttons | `#008080` | `#C0C0C0` | `#000080` | `#000080` | `#000000` |
| **12** | `frutiger-aero` | **Frutiger Aero (Y2K Liquid)** | Glossy sky gradient, specular highlights, aqua glass | `#E0F2FE` | `rgba(255,255,255,0.75)` | `#0284C7` | `#10B981` | `#0C4A6E` |
| **15** | `papercraft` | **Papercraft & Origami** | Handmade fibrous parchment, layered shadows, terracotta | `#F5F2EB` | `#FFFFFF` | `#C25E3E` | `#2C5E55` | `#2B2620` |
| **23** | `skeuomorphism` | **Skeuomorphism Light** | Tactile Dieter Rams / Braun industrial controls & bevels | `#EAECEF` | `#F5F6F8` | `#FF9500` | `#2563EB` | `#1C1D1F` |
| **25** | `e-ink` | **E-Ink / Paper** | Distraction-free matte warm paper & crisp ink contrast | `#FDFBF7` | `#FFFFFF` | `#1A1A1A` | `#E27D60` | `#1A1A1A` |
| **26** | `swiss-style` | **Swiss Modernism 2.0** | High-contrast typographic grid & bold vermilion focal | `#FFFFFF` | `#FFFFFF` | `#FF3B30` | `#007AFF` | `#000000` |

### Part 2 — Modern Dark, Spatial & Cyber Morphisms (14 Presets)

| # | Theme Key | Name | Visual Philosophy | Background | Surface | Primary | Accent | Text |
|---|---|---|---|---|---|---|---|---|
| **01b** | `material3-dark` | **Google Material 3 (Dark)** | Dark neutral tonal elevation & accessible contrast | `#121316` | `#1b1b1f` | `#bac3ff` | `#dfbbde` | `#e4e2e6` |
| **02b** | `minimal-dark` | **Minimal 2D Mono (Dark)** | High-contrast white line art over obsidian charcoal | `#0A0A0A` | `#111111` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| **03b** | `glassmorphism` | **Glassmorphism 2.0 (Dark)** | Frosted dark glass panels, blur & ambient glows | `#0b0f19` | `rgba(255,255,255,0.06)` | `#38BDF8` | `#F472B6` | `#F9FAFB` |
| **04b** | `clay-dark` | **Claymorphism Dark** | Deep inflatable plum & slate clay with 3D inner depth | `#13141F` | `#1A1B26` | `#A78BFA` | `#34D399` | `#F1F5F9` |
| **05b** | `neobrutalism-dark` | **Neo-Brutalism Dark** | Obsidian canvas, white outlines & electric pop yellow | `#0D0D0D` | `#171717` | `#FFE600` | `#FF007F` | `#FFFFFF` |
| **06b** | `neu-dark` | **Neumorphism Dark** | Extruded dark charcoal with void & light dual shadows | `#1E2024` | `#1E2024` | `#38BDF8` | `#A855F7` | `#E2E8F0` |
| **07** | `cyberpunk` | **Cyberpunk Neon HUD** | Neon magenta/cyan HUD edges & synthwave glow | `#090014` | `#13032b` | `#FF007F` | `#FFE600` | `#00F0FF` |
| **08** | `bento-modern` | **Bento Modern Dark** | Linear/Vercel precision dark mode & bento grid cards | `#080808` | `#121212` | `#5E6AD2` | `#E5E5E5` | `#EDEDED` |
| **10** | `oled-black` | **OLED Pure Black** | True `#000000` pitch-black canvas with zero light bleed | `#000000` | `#000000` | `#FFFFFF` | `#30D158` | `#FFFFFF` |
| **11** | `aurora-glow` | **Aurora Mesh Glow** | Spatial ambient violet & cyan mesh lighting | `#090714` | `rgba(19,14,36,0.65)` | `#A855F7` | `#38BDF8` | `#F8FAFC` |
| **13** | `phosphor-terminal` | **Phosphor CRT Terminal** | Vintage P1 green phosphor bloom over dark CRT glass | `#070B07` | `rgba(12,20,12,0.90)` | `#00FF66` | `#33FF88` | `#00FF66` |
| **23b** | `skeuo-dark` | **Skeuomorphism Dark** | Matte charcoal calculator keys & warm amber LCD | `#141517` | `#212327` | `#FF8C00` | `#38BDF8` | `#F1F3F5` |
| **24** | `visionos` | **Spatial UI (visionOS 2.0)** | Translucent specular depth glass & spatial lighting | `#090B10` | `rgba(255,255,255,0.08)` | `#007AFF` | `#FF9F0A` | `#FFFFFF` |
| **27** | `vaporwave` | **Vaporwave Synthwave** | Retro-futuristic magenta & mint neon horizon glow | `#140C26` | `#221640` | `#FF71CE` | `#05FFA1` | `#FFFFFF` |

### Part 3 — Developer & Syntax Themes (8 Presets)

| # | Theme Key | Name | Visual Philosophy | Background | Surface | Primary | Accent | Text |
|---|---|---|---|---|---|---|---|---|
| **14** | `nord-frost` | **Nord Arctic Frost** | Polar Night slate & glacial ice blue accents | `#2E3440` | `#3B4252` | `#88C0D0` | `#8FBCBB` | `#ECEFF4` |
| **16** | `github-dark` | **GitHub Primer Dark** | Canonical GitHub dark canvas & Primer green | `#0D1117` | `#161B22` | `#238636` | `#58A6FF` | `#F0F6FC` |
| **17** | `vscode-dark` | **VS Code Modern Dark+** | Visual Studio Code editor chrome & status blue | `#1E1E1E` | `#252526` | `#007ACC` | `#4EC9B0` | `#D4D4D4` |
| **18** | `tokyo-night` | **Tokyo Night (Folke)** | Iconic Neovim deep indigo canvas & neon blue | `#1A1B26` | `#24283B` | `#7AA2F7` | `#BB9AF7` | `#C0CAF5` |
| **19** | `catppuccin-mocha` | **Catppuccin Mocha** | Soothing pastel dark mocha with vibrant mauve | `#1E1E2E` | `#181825` | `#CBA6F7` | `#89B4FA` | `#CDD6F4` |
| **20** | `dracula` | **Dracula Official** | Gothic dark theme with electric purple & pink | `#282A36` | `#282A36` | `#BD93F9` | `#FF79C6` | `#F8F8F2` |
| **21** | `one-dark` | **One Dark Pro (Atom)** | Classic Atom & JetBrains dark slate palette | `#282C34` | `#2C313A` | `#61AFEF` | `#98C379` | `#ABB2BF` |
| **22** | `solarized-dark` | **Solarized Dark** | Precision LAB contrast cyan/teal over deep teal | `#002B36` | `#073642` | `#268BD2` | `#2AA198` | `#839496` |

---

## 🖌️ Famous Website & Retro Palettes (11 Swaps)

Apply any of these palettes in the Live Showcase (header **Palettes** menu or **Left Theme Explorer**) to re-skin the colors of any active morphism:

| Palette Key | Name | Primary | Background | Surface | Surface Container | Accent | Text |
|---|---|---|---|---|---|---|---|
| `linear` | **Linear** | `#5E6AD2` | `#0D0E11` | `#16181D` | `#1F2228` | `#6875F5` | `#F7F8F8` |
| `stripe` | **Stripe** | `#635BFF` | `#F8F9FA` | `#FFFFFF` | `#F4F6F8` | `#00D4AA` | `#0A2540` |
| `vercel` | **Vercel** | `#0070F3` | `#000000` | `#111111` | `#1A1A1A` | `#50E3C2` | `#EDEDED` |
| `supabase` | **Supabase** | `#3ECF8E` | `#1C1C1C` | `#242424` | `#2A2A2A` | `#24B47E` | `#EDEDED` |
| `notion` | **Notion** | `#2EAADC` | `#FFFFFF` | `#FFFFFF` | `#F1F1EF` | `#EB5757` | `#37352F` |
| `raycast` | **Raycast** | `#FF6363` | `#0C0C0D` | `#161618` | `#212124` | `#FF8F8F` | `#FFFFFF` |
| `openai` | **ChatGPT** | `#10A37F` | `#202123` | `#2A2B32` | `#343541` | `#19C37D` | `#ECECF1` |
| `figma` | **Figma** | `#0ACF83` | `#1E1E1E` | `#2C2C2C` | `#383838` | `#F24E1E` | `#FFFFFF` |
| `spotify` | **Spotify** | `#1DB954` | `#121212` | `#1F1F1F` | `#282828` | `#1ED760` | `#FFFFFF` |
| `discord` | **Discord** | `#5865F2` | `#1E1F22` | `#2B2D31` | `#313338` | `#57F287` | `#DBDEE1` |
| `resurrect-64` | **Resurrect-64** | `#EA4F36` | `#2E222F` | `#3E3546` | `#625565` | `#0EAF9B` | `#FFFFFF` |

---

## 🎛️ Dynamic Switching in JavaScript

```javascript
function setTheme(themeName) {
  document.documentElement.setAttribute('data-theme', themeName);
  localStorage.setItem('user-theme', themeName);
}

// Load saved user theme on startup
const savedTheme = localStorage.getItem('user-theme') || 'tokyo-night';
setTheme(savedTheme);
```

---

## 🛠️ Building & Deploying

To recompile `dist/universal-themes.css` and `dist/universal-themes.min.css` from `src/`:

```bash
chmod +x build.sh
./build.sh
```

To commit and deploy the live showcase to GitHub Pages:

```bash
./git-sync.sh --sync -m "chore: update themes" --deploy-gh-pages
```

---

## 👤 Maintainer & Links

- **Public UI Template of PT**
- **GitHub:** [@North-Abyss](https://github.com/North-Abyss)
- **Portfolio:** [https://north-abyss.github.io/Portfolio](https://north-abyss.github.io/Portfolio)
- **Live UI Showcase:** [https://north-abyss.github.io/ui-themes/](https://north-abyss.github.io/ui-themes/)

---

## 📄 License

This project is licensed under the **MIT License** — see [LICENSE](LICENSE) for details.
