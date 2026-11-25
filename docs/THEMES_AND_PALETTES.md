# Themes & Color Palettes Reference

> **Project:** Universal UI Themes — **Public UI Template of PT**  
> **Live Showcase & UI Studio:** [https://north-abyss.github.io/ui-themes/](https://north-abyss.github.io/ui-themes/)  
> **Maintainer:** [@North-Abyss](https://github.com/North-Abyss) · [Portfolio](https://north-abyss.github.io/Portfolio)

This reference documents every active CSS theme preset (`data-theme="..."`), all 1-click famous web & retro color palettes, and the core Tier 1 primitive tokens included in `dist/universal-themes.min.css` and `src/`.

---

## 1. Complete Theme Catalog (34 Active Presets)

Activate any theme in HTML with `<html data-theme="<theme-key>">` or dynamically in JavaScript via `document.documentElement.setAttribute('data-theme', '<theme-key>')`.

### Part A — Light Morphisms, Retro & Editorial (12 Presets)

| # | Theme Key (Aliases) | Name | Background | Surface | Primary | Accent / Secondary | Text |
|---|---|---|---|---|---|---|---|
| **01** | `material3` (`material3-light`) | **Google Material 3** | `#fdf8fd` | `#fffbfe` | `#294ede` | `#715573` | `#1b1b1f` |
| **02** | `minimal-mono` (`minimal-light`) | **Minimal 2D Mono (Light)** | `#FFFFFF` | `#FFFFFF` | `#000000` | `#000000` | `#000000` |
| **03** | `glass-light` | **Glassmorphism (Light)** | `#E0E7FF` | `rgba(255, 255, 255, 0.45)` | `#4F46E5` | `#DB2777` | `#1E293B` |
| **04** | `claymorphism` (`clay-light`) | **Claymorphism 3D** | `#F4F0FD` | `#E8DFF5` | `#8B5CF6` | `#10B981` | `#4C1D95` |
| **05** | `neobrutalism` (`neo-light`) | **Neo-Brutalism Pop** | `#FFFDF8` | `#FFFFFF` | `#FFE600` | `#D6B4FC` | `#000000` |
| **06** | `neumorphism` (`neu-light`) | **Neumorphism Soft UI** | `#E0E5EC` | `#E0E5EC` | `#3B82F6` | `#8B5CF6` | `#3D4451` |
| **09** | `retro-90s` (`win95`) | **Retro 90s OS (Win95)** | `#008080` | `#C0C0C0` | `#000080` | `#000080` | `#000000` |
| **12** | `frutiger-aero` | **Frutiger Aero (Y2K Liquid)** | `#E0F2FE` | `rgba(255, 255, 255, 0.75)` | `#0284C7` | `#10B981` | `#0C4A6E` |
| **15** | `papercraft` | **Papercraft & Origami** | `#F5F2EB` | `#FFFFFF` | `#C25E3E` | `#2C5E55` | `#2B2620` |
| **23** | `skeuomorphism` (`skeuo-light`) | **Skeuomorphism Light** | `#EAECEF` | `#F5F6F8` | `#FF9500` | `#2563EB` | `#1C1D1F` |
| **25** | `e-ink` (`e-ink-paper`) | **E-Ink / Paper** | `#FDFBF7` | `#FFFFFF` | `#1A1A1A` | `#E27D60` | `#1A1A1A` |
| **26** | `swiss-style` (`swiss-modernism`) | **Swiss Modernism 2.0** | `#FFFFFF` | `#FFFFFF` | `#FF3B30` | `#007AFF` | `#000000` |

### Part B — Modern Dark, Spatial & Cyber Morphisms (14 Presets)

| # | Theme Key (Aliases) | Name | Background | Surface | Primary | Accent / Secondary | Text |
|---|---|---|---|---|---|---|---|
| **01b** | `material3-dark` | **Google Material 3 (Dark)** | `#121316` | `#1b1b1f` | `#bac3ff` | `#dfbbde` | `#e4e2e6` |
| **02b** | `minimal-dark` | **Minimal 2D Mono (Dark)** | `#0A0A0A` | `#111111` | `#FFFFFF` | `#FFFFFF` | `#FFFFFF` |
| **03b** | `glassmorphism` (`glass-dark`) | **Glassmorphism 2.0 (Dark)** | `#0b0f19` | `rgba(255, 255, 255, 0.06)` | `#38BDF8` | `#F472B6` | `#F9FAFB` |
| **04b** | `claymorphism-dark` (`clay-dark`) | **Claymorphism Dark** | `#13141F` | `#1A1B26` | `#A78BFA` | `#34D399` | `#F1F5F9` |
| **05b** | `neobrutalism-dark` (`neo-dark`) | **Neo-Brutalism Dark** | `#0D0D0D` | `#171717` | `#FFE600` | `#FF007F` | `#FFFFFF` |
| **06b** | `neumorphism-dark` (`neu-dark`) | **Neumorphism Dark** | `#1E2024` | `#1E2024` | `#38BDF8` | `#A855F7` | `#E2E8F0` |
| **07** | `cyberpunk` (`cyber-dark`) | **Cyberpunk Neon HUD** | `#090014` | `#13032b` | `#FF007F` | `#FFE600` | `#00F0FF` |
| **08** | `bento-modern` (`linear-dark`) | **Bento Modern Dark** | `#080808` | `#121212` | `#5E6AD2` | `#E5E5E5` | `#EDEDED` |
| **10** | `oled-black` (`oled-pure`) | **OLED Pure Black** | `#000000` | `#000000` | `#FFFFFF` | `#30D158` | `#FFFFFF` |
| **11** | `aurora-glow` | **Aurora Mesh Glow** | `#090714` | `rgba(19, 14, 36, 0.65)` | `#A855F7` | `#38BDF8` | `#F8FAFC` |
| **13** | `phosphor-terminal` | **Phosphor CRT Terminal** | `#070B07` | `rgba(12, 20, 12, 0.90)` | `#00FF66` | `#33FF88` | `#00FF66` |
| **23b** | `skeuomorphism-dark` (`skeuo-dark`) | **Skeuomorphism Dark** | `#141517` | `#212327` | `#FF8C00` | `#38BDF8` | `#F1F3F5` |
| **24** | `visionos` (`spatial-ui`) | **Spatial UI (visionOS 2.0)** | `#090B10` | `rgba(255, 255, 255, 0.08)` | `#007AFF` | `#FF9F0A` | `#FFFFFF` |
| **27** | `vaporwave` (`retro-futurism`) | **Vaporwave Synthwave** | `#140C26` | `#221640` | `#FF71CE` | `#05FFA1` | `#FFFFFF` |

### Part C — Developer & Syntax Themes (8 Presets)

| # | Theme Key | Name | Mode | Background | Surface | Primary | Accent / Secondary | Text |
|---|---|---|---|---|---|---|---|---|
| **14** | `nord-frost` | **Nord Arctic Frost** | Dark | `#2E3440` | `#3B4252` | `#88C0D0` | `#8FBCBB` | `#ECEFF4` |
| **16** | `github-dark` | **GitHub Primer Dark** | Dark | `#0D1117` | `#161B22` | `#238636` | `#58A6FF` | `#F0F6FC` |
| **17** | `vscode-dark` | **VS Code Modern Dark+** | Dark | `#1E1E1E` | `#252526` | `#007ACC` | `#4EC9B0` | `#D4D4D4` |
| **18** | `tokyo-night` | **Tokyo Night (Folke)** | Dark | `#1A1B26` | `#24283B` | `#7AA2F7` | `#BB9AF7` | `#C0CAF5` |
| **19** | `catppuccin-mocha` | **Catppuccin Mocha** | Dark | `#1E1E2E` | `#181825` | `#CBA6F7` | `#89B4FA` | `#CDD6F4` |
| **20** | `dracula` | **Dracula Official** | Dark | `#282A36` | `#282A36` | `#BD93F9` | `#FF79C6` | `#F8F8F2` |
| **21** | `one-dark` | **One Dark Pro (Atom)** | Dark | `#282C34` | `#2C313A` | `#61AFEF` | `#98C379` | `#ABB2BF` |
| **22** | `solarized-dark` | **Solarized Dark** | Dark | `#002B36` | `#073642` | `#268BD2` | `#2AA198` | `#839496` |

---

## 2. Famous Website & Retro Palettes (11 Swappable Palettes)

Palettes override semantic color variables (`--theme-primary`, `--theme-bg`, `--theme-surface`, `--theme-surface-container`, `--theme-text`, `--theme-accent`, `--theme-border`) on top of any active morphism without altering its shadow physics or border-radius geometry.

| Palette ID | Palette Name | Primary | Background | Subtle BG | Surface | Container | Accent | Text | Muted Text |
|---|---|---|---|---|---|---|---|---|---|
| `linear` | **Linear** | `#5E6AD2` | `#0D0E11` | `#13151B` | `#16181D` | `#1F2228` | `#6875F5` | `#F7F8F8` | `#8A8F98` |
| `stripe` | **Stripe** | `#635BFF` | `#F8F9FA` | `#F1F4F9` | `#FFFFFF` | `#F4F6F8` | `#00D4AA` | `#0A2540` | `#425466` |
| `vercel` | **Vercel** | `#0070F3` | `#000000` | `#0A0A0A` | `#111111` | `#1A1A1A` | `#50E3C2` | `#EDEDED` | `#888888` |
| `supabase` | **Supabase** | `#3ECF8E` | `#1C1C1C` | `#181818` | `#242424` | `#2A2A2A` | `#24B47E` | `#EDEDED` | `#9E9E9E` |
| `notion` | **Notion** | `#2EAADC` | `#FFFFFF` | `#F7F6F3` | `#FFFFFF` | `#F1F1EF` | `#EB5757` | `#37352F` | `#787774` |
| `raycast` | **Raycast** | `#FF6363` | `#0C0C0D` | `#121214` | `#161618` | `#212124` | `#FF8F8F` | `#FFFFFF` | `#8F8F92` |
| `openai` | **ChatGPT** | `#10A37F` | `#202123` | `#2A2B32` | `#2A2B32` | `#343541` | `#19C37D` | `#ECECF1` | `#ACACBE` |
| `figma` | **Figma** | `#0ACF83` | `#1E1E1E` | `#252525` | `#2C2C2C` | `#383838` | `#F24E1E` | `#FFFFFF` | `#B3B3B3` |
| `spotify` | **Spotify** | `#1DB954` | `#121212` | `#181818` | `#1F1F1F` | `#282828` | `#1ED760` | `#FFFFFF` | `#B3B3B3` |
| `discord` | **Discord** | `#5865F2` | `#1E1F22` | `#2B2D31` | `#2B2D31` | `#313338` | `#57F287` | `#DBDEE1` | `#949BA4` |
| `resurrect-64` | **Resurrect-64** | `#EA4F36` | `#2E222F` | `#3E3546` | `#3E3546` | `#625565` | `#0EAF9B` | `#FFFFFF` | `#9BABB2` |

---

## 3. Tier 1 Primitive Color Tokens (`src/tokens/primitives.css`)

| Scale | Tokens & Hex Values |
|---|---|
| **Material 3 Primary Seed** | `--pal-primary-10` `#00105c`, `--pal-primary-20` `#001f8f`, `--pal-primary-30` `#0032b4`, `--pal-primary-40` `#294ede`, `--pal-primary-80` `#bac3ff`, `--pal-primary-90` `#dce1ff` |
| **Material 3 Neutrals (Dark → Light)** | `--pal-neutral-0` `#000000`, `--pal-neutral-6` `#121316`, `--pal-neutral-10` `#1b1b1f`, `--pal-neutral-22` `#353539`, `--pal-neutral-40` `#5e5e62`, `--pal-neutral-87` `#dbd8de`, `--pal-neutral-94` `#f0edf2`, `--pal-neutral-98` `#fdf8fd`, `--pal-neutral-99` `#fffbfe`, `--pal-neutral-100` `#ffffff` |
| **Neo-Brutalist Pop** | `--pal-pop-yellow` `#FFE600`, `--pal-pop-mint` `#00F0FF`, `--pal-pop-lilac` `#D6B4FC`, `--pal-pop-coral` `#FF5C5C`, `--pal-pop-black` `#000000`, `--pal-pop-white` `#FFFFFF` |
| **Cyberpunk / Synthwave** | `--pal-cyber-abyss` `#0B001A`, `--pal-cyber-neon-cyan` `#00F0FF`, `--pal-cyber-neon-magenta` `#FF007F`, `--pal-cyber-purple` `#8B00FF`, `--pal-cyber-hud-yellow` `#FFE600` |
| **Clay Pastels** | `--pal-clay-lilac` `#e0d4fc`, `--pal-clay-mint` `#d4fce5`, `--pal-clay-peach` `#fcdcd4`, `--pal-clay-sky` `#d4f0fc` |
