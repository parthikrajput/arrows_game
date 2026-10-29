# Ants & Bees: Garden Trails — Game 4 Design Spec
Game 4 ના આખા design spec નો overview: pitch, key numbers, folder map, coverage matrix અને v3 changes.

**Related docs:** [VFX](./VFX_IMPLEMENTATION.md) · [Shared Core Standard](./SHARED_CORE_STANDARD.md) · [Sound Effects](./SOUND_EFFECTS_IMPLEMENTATION.md) · [Logging & Error Tracking](./LOGGING_AND_ERROR_TRACKING.md) · [Phase 1 README](./phase/phase_1/README.md) · [Phase 2 README](./phase/phase_2/README.md) · [Scaling to 10,000 Levels](./SCALING_TO_10000_LEVELS.md)

---

## 1. Pitch (પરિચય)
સન્ની બગીચાની grid પર **કીડીઓની લાઈનો જમીન પર** અને **મધમાખીઓની લાઈનો હવામાં** ગોઠવાયેલી છે. Line પર tap કરો — રસ્તો ખાલી હોય તો head insect આગળ વધે અને આખી line કૂચ કરતી (ants) કે ઉડતી (bees) board બહાર જાય; રસ્તો બંધ હોય તો head "bonk" કરીને પાછું આવે અને 1 Heart જાય. આખો બગીચો ખાલી કરો.

| Item | Value |
|---|---|
| Title | **Ants & Bees: Garden Trails** |
| Genre | Turn-based, deterministic path-clear logic puzzle |
| Audience | Age 10–50 (mixed audience; neutral age gate) |
| USP | **બે layers:** ants (ground) અને bees (air) એકબીજાને **ક્યારેય નડતાં નથી**; ant lanes ને ant lines + બધા ground obstacles નડે, bee lanes ને માત્ર bee lines + `tall: true` obstacles. એક cell પર બંને ⇒ "બે puzzles એકસાથે" (L41 થી) |
| Platform / tech | Flutter 3.x (Dart 3, Impeller), 2D `CustomPainter` "soft 3D" (gradients + pre-baked shadows), `flutter_bloc`, shared `packages/puzzle_core`, Hive, AdMob + UMP, `in_app_purchase`, Firebase — Android + iOS, portrait |

## 2. Key Numbers (મુખ્ય આંકડા)

| Topic | Value |
|---|---|
| Hearts | 3 per attempt; bump −1 |
| Revive | Rewarded ad +1 heart (**1 per level**) · Honey Heart Refill 120 coins (**max 2 per attempt**) · 10-s Second Chance |
| Stars | ★★★ 0 lost · ★★ 1 lost · ★ 2+ lost or any revive |
| Boosters | **Nectar Glow Hint** (Hint) 60 / ×3 150, cap 3, L3 · **Queen's Royal Shield** (Shield) 80 / ×3 200, cap 1, L15 · **Leaf Blower** (Hammer) 100 / ×3 250, cap 2, L25 · free **Scent Trail Preview** (long-press 350 ms) |
| Coins | Clear 15/20/30/50 · first ★★★ +20 · Gift Box 150–300 · Chest 1,000 · Rush 10/line +100 · Daily +100 · Streak 1,150/week · Shop ad +50 ×5/day |
| Ads | Interstitial every 5 wins, never L1–10, 120 s cooldown, deferred on reward screens · rewarded opt-in · banner Home/Map/Gameplay L11+ |
| VIP | Beekeeper VIP Pass ₹20/month auto-renewing — ads off **while active** |
| Daily | Unlock L15 · 7 weekday modifiers · 7-day streak + Queen's Favor saver |
| Phases | 20 phases × 500 levels = 10,000 · **Phase 1 L1–500** (49 mechanics + finale) · Phase 2 L501–1000 · Phases 3–20 on-device generation |
| Grid | Phase 1 max 11×11, min cell 29 dp |

## 3. Folder Map

```
game_4_nature_ants_bees/
├─ README.md                          ← this file (whole-spec overview)
├─ SCALING_TO_10000_LEVELS.md         ← 500 → 10,000 content & scalability
└─ phase/                             ← All 20 Phase Folders (Phases 1 to 20)
   ├─ phase_1/                        ← Launch, Levels 1–500
   │  ├─ README.md
   │  ├─ 01_GAME_CONCEPT_AND_RULES.md
   │  ├─ 02_LEVEL_PROGRESSION_0001_0500.md
   │  ├─ 03_OBSTACLE_CATALOG_PHASE_1.md
   │  ├─ 04_BOOSTERS_COINS_SHOP.md
   │  ├─ 05_DAILY_CHALLENGE_AND_STREAK.md
   │  ├─ 06_UI_UX_SCREENS.md
   │  └─ 07_FRONTEND_IMPLEMENTATION_AND_QA.md
   ├─ phase_2/                        ← Levels 501–1000 + LiveOps
   │  ├─ README.md (index of Phase 2 docs)
   │  ├─ 01_PHASE_2_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PROGRESSION_0501_1000.md
   │  ├─ 03_OBSTACLE_CATALOG_PHASE_2.md
   │  ├─ 04_LIVEOPS_ALBUM_STAR_RACE_PIGGY.md
   │  ├─ 05_OFFLINE_AND_CLOUD_SYNC.md
   │  └─ 06_FRONTEND_AND_QA_PHASE_2.md
   ├─ phase_3/                        ← Levels 1001–1500 (Day & Night Garden)
   │  ├─ README.md
   │  ├─ 01_PHASE_3_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_1001_1500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_3.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_3.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_3.md
   │  └─ 06_UI_AND_QA_PHASE_3.md
   ├─ phase_4/                        ← Levels 1501–2000 (Garden Terraces)
   │  ├─ README.md
   │  ├─ 01_PHASE_4_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_1501_2000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_4.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_4.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_4.md
   │  └─ 06_UI_AND_QA_PHASE_4.md
   ├─ phase_5/                        ← Levels 2001–2500 (Acorn Physics)
   │  ├─ README.md
   │  ├─ 01_PHASE_5_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_2001_2500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_5.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_5.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_5.md
   │  └─ 06_UI_AND_QA_PHASE_5.md
   ├─ phase_6/                        ← Levels 2501–3000 (Sunlit Garden)
   │  ├─ README.md
   │  ├─ 01_PHASE_6_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_2501_3000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_6.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_6.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_6.md
   │  └─ 06_UI_AND_QA_PHASE_6.md
   ├─ phase_7/                        ← Levels 3001–3500 (Whirling Garden)
   │  ├─ README.md
   │  ├─ 01_PHASE_7_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_3001_3500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_7.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_7.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_7.md
   │  └─ 06_UI_AND_QA_PHASE_7.md
   ├─ phase_8/                        ← Levels 3501–4000 (Bloom Season)
   │  ├─ README.md
   │  ├─ 01_PHASE_8_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_3501_4000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_8.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_8.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_8.md
   │  └─ 06_UI_AND_QA_PHASE_8.md
   ├─ phase_9/                        ← Levels 4001–4500 (Swarm Splits)
   │  ├─ README.md
   │  ├─ 01_PHASE_9_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_4001_4500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_9.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_9.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_9.md
   │  └─ 06_UI_AND_QA_PHASE_9.md
   ├─ phase_10/                       ← Levels 4501–5000 (Garden Rhythm)
   │  ├─ README.md
   │  ├─ 01_PHASE_10_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_4501_5000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_10.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_10.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_10.md
   │  └─ 06_UI_AND_QA_PHASE_10.md
   ├─ phase_11/                       ← Levels 5001–5500 (Twin Gardens)
   │  ├─ README.md
   │  ├─ 01_PHASE_11_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_5001_5500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_11.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_11.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_11.md
   │  └─ 06_UI_AND_QA_PHASE_11.md
   ├─ phase_12/                       ← Levels 5501–6000 (Falling Leaves)
   │  ├─ README.md
   │  ├─ 01_PHASE_12_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_5501_6000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_12.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_12.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_12.md
   │  └─ 06_UI_AND_QA_PHASE_12.md
   ├─ phase_13/                       ← Levels 6001–6500 (Mystery Meadow)
   │  ├─ README.md
   │  ├─ 01_PHASE_13_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_6001_6500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_13.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_13.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_13.md
   │  └─ 06_UI_AND_QA_PHASE_13.md
   ├─ phase_14/                       ← Levels 6501–7000 (Reflecting Pond)
   │  ├─ README.md
   │  ├─ 01_PHASE_14_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_6501_7000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_14.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_14.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_14.md
   │  └─ 06_UI_AND_QA_PHASE_14.md
   ├─ phase_15/                       ← Levels 7001–7500 (Brook & Rails)
   │  ├─ README.md
   │  ├─ 01_PHASE_15_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_7001_7500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_15.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_15.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_15.md
   │  └─ 06_UI_AND_QA_PHASE_15.md
   ├─ phase_16/                       ← Levels 7501–8000 (Royal Keyring)
   │  ├─ README.md
   │  ├─ 01_PHASE_16_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_7501_8000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_16.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_16.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_16.md
   │  └─ 06_UI_AND_QA_PHASE_16.md
   ├─ phase_17/                       ← Levels 8001–8500 (Garden Guardians)
   │  ├─ README.md
   │  ├─ 01_PHASE_17_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_8001_8500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_17.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_17.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_17.md
   │  └─ 06_UI_AND_QA_PHASE_17.md
   ├─ phase_18/                       ← Levels 8501–9000 (Garden Festival I — Remix A)
   │  ├─ README.md
   │  ├─ 01_PHASE_18_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_8501_9000.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_18.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_18.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_18.md
   │  └─ 06_UI_AND_QA_PHASE_18.md
   ├─ phase_19/                       ← Levels 9001–9500 (Garden Festival II — Remix B)
   │  ├─ README.md
   │  ├─ 01_PHASE_19_SCOPE_AND_RULES.md
   │  ├─ 02_LEVEL_PLAN_9001_9500.md
   │  ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_19.md
   │  ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_19.md
   │  ├─ 05_REWARDS_AND_ECONOMY_PHASE_19.md
   │  └─ 06_UI_AND_QA_PHASE_19.md
   └─ phase_20/                       ← Levels 9501–10,000 (Grand Master Garden & Finale)
      ├─ README.md
      ├─ 01_PHASE_20_SCOPE_AND_RULES.md
      ├─ 02_LEVEL_PLAN_9501_10000.md
      ├─ 03_SIGNATURE_SYSTEM_AND_MECHANICS_PHASE_20.md
      ├─ 04_VARIANTS_AND_MODIFIERS_PHASE_20.md
      ├─ 05_REWARDS_AND_ECONOMY_PHASE_20.md
      └─ 06_UI_AND_QA_PHASE_20.md
```
Shared rules: [./SHARED_CORE_STANDARD.md](./SHARED_CORE_STANDARD.md) (canonical — numbers અહીં બદલાય તો પહેલાં ત્યાં).

## 4. Coverage Matrix (જરૂરી topics → doc)

| # | Required topic | Covered in |
|---|---|---|
| 1 | Whole-spec overview | [README.md](./README.md) (this) · [phase_1/README.md](./phase/phase_1/README.md) · [phase_2/README.md](./phase/phase_2/README.md) · [phase_3/README.md](./phase/phase_3/README.md) · [phase_4/README.md](./phase/phase_4/README.md) · [phase_5/README.md](./phase/phase_5/README.md) · [phase_6/README.md](./phase/phase_6/README.md) · [phase_7/README.md](./phase/phase_7/README.md) · [phase_8/README.md](./phase/phase_8/README.md) · [phase_9/README.md](./phase/phase_9/README.md) · [phase_10/README.md](./phase/phase_10/README.md) · [phase_11/README.md](./phase/phase_11/README.md) · [phase_12/README.md](./phase/phase_12/README.md) · [phase_13/README.md](./phase/phase_13/README.md) · [phase_14/README.md](./phase/phase_14/README.md) · [phase_15/README.md](./phase/phase_15/README.md) · [phase_16/README.md](./phase/phase_16/README.md) · [phase_17/README.md](./phase/phase_17/README.md) · [phase_18/README.md](./phase/phase_18/README.md) · [phase_19/README.md](./phase/phase_19/README.md) · [phase_20/README.md](./phase/phase_20/README.md) |
| 2 | Game concept & gameplay rules | [01_GAME_CONCEPT_AND_RULES.md](./phase/phase_1/01_GAME_CONCEPT_AND_RULES.md) |
| 3 | 500-level progression, new obstacle/mechanic every 10 levels | [02_LEVEL_PROGRESSION_0001_0500.md](./phase/phase_1/02_LEVEL_PROGRESSION_0001_0500.md) (§6 full 50-block table) |
| 4 | How obstacles work & their rules | [03_OBSTACLE_CATALOG_PHASE_1.md](./phase/phase_1/03_OBSTACLE_CATALOG_PHASE_1.md) |
| 5 | Hint, Shield, Hammer power-ups, coin rewards & Shop | [04_BOOSTERS_COINS_SHOP.md](./phase/phase_1/04_BOOSTERS_COINS_SHOP.md) |
| 6 | Daily challenge & 7-day streak | [05_DAILY_CHALLENGE_AND_STREAK.md](./phase/phase_1/05_DAILY_CHALLENGE_AND_STREAK.md) |
| 7 | All screens incl. Home, Gameplay, Shop, Level Map | [06_UI_UX_SCREENS.md](./phase/phase_1/06_UI_UX_SCREENS.md) |
| 8 | 500 → 10,000 content & scalability planning | [SCALING_TO_10000_LEVELS.md](./SCALING_TO_10000_LEVELS.md) · [phase_2/README.md](./phase/phase_2/README.md) · [phase_3/README.md](./phase/phase_3/README.md) · [phase_4/README.md](./phase/phase_4/README.md) · [phase_5/README.md](./phase/phase_5/README.md) · [phase_6/README.md](./phase/phase_6/README.md) · [phase_7/README.md](./phase/phase_7/README.md) · [phase_8/README.md](./phase/phase_8/README.md) · [phase_9/README.md](./phase/phase_9/README.md) · [phase_10/README.md](./phase/phase_10/README.md) · [phase_11/README.md](./phase/phase_11/README.md) · [phase_12/README.md](./phase/phase_12/README.md) · [phase_13/README.md](./phase/phase_13/README.md) · [phase_14/README.md](./phase/phase_14/README.md) · [phase_15/README.md](./phase/phase_15/README.md) · [phase_16/README.md](./phase/phase_16/README.md) · [phase_17/README.md](./phase/phase_17/README.md) · [phase_18/README.md](./phase/phase_18/README.md) · [phase_19/README.md](./phase/phase_19/README.md) · [phase_20/README.md](./phase/phase_20/README.md) |
| 9 | Frontend implementation rules & testing checklist | [07_FRONTEND_IMPLEMENTATION_AND_QA.md](./phase/phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md) · [06_FRONTEND_AND_QA_PHASE_2.md](./phase/phase_2/06_FRONTEND_AND_QA_PHASE_2.md) |
| 10 | Sound effects | [./SOUND_EFFECTS_IMPLEMENTATION.md](./SOUND_EFFECTS_IMPLEMENTATION.md) (shared) · game mapping: [07 §7](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md#7-audio--haptics) |
| 10a | VFX / game feel | [./VFX_IMPLEMENTATION.md](./VFX_IMPLEMENTATION.md) (shared) · spec: [specs/ui/vfx-and-juice.md](./specs/ui/vfx-and-juice.md) |
| 11 | Logging & error tracking | [./LOGGING_AND_ERROR_TRACKING.md](./LOGGING_AND_ERROR_TRACKING.md) (shared) · game error table: [07 §12](./phase_1/07_FRONTEND_IMPLEMENTATION_AND_QA.md#12-error-handling) |

## 5. v3 Changes (જૂના docs થી શું સુધાર્યું)

1. **એક જ title** "Ants & Bees: Garden Trails" (જૂના docs માં "Ants & Bees! Garden Guide" અને "Nature Ants & Bees" બે નામ).
2. **Layer rule સ્પષ્ટ** કર્યો: ants ↔ bees ક્યારેય collide નહીં; ant lanes = ant lines + બધા obstacles; bee lanes = bee lines + `tall: true` obstacles; cover lock; tap priority air ઉપર. દરેક mechanic card માં Ants/Bees/Tall fields. (જૂના docs: "કોઈપણ જીવડાં કે અવરોધને touch ⇒ heart" — layer નિયમ જ નહોતો.)
3. **Real-time obstacles દૂર** (flytrap "દર 4 સેકન્ડ", sprinkler 3 s, sunbeam clock 5 s, resin 3 s, વગેરે). બધું turn-based, Move counter પર; એકમાત્ર timer Golden Nectar Rush (30 s).
4. **Mechanics schedule** Standard M001–M049 મુજબ દર 10 levels એ x1 પર (જૂના catalog માં L18, 26, 34… અને #41–50 L150–470 વચ્ચે અવ્યવસ્થિત). Bees M004 slot (L41), Key & Lock M032 slot (L321) — Standard §10 exception.
5. **Boosters standard મુજબ 3:** Hint, Shield, Hammer + free Preview. Undo (Dewdrop Rewind) અને "Sweet Honey Pot Magnet" booster કાઢ્યા. Booster names એક જ set માં (Scent/Snip/Dewdrop Bubble વગેરે variants દૂર). Hammer = **Leaf Blower**.
6. **Ice/frost leftovers દૂર** ("Morning Frost Bubble", "બરફ") ⇒ Dew-Stuck Line.
7. **Economy numbers Standard મુજબ:** streak ladder 1,150/week (જૂના 1,500 અને 500+skin), Coin Rush 10/line +100 (જૂના 200–500), Gift Box 150–300 schedule, Heart Refill 120 ×2.
8. **Revive:** level દીઠ 1 ad revive + Heart Refill; 10-s countdown (જૂના 5-s).
9. **Ads:** interstitial L1–10 માં નહીં, 120 s cooldown, reward screens પર defer (જૂના: "Level 5, 10, 15…").
10. **VIP** ₹20/month auto-renew, "while active" (જૂના: "કાયમી બંધ").
11. **Streak miss rule:** Queen's Favor (ad / 200 coins) 1 વાર/cycle (જૂના: 1 દિવસ miss ⇒ reset, અને બીજા doc માં ad saver — વિરોધાભાસ).
12. **Exits:** board edge થી જ; interior anthill/hive exits માત્ર M020 (L201+).
13. **Rendering:** "3D" claims ⇒ 2D CustomPainter soft-3D; bee wing flutter 30 Hz (60 fps પર aliasing) ⇒ 12 Hz time-based.
14. **Daily:** Sunday 15×15 દૂર (Phase 1 max 11×11); weekday modifiers + fallbacks; anti-cheat day key.
15. **Unsourced statistics દૂર** (દા.ત. "Day 7 retention 27%"); QA items "Not run".
16. **Docs reorganized:** duplicate root/phase files દૂર, numbered phase_1 docs, Phase 2 + scaling અલગ.
