> [!warning] THE COMMANDS IN THIS README IS DESIGNED FOR THE REPO TO BE CLONE TO `~/Projects` with its original name `niri-dms`!!!

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/aier9500/niri-dms
```

# niri + DMS dotfiles

Config for the niri window manager plus DankMaterialShell (DMS) presets.
niri config is symlinked; DMS presets you set by hand in its settings app. Optional voice typing via `voxtype` setup before OpenWhispr implements Wayland compositor support.

## Install

> Needs the Terra or Copr repo for DMS

```bash
ln -sfn ~/Projects/niri-dms/niri ~/.config/niri
sudo dnf install niri dms bibata-cursor-theme ocean-sound-theme
systemctl --user add-wants niri.service dms
```

## DMS presets

Set these by hand in DMS settings after a fresh install.

### Personalization

- Wallpaper -> Duplicate with Blur
- Theme color -> Auto
- Automatic Color Mode -> Location
- Cursor theme -> Bibata-Original-Ice (install `bibata-cursor-theme`)
- 24-Hour Format -> true
- Date Format (top bar + lock screen) -> ISO
- Sound Theme -> ocean (install `ocean-sound-theme`)
- Volume Changed sound -> false

### Dank Bar

- Position -> Bottom
- Left: Workspace Switcher, Running Apps
- Right: System Tray, Clipboard, Battery, Control Center, Clock, Notifications

### Power & Security (idle)

- Plugged in: lock 15m, screen off 30m, never sleep
- On battery: lock 10m, screen off 5m, sleep 15m

Keyboard shortcuts live in `niri/user/binds.kdl`.

## Voice Typing (`voxtype`)

Press hotkey, talk, and the text pastes at your cursor. An optional local-LLM tidies the grammar and spelling. Set it up in these blocks.

> [!tip] This is the solution I would suggest before OpenWhispr (much simpler setup) implements better Wayland compositor support.

### Install `voxtype`

Get the rpm from [voxtype.io/download](https://voxtype.io/download) (or `dnf install voxtype`, which may be older). Then:

```bash
voxtype setup             # create the config
voxtype setup --download  # download the speech model
voxtype setup check       # report anything still missing
```

### Hotkeys

Bound in `niri/user/binds.kdl`:

In the config, set `[hotkey] enabled = false` so niri owns the key. (Set it
`true` only on a desktop like GNOME, where Voxtype must listen for the key.)

- `F8` -> start / stop recording
- `Shift+F8` -> cancel, discards without pasting

### Paste + sound

- `[output] mode = "paste"` -> text lands as one clean paste, not typed
  character by character.
- `[audio.feedback] enabled = true`, `volume = 0.2` -> soft beep on record
  start and stop.

### Teach it your words

Add proper nouns and jargon to `[whisper] initial_prompt`, comma-separated ->
Whisper stops mangling names it hasn't heard of.

### AI cleanup (optional)

Runs each transcript through a local LLM -> fixes grammar, converts to British
spelling, strips the "um"s. Needs Ollama **0.20+** (Fedora's is too old):

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull gemma4:e4b
ln -sfn ~/Projects/niri-dms/voxtype/cleanup.sh ~/.config/voxtype/cleanup.sh
```

Then point the config at the script:

```toml
[output.post_process]
command = "sh -c 'exec \"$HOME/.config/voxtype/cleanup.sh\"'"
```

All the rules live in the script — no custom model to build. Swap models by
editing its `MODEL=` line.

### Keep it running

```bash
voxtype setup systemd             # autostart on login
systemctl --user restart voxtype  # reload after any config change
```

### DMS extras

- **Status icon** -> `voxtype setup dms --install`, then enable the **Voxtype**
  plugin in DMS Settings -> Plugins and add it to the bar. Needs a Nerd Font
  (`sudo dnf install jetbrains-mono-nerd-fonts`).
- **Activity Overlay** -> if that plugin is installed, `cleanup.sh` feeds it the
  live transcript bubble automatically. Nothing to configure.
