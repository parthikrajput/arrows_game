Source docs: phase_1/03_OBSTACLE_CATALOG_PHASE_1.md, ../../SHARED_CORE_STANDARD.md

# Spec: Obstacle and Mechanics Catalog Phase 1 (M001–M049) (Toy Trains)

## Status
Draft

## Type
New Feature

## Goal
Implement the complete catalog of 49 railway-themed puzzle mechanics (M001–M049) and the L500 Grand Central Finale for Toy Trains Phase 1, specifying collision rules, tick order, hammerability, JSON definitions, and solver integration.

## Current State
Design documented in phase_1/03_OBSTACLE_CATALOG_PHASE_1.md and ../../SHARED_CORE_STANDARD.md, not yet implemented.
- 49 mechanics mapped 1:1 to the shared mechanics library M001–M049.
- Every mechanic unlocks at `L(10k + 1)` (L11, L21 ... L491).
- Turn-based only: all timed obstacles count Moves, not wall-clock time.
- No forced-damage obstacles: all levels are 100% solvable with 0 hearts lost and 0 boosters.

## Proposed Change
Implement individual mechanic classes and collision handlers in `packages/puzzle_core/lib/src/mechanics/`:

### 1. Mechanic Catalog Table
| ID | Themed Name | Intro | Cat | Exact Gameplay Rule | Hammerable (Track Crane) |
|---|---|---|---|---|---|
| **M001** | Buffer Stop | L11 | B | 1 cell; blocks exit lane. Train bumps buffer and takes −1 heart. | Yes |
| **M002** | Cargo Crate Row | L21 | B | 2–4 contiguous cells; acts as a solid wooden wall blocking lanes. | Yes (destroys full row) |
| **M003** | Snowed-In Train | L31 | C | Train locked under snow until K (1–3) orthogonal neighbours exit; badge shows remaining K. | n/a (train: crane removes) |
| **M004** | Ticket & Barrier | L41 | K | Ticket icon on a train; matching-colour barrier gate blocks track until ticket-train exits, then permanently opens. | No |
| **M005** | Colour Platform Gate | L51 | B | Platform gate passable only by trains matching gate colour; all other colours bump. | No |
| **M006** | One-Way Rail | L61 | D | Track passable only in painted arrow direction; opposing or orthogonal entries bump. | No |
| **M007** | Level Crossing | L71 | C | Closed barrier gate opens permanently after N Moves (badge shows countdown N; ticks in Step 3). | No |
| **M008** | Tunnel Pair | L81 | D | Lane entering portal A instantly emerges from portal B maintaining the same heading. If exit portal B is occupied, entry blocks. | No |
| **M009** | Signal Lever & Semaphores | L91 | T | Tapping lever (1 Move) flips all linked semaphore gates between open and closed states. Non-monotone. | No |
| **M010** | Steam Cloud | L101 | C | Dense steam conceals and locks trains beneath it. Clears permanently when any train touching the cloud exits. | No |
| **M011** | Coupled Engines | L111 | P | 2 trains linked by coupling rod. Tapping either commands both to depart; both lanes must be clear or both bump (−1 heart total). | n/a (train: crane removes) |
| **M012** | Cold Engine | L121 | P | Cold boiler: first tap fires boiler and wakes engine (1 Move); second tap departs. | n/a (train: crane removes) |
| **M013** | Turntable | L131 | T | Engine resting on turntable: tapping turntable rotates that train 90° clockwise (1 Move). If engine faces own car, marked "tangled" (locked tap). | No |
| **M014** | Curve Rail | L141 | D | Curved track segment (`/` or `\`); turns traversing exit lane by 90°. | No |
| **M015** | Wooden Overpass | L151 | L | Bridge overpass. Trains travelling on the overpass do not block perpendicular tracks passing beneath. | No |
| **M016** | Rock Pile | L161 | C | Track obstruction with 1–3 HP; loses 1 HP each time an exiting train passes an adjacent orthogonal cell. Removed at 0 HP. | Yes |
| **M017** | Steam Pressure Train | L171 | C | Boiler pressure gauge: must exit within N Moves. Reaching 0 Move countdown costs 1 Heart and resets gauge to N. | n/a (train: crane removes) |
| **M018** | Track Switch | L181 | T | Junction point diverts lane left or right based on switch lever; tapping switch toggles routing (1 Move). | No |
| **M019** | Weighbridge Plate | L191 | T | Pressure plate holds linked gate open while covered by any train car. Gate closes when train completely exits plate. | No |
| **M020** | Engine Shed | L201 | G | Internal board building functioning as an exit depot; lanes reaching the shed entrance depart safely inside. | No |
| **M021** | Phantom Express | L211 | P | Spectral locomotive: solid physical blocker on even move counts; ethereal ghost (passable, non-interactive) on odd counts. | n/a (train: crane removes) |
| **M022** | Shunting Train | L221 | P | Shunting engine that departs backwards (tail-first). Visual reverse-arrow cue on caboose. | n/a (train: crane removes) |
| **M023** | Push-Pull Train | L231 | P | Engine cabs at both ends. Tapping near either end departs in that direction. Middle tap defaults to `body[0]`. | n/a (train: crane removes) |
| **M024** | Wide Load Freight | L241 | P | Oversized cargo 2 cells wide; requires a 2-cell-wide clear corridor to exit. | n/a (train: crane removes) |
| **M025** | Handcar Patrol | L251 | C | Maintenance handcar patrols a fixed track circuit 1 cell per Move, blocking its occupied cell. | Yes |
| **M026** | Mail Sack Pickup | L261 | G | Mail sacks on track. Level win condition requires collecting all sacks (lane traversing sack collects it). | No |
| **M027** | Creeping Ivy | L271 | C | Invasive ivy: expands 1 cell into first available free neighbour every N Moves (fixed order: Up, Right, Down, Left). | Yes (removes 1 cell) |
| **M028** | Timetable Order | L281 | P | Numbered trains that must depart in strict ascending timetable sequence (1, 2, 3...). Out-of-order tap produces locked tap. | n/a (train: crane removes) |
| **M029** | Table Edge Fence | L291 | B | Wooden fencing along table edges. Lanes directed into fence bounce buffer clack (−1 heart). | No |
| **M030** | Colour Station Exit | L301 | B | Edge exit depot that accepts only trains matching its livery colour. Mismatched train bumps. | No |
| **M031** | Last Call Exit | L311 | C | Temporary depot exit opening that closes permanently after N Moves (countdown badge N). | No |
| **M032** | Viaduct Deck | L321 | L | Two-layer elevated railway. Upper deck trains occlude and lock lower trains underneath; lanes interact only within same layer. | No |
| **M033** | Locked Siding | L331 | K | Siding corral holding a train locked until all other trains of matching colour have departed. | No |
| **M034** | Rotating Yard 2×2 | L341 | T | 2×2 turntable yard: tapping hub rotates entire 2×2 area and fully contained trains 90° clockwise (1 Move). | No |
| **M035** | Depot Dispatcher | L351 | P | Master locomotive: upon departing, immediately dispatches a 2-car tender from marked depot tracks. | n/a (train: crane removes) |
| **M036** | Coal Tender | L361 | P | Steam engine that cannot depart unless its exit lane traverses a coal bunker cell (consumes coal). | n/a (train: crane removes) |
| **M037** | Sand Drift | L371 | D | Sand trap on track: lane reaching sand halts train immediately (relocates body, 1 Move). Next tap continues from sand. | No |
| **M038** | Junction Signal | L381 | B | Alternating signal gate: swaps between open and closed state on every player Move. | No |
| **M039** | Convoy Train | L391 | P | Multi-section convoy: 3 connected trains spaced apart. Tapping one commands all 3 to depart in unison. | n/a (train: crane removes) |
| **M040** | Trestle Bridge | L401 | C | Fragile wooden trestle: collapses into an empty void after K (1–2) trains cross over it. | No |
| **M041** | Windmill Signal | L411 | C | Rotating mechanical arms: cycles blocker orientation clockwise every Move. | No |
| **M042** | Repair Siding | L421 | C | Broken barrier gate: requires 2 adjacent train departures or Track Crane hit to clear. | Yes |
| **M043** | Interlocking Signal | L431 | K | Multi-key signal box: requires collecting K distinct ticket keys before master barrier unlocks. | No |
| **M044** | Bend Tunnel | L441 | D | Curved portal: lane enters along one axis and emerges at exit portal heading in a perpendicular direction. | No |
| **M045** | Master Gear Lever | L451 | T | Multi-state gear lever: cycling through 3 positions adjusts different combinations of track gates. | No |
| **M046** | Loop Line Train | L461 | P | Closed circular ring of carriages. Cannot depart until linked ticket train departs; then straightens toward designated exit. | n/a (train: crane removes) |
| **M047** | Auto-Coupler Freight | L471 | P | Heavy freight train that couples onto any train it bumps or gains carriages every N moves if unmanaged. | n/a (train: crane removes) |
| **M048** | Twin Steamers | L481 | P | Mirrored locomotive pair: moving one drives the other simultaneously across the board's mirror axis. | n/a (train: crane removes) |
| **M049** | Clock Tower Guardian | L491 | C | Boss obstacle at center with 3–5 HP. Each departing train lane grazing an adjacent cell deducts 1 HP. Vanishes at 0 HP. | No (not hammerable) |
| **L500** | Grand Central Finale | L500 | Boss | Phase Finale combining Clock Tower Guardian, interlocking switch yards, ticket barriers, and dual turntables. | Boss level rules |

### 2. Track Crane (Hammer) Enforcement
- **Targeting Trains:** Track Crane can lift and remove any train from the board. This counts as a departure for non-lane state dependencies (thaws M003 Snowed-In counters, decrements M049 Guardian HP, clears M010 Steam Clouds, triggers M004 Ticket Barriers, and unlocks M033 Sidings). Lane-traversal effects (collecting M026 Mail Sacks, consuming M036 Coal) do NOT trigger.
- **Safety Restriction:** Track Crane is disabled on the final train if uncollected Mail Sacks remain on the board.
- **Targeting Obstacles:** Destroys hammerable blockers (M001, M002, M016, M025, M027, broken M042). Track Crane cannot target Clock Tower Guardian (M049), Table Edge Fences (M029), Ticket Barriers (M004), or interactive levers/turntables.

### 3. Level JSON Schema (v3)
Each mechanic instance resides in `mechanics[]`:
```json
{
  "id": "m1",
  "type": "M004",
  "cells": [[4, 2]],
  "params": {
    "keyPathId": "train_red_1",
    "color": "red"
  },
  "hammerable": false
}
```

### 4. Color-Blind Compliance
All color-dependent mechanics (Ticket Barriers M004/M043, Platform Gates M005, Station Exits M030, Locked Sidings M033) pair colors with distinct geometric shapes:
- Red: Circle ●
- Blue: Triangle ▲
- Yellow: Square ■
- Green: Diamond ◆
- Purple: Star ★
- Orange: Cross ✚
- Teal: Pentagon ⬟
- Pink: Heart ♥

## Affected Files
- `packages/puzzle_core/lib/src/mechanics/mechanic_base.dart` (to be created)
- `packages/puzzle_core/lib/src/mechanics/m001_buffer_stop.dart` through `m049_clock_tower_guardian.dart` (to be created)
- `packages/puzzle_core/test/mechanics/mechanic_test.dart` (to be created)

## Risks
- Interactions between M013 Turntables, M018 Switches, and M008 Tunnels must resolve without circular pointer loops.
- Handcar Patrol (M025) and Creeping Ivy (M027) step execution must strictly follow Step 3 tick order.

## Open Questions
- None. Catalog reflects phase_1/03 and SHARED_CORE_STANDARD.md.
