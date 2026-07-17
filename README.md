# niri + DMS dotfiles

niri (WM) config and DankMaterialShell (DMS) presets in one repo. niri is
live-symlinked; DMS is a minimal overlay under `dank/` (see `dank/README.md`).

## Install

> Requires Terra/Copr for DMS

```bash
ln -sfn ~/Projects/niri-dms/niri ~/.config/niri
cp dank/settings.json ~/.config/DankMaterialShell/settings.json
sudo dnf install niri dms bibata-cursor-theme ocean-sound-theme
systemctl --user add-wants niri.service dms
```
