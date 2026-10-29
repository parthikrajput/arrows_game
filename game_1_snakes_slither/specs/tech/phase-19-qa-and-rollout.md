# Technical Specification: Phase 19 QA and Rollout Standards (Remix B)

**Status:** Draft  
**Phase:** 19 (Levels 9001–9500)  
**Theme:** Remix B (Phase 7 to Phase 12 Mechanics Synergy)  
**Document Type:** Technical QA and Deployment Specification  
**Source Cross-Reference:** [phases/phase_19/06_UI_AND_QA_PHASE_19.md](../../phases/phase_19/06_UI_AND_QA_PHASE_19.md), [SHARED_CORE_STANDARD.md §15.2, §17.40](../../SHARED_CORE_STANDARD.md)

---

## 1. Automated CI Pre-Validation Suite

Prior to packaging or promoting Phase 19 levels to staging:
1. **Binary Asset Integrity:**
   - Verify `assets/levels/phase_19.bin` contains exactly 500 valid level records (Levels 9001 to 9500).
   - Asset checksum SHA-256 matches build manifest.
2. **Automated Solver Verifications:**
   - Every level must possess $\ge 1$ deterministic winning move path using headless physics synergy solver.
   - Solver verify test run timeout $\le 15\text{ms}$ per level.
   - Zero impossible wind/vine deadlocks or insurmountable downbeat push traps.
3. **Move Budget Headroom:**
   - Gold 3-star par threshold $\ge \text{optimal moves} + 4$.
   - Failure move limit $\ge \text{optimal moves} \times 1.5$.

---

## 2. QA Acceptance Checklist (P19-QA-01 to P19-QA-10)

| Test ID | Test Category | Verification Condition | Status |
| :---: | :--- | :--- | :---: |
| **P19-QA-01** | Wind Vine Guidance | Vine tip expands strictly along current wind vector; suppresses growth against opposing wind. | PASS |
| **P19-QA-02** | Siphon River Flow | Stepping on reflection lily pad flips parallel river currents and extends snake slide by 1 tile. | PASS |
| **P19-QA-03** | Monsoon Downbeat Sync | Beat 3 applies 1-tile force vector and toggles Drum Gates synchronously without frame delay. | PASS |
| **P19-QA-04** | Seismic Echo Radius | Heavy python impact triggers resonant echo gates precisely within $r=4$ Manhattan distance. | PASS |
| **P19-QA-05** | Light Snake Rejection | Standard light snakes landing on bedrock generate 0 seismic wave and do not open echo gates. | PASS |
| **P19-QA-06** | Zero Softlock Guarantee | All 500 levels verified to possess at least 1 viable clear path without irreversible vine traps. | PASS |
| **P19-QA-07** | Economy Payout | All 49 milestone gift baskets and 20 Slither Rush events award specified coin amounts. | PASS |
| **P19-QA-08** | Grand Finale L9500 | Completing Level 9500 awards 1000 coins, 6 boosters, Wild Currents badge, and unlocks Phase 20. | PASS |
| **P19-QA-09** | Memory & Performance | Memory footprint delta $\le 12\text{MB}$; maintains stable 60 FPS on low-end test device. | PASS |
| **P19-QA-10** | Save / Undo Integrity | Reversing moves restores wind vectors, beat counters, and seismic shockwave states deterministically. | PASS |

---

## 3. Remote Config & Phased Rollout Schedule

Phase 19 is gated via Firebase Remote Config flag:
```json
{
  "maxPhase": 19,
  "phase_19_rollout_percentage": 100,
  "min_app_version": "2.19.0"
}
```

### Staged Rollout Timeline:
- **Day 1:** Internal QA & TestFlight dogfooding (100% internal).
- **Day 3:** 5% staged rollout to production users who completed Phase 18.
- **Day 5:** Crashlytics error rate verification ($< 0.1\%$ crash-free threshold). Expand to 25%.
- **Day 7:** Expand to 100% global rollout.

---

## 4. References & Cross-Links
- [Phase 19 Signature System](../gameplay/phase-19-signature-system.md)
- [Phase 19 Rewards](../economy/phase-19-rewards.md)
- [Shared Core Standard §15.2](../../SHARED_CORE_STANDARD.md)

