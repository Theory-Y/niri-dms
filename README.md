> [!WARNING]
> THE COMMANDS IN THIS README IS DESIGNED FOR THE REPO TO BE CLONED TO `~/Projects` with its original name `niri-dms`!!!

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/aier9500/niri-dms
```

# Niri + DMS dotfiles

Config for the Niri window manager plus DankMaterialShell (DMS) presets.

Niri config is symlinked; DMS settings set by hand in its settings app. Optional voice typing via `voxtype` setup before OpenWhispr implements Wayland compositor support.

## Install Niri & DMS

> Needs the Terra or Copr repo for DMS

```bash
ln -sfn ~/Projects/niri-dms/niri ~/.config/niri
systemctl --user add-wants niri.service dms
```

## fcitx5 + Rime Setup (Keyboard Layout Management, Chinese)

Optional — skip if you don't use multiple keyboard layouts. Niri autostarts fcitx5 and sets `XMODIFIERS` X11 compatibility already (see `niri/user/autostart.kdl` / `misc.kdl`); everything else lives in fcitx5 itself.

```bash
sudo dnf install fcitx5 fcitx5-rime fcitx5-configtool
```

Input methods, keyboard layouts, and the layout switch bind are all managed in the fcitx5 settings app (`fcitx5-configtool`).

## DMS suggested presets

Some settings worth changing in the DMS settings after fresh install. Sorted by section.

> [!IMPORTANT]
> This repo's keyboard shortcuts live in `niri/user/binds.kdl`.
>
> I highly suggest declaring bindings via the .kdl file and upload them to a remote instead of using the GUI.

### Personalization

- Wallpaper -> Duplicate with Blur -> true (blurry overview)
- Theme & Colors
  - Theme color -> Auto
  - Cursor theme

### Dank Bar

- Positions
- Widgets

### Power & Security -> Power & Sleep

- Plugged in: lock 15m, screen off 30m, never sleep
- On battery: lock 10m, screen off 5m, sleep 15m

## Voice Typing (`voxtype`)

Press hotkey, talk, and the text pastes at your cursor. An optional local-LLM tidies the grammar and spelling. Set it up in these blocks.

> [!TIP]
> This is the solution I would suggest before OpenWhispr (which has a much simpler setup) implements better Wayland compositor support.
>
> Currently the universal keybinding does not work without an extensive amount of tweaks.

### Install `voxtype`

Install the package using instructions from [https://voxtype.io/download](https://voxtype.io/download). Then:

```bash
voxtype setup             # create the config
voxtype setup --download  # download the speech model
voxtype setup check       # report anything still missing
```

### `voxtype` Binding

In this repo, it is bound via `niri/user/binds.kdl`:

- `Alt+Space` -> start / stop recording
- `Alt+Shift+Space` -> cancel, discards without pasting

In the `voxtype` config, set `[hotkey] enabled = false` so Niri owns the key. (Set it `true` only on a desktop like GNOME, where Voxtype must listen for the key.)

### Autostart

Instead of `voxtype setup systemd` (which installs a stock unit that runs `voxtype daemon` directly), use the repo's unit + launcher so the vocabulary comes from `vocabulary.txt`:

```bash
repo=~/Projects/niri-dms/voxtype
cp -n "$repo/vocabulary.txt.example" "$repo/vocabulary.txt"   # your private copy (gitignored)
ln -sfn "$repo/vocabulary.txt"  ~/.config/voxtype/vocabulary.txt
ln -sfn "$repo/voxtype-with-vocab-list"  ~/.config/voxtype/voxtype-with-vocab-list
ln -sfn "$repo/voxtype.service" ~/.config/systemd/user/voxtype.service
systemctl --user daemon-reload
systemctl --user enable --now voxtype    # autostart on login + start now
```

After any config or vocabulary change:

```bash
systemctl --user restart voxtype
```

### Configuring `voxtype`

`voxtype`'s config file lives in `~/.config/voxtype/config.toml`. Edit using:

```bash
cd ~/.config/voxtype
$EDITOR config.toml
```

You can edit via the TUI using:

```bash
voxtype configure
```

#### Sound feedback

- `[audio.feedback] enabled = true`, `volume = 0.2` -> soft beep on record upon start and stop.

#### Teach it your words

Proper nouns and jargon that Whisper would otherwise mistranscribe live in `voxtype/vocabulary.txt` — one term per line, `#` comments and blank lines ignored:

```
# voxtype/vocabulary.txt
# --- AI / LLM ---
OpenWhispr
Claude
Qwen
# --- People (add your own) ---
Jane Doe
Bob
# ... etc
```

The repo ships an template vocabulary list `vocabulary.txt.example`; the [Autostart](#autostart) step copies it to `vocabulary.txt`, which is **gitignored** — so your personal word list stays local and is never pushed.

Voxtype can't read a word list from a file on its own — it only accepts an `initial_prompt` string in `config.toml` or the top-level `--initial-prompt` flag. So the daemon is launched through the `voxtype/voxtype-with-vocab-list` wrapper, which flattens `vocabulary.txt` into a single `Vocabulary: word-a, word-b, word-c` string and runs `voxtype --initial-prompt "…" daemon`.

### AI cleanup (optional)

Runs each transcript through a local LLM to fix grammar, converts to British spelling, strips the "um"s.

> [!TIP]
> This repo has a script that pipes raw output to Gemma 4 E4B and processes it; it contains the prompt that is given to the LLM to clean up text.
>
> Feel free to tweak the script if 1) you don't want conversion to British English, 2) want specific writing style/tone, 3) others.

> [!WARNING]
> Needs Ollama **0.20+** (the one packaged in dnf is too old as of 2026-07-17). That's why we are curling.

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull gemma4:e4b
ln -sfn ~/Projects/niri-dms/voxtype/cleanup.sh ~/.config/voxtype/cleanup.sh
```

Then point the post processing command at the script in the config:

```toml
[output.post_process]
command = "sh -c 'exec \"$HOME/.config/voxtype/cleanup.sh\"'"
```

Swap models by editing its `MODEL=` line. Default uses Gemma 4 E4B

### `gaze` (facial recognition) integration with DMS Lock

`gaze` has yet to add official support for DMS Lock, but all you have to do to get it working is add the following two lines to `/etc/pam.d/dankshell`:

```conf
auth    sufficient    pam_gaze.so
auth    substack      sysctem-auth
```

First line lets `gaze` unlock DMS Lock, and second line allows for password fallback.

Press enter in the DMS Lock to trigger `gaze`.

## DMS Plugins I Use

- Dank ASUS Control Center
- Clight (auto screen brightness)
