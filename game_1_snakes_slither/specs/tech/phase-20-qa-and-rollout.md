# Technical Specification: Phase 20 QA and Rollout Standards (Grand Jungle Master)

**Status:** Draft  
**Phase:** 20 (Levels 9501–10,000)  
**Theme:** Grand Jungle Master (All Systems Culmination & Level 10,000 Grand Finale)  
**Document Type:** Technical QA and Deployment Specification  
**Source Cross-Reference:** [phases/phase_20/06_UI_AND_QA_PHASE_20.md](../../phases/phase_20/06_UI_AND_QA_PHASE_20.md), [SHARED_CORE_STANDARD.md §15.2, §17.40](../../SHARED_CORE_STANDARD.md)

---

## 1. Automated CI Pre-Validation Suite

Prior to packaging or promoting Phase 20 levels to staging:
1. **Binary Asset Integrity:**
   - Verify `assets/levels/phase_20.bin` contains exactly 500 valid level records (Levels 9501 to 10000).
   - Asset checksum SHA-256 matches build manifest.
2. **Automated Solver Verifications:**
   - Every level must possess $\ge 1$ deterministic winning move path using headless master AI solver.
   - Solver verify test run timeout $\le 15\text{ms}$ per level.
   - Verify zero softlock traps across all 14 integrated systems.
   - Verify Level 10,000 deterministic win path in $\le 88$ moves.
3. **Move Budget Headroom:**
   - Gold 3-star par threshold $\ge \text{optimal moves} + 4$.
   - Failure move limit $\ge \text{optimal moves} \times 1.5$.

---

## 2. QA Acceptance Checklist (P20-QA-01 to P20-QA-10)

| Test ID | Test Category | Verification Condition | Status |
| :---: | :--- | :--- | :---: |
| **P20-QA-01** | Apex Boss Telegraph | Boss spots snake $\le 4$ tiles in line-of-sight and projects threat corridor for 1 full turn before rushing. | PASS |
| **P20-QA-02** | Boss Obstacle Stun | Baiting boss into wall, boulder, or trapdoor stuns boss for exactly 3 turns without moving. | PASS |
| **P20-QA-03** | Prismatic Omni-Key | Collecting Master Key immediately unlocks all elemental gates across the board in 1 tick. | PASS |
| **P20-QA-04** | Vortex Tail Continuity | Snake gliding through Convergence Vortex maintains seamless tail segment curvature. | PASS |
| **P20-QA-05** | Crown Pedestal Win | Sovereign serpent mounting the Jungle Crown Pedestal immediately triggers victory coronation. | PASS |
| **P20-QA-06** | Zero Twitch Reflex | Boss mechanics are 100% turn-based; player has infinite thinking time between moves. | PASS |
| **P20-QA-07** | Economy Payout | All 49 milestone gift baskets and 20 Slither Rush events award specified coin amounts. | PASS |
| **P20-QA-08** | Level 10,000 Climax | Completing Level 10,000 awards 5,000 coins, 15 boosters, Sovereign skin, badge, and Endless mode. | PASS |
| **P20-QA-09** | Memory & Performance | Memory footprint delta $\le 12\text{MB}$; maintains stable 60 FPS on low-end test device. | PASS |
| **P20-QA-10** | Save / Undo Integrity | Reversing moves restores boss telegraphs, stun states, and omni-key states deterministically. | PASS |

---

## 3. Remote Config & Phased Rollout Schedule

Phase 20 is gated via Firebase Remote Config flag:
```json
{
  "maxPhase": 20,
  "phase_20_rollout_percentage": 100,
  "min_app_version": "2.20.0"
}
```

### Staged Rollout Timeline:
- **Day 1:** Internal QA & TestFlight dogfooding (100% internal).
- **Day 3:** 5% staged rollout to production users who completed Phase 19.
- **Day 5:** Crashlytics error rate verification ($< 0.1\%$ crash-free threshold). Expand to 25%.
- **Day 7:** Expand to 100% global rollout across the entire player base.

---

## 4. References & Cross-Links
- [Phase 20 Signature System](../gameplay/phase-20-signature-system.md)
- [Phase 20 Rewards](../economy/phase-20-rewards.md)
- [Shared Core Standard §15.2](../../SHARED_CORE_STANDARD.md)

