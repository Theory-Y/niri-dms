> [!WARNING]
> THE COMMANDS IN THIS README IS DESIGNED FOR THE REPO TO BE CLONED TO `~/Projects` with its original name `niri-dms`!!!

> [!TIP]
> This repo uses symlinks to respective folders in `~/.config`. You can edit their configs within this repo folder.

```bash
mkdir -p ~/Projects
cd ~/Projects
git clone https://github.com/aier9500/niri-dms
```

# Niri + DMS dotfiles

Configs for the Niri window manager plus DankMaterialShell (DMS) presets.

Niri configs is symlinked; DMS settings set by hand in its settings app. Optional voice typing via `voxtype` setup before OpenWhispr implements Wayland compositor support.

## Install Niri & DMS

> Needs the Terra or Copr repo for DMS

```bash
ln -sin ~/Projects/niri-dms/niri ~/.config/niri
systemctl --user add-wants niri.service dms
```

## Nvidia High VRAM Fix

The Nvidia driver doesn't return freed VRAM to Niri, so Niri can hog ~1 GiB VRAM instead of ~100 MiB. The driver ships a fix profile it is not wired automatically for Niri (Smithay-based compositors), so we have to apply it ourselves.

Create `/etc/nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json`:

```json
{
  "rules": [
    {
      "pattern": {
        "feature": "procname",
        "matches": "niri"
      },
      "profile": "Limit Free Buffer Pool On Wayland Compositors"
    }
  ],
  "profiles": [
    {
      "name": "Limit Free Buffer Pool On Wayland Compositors",
      "settings": [
        {
          "key": "GLVidHeapReuseRatio",
          "value": 0
        }
      ]
    }
  ]
}
```

Restart Niri to apply. See the [Niri Nvidia wiki](https://github.com/niri-wm/niri/wiki/Nvidia).

## fcitx5 + Rime Setup (Keyboard Layout Management, Chinese)

Optional — skip if you don't use multiple keyboard layouts. This repo's Niri configs autostarts fcitx5 and sets `XMODIFIERS` X11 compatibility already (see `niri/user/autostart.kdl` & `misc.kdl`); the actual layout config and and hotkey are managed in `fcitx5` itself (`fcitx5-configtool` GUI available).

```bash
sudo dnf install fcitx5 fcitx5-rime fcitx5-configtool
```

## DMS Settings Suggestions

Some settings worth changing in the DMS settings after fresh install. Sorted by section.

> [!TIP]
> This repo's keyboard shortcuts live in `niri/user/binds.kdl`.
>
> I highly suggest declaring bindings via the .kdl file and back up to a remote instead of using the DMS GUI.

### Personalisation

- Wallpaper -> Duplicate with Blur -> true (blurry overview)
- Theme & Colors
  - Theme color -> Auto
  - Cursor theme

### Dank Bar

- Positions
- Widgets

### Power & Security -> Power & Sleep -> Idle Settings

- Lock before suspend -> true
- Plugged in: lock 5m, screen off 30m, sleep 1hr
- On battery: lock 5m, screen off 5m, sleep 15m

### Plugins

- Dank ASUS Control Center (ASUS laptops only)
- Clight (auto screen brightness; req: `clightd`)

## Voice Typing (`voxtype`)

Press hotkey, talk, and the text pastes at your cursor. An optional local-LLM tidies the grammar and spelling. Set it up in these blocks.

> [!TIP]
> `voxtype` is the solution I would suggest before OpenWhispr implements better Wayland compositor support.
>
> OpenWhispr has a much simpler setup but its universal keybinding does not work without an extensive amount of tweaks.

### Install `voxtype`

Install the package using instructions from [https://voxtype.io/download](https://voxtype.io/download). Then:

Create the `voxtype` config:

```bash
voxtype setup
```

> [!TIP]
> **Whispr model recommendations:**
>
> GPU: `large-v3-turbo`\
> Capable iGPU: `small`\
> Smaller models: `base`, `tiny`

Configure a transcription model:

```bash
voxtype setup model # then select your model
```

```bash
voxtype setup --download  # download the speech model
voxtype setup check       # report anything still missing
```

### `voxtype` Binding

In this repo, it is bound via `niri/user/binds.kdl`:

- `Alt+Space` -> start / stop recording
- `Alt+Shift+Space` -> cancel, discards without pasting

In the `~/.config/voxtype/config.toml`, disable kernel level shortcut. Disable on Wayland compositors; enable only on DEs like GNOME and KDE.

```toml
[hotkey]
enabled = false
```

### Autostart

Instead of `voxtype setup systemd` which uses the stock daemon, use the repo's unit + launcher so the dictionary comes from `~/.config/voxtype/dictionary.txt`. More on the dictionary in the section below.

The following code

- Creates a private copy of the example dictionary list.
- Links the following to `~/.config/voxtype/`:
  - `voxtype/dictionary.txt` — portable dictionary list.
  - `voxtype/voxtype-with-dictionary.sh` — script that pipes dictionary list into whispr.
  - `voxtype/voxtype.service` — `systemd` service that tells `voxtype` to always use the script above.
- Reloads and starts custom `voxtype`.

```bash
repo=~/Projects/niri-dms/voxtype
cp -n "$repo/dictionary.txt.example" "$repo/dictionary.txt"
ln -sin "$repo/dictionary.txt" ~/.config/voxtype/dictionary.txt
ln -sin "$repo/voxtype-with-dictionary.sh" ~/.config/voxtype/voxtype-with-dictionary.sh
ln -sin "$repo/voxtype.service" ~/.config/systemd/user/voxtype.service
systemctl --user daemon-reload
systemctl --user enable --now voxtype    # autostart on login + start now
```

### Configuring `voxtype`

The `voxtype` config file is in `~/.config/voxtype/config.toml`. This is an autogenerated file by `voxtype` so it is not symlinked from this repo.

Edit using:

```bash
$EDITOR ~/.config/voxtype/config.toml
```

... or edit via the TUI using:

```bash
voxtype configure
```

#### Sound feedback

In `~/.config/voxtype/config.toml`, enable sound feedback and set it to a non-distracting volume.

```toml
[audio.feedback]
enabled = true
volume = 0.2
```

#### Output mode

Set the output mode to `clipboard` so the transcript is copied to your clipboard and you paste it yourself with `Ctrl+V` or `Ctrl+Shift+V`. Requires `wl-copy` (Wayland).

The four modes:

- `type` — simulate keystrokes char-by-char at the cursor.
- `clipboard` — copy to clipboard, paste manually.
- `paste` — copy to clipboard, then fires `Ctrl+V`, might not work in the terminal.
- `file` — write the transcript to a file (`file_path` needs to be defined).

```toml
[output]
mode = "clipboard"
```

#### Personal dictionary

Proper nouns and jargon that Whisper would otherwise mistranscribe live in `voxtype/dictionary.txt` — one term per line, `#` comments and blank lines ignored:

```
# voxtype/dictionary.txt
# --- AI / LLM ---
OpenWhispr
Claude
Qwen
# --- People (add your own) ---
Jane Doe
Bob
# ... etc
```

The repo ships an template dictionary list `voxtype/dictionary.txt.example`; the [Autostart](#autostart) step above created a local copy to `voxtype/dictionary.txt`.

Voxtype can't read a word list from a file on its own — it only accepts an `initial_prompt` string in `config.toml`. To avoid cluttering the config file, we use `voxtype/voxtype-with-dictionary.sh` to process and inject `dictionary.txt` to run `voxtype --initial-prompt "…" daemon`.

### AI cleanup (optional)

Runs each transcript through a local LLM to fix grammar, converts to British spelling, strips the "um"s.

> [!TIP]
> This repo has a script (`voxtype/cleanup.sh`) that pipes raw output to Gemma 4 E4B and processes it; it contains the prompt that is given to the LLM to clean up text.
>
> Feel free to tweak the script if 1) you don't want conversion to British English, 2) want specific writing style/tone, 3) others.

> [!WARNING]
> Needs Ollama **0.20+**. Ollama doesn't package for repos, that's why we are curling.

Installs Ollama, downloads gemma4:e4b model, applies LLM cleanup script:

```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull gemma4:e4b
ln -sin ~/Projects/niri-dms/voxtype/cleanup.sh ~/.config/voxtype/cleanup.sh
```

In `~/.config/voxtype/config.toml`, set the post processing command to use the LLM cleanup script:

```toml
[output.post_process]
command = "sh -c 'exec \"$HOME/.config/voxtype/cleanup.sh\"'"
```

## `gaze` (facial recognition) integration with DMS Lock

`gaze` has yet to add official support for DMS Lock; `auth  sufficient  pam_gaze.so` lets `gaze` unlock DMS Lock, `auth  substack  sysctem-auth` allows for password fallback.

```bash
sudo tee /etc/pam.d/dankshell > /dev/null << 'EOF'
auth    sufficient    pam_gaze.so
auth    substack      system-auth
EOF
sudo chmod 644 /etc/pam.d/dankshell
```

Press enter in the DMS Lock to trigger `gaze`.
