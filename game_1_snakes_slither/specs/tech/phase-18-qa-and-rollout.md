# Technical Specification: Phase 18 QA and Rollout Standards (Remix A)

**Status:** Draft  
**Phase:** 18 (Levels 8501–9000)  
**Theme:** Remix A (Early Eras Synergy / Data-Driven)  
**Document Type:** Technical QA and Deployment Specification  
**Source Cross-Reference:** [phases/phase_18/06_UI_AND_QA_PHASE_18.md](../../phases/phase_18/06_UI_AND_QA_PHASE_18.md), [SHARED_CORE_STANDARD.md §15.2, §17.40](../../SHARED_CORE_STANDARD.md)

---

## 1. Automated CI Pre-Validation Suite

Prior to packaging or promoting Phase 18 levels to staging:
1. **Binary Asset Integrity:**
   - Verify `assets/levels/phase_18.bin` contains exactly 500 valid level records (Levels 8501 to 9000).
   - Asset checksum SHA-256 matches build manifest.
2. **Automated Solver Verifications:**
   - Every level must possess $\ge 1$ deterministic winning move path using headless multi-system solver.
   - Solver verify test run timeout $\le 15\text{ms}$ per level.
   - Zero deadlock configurations involving trapped rolling boulders or inaccessible elevator terraces.
3. **Move Budget Headroom:**
   - Gold 3-star par threshold $\ge \text{optimal moves} + 4$.
   - Failure move limit $\ge \text{optimal moves} \times 1.5$.

---

## 2. QA Acceptance Checklist (P18-QA-01 to P18-QA-10)

| Test ID | Test Category | Verification Condition | Status |
| :---: | :--- | :--- | :---: |
| **P18-QA-01** | Seasonal Elevator Shift | Sub-floor elevator tiles rise and fall precisely on modulo $N$ moves. | PASS |
| **P18-QA-02** | Coconut Prism Collision | Boulder colliding with active light beam deflects or shatters based on beam type. | PASS |
| **P18-QA-03** | Solar Portal Warp | Entering powered portal instantly teleports snake head to linked exit without desync. | PASS |
| **P18-QA-04** | Weight Plate Balance | Required coconut weight ($1W$, $2W$) depresses balance plate and opens connected trapdoor. | PASS |
| **P18-QA-05** | Multi-Layer Collision | Snake on upper floor traverses over lower trench without colliding with snakes below. | PASS |
| **P18-QA-06** | Zero Boulder Soft-Lock | Pushing coconut against solid wall halts movement without trapping subsequent snake bodies. | PASS |
| **P18-QA-07** | Economy Payout | All 49 milestone gift baskets and 20 Slither Rush events award specified coin amounts. | PASS |
| **P18-QA-08** | Grand Finale L9000 | Completing Level 9000 awards 1000 coins, 6 boosters, Remix A badge, and unlocks Phase 19. | PASS |
| **P18-QA-09** | Memory & Performance | Memory footprint delta $\le 12\text{MB}$; maintains stable 60 FPS on low-end test device. | PASS |
| **P18-QA-10** | Save / Undo Integrity | Reversing moves restores cycle clocks, elevator heights, and boulder positions deterministically. | PASS |

---

## 3. Remote Config & Phased Rollout Schedule

Phase 18 is gated via Firebase Remote Config flag:
```json
{
  "maxPhase": 18,
  "phase_18_rollout_percentage": 100,
  "min_app_version": "2.18.0"
}
```

### Staged Rollout Timeline:
- **Day 1:** Internal QA & TestFlight dogfooding (100% internal).
- **Day 3:** 5% staged rollout to production users who completed Phase 17.
- **Day 5:** Crashlytics error rate verification ($< 0.1\%$ crash-free threshold). Expand to 25%.
- **Day 7:** Expand to 100% global rollout.

---

## 4. References & Cross-Links
- [Phase 18 Signature System](../gameplay/phase-18-signature-system.md)
- [Phase 18 Rewards](../economy/phase-18-rewards.md)
- [Shared Core Standard §15.2](../../SHARED_CORE_STANDARD.md)
