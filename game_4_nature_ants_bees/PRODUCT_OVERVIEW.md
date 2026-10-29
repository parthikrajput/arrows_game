# Product Overview: Ants & Bees: Garden Trails

## What is it?
Lines of ants walk on the ground and lines of bees fly in the air on a sunny garden grid. Tapping a line moves it out of the garden if its lane is clear, otherwise it bumps and the player loses 1 Heart. Ants and bees never block each other, so from level 41 a cell can hold two puzzles at once.

Theme: lines of ants (ground) and bees (air) leave a garden.

## Who is it for?
Casual puzzle players aged 10 to 50. Sessions run from about 10 seconds (first levels) to 2 to 4 minutes (late levels). There is no wall-clock timer in the puzzle itself.

## How is it different?
- Living characters with feedback on every tap, not plain arrows.
- A new themed mechanic every 10 levels (49 mechanics in Phase 1).
- Fair puzzles: every level can be solved with 0 hearts lost and 0 boosters (checked by a CI solver).
- Respectful ads: no interstitials in levels 1 to 10, 120 second gap, optional rewarded ads, VIP pass at Rs 20 per month.

## Main features
- 3 Hearts per attempt. One ad revive per level. Heart Refill for 120 coins, at most 2 per attempt.
- Boosters: Nectar Glow Hint (Hint), Queen's Royal Shield (Shield), Leaf Blower (Hammer), Scent Trail Preview (free long-press).
- Shop, coins, Gift Boxes, Coin Rush bonus round.
- Daily Challenge with a 7-day streak.
- Phase 1: levels 1 to 500. Phase 2: levels 501 to 1000 with LiveOps. Phases 3 to 20: up to level 10,000.

## Notes
Two layers: ant lanes are blocked by ant lines and all ground obstacles; bee lanes only by bee lines and obstacles marked tall.

This game is one of four games that share one puzzle engine and one rule book. See ./SHARED_CORE_STANDARD.md and ../README.md.

## Current state
This folder holds design and technical documents only. There is no code yet. The tech plan is Flutter with a shared engine package called puzzle_core.
