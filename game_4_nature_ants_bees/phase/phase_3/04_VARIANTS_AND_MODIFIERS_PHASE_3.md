# 04 — Variants & Modifiers, Phase 3 (વેરિઅન્ટ્સ)
> Phase 3 ના 45 વેરિઅન્ટ સ્લોટ્સ: Base Mechanics × 10 Modifiers ના ચોક્કસ નિયમો અને કોમ્બિનેશન્સ.

**Related docs:** [Phase 3 README](./README.md) · [Shared Core Standard §11](../../SHARED_CORE_STANDARD.md) · [Scaling to 10,000 §7](../../SCALING_TO_10000_LEVELS.md) · [02 Level Plan](./02_LEVEL_PLAN_1001_1500.md)

---

## 1. Variant Architecture
Standard §11 મુજબ દરેક variant એક અગાઉ અનલૉક થયેલા base mechanic અને એક standard modifier નું સંયોજન છે:
- **Variant Formula:** `Base Mechanic × Modifier`
- **45 Slots:** 50 બ્લોક્સમાંથી Signature Intro (Block 1), 4 Base Intros (Blocks 2, 14, 26, 38) અને Review Block (Block 50) બાદ કરતાં બાકીના 45 બ્લોક્સના x1 સ્લોટ પર 1 નવો variant રજૂ થાય છે.
- **Tutorial Presentation:** દરેક variant ના x1 સ્લોટ પર 1-line tutorial card પ્રદર્શિત થાય છે (દા.ત. "Frozen Sunrise Gate — stays closed until 2 adjacent lines leave").

## 2. The 10 Modifiers (SCALING §7)
| Modifier | નિયમ | સુસંગતતા |
|---|---|---|
| `Frozen(K)` | નજીકની K lines exit ન થાય ત્યાં સુધી instance નિષ્ક્રિય રહે છે (Badge K). | All mechanics |
| `Colored(c)` | માત્ર `c` રંગની લાઈનોને જ અસર કરે છે; અન્ય લાઈનો માટે ખાલી સેલ જેવું રહે છે. | Gates, bridges, edge walls |
| `Fogged` | M010 ધુમ્મસ નીચે ઢંકાયેલું રહે છે; ધુમ્મસ હટતાં દેખાય છે. | All mechanics |
| `Chained` | 2 instances એકબીજા સાથે જોડાયેલ છે; એક બદલાય તો બીજું પણ તે જ ક્ષણે બદલાય. | Gates, levers, rotors |
| `Countdown(N)` | પ્રથમ N moves સુધી જ સક્રિય રહે છે, પછી કાયમી નિષ્ક્રિય બને છે. | Blocker, gates, controls |
| `Phasing` | Even moves પર સક્રિય, Odd moves પર અદ્રશ્ય/નિષ્ક્રિય. | Blockers, gates, lines |
| `Armored` | Leaf Blower થી ઉડાડી શકાતું નથી; માત્ર લીવર અથવા પઝલ નિયમથી દૂર થાય. | Blockers, push blocks |
| `Layered(mask)`| સ્પષ્ટ layer mask (દા.ત. `[1]` = માત્ર bees) લાગુ કરે છે. | Gates, deflectors, tiles |
| `Mirrored` | સેન્ટ્રલ અક્ષિસની સામે ડુપ્લિકેટ બને છે અને સ્ટેટ શેર કરે છે. | Static & directional items |
| `Growing(N)` | દર N moves એ એક સેલ આગળ વધે છે. | Brambles, moss, vines |

## 3. Phase 3 Variant Slot Allocation (45 Slots)
| Block | Level | Variant Themed Name | Base × Modifier |
|---|---|---|---|
| **3** | L1021 | Frozen Sunrise Gate | M101 × `Frozen(2)` |
| **4** | L1031 | Colored Sunrise Gate | M101 × `Colored(Blue)` |
| **5** | L1041 | Fogged Sunrise Gate | M101 × `Fogged` |
| **6** | L1051 | Chained Sunrise Gates | M101 × `Chained` |
| **7** | L1061 | Countdown Sunrise Gate | M101 × `Countdown(8)` |
| **8** | L1071 | Phasing Garden Pebble | M001 × `Phasing` |
| **9** | L1081 | Mirrored Twig Fence | M002 × `Mirrored` |
| **10** | L1091 | Armored Dirt Clod | M016 × `Armored` |
| **11** | L1101 | Growing Bramble Row | M002 × `Growing(4)` |
| **12** | L1111 | Layered Petal Gate | M005 × `Layered(air)` |
| **13** | L1121 | Frozen Bamboo Tube | M006 × `Frozen(1)` |
| **15** | L1141 | Fogged Moonlit Bridge | M102 × `Fogged` |
| **16** | L1151 | Chained Moonlit Bridges | M102 × `Chained` |
| **17** | L1161 | Countdown Moonlit Bridge | M102 × `Countdown(10)` |
| **18** | L1171 | Phasing Curled Leaf | M014 × `Phasing` |
| **19** | L1181 | Mirrored Spinning Daisy | M013 × `Mirrored` |
| **20** | L1191 | Colored Acorn Plate | M019 × `Colored(Red)` |
| **21** | L1201 | Armored Old Stone Wall | M074 × `Armored` |
| **22** | L1211 | Frozen Pinecone Bumper | M052 × `Frozen(2)` |
| **23** | L1221 | Growing Creeping Moss | M027 × `Growing(3)` |
| **24** | L1231 | Layered Dandelion Lift | M056 × `Layered(ground->canopy)` |
| **25** | L1241 | Countdown Sleepy Tulip | M057 × `Countdown(6)` |
| **27** | L1261 | Frozen Dawn Burrow | M103 × `Frozen(3)` |
| **28** | L1271 | Colored Dawn Burrow | M103 × `Colored(Yellow)` |
| **29** | L1281 | Chained Dawn Burrows | M103 × `Chained` |
| **30** | L1291 | Fogged Dawn Burrow | M103 × `Fogged` |
| **31** | L1301 | Phasing Rolling Acorn | M053 × `Phasing` |
| **32** | L1311 | Mirrored Seed Socket | M055 × `Mirrored` |
| **33** | L1321 | Armored Thorn Lock | M004 × `Armored` |
| **34** | L1331 | Countdown Sunbeam Lens | M084 × `Countdown(12)` |
| **35** | L1341 | Layered Beetle Mirror | M086 × `Layered(air)` |
| **36** | L1351 | Frozen Dew Prism | M089 × `Frozen(2)` |
| **37** | L1361 | Growing Hedge Gap | M071 × `Growing(5)` |
| **39** | L1381 | Frozen Day-Bloom Line | M104 × `Frozen(2)` |
| **40** | L1391 | Phasing Day-Bloom Line | M104 × `Phasing` |
| **41** | L1401 | Fogged Day-Bloom Line | M104 × `Fogged` |
| **42** | L1411 | Chained Day-Bloom Lines | M104 × `Chained` |
| **43** | L1421 | Countdown Day-Bloom Line | M104 × `Countdown(10)` |
| **44** | L1431 | Mirrored Day-Bloom Line | M104 × `Mirrored` |
| **45** | L1441 | Armored Great Stag Beetle | M098 × `Armored` |
| **46** | L1451 | Layered Solar Sunflower | M085 × `Layered(canopy)` |
| **47** | L1461 | Growing Mud Puddle | M037 × `Growing(4)` |
| **48** | L1471 | Colored Royal Hive Door | M099 × `Colored(Gold)` |
| **49** | L1481 | Chained Twin Mushrooms | M060 × `Chained` |

*(બધા 45 slots standard compatibility matrix અનુસાર ચકાસાયેલ છે).*

