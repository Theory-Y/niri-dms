# niri + DMS dotfiles

niri (WM) config and DankMaterialShell (DMS) presets in one repo. niri is
live-symlinked; DMS presets are applied by hand in the GUI (see `dank/README.md`).

## Install

> Requires Terra/Copr for DMS

```bash
ln -sfn ~/Projects/niri-dms/niri ~/.config/niri
sudo dnf install niri dms bibata-cursor-theme ocean-sound-theme
systemctl --user add-wants niri.service dms
```
