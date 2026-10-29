# Technical Specification: Phase 16 Variants and Modifiers (Treasure Keys)

**Status:** Draft  
**Phase:** 16 (Levels 7501–8000)  
**Theme:** Treasure Keys (Keys Deluxe)  
**Document Type:** Technical Specification  
**Source Cross-Reference:** [phases/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md](../../phases/phase_16/04_VARIANTS_AND_MODIFIERS_PHASE_16.md), [SHARED_CORE_STANDARD.md §17.38](../../SHARED_CORE_STANDARD.md)

---

## 1. Modifier Catalog (MOD-01 through MOD-10)

Phase 16 applies 10 systematic modifiers to the 4 base key mechanics across 45 unique variants:
- **MOD-01 (Multi-Stage):** 3-part key crafting (Tri-Key), multi-tiered vine cascades.
- **MOD-02 (Directional / Polarized):** One-way locks only accepting keys inserted from specific cardinal angles.
- **MOD-03 (Color-Coded):** Strict color alignment matching key hues to gate locks.
- **MOD-04 (Rusting Key Timer):** Key oxidizes and vanishes if uncollected/unused within $N$ moves.
- **MOD-05 (Speed / Rapid Craft):** Immediate auto-teleport or instant speed unlock upon forge.
- **MOD-06 (Inverted Key):** Key locks open gate rather than unlocking closed barrier.
- **MOD-07 (Paired Swap Stones):** Linked tele-pedestals swapping keys between two distant board points.
- **MOD-08 (Shifting Pedestal):** Pedestal moves 1 tile along track every $N$ turns.
- **MOD-09 (Ice Slide Carrier):** Key rests on ice requiring directional glide to grab.
- **MOD-10 (Obstacle Guarded):** Dense bramble or rock barriers shielding key fragments.

---

## 2. Complete 45 Variants Catalog (Blocks 753 to 800)

| Variant # | Block | Intro Level (x1) | Base Mechanic | Modifier | Variant Name & Mechanics Summary |
| :---: | :---: | :---: | :---: | :---: | :--- |
| **V01** | 753 | 7521 | M751 | MOD-01 | **Tri-Chain Vines:** 3-link sequential cascade of tethered gates. |
| **V02** | 754 | 7531 | M751 | MOD-03 | **Chroma Key Vine:** Colored vine matching specific colored key to release. |
| **V03** | 755 | 7541 | M751 | MOD-04 | **Rusting Chain:** Vine lock withers and hard-locks after 8 moves if untouched. |
| **V04** | 756 | 7551 | M751 | MOD-05 | **Rapid Chain:** Vine snaps instantly releasing 2 keys simultaneously. |
| **V05** | 757 | 7561 | M751 | MOD-09 | **Glacier Key Vine:** Vine releases key onto slippery ice patch. |
| **V06** | 758 | 7571 | M751 | MOD-10 | **Muddy Chain:** Mud patch slows transit to released vine key. |
| **V07** | 759 | 7581 | M751 | MOD-07 | **Dual Branching Chain:** 1 master lock unspools 2 distinct vine pathways. |
| **V08** | 760 | 7591 | M751 | MOD-08 | **Rotating Vine Lock:** Lock gate pivots orientation $90^\circ$ each turn. |
| **V09** | 761 | 7601 | M751 | MOD-02 | **One-Way Vine Lock:** Gate keyhole accessible only from East entry. |
| **V10** | 762 | 7611 | M751 | MOD-06 | **Inverse Chain:** Unlocking gate closes secondary escape gate. |
| **V11** | 763 | 7621 | M751 | MOD-01 | **Master Key Cascade:** 4-tier chain reaction of cascading locks. |
| **V12** | 765 | 7641 | M752 | MOD-01 | **Tri-Part Key (1/3 each):** 3 fragments required to forge master key. |
| **V13** | 766 | 7651 | M752 | MOD-03 | **Chroma Crafting:** Colored fragments forge specific colored master keys. |
| **V14** | 767 | 7661 | M752 | MOD-04 | **Urgent Crafting:** Half-keys rust if not combined within 6 moves of first grab. |
| **V15** | 768 | 7671 | M752 | MOD-07 | **Twin Crafting Gates:** Forging grants 2 keys to open twin exit barriers. |
| **V16** | 769 | 7681 | M752 | MOD-05 | **Surge Craft:** Forging releases shockwave clearing adjacent weeds. |
| **V17** | 770 | 7691 | M752 | MOD-10 | **Bramble-Locked Half-Key:** Half-key locked inside breakable bramble patch. |
| **V18** | 771 | 7701 | M752 | MOD-08 | **Shifting Craft Gate:** Target lock shifts along perimeter track. |
| **V19** | 772 | 7711 | M752 | MOD-09 | **Ice Slide Craft:** Both half-keys positioned on high-speed ice rinks. |
| **V20** | 773 | 7721 | M752 | MOD-02 | **Directional Crafting:** Fragments must be collected in strict Left-to-Right order. |
| **V21** | 774 | 7731 | M752 | MOD-06 | **Asymmetric Halves:** Half A and Half B swap places if left idle 4 turns. |
| **V22** | 775 | 7741 | M752 | MOD-01 | **Dual Key Forge:** 4 fragments forging 2 independent master keys. |
| **V23** | 777 | 7761 | M753 | MOD-01 | **Skeleton Duo:** 2 Skeleton Keys allowing bypass of 2 critical gates. |
| **V24** | 778 | 7771 | M753 | MOD-03 | **Prismatic Skeleton:** Skeleton Key transforms to match gate color upon approach. |
| **V25** | 779 | 7781 | M753 | MOD-04 | **Decaying Skeleton Key:** Skeleton Key dissolves if held longer than 5 moves. |
| **V26** | 780 | 7791 | M753 | MOD-05 | **Supercharged Skeleton:** Unlocks target gate + all adjacent gates of same color. |
| **V27** | 781 | 7801 | M753 | MOD-09 | **Glacial Skeleton:** Frozen skeleton key requiring ice slide traversal. |
| **V28** | 782 | 7811 | M753 | MOD-10 | **Vault Guard Skeleton:** Skeleton key guarded by stationary stone sentinel. |
| **V29** | 783 | 7821 | M753 | MOD-07 | **Shared Skeleton:** Either of 2 snakes can pick up and use master key. |
| **V30** | 784 | 7831 | M753 | MOD-08 | **Orbiting Skeleton:** Key revolves around central garden pond. |
| **V31** | 785 | 7841 | M753 | MOD-02 | **Keyhole Alignment:** Skeleton key only fits north-facing master vault. |
| **V32** | 786 | 7851 | M753 | MOD-06 | **Inverted Skeleton:** Unlocks exit but locks side treasures. |
| **V33** | 787 | 7861 | M753 | MOD-01 | **Vault Trinity:** 3 skeleton keys required to breach final vault doors. |
| **V34** | 789 | 7881 | M754 | MOD-01 | **Triple Swap Pedestals:** 3 pedestals for complex 3-key permutations. |
| **V35** | 790 | 7891 | M754 | MOD-03 | **Chroma Swap Stone:** Pedestal only accepts keys matching its color gem. |
| **V36** | 791 | 7901 | M754 | MOD-04 | **Timed Swap Stone:** Pedestal locks key exchange after turn 10. |
| **V37** | 792 | 7911 | M754 | MOD-05 | **Turbo Swap:** Exchanging keys grants +1 bonus move. |
| **V38** | 793 | 7921 | M754 | MOD-09 | **Icy Pedestal:** Slippery tiles surround pedestal requiring rebound stop. |
| **V39** | 794 | 7931 | M754 | MOD-10 | **Walled Pedestal:** Pedestal situated within narrow blind corridor. |
| **V40** | 795 | 7941 | M754 | MOD-07 | **Teleporting Pedestals:** Key placed on Pedestal A appears instantly on Pedestal B. |
| **V41** | 796 | 7951 | M754 | MOD-08 | **Mobile Pedestal:** Pedestal glides along 4-tile patrol route. |
| **V42** | 797 | 7961 | M754 | MOD-02 | **Unidirectional Swap:** Key can be deposited from South, withdrawn from North. |
| **V43** | 798 | 7971 | M754 | MOD-06 | **Reverse Swap:** Key converts to its inverse color when swapped. |
| **V44** | 799 | 7981 | M754 | MOD-01 | **Gilded Vault Complex:** 4-pedestal puzzle network governing inner sanctum. |
| **V45** | 800 | 7991 | M754 | MOD-10 | **Grand Treasure Vault Finale:** Ultimate DAG key labyrinth on $14 \times 14$ grid. |

---

## 3. References & Cross-Links
- [Phase 16 Base Mechanics](phase-16-base-mechanics.md)
- [Phase 16 Level Plan](phase-16-level-plan-07501-08000.md)
- [Shared Core Standard §17.38](../../SHARED_CORE_STANDARD.md)

