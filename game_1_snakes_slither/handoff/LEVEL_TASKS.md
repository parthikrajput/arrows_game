# Level tasks: all of Phase 1 (level agent: Antigravity)

Give these to Antigravity **one at a time, in order**, with the `game_1_snakes_slither` folder open.
Each task adds levels to the end of `assets/levels/phase_1.json`.

| Task | Levels | Blocks | New mechanics | Checker result today |
|---|---|---|---|---|
| LV1 | 1–10 | 1 (FTUE) | none (clean boards) | ✓ full check |
| LV2 | 11–20 | 2 | M001 Garden Rock | ✓ full check |
| LV3 | 21–60 | 3–6 | M002–M005 | ⏳ draft |
| LV4 | 61–100 | 7–10 | M006–M009 | ⏳ draft |
| LV5 | 101–150 | 11–15 | M010–M014 | ⏳ draft |
| LV6 | 151–200 | 16–20 | M015–M019 | ⏳ draft |
| LV7 | 201–250 | 21–25 | M020–M024 | ⏳ draft |
| LV8 | 251–300 | 26–30 | M025–M029 | ⏳ draft |
| LV9 | 301–350 | 31–35 | M030–M034 | ⏳ draft |
| LV10 | 351–400 | 36–40 | M035–M039 | ⏳ draft |
| LV11 | 401–450 | 41–45 | M040–M044 | ⏳ draft |
| LV12 | 451–499 | 46–50 | M045–M049 | ⏳ draft |
| LV13 | 500 | Finale | Mongoose King's Garden | ⏳ draft |

**What ✓ and ⏳ mean.** Right now the engine can play clean boards and Garden Rock. For those levels the checker plays the solution and confirms the whole level (✓). For later mechanics it checks everything it can without playing: format, sizes, counts, ids, slot and tag, mechanic rules, references, par, and the D band (⏳). When the logic agent adds a mechanic to the engine, those drafts get the full check automatically. If one turns out unsolvable or its D is off, it shows ✗ and goes back to Antigravity to fix.

---

## Rules for every task (Antigravity reads these each time)

```
Read AGENTS.md first and follow the "Level agent" rules strictly.
Edit ONLY assets/levels/phase_1.json. Append levels in number order.

Sources of truth (read before designing):
- phases/phase_1/02_LEVEL_PROGRESSION_0001_0500.md
    §2 tier table and D formula, §3 10-level block pattern (slots/tags),
    §6 intro rules, §7 block table (grid, snakes, D band per block)
- phases/phase_1/03_OBSTACLE_CATALOG_PHASE_1.md
    §2 JSON conventions + one card per mechanic (rule, JSON, Do/Don't,
    Combos). Copy each mechanic's JSON shape exactly from its card.
- phases/phase_1/01_GAME_CONCEPT_AND_RULES.md §4–§5 (board, snake and
    move rules, including the fixed move resolution order in §5.9)
- SHARED_CORE_STANDARD.md §12 (schema v3)

Level object (schema v3):
{"schema":3,"level":N,"phase":1,"seed":"0x<16 hex digits of N>",
 "slot":"…","tag":"…","grid":[W,H],"layers":1,"hearts":3,
 "paths":[{"id":"p1","color":"green","dir":"R","body":[[x,y],…],
           "layer":0,"mods":{}}],
 "mechanics":[{"id":"o1","type":"M0xx","cells":[[x,y],…],
               "params":{…},"hammerable":true|false}],
 "goals":{"gems":0},"par_moves":K,"difficulty":D,"solution":["p3","o1",…]}

Board rules:
- body[0] is the HEAD. [x,y], x → right, y → down, from 0. dir = U/D/L/R.
- A snake exits in a straight line from its head to the edge; anything in
  that line blocks it (unless a mechanic says otherwise).
- Bodies connected cell to cell, length 2–8 (FTUE 2–4), never facing their
  own neck, never overlapping another snake on the same layer.
- Snake variants and snake-linked mechanics go in "mechanics" with
  params.path / params.paths. "mods" is ONLY {"skin":"caterpillar"}
  (use on 0–40% of snakes).
- "hammerable": true only for M001, M002, M016, M025, M027; false for all others.
- Ids: snakes p1, p2, …; obstacles o1, o2, … (unique within a level).
- Use all 8 colours; avoid same-colour snakes touching (except where a
  colour mechanic needs it).

Block rules (checker enforces these):
- Slots: x1 intro/normal · x2–x4 practice/normal · x5 breather/easy ·
  x6–x8 ramp/normal · x9 hard/hard · x0 milestone/normal · L500 finale/finale.
- Every level in a block has ≥ 1 instance of that block's new mechanic.
- Intro (x1): only the new mechanic (1–2 instances) + at most 1 older one,
  smallest grid of the block, low D. A tutorial hand points at the first
  solution step, so make solution[0] a clear teaching move.
- Other levels: about 60% of the extra obstacles from the last 5 unlocked
  mechanics, 40% from older ones.
- Grid, snake count and D inside the block's row in §7. Hard (x9) may go
  up to band max × 1.1. Obstacle count ≤ the tier cap
  (T1 4 · T2 6 · T3 8 · T4 9 · T5 10).
- D = 0.6·P + 1.5·C + 2.0·O + 3.0·N + 1.0·S
  P snakes, C longest "must leave before" chain (links), O obstacle
  instances, N non-monotone instances (cards marked N ✅ in §1 table),
  S = solution moves − P. Write the D you get in "difficulty".

FAIRNESS (most important, see §1 rule 2):
- Every level must be winnable with 0 bonks and 0 boosters.
- "solution" must be a real winning sequence of taps (snake ids, plus
  obstacle ids for interactive taps like levers and lilypads), following
  each mechanic's card exactly. "par_moves" = its length.
- No snake may be stuck forever. Think through every step of the solution
  with the card's rules before writing it.

Check: dart run packages/puzzle_core/bin/validate_levels.dart --from A --to B
Done when every level in the task shows ✓ or ⏳ (no ✗) and `flutter test`
passes. If a rule is impossible or a card is unclear, write it in
handoff/CHANGE_REQUESTS.md and move on.
```

---

## LV1: FTUE levels 1–10

```
Follow "Rules for every task" above.
Task: levels 1–10, clean boards (no mechanics). The file already has L1–L5
as starter levels that pass; keep or improve them, and add L6–L10.
Hit each level's targets in the FTUE table (02 §4): grid, snakes, chain C,
optimal moves, D, slot/tag. Max moves: L1–3 ≤ 4, L4–10 ≤ 8. Make each level
fit its tutorial step: L1 two obvious free snakes, L2 the first "this one
first", L4 the first bend, L6 the first caterpillar, L7 longer bendy snakes,
L8 curvy routes, L9 think ahead (ramp/normal, no Hard in FTUE), L10 a calm
milestone.
```

## LV2: levels 11–20 (block 2, M001 Garden Rock)

```
Follow "Rules for every task" above.
Task: levels 11–20. Block 2: grid 6×6–7×7, 6–10 snakes, D 6–12, Hard L19
(≤ 13.2). New mechanic M001 Garden Rock (card M001).
A rock blocks any lane through it forever, so never put a rock in a snake's
exit lane. Use rocks to shape the board (boxing in space so snakes face
other ways and chains get longer). L11 intro: 1–2 rocks, 6×6, lowest D.
L15 breather is where the Shield tutorial plays; keep it calm.
```

## LV3: levels 21–60 (blocks 3–6)

```
Follow "Rules for every task" above.
Task: levels 21–60, one block at a time, in order.
- Block 3, L21–30: M002 Fallen Log (multi-cell wall). Grid 6–7, 6–10 snakes, D 6–12.
- Block 4, L31–40: M003 Frost Coil (frozen snake, thaws after k exits). Grid 6–7, 6–10 snakes, D 6–12.
- Block 5, L41–50: M004 Bamboo Cage & Key (lock opens when its key snake exits). Grid 6–8, 8–12 snakes, D 9–15.
- Block 6, L51–60: M005 Flower Gate (only same-colour snakes pass). Grid 6–8, 8–12 snakes, D 9–15.
Read each card fully, especially "Do / Don't" and "Hint / solver".
```

## LV4: levels 61–100 (blocks 7–10)

```
Follow "Rules for every task" above.
Task: levels 61–100, one block at a time, in order.
- Block 7, L61–70: M006 Bamboo One-Way. Grid 6–8, 8–12 snakes, D 9–15.
- Block 8, L71–80: M007 Lotus Bud Gate (counts moves; N mechanic). Grid 7–8, 10–14 snakes, D 12–18.
- Block 9, L81–90: M008 Rabbit Burrows (portal pair). Grid 7–8, 10–14 snakes, D 12–18.
- Block 10, L91–100: M009 Branch Lever & Twig Gates (tap lever = a move; N). Grid 7–8, 10–14 snakes, D 12–18.
  L100 milestone ≈ D 15 (the tier jump to L101 must stay small).
For move-counting and lever levels, write lever taps into "solution" by
obstacle id, and track every counter step by step.
```

## LV5: levels 101–150 (blocks 11–15, tier T2)

```
Follow "Rules for every task" above.
Task: levels 101–150, one block at a time, in order.
- Block 11, L101–110: M010 Jungle Mist. Grid 7–8, 10–14 snakes, D 14–20. L101 intro ≈ D 14–15.
- Block 12, L111–120: M011 Vine-Tied Twins. Grid 7–8, 10–14 snakes, D 14–20.
- Block 13, L121–130: M012 Sleepy Python. Grid 7–8, 10–14 snakes, D 14–20.
- Block 14, L131–140: M013 Spinning Lilypad (interactive; N). Grid 7–9, 12–16 snakes, D 17–23.
- Block 15, L141–150: M014 Mushroom Bumper (mirror). Grid 7–9, 12–16 snakes, D 17–23.
T2 obstacle cap: 6.
```

## LV6: levels 151–200 (blocks 16–20)

```
Follow "Rules for every task" above.
Task: levels 151–200, one block at a time, in order.
- Block 16, L151–160: M015 Root Bridge. Grid 7–9, 12–16 snakes, D 17–23.
- Block 17, L161–170: M016 Termite Mound (HP). Grid 7–9, 12–16 snakes, D 17–23.
- Block 18, L171–180: M017 Restless Caterpillar (countdown; N). Grid 8–9, 14–18 snakes, D 20–26.
- Block 19, L181–190: M018 Fern Fork Switch (N). Grid 8–9, 14–18 snakes, D 20–26.
- Block 20, L191–200: M019 Mossy Pressure Stone (N). Grid 8–9, 14–18 snakes, D 20–26.
```

## LV7: levels 201–250 (blocks 21–25, tier T3)

```
Follow "Rules for every task" above.
Task: levels 201–250, one block at a time, in order.
- Block 21, L201–210: M020 Home Burrow. Grid 8–9, 14–18 snakes, D 22–29.
- Block 22, L211–220: M021 Phantom Snake (parity; N). Grid 8–9, 14–18 snakes, D 22–29.
- Block 23, L221–230: M022 Reverse Slither. Grid 8–9, 14–18 snakes, D 22–29.
- Block 24, L231–240: M023 Two-Headed Hydra. Grid 8–10, 16–20 snakes, D 26–32.
- Block 25, L241–250: M024 Giant Anaconda. Grid 8–10, 16–20 snakes, D 26–32.
T3 obstacle cap: 8.
```

## LV8: levels 251–300 (blocks 26–30)

```
Follow "Rules for every task" above.
Task: levels 251–300, one block at a time, in order.
- Block 26, L251–260: M025 Patrolling Beetle (N). Grid 8–10, 16–20 snakes, D 26–32.
- Block 27, L261–270: M026 Jungle Gems (goal: set "goals":{"gems":K} to match). Grid 8–10, 16–20 snakes, D 26–32.
- Block 28, L271–280: M027 Creeping Vine (N). Grid 9–10, 18–22 snakes, D 29–36.
- Block 29, L281–290: M028 Hatch Order Snakes. Grid 9–10, 18–22 snakes, D 29–36.
- Block 30, L291–300: M029 Hedge Border. Grid 9–10, 18–22 snakes, D 29–36.
```

## LV9: levels 301–350 (blocks 31–35, tier T4)

```
Follow "Rules for every task" above.
Task: levels 301–350, one block at a time, in order.
- Block 31, L301–310: M030 Flower Arch Exit. Grid 9×9, 18–22 snakes, D 30–37.
- Block 32, L311–320: M031 Closing Hedge Gap (N). Grid 9×9, 18–22 snakes, D 30–37.
- Block 33, L321–330: M032 Canopy & Ground (2 layers: "layers":2, snakes on
  "layer":0 or 1). Grid 9×9, 18–22 snakes, D 30–37.
- Block 34, L331–340: M033 Petal Cage. Grid 9–10, 20–24 snakes, D 34–40.
- Block 35, L341–350: M034 Whirl Stump (interactive; N). Grid 9–10, 20–24 snakes, D 34–40.
T4 obstacle cap: 9.
```

## LV10: levels 351–400 (blocks 36–40)

```
Follow "Rules for every task" above.
Task: levels 351–400, one block at a time, in order.
- Block 36, L351–360: M035 Mama Snake (spawns a child snake; the child's id
  from params.child may appear in "solution"). Grid 9–10, 20–24 snakes, D 34–40.
- Block 37, L361–370: M036 Hungry Caterpillar. Grid 9–10, 20–24 snakes, D 34–40.
- Block 38, L371–380: M037 Sticky Swamp Mud. Grid 10×10, 22–26 snakes, D 37–44.
- Block 39, L381–390: M038 Bouncy Fern Pad. Grid 10×10, 22–26 snakes, D 37–44.
- Block 40, L391–400: M039 Pond Twins. Grid 10×10, 22–26 snakes, D 37–44.
```

## LV11: levels 401–450 (blocks 41–45, tier T5)

```
Follow "Rules for every task" above.
Task: levels 401–450, one block at a time, in order.
- Block 41, L401–410: M040 Jungle Night (visual; keep boards readable). Grid 10×10, 22–26 snakes, D 38–45.
- Block 42, L411–420: M041 Chameleon Snake (N). Grid 10×10, 22–26 snakes, D 38–45.
- Block 43, L421–430: M042 Dry Twig Bridge. Grid 10×10, 22–26 snakes, D 38–45.
- Block 44, L431–440: M043 Big Knot Cage. Grid 10–11, 24–28 snakes, D 42–48.
- Block 45, L441–450: M044 Twisty Burrow. Grid 10–11, 24–28 snakes, D 42–48.
T5 obstacle cap: 10. Max grid 11×11.
```

## LV12: levels 451–499 (blocks 46–50)

```
Follow "Rules for every task" above.
Task: levels 451–499, one block at a time, in order.
- Block 46, L451–460: M045 Root Gear Lever (N; params.turntables name lilypad ids in the level). Grid 10–11, 24–28 snakes, D 42–48.
- Block 47, L461–470: M046 Tail-Biter Loop. Grid 10–11, 24–28 snakes, D 42–48.
- Block 48, L471–480: M047 Growing Caterpillar (N). Grid 11×11, 26–30 snakes, D 45–52.
- Block 49, L481–490: M048 Snake Parade. Grid 11×11, 26–30 snakes, D 45–52.
- Block 50, L491–499: M049 Grumpy Mongoose (boss). Grid 11×11, 26–30 snakes, D 45–52.
  L491 clear shows "Boss ahead"; build up to the finale.
```

## LV13: L500 finale, "Mongoose King's Garden"

```
Follow "Rules for every task" above.
Task: level 500 only. Follow 02 §8 exactly: 11×11, 1 layer, 30 snakes
(6 caterpillars), 10 obstacle instances = Mongoose King (M049, 3×3 at
(4,4)–(6,6), 6 linked snakes) + the 9 listed mechanics (M004, M009, M010,
M013, M016, M020, M026 with 3 gems, M028, M041), slot/tag finale,
D ≈ 62 (±3), par ≈ 34. Build the 3 acts in §8.2: outer ring → middle ring
→ core.
```
