# Level tasks (level agent: Antigravity)

Give these to Antigravity one at a time, with the `game_1_snakes_slither` folder open. Do **LV1 first**.
The engine plays clean boards and **M001 Garden Rock** today. Later blocks come once each mechanic is in the engine.

---

## LV1 — FTUE levels 1–10

```
Read AGENTS.md first and follow the "Level agent" rules strictly.

Task: design Phase 1 levels 1–10 in assets/levels/phase_1.json.
Source of truth: phases/phase_1/02_LEVEL_PROGRESSION_0001_0500.md §2–§4
(the FTUE table in §4 gives each level's grid, snake count, chain C,
optimal moves, D, slot and tag) and phases/phase_1/01_GAME_CONCEPT_AND_RULES.md
§4–§5 (board and snake rules).

The file already has L1–L5 as starter levels that pass the checker. Keep them
or improve them, and add L6–L10.

Format (schema v3, one object per level inside "levels"):
{"schema":3,"level":6,"phase":1,"seed":"0x0000000000000006",
 "slot":"ramp","tag":"normal","grid":[6,6],"layers":1,"hearts":3,
 "paths":[{"id":"p1","color":"green","dir":"R","body":[[2,1],[1,1]],
           "layer":0,"mods":{}}, ...],
 "mechanics":[], "goals":{"gems":0},
 "par_moves":6, "difficulty":6.6, "solution":["p3","p1", ...]}
- body[0] is the HEAD; coordinates are [x, y], x right, y down, from 0.
- dir is the way the head faces: U, D, L or R. A snake exits in a straight
  line from its head to the board edge; any snake in that line blocks it.
- A body must be connected cell to cell (no diagonals), 2–4 cells long in
  FTUE, and must not face back into its own neck.
- Caterpillar skin: "mods": {"skin": "caterpillar"} (0–40% of snakes).
- Use all 8 colours (red, green, blue, yellow, purple, orange, pink, teal);
  avoid two same-colour snakes touching.
- "solution": path ids in a tap order that clears the board with no bonks.
  "par_moves" = number of steps. "difficulty" = the D the checker prints.
- Hit each level's target from the §4 table: grid, snake count, chain C, D.
  C = longest "must leave before" chain in links (all free = 0).
- Make it feel like the tutorial steps in §4: L1 two obvious free snakes,
  L2 the first "this one first" order, L4 the first bend, L6 the first
  caterpillar, L7 longer bendy snakes, L8 curvy routes, L9 think ahead,
  L10 a calm milestone.

Check: dart run packages/puzzle_core/bin/validate_levels.dart
Done when every level shows ✓ and `flutter test` passes. Don't edit any
other file. If a rule seems impossible, write it in handoff/CHANGE_REQUESTS.md.
```

---

## LV2 — Block 2: levels 11–20 (M001 Garden Rock)

```
Read AGENTS.md first and follow the "Level agent" rules strictly. LV1 is done.

Task: add levels 11–20 to assets/levels/phase_1.json.
Sources: phases/phase_1/02_LEVEL_PROGRESSION_0001_0500.md §3 (10-level block
pattern), §6 (intro rules), §7 block 2 row (grid 6×6–7×7, 6–10 snakes,
D band 6–12, first Hard = L19, Gift Basket at L20), and the M001 Garden Rock
card in phases/phase_1/03_OBSTACLE_CATALOG_PHASE_1.md.

Garden Rock in the file:
{"id":"o1","type":"M001","cells":[[3,2]],"params":{"variant":1},"hammerable":true}
- One cell each. A rock blocks any lane that passes through it, forever.
  So a rock must never sit in a snake's exit lane, or that snake can never
  leave (the checker rejects it). Use rocks to shape the board, for example
  boxing in space so snakes must face other ways and form longer "this one
  first" chains. Don't drop them in unused corners.
- Every level in this block has at least 1 rock. L11 (intro) has 1–2 rocks
  and the lowest difficulty of the block (6×6 grid).
- Ids: snakes p1, p2, …; rocks o1, o2, … (all ids unique in a level).

Block pattern (the checker enforces slot and tag):
L11 intro/normal (low D) · L12–14 practice/normal (low → mid) ·
L15 breather/easy (low; the Shield tutorial plays here) ·
L16–18 ramp/normal (mid → high) · L19 hard/hard (top of band, up to 13.2) ·
L20 milestone/normal (mid).
D = 0.6·P + 1.5·C + 2.0·O (O = rock count). Aim inside 6–12.

Check: dart run packages/puzzle_core/bin/validate_levels.dart
Done when L1–L20 all show ✓ and `flutter test` passes.
```

---

## Next blocks
L21+ needs M002 Fallen Log, M003 Frost Coil and so on. The logic agent adds each mechanic to the engine and the checker, then adds a task here.
