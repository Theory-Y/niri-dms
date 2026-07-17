# DMS presets

`settings.json` is a minimal overlay: only settings that differ from DMS
defaults. DMS fills absent keys from its own defaults, so this is version-proof.
After tweaking DMS in the GUI, run `./snapshot.sh` to recapture (it strips
`wifiNetworkPins` so home SSIDs stay out of git).

The list below is what the overlay encodes — a human reference, plus the few
items not stored in `settings.json` (wallpaper).

## Personalization

### Wallpaper

- Duplicate Wallpaper with Blur

### Theme & Colors

- Theme color -> Auto
- Automatic Color Mode -> Location
- Cursor theme -> Bibata-Original-Ice (req: `bibata-cursor-theme`)

### Time & Weather

- Time Format -> 24-Hour Format -> true
- Date Format -> Top Bar Format -> ISO Date
- Date Format -> Lock Screen Format -> ISO Date

### Sounds

- Sound Theme -> ocean (req: `ocean-sound-theme`)
- Volumn Changed -> false

## Dank Bar

### Settings

- Position -> Bottom

### Widgets

- Left
  - Workspace Switcher
  - Running Apps
- Right
  - System Tray
  - Clipboard Manager
  - Battery
  - Control Center
  - Clock
  - Notification Center

## Keyboard Shortcuts

Handled by `niri/user/binds.kdl`.

## Power & Security

### Idle Settings

- AC Power
  - Automatically lock after -> 15 minutes
  - Turn off monitors after -> 30 minutes
  - Suspend system after -> Never
- Battery
  - Automatically lock after -> 10 minutes
  - Turn off monitors after -> 5 minutes
  - Suspend system after -> 15 minutes
