# Technical Specification: Phase 16 QA and Rollout Standards (Treasure Keys)

**Status:** Draft  
**Phase:** 16 (Levels 7501–8000)  
**Theme:** Treasure Keys (Keys Deluxe)  
**Document Type:** Technical QA and Deployment Specification  
**Source Cross-Reference:** [phases/phase_16/06_UI_AND_QA_PHASE_16.md](../../phases/phase_16/06_UI_AND_QA_PHASE_16.md), [SHARED_CORE_STANDARD.md §15.2, §17.40](../../SHARED_CORE_STANDARD.md)

---

## 1. Automated CI Pre-Validation Suite

Prior to packaging or promoting Phase 16 levels to staging:
1. **Binary Asset Integrity:**
   - Verify `assets/levels/phase_16.bin` contains exactly 500 valid level records (Levels 7501 to 8000).
   - Asset checksum SHA-256 matches build manifest.
2. **Automated Solver Verifications:**
   - Every level must possess $\ge 1$ deterministic winning move path using headless DAG BFS solver.
   - Solver verify test run timeout $\le 15\text{ms}$ per level.
   - Zero impossible lock loops (e.g. Key A trapped behind Gate A requiring Key A to open).
3. **Move Budget Headroom:**
   - Gold 3-star par threshold $\ge \text{optimal moves} + 4$.
   - Failure move limit $\ge \text{optimal moves} \times 1.5$.

---

## 2. QA Acceptance Checklist (P16-QA-01 to P16-QA-10)

| Test ID | Test Category | Verification Condition | Status |
| :---: | :--- | :--- | :---: |
| **P16-QA-01** | Key Vine Release | Unlocking a vine gate successfully drops the tethered dependent key on board. | PASS |
| **P16-QA-02** | Half-Key Crafting | Collecting Half-Key A + Half-Key B triggers forge event and outputs 1 Master Key. | PASS |
| **P16-QA-03** | Incomplete Craft Reject | Attempting to unlock a Master Lock with only 1 half-key fails with lock recoil VFX. | PASS |
| **P16-QA-04** | Skeleton Key Universal | M753 Skeleton Key opens any colored lock, consuming 1 Skeleton Key from inventory. | PASS |
| **P16-QA-05** | Key Swap Pedestal | Stepping on pedestal swaps held key with pedestal key seamlessly in 0 extra moves. | PASS |
| **P16-QA-06** | Color Matching Lock | Color-coded locks reject non-matching colored keys with clear feedback bonk. | PASS |
| **P16-QA-07** | Economy Payout | All 49 milestone gift baskets and 20 Slither Rush events award specified coin amounts. | PASS |
| **P16-QA-08** | Grand Finale L8000 | Completing Level 8000 awards 1000 coins, 6 boosters, Treasure Vault badge, and unlocks Phase 17. | PASS |
| **P16-QA-09** | Memory & Performance | Memory footprint delta $\le 12\text{MB}$; maintains stable 60 FPS on low-end test device. | PASS |
| **P16-QA-10** | Save / Undo Integrity | Reversing moves restores key collection, vine unspooling, and pedestal exchanges deterministically. | PASS |

---

## 3. Remote Config & Phased Rollout Schedule

Phase 16 is gated via Firebase Remote Config flag:
```json
{
  "maxPhase": 16,
  "phase_16_rollout_percentage": 100,
  "min_app_version": "2.16.0"
}
```

### Staged Rollout Timeline:
- **Day 1:** Internal QA & TestFlight dogfooding (100% internal).
- **Day 3:** 5% staged rollout to production users who completed Phase 15.
- **Day 5:** Crashlytics error rate verification ($< 0.1\%$ crash-free threshold). Expand to 25%.
- **Day 7:** Expand to 100% global rollout.

---

## 4. References & Cross-Links
- [Phase 16 Signature System](../gameplay/phase-16-signature-system.md)
- [Phase 16 Rewards](../economy/phase-16-rewards.md)
- [Shared Core Standard §15.2](../../SHARED_CORE_STANDARD.md)

