# BoosterButton

One of the three Phase 1 boosters in the bar under the board: Glow Firefly Hint (`hint`), Safety Shell Shield (`shield`), Magic Stone Hammer (`hammer`). Never a fourth.

- 72 × 72, `canopy`, radius `radius-md`, bottom lip `lip-canopy`; icon 46px.
- Count badge top-right: `gold` with `on-gold`. Count 0 shows an emerald `+` badge (tap opens the mini shop).
- States: **active** (Shield running / Hammer choosing a target) = `glow-ring` + `moss`; **cap reached** = dimmed icon + "3/3"; **locked** = dimmed icon + lock + "L15"/"L25"; **busy** (a move animating) = 50% opacity, no tap.
- Consumer provides: booster, count, used/cap, locked/unlock level, active, enabled, onPressed.
