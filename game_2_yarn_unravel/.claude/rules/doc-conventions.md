# Documentation Conventions

- Numbers and rules (hearts, prices, unlock levels, ad caps, coin rewards) are defined only in ../../SHARED_CORE_STANDARD.md. In this game's docs, quote them only if the value is identical, and never invent a different one.
- Never change a shared number in one game only. Change the standard first, then check the other three game folders for the same value.
- Keep the phase doc numbering: phase_1/01 to 07, phase_2/01 to 06. Add new docs with the next number and add them to the folder map in README.md.
- Each doc starts with a title, a one-line purpose, and a Related docs line. Use relative links only, never file:/// links.
- Mechanics use IDs M001 to M099 from the shared mechanics library. Do not reuse or renumber an ID.
- Every level must stay solvable with 0 hearts lost and 0 boosters. Any level or mechanic change must say how this is still true.
- No wall-clock timers in puzzles. Timed obstacles count Moves. The only exception is the 30 second Coin Rush bonus round.
- Keep theme names (booster names, currency names, mechanic names) as already written in this game's README.md. Do not mix names from the other three games.
