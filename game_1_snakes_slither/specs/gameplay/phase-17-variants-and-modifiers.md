# Technical Specification: Phase 17 Variants and Modifiers (Mongoose Clan)

**Status:** Draft  
**Phase:** 17 (Levels 8001–8500)  
**Theme:** Mongoose Clan (Guardians)  
**Document Type:** Technical Specification  
**Source Cross-Reference:** [phases/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md](../../phases/phase_17/04_VARIANTS_AND_MODIFIERS_PHASE_17.md), [SHARED_CORE_STANDARD.md §17.38](../../SHARED_CORE_STANDARD.md)

---

## 1. Modifier Catalog (MOD-01 through MOD-10)

Phase 17 applies 10 systematic modifiers to the 4 base guardian mechanics across 45 unique variants:
- **MOD-01 (Multi-Stage):** 3-guardian clans (Tri-Mongoose), multi-phase HP bars.
- **MOD-02 (Directional / Polarized):** Strict cardinal entry angles and polarized attack shields.
- **MOD-03 (Color-Coded):** Color-matched guardians damaged only by same-colored snakes.
- **MOD-04 (Move Countdown):** Enraged guardian timer adding extra rocks or enrage buff after $N$ turns.
- **MOD-05 (Speed / Rapid Strike):** Double damage strike or high-frequency turn checks.
- **MOD-06 (Inverted Shield):** Lever toggling shield on one guardian while lowering another.
- **MOD-07 (Paired Spawners):** Two Mama Mongooses alternating spawn turns.
- **MOD-08 (Shifting Den):** Guardian burrow relocation every 3 turns.
- **MOD-09 (Ice Slide Guardian):** Guardian stationed on slippery ice pond rink.
- **MOD-10 (Obstacle Guarded):** Heavy stone sentinels and trenches surrounding guardian lair.

---

## 2. Complete 45 Variants Catalog (Blocks 803 to 850)

| Variant # | Block | Intro Level (x1) | Base Mechanic | Modifier | Variant Name & Mechanics Summary |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 803 | 8021 | M801 | MOD-03 | **Chroma Twins:** Twin A takes damage from Blue snakes; Twin B from Red. |
| **V02** | 804 | 8031 | M801 | MOD-01 | **Tri-Mongoose Clan:** 3 linked guardians sharing 9 HP pool. |
| **V03** | 805 | 8041 | M801 | MOD-04 | **Restless Twins:** Twins relocate to new burrows every 5 moves. |
| **V04** | 806 | 8051 | M801 | MOD-05 | **Furious Twins:** Critical exit lane deals 2 HP damage instead of 1. |
| **V05** | 807 | 8061 | M801 | MOD-09 | **Glacier Twins:** Sliding ice surround makes positioning snakes tricky. |
| **V06** | 808 | 8071 | M801 | MOD-10 | **Muddy Burrow Twins:** Mud pits slow snake transit between twin zones. |
| **V07** | 809 | 8081 | M801 | MOD-07 | **Dual Lever Twins:** Twin shields linked to dual synchronized levers. |
| **V08** | 810 | 8091 | M801 | MOD-08 | **Rotating Guardian Fort:** Fort defenses rotate $90^\circ$ each turn. |
| **V09** | 811 | 8101 | M801 | MOD-02 | **Flanked Twins:** Only side exits register damage; frontal exits blocked. |
| **V10** | 812 | 8111 | M801 | MOD-06 | **Inverse Twins:** Damaging Twin A heals Twin B unless hit in quick succession. |
| **V11** | 813 | 8121 | M801 | MOD-01 | **Clan Patriarchs:** 4 interconnected guardians guarding four corners. |
| **V12** | 815 | 8141 | M802 | MOD-01 | **Tri-Shield Armadillo:** 3 layered crystalline shields requiring 3 lever hits. |
| **V13** | 816 | 8151 | M802 | MOD-03 | **Prismatic Shield:** Shield color changes with each lever tap. |
| **V14** | 817 | 8161 | M802 | MOD-04 | **Timed Armadillo Shield:** Lever automatically reactivates after 2 moves. |
| **V15** | 818 | 8171 | M802 | MOD-07 | **Twin Shield Bastion:** Two armadillos shielding each other's levers. |
| **V16** | 819 | 8181 | M802 | MOD-05 | **Overheated Shield:** Lowering shield grants temporary +1 move speed. |
| **V17** | 820 | 8191 | M802 | MOD-10 | **Bramble-Covered Lever:** Shield lever encased in breakable thorns. |
| **V18** | 821 | 8201 | M802 | MOD-08 | **Mobile Shield Carrier:** Armadillo patrols back and forth along trench. |
| **V19** | 822 | 8211 | M802 | MOD-09 | **Ice-Lock Lever:** Lever handle frozen on ice requiring snake push to toggle. |
| **V20** | 823 | 8221 | M802 | MOD-02 | **Directional Shield:** Armadillo shields front $180^\circ$ only; back exposed. |
| **V21** | 824 | 8231 | M802 | MOD-06 | **Reciprocal Shield:** Lowering Armadillo shield raises secondary gate. |
| **V22** | 825 | 8241 | M802 | MOD-01 | **Mongoose Outpost Citadel:** Dual armadillos + twin mongooses combined. |
| **V23** | 827 | 8261 | M803 | MOD-01 | **Twin Mama Spawners:** Two mothers spawning rocks on alternating cadence. |
| **V24** | 828 | 8271 | M803 | MOD-03 | **Chroma Rock Spawner:** Drops color-tinted rocks breakable only by same snakes. |
| **V25** | 829 | 8281 | M803 | MOD-04 | **Enraged Spawner:** Spawns rocks every 2 moves if HP falls below 50%. |
| **V26** | 830 | 8291 | M803 | MOD-05 | **Rolling Rock Spawner:** Spawned rocks roll 2 tiles before coming to rest. |
| **V27** | 831 | 8301 | M803 | MOD-09 | **Glacial Spawner:** Rocks slide on ice until hitting a wall. |
| **V28** | 832 | 8311 | M803 | MOD-10 | **Canyon Den Spawner:** Mama mongoose situated in deep walled ravine. |
| **V29** | 833 | 8321 | M803 | MOD-07 | **Sluice-Linked Spawner:** Spawned rocks carried down sluice canals. |
| **V30** | 834 | 8331 | M803 | MOD-08 | **Pivoting Spawner Nest:** Spawner rotates throw angle $90^\circ$ clockwise. |
| **V31** | 835 | 8341 | M803 | MOD-02 | **Narrow Trench Spawner:** Spawns exclusively along central corridor. |
| **V32** | 836 | 8351 | M803 | MOD-06 | **Recycle Spawner:** Defeating a rock immediately grants 1 free booster point. |
| **V33** | 837 | 8361 | M803 | MOD-01 | **Broodmother Matriarch:** Massive 12 HP spawner controlling 3 nests. |
| **V34** | 839 | 8381 | M804 | MOD-01 | **Tri-Core Sanctuary:** 3 cores requiring simultaneous destruction. |
| **V35** | 840 | 8391 | M804 | MOD-03 | **Chroma Core:** Core vulnerability cycles through Blue $\to$ Red $\to$ Green. |
| **V36** | 841 | 8401 | M804 | MOD-04 | **Overheating Core:** Core explodes clearing all obstacles after 12 moves. |
| **V37** | 842 | 8411 | M804 | MOD-05 | **Surge Core:** Critical strike triggers board-wide shockwave. |
| **V38** | 843 | 8421 | M804 | MOD-09 | **Ice Vault Core:** Core surrounded by frozen moat. |
| **V39** | 844 | 8431 | M804 | MOD-10 | **Bunker Core:** Heavy iron bastions shielding all 4 quadrants. |
| **V40** | 845 | 8441 | M804 | MOD-07 | **Interlocked Cores:** Core A and Core B must be damaged in strict rotation. |
| **V41** | 846 | 8451 | M804 | MOD-08 | **Revolving Fortress Core:** Weak-point aperture rotates $90^\circ$ each turn. |
| **V42** | 847 | 8461 | M804 | MOD-02 | **Pinpoint Aperture Core:** Only extreme diagonal exit routes reach core. |
| **V43** | 848 | 8471 | M804 | MOD-06 | **Phase-Shift Core:** Alternates between physical and ethereal states. |
| **V44** | 849 | 8481 | M804 | MOD-01 | **Den of the Clan Nexus:** Multi-room fortress with central command core. |
| **V45** | 850 | 8491 | M804 | MOD-10 | **Grand Mongoose Clan Finale:** Supreme multi-guardian gauntlet on $14 \times 14$ grid. |

---

## 3. References & Cross-Links
- [Phase 17 Base Mechanics](phase-17-base-mechanics.md)
- [Phase 17 Level Plan](phase-17-level-plan-08001-08500.md)
- [Shared Core Standard §17.38](../../SHARED_CORE_STANDARD.md)
