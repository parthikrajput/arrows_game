/// Player-facing name and one-line rule of every Phase 1 mechanic, for the
/// Grandpa Tortoise intro card and Settings › Jungle Guide.
class MechanicInfo {
  const MechanicInfo(this.type, this.name, this.rule, {this.heartNote});
  final String type;
  final String name;
  final String rule;

  /// Shown under the animation when the mechanic can cost a heart.
  final String? heartNote;
}

const _bonk = 'Bonk = −1 heart berry';

const mechanicInfo = <String, MechanicInfo>{
  'M001': MechanicInfo('M001', 'Garden Rock', 'A rock blocks any snake that heads into it. Clear the other snakes first, or slither around it.', heartNote: _bonk),
  'M002': MechanicInfo('M002', 'Fallen Log', 'A long log blocks every lane that crosses it. The Hammer can smash the whole log.', heartNote: _bonk),
  'M003': MechanicInfo('M003', 'Frost Coil', 'A frozen snake thaws after its number of neighbours slither out.'),
  'M004': MechanicInfo('M004', 'Bamboo Cage & Key', 'The cage opens when the snake carrying the matching key leaves.', heartNote: _bonk),
  'M005': MechanicInfo('M005', 'Flower Gate', 'Only snakes of the flower\'s colour may pass through.', heartNote: _bonk),
  'M006': MechanicInfo('M006', 'Bamboo One-Way', 'Pass only in the arrow\'s direction.', heartNote: _bonk),
  'M007': MechanicInfo('M007', 'Lotus Bud Gate', 'The bud opens for good after its number of moves.', heartNote: _bonk),
  'M008': MechanicInfo('M008', 'Rabbit Burrows', 'Go in one burrow, come out of its twin, same direction.'),
  'M009': MechanicInfo('M009', 'Branch Lever & Twig Gates', 'Tap the lever to open or close every linked twig gate. It costs 1 move.'),
  'M010': MechanicInfo('M010', 'Jungle Mist', 'Snakes under the mist are hidden. A snake touching the mist clears it when it leaves.'),
  'M011': MechanicInfo('M011', 'Vine-Tied Twins', 'Tap one twin and both slither. If either is blocked, both bonk.', heartNote: _bonk),
  'M012': MechanicInfo('M012', 'Sleepy Python', 'The first tap wakes it up (1 move). The next tap slithers it out.'),
  'M013': MechanicInfo('M013', 'Spinning Lilypad', 'Tap the snake\'s head to turn it a quarter turn clockwise (1 move).'),
  'M014': MechanicInfo('M014', 'Mushroom Bumper', 'Lanes bounce off the mushroom at a right angle.'),
  'M015': MechanicInfo('M015', 'Root Bridge', 'Snakes can cross under the bridge in the other direction.'),
  'M016': MechanicInfo('M016', 'Termite Mound', 'Every snake that slithers past it knocks off 1 HP. At 0 it crumbles.', heartNote: _bonk),
  'M017': MechanicInfo('M017', 'Restless Caterpillar', 'Get it out before its counter runs out, or lose a heart berry.', heartNote: 'Counter at 0 = −1 heart berry'),
  'M018': MechanicInfo('M018', 'Fern Fork Switch', 'Lanes turn left or right here. Tap the switch to flip it (1 move).'),
  'M019': MechanicInfo('M019', 'Mossy Pressure Stone', 'Its gate stays open only while a snake lies on the stone.', heartNote: _bonk),
  'M020': MechanicInfo('M020', 'Home Burrow', 'A hole in the garden: any snake whose lane reaches it slithers home.'),
  'M021': MechanicInfo('M021', 'Phantom Snake', 'Solid on even moves, a see-through ghost on odd moves.'),
  'M022': MechanicInfo('M022', 'Reverse Slither', 'This snake leaves tail first. Follow the arrow on its tail.'),
  'M023': MechanicInfo('M023', 'Two-Headed Hydra', 'Two heads! Tap near the end you want it to leave from.'),
  'M024': MechanicInfo('M024', 'Giant Anaconda', 'A wide snake needs a lane two cells wide.', heartNote: _bonk),
  'M025': MechanicInfo('M025', 'Patrolling Beetle', 'The beetle walks its loop one step every move and blocks lanes.', heartNote: _bonk),
  'M026': MechanicInfo('M026', 'Jungle Gems', 'Collect every gem by slithering over it to win.'),
  'M027': MechanicInfo('M027', 'Creeping Vine', 'The vine grows a cell every few moves. The Hammer cuts a cell.', heartNote: _bonk),
  'M028': MechanicInfo('M028', 'Hatch Order Snakes', 'Numbered snakes leave in order: 1, then 2, then 3.'),
  'M029': MechanicInfo('M029', 'Hedge Border', 'No snake can leave through a hedge on the edge.', heartNote: _bonk),
  'M030': MechanicInfo('M030', 'Flower Arch Exit', 'Only snakes of the arch\'s colour may leave through it.', heartNote: _bonk),
  'M031': MechanicInfo('M031', 'Closing Hedge Gap', 'The gap in the hedge closes for good after its number of moves.', heartNote: _bonk),
  'M032': MechanicInfo('M032', 'Canopy & Ground', 'Snakes up in the canopy cover the ones below. Free the top first.'),
  'M033': MechanicInfo('M033', 'Petal Cage', 'The caged snake is free once every other snake of the cage\'s colour is gone.'),
  'M034': MechanicInfo('M034', 'Whirl Stump', 'Tap the stump\'s centre to turn everything inside a quarter turn (1 move).'),
  'M035': MechanicInfo('M035', 'Mama Snake', 'When Mama leaves, a baby hatches from the eggs as soon as they are clear.'),
  'M036': MechanicInfo('M036', 'Hungry Caterpillar', 'It only leaves if its lane passes a berry. No berry = bonk.', heartNote: _bonk),
  'M037': MechanicInfo('M037', 'Sticky Swamp Mud', 'A snake that slides into mud stops there. Tap again to pull it out.'),
  'M038': MechanicInfo('M038', 'Bouncy Fern Pad', 'The lane hops over the next cell. It can hop a rock, never a snake.'),
  'M039': MechanicInfo('M039', 'Pond Twins', 'Tap one and its mirror twin slithers too. Both lanes must be clear.', heartNote: _bonk),
  'M040': MechanicInfo('M040', 'Jungle Night', 'It\'s dark! Only the last snake you moved glows. Hold a snake to light its path.'),
  'M041': MechanicInfo('M041', 'Chameleon Snake', 'Its colour changes every move: red, green, blue…'),
  'M042': MechanicInfo('M042', 'Dry Twig Bridge', 'One snake may cross, then it snaps into a blocker.', heartNote: _bonk),
  'M043': MechanicInfo('M043', 'Big Knot Cage', 'Needs every key snake to leave before it opens.', heartNote: _bonk),
  'M044': MechanicInfo('M044', 'Twisty Burrow', 'Go in one burrow and come out of its twin facing a new way.'),
  'M045': MechanicInfo('M045', 'Root Gear Lever', 'One tap turns every linked lilypad a quarter turn (1 move).'),
  'M046': MechanicInfo('M046', 'Tail-Biter Loop', 'This snake bites its tail until its key snake leaves.'),
  'M047': MechanicInfo('M047', 'Growing Caterpillar', 'Its tail grows a cell every few moves. Hurry!'),
  'M048': MechanicInfo('M048', 'Snake Parade', 'Tap one and every parade snake of that colour slithers together.', heartNote: _bonk),
  'M049': MechanicInfo('M049', 'Grumpy Mongoose', 'Each linked snake that leaves takes 1 HP. At 0 the mongoose leaves in a puff of leaves.', heartNote: _bonk),
};
