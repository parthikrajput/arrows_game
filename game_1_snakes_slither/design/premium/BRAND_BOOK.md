Snakes Slither is a calm logic puzzle: cute snakes tangled in a jungle garden, and the player decides who slithers out first. The look is **Jungle at dusk**. Deep emerald-ink grounds, warm gold rewards and soft glow accents let the bright snakes do the talking. It should feel premium and quiet: few elements, generous space, tactile 3D buttons, no clutter.

## Principles

1. **The board is the hero.** On the gameplay screen the board takes all remaining space; HUD and booster bar stay compact. Nothing on screen may be brighter than the snakes.
2. **One primary action per screen.** Exactly one `emerald` button (Play, Next, Continue). Rewards use `gold`. Everything else is `secondary` or `ghost`.
3. **Calm feedback.** Short, soft motion: a bonk is a squash and a shake, never a full-screen red flash.
4. **Rewards feel earned.** `gold` is only for coins, stars and things that pay out, so the colour itself means "reward".
5. **Ads never surprise.** Every rewarded ad button is `gold`, carries the `ad` glyph and says what you get ("Watch ad · +1 heart").

## Content and voice

- Friendly, short, plain. Sentence case for everything except the level badge ("LEVEL 37").
- Second person, never blaming: "Oh no! The snakes got tangled", "Pip needs a berry!", "Hold a snake to preview its path".
- Use the game's own names: Heart Berry, Glow Firefly Hint, Safety Shell Shield, Magic Stone Hammer, Jungle Gift Basket, Lucky Lily Wheel, Golden Slither Rush.
- Numbers are locale-formatted (1,250). No emoji in UI copy; the illustrated game icons do that job.

## Colour

- Grounds, darkest to lightest: `night` (app background) → `dusk` (screen) → `canopy` (cards, pills, sheets) → `moss` (inner panels, pressed, selected). Raise by one step per layer; never skip from `night` to `moss`.
- Text: `mist` for primary, `fern` for secondary, `sage` for disabled. All pass 4.5:1 on every ground.
- Actions: `emerald` fill with `on-emerald` text; rewards: `gold` with `on-gold`. Never put `mist` text on `emerald`.
- Signals: `ember` = hearts, bonk, blocked lane; `lagoon` = Shield; `glow` = Hint, focus ring, NEW; `orchid` = VIP only.
- `vine` is a decorative hairline only (below 3:1); never use it for text or a control's border.
- The 8 `snake-*` colours belong to snakes (and the gates, cages and keys that match them). Never use them for UI. Each snake colour also has its pattern, so colour is never the only cue.
- Gradients: only the subtle top highlight on buttons and the soft shading inside game icons. No full-screen gradients, no purple-blue sheens.

## Type

- `display` font (Fredoka) for titles, buttons and numbers; `body` font (Nunito) for everything you read.
- Styles: `display` 32/40 for screen titles; `h1` 24/32 for popup titles; `h2` 20/28 for card titles; `button` 18/24; `hud-number` 20/24 with tabular figures; `body` 16/24; `caption` 13/18.
- Gujarati falls back to Baloo Bhai 2, Hindi to Baloo 2, same sizes, line height +10%.
- Respect the system text size up to 200% in menus; HUD numbers clamp at 150%.

## Spacing, radius, elevation

- 4-based scale: `space-4` … `space-48`. Screen gutter `space-16`; popup padding `space-24`.
- Radii: `radius-xs` badges, `radius-sm` tabs, `radius-md` buttons and booster buttons, `radius-lg` cards and popups, `radius-pill` pills and round buttons. Board tile corners = 0.18 × cell.
- Elevation is light, not borders: `elev-1` for cards and pills, `elev-2` for popups. Buttons use a solid 4px lip (`lip-emerald`, `lip-gold`, `lip-canopy`) and sink 3px when pressed.

## Iconography

Two tiers, both custom for this game:

- **Glyphs** (asset group *Glyphs*): 24px grid, 1.75px rounded strokes, single ink `mist` (`#EEF5EF`). Use them for navigation and utility: play, pause, back, close, settings, map, shop, spin, daily, ranks, home, restart, lock, info, sound, music, haptics, preview, guide, ad, check, plus. On a filled button, tint them to the button's text colour.
- **Game icons** (asset group *GameIcons*): 48px full-colour illustrations for things you collect or use: coin, heart, star, hint (firefly), shield (shell), hammer (stone), gift (basket), trophy (coil), crown (VIP), wheel (lily wheel). Show them at 24–96px; never recolour them.
- Logos: the real 3D wordmark (`snakes-slither-logo.png`) and app icon (`app-icon-1024.png`) from the brand folder. Never redraw them.

## Motion

- `fast` 150 ms ease-out (taps, toggles); `base` 250 ms ease-out-cubic (screen elements); `popupIn` 300 ms ease-out-back from 92% scale.
- Snake exit 250–450 ms by lane length, with a sine wiggle; bonk 380 ms (out ease-out, back elastic); locked tap: a 200 ms side wobble.
- Screens: Home → Map slides up; Map → Gameplay zooms from the tapped node; popups scale in over the `scrim`.
- Reduced motion: no wiggle, shake or confetti; screen transitions become 150 ms fades. Functional motion (a snake leaving) stays, shorter.

## Layout and flow

- Phones portrait; tablets centre the board (max 600px wide) and may go landscape with the booster bar on the right.
- Gameplay: HUD 64 → board (auto-fit, cell ≥ 29px) → booster bar 88 → banner slot (from L11, non-VIP) with an 8px gap.
- Home: logo and Pip on top; one big Play button; a row of round shortcuts (Daily, Spin, Shop, Ranks); settings top-right.
- Every screen has one obvious way back (top-left `back` glyph or Android back). Popups close with a ghost button, never with a tap outside during play.
