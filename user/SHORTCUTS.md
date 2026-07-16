# Niri + DMS shortcut cheatsheet

Source: **D** = `dms/binds.kdl` (DMS-generated) · **U** = `dms/user-binds.kdl` (yours, survives `dms setup`).
**IPC** = spawns a `dms ipc call …` service. Mod = Super.

---

## Launchers & apps
| Key | Action | Src | IPC |
|-----|--------|-----|-----|
| `Super+Return` | Terminal (ghostty) | U | |
| `Super+E` | Files (nautilus) | U | |
| `Super+B` | Zen Browser | U | |
| `Super+A` | App launcher (spotlight) | U | ✅ |
| `Super+V` | Clipboard manager | D | ✅ |
| `Super+Y` | Wallpaper browser (dankdash) | D | ✅ |
| `Super+N` | Notepad | D | ✅ |
| `Super+M` | Notifications | U | ✅ |
| `Super+I` | DMS settings | D | ✅ |
| `Super+Shift+W` | Create window rule | D | ✅ |

## Window management
| Key | Action | Src |
|-----|--------|-----|
| `Super+X` / `Alt+F4` | Close window | U |
| `Super+F` | Maximize column (100% width) | D |
| `Super+Shift+F` | Fullscreen (true) | D |
| `Super+T` | Toggle floating | D |
| `Super+Shift+T` | Focus floating ↔ tiling | D |
| `Super+W` | Toggle tabbed column | D |
| `Super+C` | Center column | D |
| `Super+Ctrl+C` | Center visible columns | D |

## Focus
| Key | Action | Src |
|-----|--------|-----|
| `Super+←/→` | Focus column left/right | D |
| `Super+↑/↓` | Focus window up/down (in column) | D |
| `Super+Home/End` | Focus first/last column | D |
| `Super+Ctrl+←/→` | Focus monitor left/right | D |

## Move / arrange
| Key | Action | Src |
|-----|--------|-----|
| `Super+[ / Super+]` | Move window to monitor left/right | D |
| `Super+Ctrl+Shift+↑/↓` | Move window to workspace up/down | D |
| `Super+Shift+←/→` | Consume/expel window to neighbour column | D |
| `Super+Shift+↑/↓` | Swap window up/down in column | D |
| `Super+Alt+←/→` | Move column (reposition in strip) | D |

## Workspaces
| Key | Action | Src |
|-----|--------|-----|
| `Super+Ctrl+↑/↓` | Switch workspace | D |
| `Super+PageUp/PageDown` | Switch workspace | D |
| `Super+1…9` | Switch to workspace N | D |
| `Super+Shift+1…9` | Move column to workspace N | D |
| `Super+Shift+PageUp/PageDown` | Reorder workspace itself | D |
| `Ctrl+Shift+R` | Rename workspace | D · ✅ |

## Sizing
| Key | Action | Src |
|-----|--------|-----|
| `Super+R` | Cycle preset column widths | D |
| `Super+Ctrl+R` | Reset window height | D |
| `Super+Ctrl+F` | Expand column to available width | D |
| `Super+-/=` | Column width −/+10% | D |
| `Super+Shift+-/=` | Window height −/+10% | D |

## Mouse wheel (hold Super)
| Key | Action |
|-----|--------|
| `Super+Wheel↕` | Switch workspace |
| `Super+Wheel↔` / `Super+Shift+Wheel↕` | Focus column |

## Overview / language / system
| Key | Action | Src |
|-----|--------|-----|
| `Super+Tab` | Toggle overview | D |
| `Super+Space` | Switch keyboard layout (Colemak-DH ↔ US) | U |
| `Super+Shift+Slash` | Show hotkey overlay (live) | D |
| `Super+L` | Lock screen | D · ✅ |
| `Ctrl+Alt+Delete` | Power menu (logout/reboot/shutdown live here) | D · ✅ |
| `Ctrl+Shift+Escape` | System monitor (Mission Center) | D |
| `Super+Escape` | Toggle shortcut inhibit | D |

## Media / brightness (function keys)
| Key | Action | IPC |
|-----|--------|-----|
| `XF86Audio Raise/Lower/Mute/MicMute` | Volume / mute | ✅ |
| `XF86Audio Play/Pause/Prev/Next` | MPRIS transport | ✅ |
| `Ctrl+XF86Audio Raise/Lower` | MPRIS volume | ✅ |
| `XF86MonBrightness Up/Down` | Screen brightness | ✅ |

## Screenshots
| Key | Action | Src |
|-----|--------|-----|
| `Print` / `XF86Launch1` | Screenshot (region UI) | D |
| `Ctrl+Print` / `Ctrl+XF86Launch1` | Screenshot whole screen | D |
| `Alt+Print` / `Alt+XF86Launch1` | Screenshot window | D |
| `Super+Shift+S` | Screenshot (region UI) | U |

---

## Disabled / freed
- **Disabled** (`/-`): `Super+Shift+P` power-off-monitors.
- **Freed families**: `Super+Shift+Ctrl+*` and `Super+Shift+Alt+*` (fully open), `Super+Shift+X`, `Super+Ctrl+Wheel`, `Super+Ctrl+Shift+Wheel`,
  `Super+Comma`, `Super+Shift+N`, `Super+Shift+V`, `Super+Period`, `Super+Ctrl+Home/End`,
  `Super+Shift+↑/↓`, `Super+C`, `Super+Shift+R`, `Super+Alt+L`, `Super+Shift+E`, `Super+T`(old term), `F13`.
- **Also free**: `Super+Alt+↑/↓`, `Super+Shift+Return`, `Super+Shift+Escape`, `Alt+Space`, `Alt+Shift+S`.
- **Free letters** (colemak cleanup): most of `D G H J K O P Q U Z`.

## Blur
Global `blur { on; passes 2; noise 0.02 }` in `config.kdl` — frosts behind any translucent surface.
Visible on ghostty (opacity 0.8 + background-blur). Not per-app scopable; overview has no separate toggle.
