# Button

The game's 3D button: a solid fill, a soft top highlight and a 4px bottom lip that the button sinks into when pressed (translate 3px, lip 1px, 120 ms).

- **primary** (`emerald`, text `on-emerald`, lip `lip-emerald`): the ONE main action per screen — Play, Next, Continue, Collect.
- **gold** (`gold`, text `on-gold`, lip `lip-gold`): rewards and anything that pays out — Claim 2X, Watch ad +1 heart, Spin. Always pair an ad button with the `ad` glyph and the reward text.
- **secondary** (`canopy`, text `mist`, lip `lip-canopy`): the other choices — Map, Home, Restart.
- **ghost** (no fill, text `fern`): dismissals — No thanks, Not now, Cancel.
- Disabled: `canopy` fill, `sage` text, no lip; keep the label (say why when it is not obvious: "Ad unavailable").
- Size: 56px tall (48px ghost), radius `radius-md`, label style `button`, min width 120px; full-width inside popups. Focus: `glow-ring`.
- Consumer provides: label, optional leading 22px icon (glyphs in `on-emerald`/`on-gold` ink on filled buttons), onPressed, variant.
- Plays the `tap` UI sound and a light haptic.
