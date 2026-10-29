# Technical Specification: Phase 15 QA and Rollout Standards (River Delta)

**Status:** Draft  
**Phase:** 15 (Levels 7001–7500)  
**Theme:** River Delta (Conveyors & Tracks)  
**Document Type:** Technical QA and Deployment Specification  
**Source Cross-Reference:** [phases/phase_15/06_UI_AND_QA_PHASE_15.md](../../phases/phase_15/06_UI_AND_QA_PHASE_15.md), [SHARED_CORE_STANDARD.md §15.2, §17.40](../../SHARED_CORE_STANDARD.md)

---

## 1. Automated CI Pre-Validation Suite

Prior to packaging or promoting Phase 15 levels to staging:
1. **Binary Asset Integrity:**
   - Verify `assets/levels/phase_15.bin` contains exactly 500 valid level records (Levels 7001 to 7500).
   - Asset checksum SHA-256 matches build manifest.
2. **Automated Solver Verifications:**
   - Every level must possess $\ge 1$ deterministic winning move path using headless BFS/A* solver.
   - Solver verify test run timeout $\le 15\text{ms}$ per level.
   - Zero deadlock traps where conveyor infinitely loops snake without exit path.
3. **Move Budget Headroom:**
   - Gold 3-star par threshold $\ge \text{optimal moves} + 4$.
   - Failure move limit $\ge \text{optimal moves} \times 1.5$.

---

## 2. QA Acceptance Checklist (P15-QA-01 to P15-QA-10)

| Test ID | Test Category | Verification Condition | Status |
| :---: | :--- | :--- | :---: |
| **P15-QA-01** | Conveyor Displacement | Snake resting on active conveyor moves exactly 1 tile in flow direction post-move. | PASS |
| **P15-QA-02** | Tide Reversal Period | M702 reverses flow direction precisely at modulo $N$ moves without off-by-one errors. | PASS |
| **P15-QA-03** | Sluice Lever Gate | Closing sluice lever halts water flow and disables conveyor tile displacement immediately. | PASS |
| **P15-QA-04** | Whirlpool Orbit | Snake inside whirlpool loop circulates indefinitely without clipping or desyncing segments. | PASS |
| **P15-QA-05** | Whirlpool Tangent Tap | Tapping circulating snake head at tangent exit correctly ejects snake onto receiving lane. | PASS |
| **P15-QA-06** | Obstacle Block Bonk | Snake conveyor movement halted by obstacle or snake produces zero displacement and bonk VFX. | PASS |
| **P15-QA-07** | Economy Payout | All 49 milestone gift baskets and 20 Slither Rush events award specified coin amounts. | PASS |
| **P15-QA-08** | Grand Finale L7500 | Completing Level 7500 awards 1000 coins, 6 boosters, Delta Tide badge, and unlocks Phase 16. | PASS |
| **P15-QA-09** | Memory & Performance | Memory footprint delta $\le 12\text{MB}$; maintains stable 60 FPS on low-end test device. | PASS |
| **P15-QA-10** | Save / Undo Integrity | Reversing moves restores conveyor states, tide countdowns, and snake positions deterministically. | PASS |

---

## 3. Remote Config & Phased Rollout Schedule

Phase 15 is gated via Firebase Remote Config flag:
```json
{
  "maxPhase": 15,
  "phase_15_rollout_percentage": 100,
  "min_app_version": "2.15.0"
}
```

### Staged Rollout Timeline:
- **Day 1:** Internal QA & TestFlight dogfooding (100% internal).
- **Day 3:** 5% staged rollout to production users who completed Phase 14.
- **Day 5:** Crashlytics error rate verification ($< 0.1\%$ crash-free threshold). Expand to 25%.
- **Day 7:** Expand to 100% global rollout.

---

## 4. References & Cross-Links
- [Phase 15 Signature System](../gameplay/phase-15-signature-system.md)
- [Phase 15 Rewards](../economy/phase-15-rewards.md)
- [Shared Core Standard §15.2](../../SHARED_CORE_STANDARD.md)

