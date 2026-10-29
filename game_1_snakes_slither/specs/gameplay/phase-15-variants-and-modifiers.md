# Technical Specification: Phase 15 Variants and Modifiers (River Delta)

**Status:** Draft  
**Phase:** 15 (Levels 7001–7500)  
**Theme:** River Delta (Conveyors & Tracks)  
**Document Type:** Technical Specification  
**Source Cross-Reference:** [phases/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md](../../phases/phase_15/04_VARIANTS_AND_MODIFIERS_PHASE_15.md), [SHARED_CORE_STANDARD.md §17.38](../../SHARED_CORE_STANDARD.md)

---

## 1. Modifier Catalog (MOD-01 through MOD-10)

Phase 15 applies 10 systematic modifiers to the 4 base conveyor mechanics across 45 unique variants:
- **MOD-01 (Multi-Stage):** 3-way branching, triple cascades, or multi-phase circuits.
- **MOD-02 (Directional / Polarized):** One-way entry channels, strict cardinal alignment.
- **MOD-03 (Color-Coded):** Color-matched conveyor streams accessible only by identical colored snakes.
- **MOD-04 (Move Countdown):** Timed switches or decaying currents expiring in $N$ turns.
- **MOD-05 (Turbo Conveyor):** High-velocity torrent carrying snakes 2 tiles per turn.
- **MOD-06 (Inverted Tide):** Counter-current flowing opposite to neighboring waterways.
- **MOD-07 (Paired Levers):** Synchronously linked levers toggling dual sluices simultaneously.
- **MOD-08 (Rotating Junction):** Rotary turntable tile shifting $90^\circ$ after each move.
- **MOD-09 (Ice-To-Belt Slide):** Hybrid ice entry boosting velocity into conveyor entry.
- **MOD-10 (Obstacle Guarded):** Heavy reeds, brambles, or boulders flanking conveyor channels.

---

## 2. Complete 45 Variants Catalog (Blocks 703 to 750)

| Variant # | Block | Intro Level (x1) | Base Mechanic | Modifier | Variant Name & Mechanics Summary |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 703 | 7021 | M701 | MOD-01 | **Tri-Fork Junction:** 3-way branching switch (North, East, South). |
| **V02** | 704 | 7031 | M701 | MOD-03 | **Chroma Junction:** Conveyor branch paths filterable by snake color. |
| **V03** | 705 | 7041 | M701 | MOD-04 | **Timed Switch:** Switch resets to default orientation every 4 moves. |
| **V04** | 706 | 7051 | M701 | MOD-05 | **Rapid Junction:** Turbo current launches snake 2 tiles past junction. |
| **V05** | 707 | 7061 | M701 | MOD-09 | **Icy Fork:** Slippery approach tile prevents stopping before junction. |
| **V06** | 708 | 7071 | M701 | MOD-10 | **Muddy Junction:** Mud patch reduces conveyor slide velocity. |
| **V07** | 709 | 7081 | M701 | MOD-07 | **Dual Linked Switches:** Tapping one switch mirrors state on secondary fork. |
| **V08** | 710 | 7091 | M701 | MOD-08 | **Auto-Revolving Fork:** Switch rotates $90^\circ$ clockwise automatically each turn. |
| **V09** | 711 | 7101 | M701 | MOD-02 | **One-Way Entry Fork:** Conveyor gate prevents upstream back-flow. |
| **V10** | 712 | 7111 | M701 | MOD-06 | **Inverse Switch:** Directs current in reverse direction when toggled. |
| **V11** | 713 | 7121 | M701 | MOD-01 | **Cascade Switches:** Series of 3 contiguous forks requiring chained routing. |
| **V12** | 715 | 7141 | M702 | MOD-05 | **Rapid Tide:** High-frequency tide reversing every 2 moves. |
| **V13** | 716 | 7151 | M702 | MOD-03 | **Color Tide:** Alternating blue/red currents carrying matching snakes. |
| **V14** | 717 | 7161 | M702 | MOD-01 | **Dual Phase Tides:** Two parallel rivers alternating out of sync. |
| **V15** | 718 | 7171 | M702 | MOD-04 | **Predictable Tide:** Visible move ticker displaying exact flip step. |
| **V16** | 719 | 7181 | M702 | MOD-09 | **Glacier Tide:** Icy river bank propelling snakes along tidal flow. |
| **V17** | 720 | 7191 | M702 | MOD-10 | **Bramble-Guarded Tide:** Thorny obstacles lining tidal river banks. |
| **V18** | 721 | 7201 | M702 | MOD-07 | **Cross-Tide Interlock:** Perpendicular rivers with alternating cross-flow. |
| **V19** | 722 | 7211 | M702 | MOD-08 | **Rotating Tide River:** Tidal flow pivots $90^\circ$ rather than $180^\circ$. |
| **V20** | 723 | 7221 | M702 | MOD-02 | **North-South Surge:** Strict vertical tidal surges between delta walls. |
| **V21** | 724 | 7231 | M702 | MOD-06 | **Counter-Current:** Opposing double currents forcing squeeze navigation. |
| **V22** | 725 | 7241 | M702 | MOD-01 | **Grand Delta Surge:** Massive 4-lane delta surge spanning entire board. |
| **V23** | 727 | 7261 | M703 | MOD-01 | **Triple Sluice Array:** 3 sequential sluices requiring coordinated order. |
| **V24** | 728 | 7271 | M703 | MOD-03 | **Chroma Sluice Gate:** Colored gates opening only via colored keys/snakes. |
| **V25** | 729 | 7281 | M703 | MOD-04 | **Decaying Sluice Gate:** Open gate closes automatically after 3 moves. |
| **V26** | 730 | 7291 | M703 | MOD-05 | **High-Pressure Sluice:** Rushing torrent pushes 2 tiles upon opening. |
| **V27** | 731 | 7301 | M703 | MOD-09 | **Ice-Locked Sluice:** Sluice handle frozen until thawed or struck. |
| **V28** | 732 | 7311 | M703 | MOD-10 | **Obstacle Sluice:** Gate guarded by breakable rock walls. |
| **V29** | 733 | 7321 | M703 | MOD-07 | **Dual Linked Sluices:** Master lever opening Gate A and closing Gate B. |
| **V30** | 734 | 7331 | M703 | MOD-08 | **Rotating Sluice Paddle:** Rotary water wheel toggling flow every move. |
| **V31** | 735 | 7341 | M703 | MOD-02 | **Unidirectional Sluice:** Water flows in one direction only when raised. |
| **V32** | 736 | 7351 | M703 | MOD-06 | **Reverse Sluice Gate:** Draining one channel floods adjacent canal. |
| **V33** | 737 | 7361 | M703 | MOD-01 | **Delta Canal Network:** Multi-branch canal regulated by 4 interconnected sluices. |
| **V34** | 739 | 7381 | M704 | MOD-01 | **Figure-Eight Vortex:** Interlocking dual whirlpools with center cross-point. |
| **V35** | 740 | 7391 | M704 | MOD-03 | **Chroma Whirlpool:** Colored vortex capturing only matching snakes. |
| **V36** | 741 | 7401 | M704 | MOD-04 | **Collapsing Vortex:** Whirlpool shrinks by 1 tile every 5 moves. |
| **V37** | 742 | 7411 | M704 | MOD-05 | **Centrifugal Whirlpool:** High-velocity rotation carrying 2 nodes/turn. |
| **V38** | 743 | 7421 | M704 | MOD-09 | **Glacial Eddy:** Frozen outer edge trapping snake until spun free. |
| **V39** | 744 | 7431 | M704 | MOD-10 | **Reef-Lined Whirlpool:** Coral reefs lining perimeter causing hazard on wrong exit. |
| **V40** | 745 | 7441 | M704 | MOD-07 | **Synchronized Whirlpools:** Twin counter-rotating whirlpools exchanging snakes. |
| **V41** | 746 | 7451 | M704 | MOD-08 | **Pivoting Vortex Exit:** Tangent exit route shifts $90^\circ$ each turn. |
| **V42** | 747 | 7461 | M704 | MOD-02 | **Exit-Only Whirlpool:** Entrance allowed only during specific tidal window. |
| **V43** | 748 | 7471 | M704 | MOD-06 | **Counter-Vortex:** Clockwise and counter-clockwise layered rings. |
| **V44** | 749 | 7481 | M704 | MOD-01 | **Maelstrom Nexus:** Triple vortex feeding central river estuary. |
| **V45** | 750 | 7491 | M704 | MOD-10 | **Grand Delta Finale Gauntlet:** Master combination of M701-M704 on $14 \times 14$ grid. |

---

## 3. References & Cross-Links
- [Phase 15 Base Mechanics](phase-15-base-mechanics.md)
- [Phase 15 Level Plan](phase-15-level-plan-07001-07500.md)
- [Shared Core Standard §17.38](../../SHARED_CORE_STANDARD.md)

