# Technical Specification: Phase 17 QA and Rollout Standards (Mongoose Clan)

**Status:** Draft  
**Phase:** 17 (Levels 8001–8500)  
**Theme:** Mongoose Clan (Guardians)  
**Document Type:** Technical QA and Deployment Specification  
**Source Cross-Reference:** [phases/phase_17/06_UI_AND_QA_PHASE_17.md](../../phases/phase_17/06_UI_AND_QA_PHASE_17.md), [SHARED_CORE_STANDARD.md §15.2, §17.40](../../SHARED_CORE_STANDARD.md)

---

## 1. Automated CI Pre-Validation Suite

Prior to packaging or promoting Phase 17 levels to staging:
1. **Binary Asset Integrity:**
   - Verify `assets/levels/phase_17.bin` contains exactly 500 valid level records (Levels 8001 to 8500).
   - Asset checksum SHA-256 matches build manifest.
2. **Automated Solver Verifications:**
   - Every level must possess $\ge 1$ deterministic winning move path using headless boss solver.
   - Solver verify test run timeout $\le 15\text{ms}$ per level.
   - Verify strict rock spawning cap: active spawned rocks never exceed 3.
3. **Move Budget Headroom:**
   - Gold 3-star par threshold $\ge \text{optimal moves} + 4$.
   - Failure move limit $\ge \text{optimal moves} \times 1.5$.

---

## 2. QA Acceptance Checklist (P17-QA-01 to P17-QA-10)

| Test ID | Test Category | Verification Condition | Status |
| :---: | :--- | :--- | :---: |
| **P17-QA-01** | Guardian Damage Strike | Exiting snake deducts exactly 1 HP from target guardian or shared pool M801. | PASS |
| **P17-QA-02** | Shield Lever Window | Armadillo deflects damage when shield ON; takes damage when shield lowered. | PASS |
| **P17-QA-03** | Rock Spawner Cap | Mama Mongoose stops throwing rocks as soon as 3 spawned rocks exist simultaneously. | PASS |
| **P17-QA-04** | Core Attack Alignment | M804 Core only takes damage when snake exits along illuminated matching lane. | PASS |
| **P17-QA-05** | Guardian Retreat Path | Defeated guardian clears cell completely, allowing subsequent snakes to traverse tile. | PASS |
| **P17-QA-06** | Zero Collision Hazard | Snake bumping into stationary guardian halts safely with 0 damage/life loss. | PASS |
| **P17-QA-07** | Economy Payout | All 49 milestone gift baskets and 20 Slither Rush events award specified coin amounts. | PASS |
| **P17-QA-08** | Grand Finale L8500 | Completing Level 8500 awards 1000 coins, 6 boosters, Mongoose Clan badge, and unlocks Phase 18. | PASS |
| **P17-QA-09** | Memory & Performance | Memory footprint delta $\le 12\text{MB}$; maintains stable 60 FPS on low-end test device. | PASS |
| **P17-QA-10** | Save / Undo Integrity | Reversing moves restores exact guardian HP, despawns recently thrown rocks deterministically. | PASS |

---

## 3. Remote Config & Phased Rollout Schedule

Phase 17 is gated via Firebase Remote Config flag:
```json
{
  "maxPhase": 17,
  "phase_17_rollout_percentage": 100,
  "min_app_version": "2.17.0"
}
```

### Staged Rollout Timeline:
- **Day 1:** Internal QA & TestFlight dogfooding (100% internal).
- **Day 3:** 5% staged rollout to production users who completed Phase 16.
- **Day 5:** Crashlytics error rate verification ($< 0.1\%$ crash-free threshold). Expand to 25%.
- **Day 7:** Expand to 100% global rollout.

---

## 4. References & Cross-Links
- [Phase 17 Signature System](../gameplay/phase-17-signature-system.md)
- [Phase 17 Rewards](../economy/phase-17-rewards.md)
- [Shared Core Standard §15.2](../../SHARED_CORE_STANDARD.md)
