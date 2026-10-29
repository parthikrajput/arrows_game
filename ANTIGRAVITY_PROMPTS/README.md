# Antigravity Prompts: Specs for All Phases

There are 20 phases in the plan (500 levels each, 10,000 levels in total). One prompt file per phase.
Each prompt creates the specs for ONE phase of ONE game. The shared standards (SHARED_CORE_STANDARD, SOUND_EFFECTS, VFX, LOGGING, PERFORMANCE, SPLASH) now live inside each game folder as game-wise copies, so the prompts read them from the game folder itself. Open one game folder in Antigravity, paste the code block from the phase file, and repeat for each of the 4 games.

| Phase | Levels | Content | Prompt file |
|---|---|---|---|
| 1 | 1 to 500 | Launch: rules, 49 mechanics, boosters, shop, daily, UI, frontend | [phase_01_levels_0001_0500.md](./phase_01_levels_0001_0500.md) |
| 2 | 501 to 1000 | Bigger boards, 49 mechanics, LiveOps, cloud sync, backend | [phase_02_levels_0501_1000.md](./phase_02_levels_0501_1000.md) |
| 3 | 1001 to 1500 | Cycles (board state A/B every 5 Moves) | [phase_03_levels_01001_01500.md](./phase_03_levels_01001_01500.md) |
| 4 | 1501 to 2000 | Multi-floor (up to 3 floors, stairs) | [phase_04_levels_01501_02000.md](./phase_04_levels_01501_02000.md) |
| 5 | 2001 to 2500 | Push Physics+ | [phase_05_levels_02001_02500.md](./phase_05_levels_02001_02500.md) |
| 6 | 2501 to 3000 | Light & Beams+ | [phase_06_levels_02501_03000.md](./phase_06_levels_02501_03000.md) |
| 7 | 3001 to 3500 | Rotation | [phase_07_levels_03001_03500.md](./phase_07_levels_03001_03500.md) |
| 8 | 3501 to 4000 | Growth | [phase_08_levels_03501_04000.md](./phase_08_levels_03501_04000.md) |
| 9 | 4001 to 4500 | Split & Merge | [phase_09_levels_04001_04500.md](./phase_09_levels_04001_04500.md) |
| 10 | 4501 to 5000 | Sequencing | [phase_10_levels_04501_05000.md](./phase_10_levels_04501_05000.md) |
| 11 | 5001 to 5500 | Linked Boards (2 mini boards) | [phase_11_levels_05001_05500.md](./phase_11_levels_05001_05500.md) |
| 12 | 5501 to 6000 | Gravity | [phase_12_levels_05501_06000.md](./phase_12_levels_05501_06000.md) |
| 13 | 6001 to 6500 | Hidden Info | [phase_13_levels_06001_06500.md](./phase_13_levels_06001_06500.md) |
| 14 | 6501 to 7000 | Mirror Worlds | [phase_14_levels_06501_07000.md](./phase_14_levels_06501_07000.md) |
| 15 | 7001 to 7500 | Conveyors & Tracks | [phase_15_levels_07001_07500.md](./phase_15_levels_07001_07500.md) |
| 16 | 7501 to 8000 | Keys Deluxe | [phase_16_levels_07501_08000.md](./phase_16_levels_07501_08000.md) |
| 17 | 8001 to 8500 | Guardians | [phase_17_levels_08001_08500.md](./phase_17_levels_08001_08500.md) |
| 18 | 8501 to 9000 | Remix A (systems of Phases 1 to 6) | [phase_18_levels_08501_09000.md](./phase_18_levels_08501_09000.md) |
| 19 | 9001 to 9500 | Remix B (systems of Phases 7 to 12) | [phase_19_levels_09001_09500.md](./phase_19_levels_09001_09500.md) |
| 20 | 9501 to 10000 | Grand Master (all systems) | [phase_20_levels_09501_10000.md](./phase_20_levels_09501_10000.md) |

## Rules for using these prompts

0. For Phases 3 to 20, run [00_create_phase_folders_3_to_20.md](./00_create_phase_folders_3_to_20.md) first.
1. Go in order: Phase 1, then 2, then 3 and so on. Each phase reads the specs of the earlier phases.
2. Review and set every spec to Approved before you start the next phase's prompt.
3. Phase 1 and 2 have their own detailed docs in the game folder. Phases 3 to 20 are designed only in `SHARED_CORE_STANDARD.md` (section 11) and each game's `SCALING_TO_10000_LEVELS.md` (section 6), so those prompts point there.
4. Phase 3 also creates the shared on-device level generation spec. Phases 4 to 20 link to it.
5. Phases 18 and 19 use "combo mechanics chosen by data". The prompt will list them as open questions until real analytics exist.
6. Prompts never write app code and never mark a spec Approved.
7. The shared standards are game-wise copies (one per game folder). If a prompt result shows a shared rule or number must change, change it in all four game folders, never in one only.
8. Prompts read the shared docs from the game folder (for example `VFX_IMPLEMENTATION.md`, `SHARED_CORE_STANDARD.md`). No prompt needs files outside the game folder.
