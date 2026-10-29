from v2_common import *

# ---------------- Splash ----------------
inner = (corner_leaves() + falling_leaves(8, 5) + status() +
  '<div style="position: relative; z-index: 2; height: 800px; display: flex; flex-direction: column; align-items: center;">'
  '<div aria-hidden="true" style="position: absolute; top: 110px; width: 360px; height: 360px; border-radius: 50%; background: radial-gradient(circle, rgba(255,255,255,0.95) 0%, rgba(255,250,225,0.6) 40%, rgba(255,255,255,0) 70%);"></div>'
  '<img src="' + B['logo'] + '" alt="Snake Slither" style="position: relative; margin-top: 128px; width: 340px; animation: ssPop .9s cubic-bezier(.2,1.2,.4,1) both, ssBob 4s ease-in-out 1s infinite;">'
  "<p style=\"position: relative; margin: 18px 0 0; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 19px; letter-spacing: 0.5px; color: " + FOREST + "; animation: ssIn .7s .6s both;\">Play. Grow. Win.</p>"
  '<div style="margin-top: auto; width: 230px; animation: ssIn .6s 1s both;">' + btn('Tap to Start', 'Home.dc.html', 58, '230px', 20, anim='ssPulse 2.2s ease-in-out 1.6s infinite') + '</div>'
  '<span style="margin: 26px 0 30px; font-size: 12px; font-weight: 700; color: #8A9A8E;">v1.0.0</span>'
  '</div>')
write('Main.dc.html', head('Splash') + root(inner) + foot())

# ---------------- Home ----------------
navitems = [('Home', 'Home.dc.html', '<path d="M4 11 L12 4 L20 11 V20 H14 V14 H10 V20 H4 Z"/>', True),
            ('Shop', 'Shop.dc.html', '<path d="M5 8 H19 L18 20 H6 Z"/><path d="M9 8 V6 a3 3 0 0 1 6 0 V8"/>', False),
            ('Ranks', 'Leaderboards.dc.html', '<path d="M4 20 V13 H9 V20 Z M9.5 20 V8 H14.5 V20 Z M15 20 V11 H20 V20 Z"/>', False),
            ('Awards', 'Rewards.dc.html', '<circle cx="12" cy="9" r="5"/><path d="M8.5 13 L7 21 L12 18.5 L17 21 L15.5 13"/>', False),
            ('Settings', 'Settings.dc.html', '<circle cx="12" cy="12" r="3.2"/><path d="M12 2.8 V5.2 M12 18.8 V21.2 M2.8 12 H5.2 M18.8 12 H21.2 M5.5 5.5 L7.2 7.2 M16.8 16.8 L18.5 18.5 M5.5 18.5 L7.2 16.8 M16.8 7.2 L18.5 5.5"/>', False)]
nav = ''.join('<a href="' + h + '" class="ss-press" style="flex: 1; display: flex; flex-direction: column; align-items: center; gap: 3px; padding-top: 10px; color: ' + (EMERALD if on else '#7D8C80') + ';">'
              '<span style="width: 44px; height: 30px; border-radius: 15px; display: flex; align-items: center; justify-content: center; ' + ('background: #E3F2D3;' if on else '') + '">'
              '<svg width="22" height="22" viewBox="0 0 24 24" fill="' + ('currentColor' if on else 'none') + '" stroke="currentColor" stroke-width="2" stroke-linejoin="round" stroke-linecap="round" aria-hidden="true">' + ic + '</svg></span>'
              '<span style="font-size: 11px; font-weight: 800;">' + n + '</span></a>' for n, h, ic, on in navitems)
inner = (corner_leaves() + status() +
  '<div style="position: relative; z-index: 2; padding: 6px 16px 0; display: flex; align-items: center; gap: 8px;">'
  '<a href="Profile.dc.html" aria-label="Profile" class="ss-press" style="width: 44px; height: 44px; border-radius: 22px; border: 3px solid #FFFFFF; box-shadow: 0 0 0 2px ' + EMERALD + ', 0 6px 12px rgba(22,59,40,0.18); overflow: hidden; display: block;">' + avatar(38) + '</a>'
  '<div style="flex: 1;"></div>' + pill(coin(22), '8,420', 'Shop.dc.html', True) + pill(gem(20), '96', 'Shop.dc.html', True) + '</div>'
  '<a href="Rewards.dc.html" class="ss-press" aria-label="Free gift" style="position: absolute; z-index: 3; right: 16px; top: 112px; width: 64px; display: flex; flex-direction: column; align-items: center; animation: ssBob 2.6s ease-in-out infinite;">'
  '<span style="width: 60px; height: 60px; border-radius: 18px; background: ' + CARD + '; border: 1px solid #ECE5CF; box-shadow: 0 8px 18px rgba(22,59,40,0.14); display: flex; align-items: center; justify-content: center;">' + gift(44) + '</span>'
  '<span style="margin-top: -8px; padding: 2px 7px; border-radius: 8px; background: #E84B3C; color: #FFF; font-size: 10px; font-weight: 800; letter-spacing: 0.4px; box-shadow: 0 2px 0 #A8281C;">FREE GIFT</span>'
  '<span aria-hidden="true" style="position: absolute; right: -2px; top: -4px; width: 12px; height: 12px; border-radius: 6px; background: #E84B3C; border: 2px solid #FFF;"></span></a>'
  '<div style="position: relative; z-index: 1; height: 330px; display: flex; justify-content: center; align-items: flex-end; margin-top: 4px;">'
  '<div aria-hidden="true" style="position: absolute; bottom: 30px; width: 300px; height: 300px; border-radius: 50%; background: radial-gradient(circle, rgba(255,255,255,0.95), rgba(255,255,255,0) 68%);"></div>'
  '<img src="' + B['home'] + '" alt="Snake mascot on a platform" style="position: relative; width: 292px; animation: ssBob 3.6s ease-in-out infinite;"></div>'
  '<div style="position: relative; z-index: 2; margin: 14px 24px 0; border-radius: 20px; animation: ssGlow 2.4s ease-out infinite;">' + btn('Play', 'LevelMap.dc.html', 64, '100%', 26, icon='<svg width="22" height="22" viewBox="0 0 24 24" aria-hidden="true" style="position: relative;"><path d="M7 4.5 L19.5 12 L7 19.5 Z" fill="#FFFFFF" stroke="#FFFFFF" stroke-width="2" stroke-linejoin="round"/></svg>') + '</div>'
  '<div style="position: relative; z-index: 2; padding: 18px 16px 0; display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">'
  '<a href="LevelMap.dc.html" class="ss-press ss-in" style="display: block; animation-delay: .1s;">' + card(
     '<div style="display: flex; align-items: center; gap: 8px;"><span style="width: 36px; height: 36px; border-radius: 12px; background: #E3F2D3; display: flex; align-items: center; justify-content: center;">' + leaf_svg(24) + '</span>'
     "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px;\">Levels</span></div>"
     '<div style="margin-top: 8px; display: flex; justify-content: space-between; font-size: 13px; font-weight: 800; color: ' + MUTED + ';"><span>12 / 200</span><span>6%</span></div>'
     '<div style="margin-top: 6px; height: 8px; border-radius: 4px; background: #ECE5CF; overflow: hidden;"><div style="width: 6%; min-width: 14px; height: 100%; border-radius: 4px; background: linear-gradient(90deg, ' + LEAF + ', ' + EMERALD + ');"></div></div>', 'padding: 12px;') + '</a>'
  '<a href="Daily.dc.html" class="ss-press ss-in" style="display: block; position: relative; animation-delay: .2s;">' + card(
     '<div style="display: flex; align-items: center; gap: 8px;"><span style="width: 36px; height: 36px; border-radius: 12px; background: #FDF0CC; display: flex; align-items: center; justify-content: center;">' + star(24) + '</span>'
     "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px; line-height: 1.1;\">Daily<br>Challenge</span></div>"
     '<div style="margin-top: 8px; display: flex; justify-content: space-between; font-size: 13px; font-weight: 800; color: ' + MUTED + ';"><span>1 / 3 done</span><span style="color: #D9822B;">6h left</span></div>'
     '<div style="margin-top: 6px; height: 8px; border-radius: 4px; background: #ECE5CF; overflow: hidden;"><div style="width: 33%; height: 100%; border-radius: 4px; background: linear-gradient(90deg, #FFD84A, ' + GOLD + ');"></div></div>', 'padding: 12px;')
  + '<span aria-hidden="true" style="position: absolute; right: 8px; top: 8px; width: 10px; height: 10px; border-radius: 5px; background: #E84B3C; border: 2px solid #FFF;"></span></a>'
  '</div>'
  '<nav aria-label="Main" style="position: absolute; z-index: 3; left: 0; right: 0; bottom: 0; height: 84px; padding: 0 8px 18px; box-sizing: border-box; display: flex; background: ' + CARD + '; border-top: 1px solid #ECE5CF; border-radius: 24px 24px 0 0; box-shadow: 0 -8px 24px rgba(22,59,40,0.08);">' + nav + '</nav>')
write('Home.dc.html', head('Home') + root(inner) + foot())

# ---------------- Level Map ----------------
nodes = [(150, 600, 1, 'done', 3), (252, 528, 2, 'done', 2), (160, 452, 3, 'current', 0), (238, 374, 4, 'locked', 0), (140, 300, 5, 'locked', 0), (236, 228, 6, 'locked', 0), (156, 160, 7, 'locked', 0), (250, 96, 8, 'locked', 0)]
pathd = 'M 200 860 C 120 760, 110 660, 150 600 S 290 560, 252 528 S 120 480, 160 452 S 290 400, 238 374 S 100 330, 140 300 S 280 260, 236 228 S 110 190, 156 160 S 290 120, 250 96 S 200 40, 230 -20'
nodesvg = ''
for x, y, n, st, stars in nodes:
    if st == 'done':
        nodesvg += ('<g transform="translate(' + str(x) + ' ' + str(y) + ')"><ellipse cx="0" cy="12" rx="24" ry="8" fill="#000" opacity="0.25"/>'
                    '<circle r="22" cy="4" fill="#B97A08"/><circle r="22" fill="url(#gNode)"/><circle r="16" fill="none" stroke="#FFF3B8" stroke-width="2" opacity="0.8"/>'
                    "<text y=\"7\" text-anchor=\"middle\" style=\"font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 20px;\" fill=\"#7A4A00\">" + str(n) + '</text>'
                    + ''.join('<path transform="translate(' + str(-16 + 16 * i) + ' -32) scale(0.5)" d="M0 -11l3.2 6.6 7.3.9-5.4 5 1.4 7.2L0 15.1l-6.5 3.6 1.4-7.2-5.4-5 7.3-.9z" fill="' + ('#FFD84A' if i < stars else '#D8D2BE') + '" stroke="#B97A08" stroke-width="1.4"/>' for i in range(3)) + '</g>')
    elif st == 'current':
        nodesvg += ('<g transform="translate(' + str(x) + ' ' + str(y) + ')"><circle r="34" fill="#A8D94F" opacity="0.45"><animate attributeName="r" values="28;40;28" dur="1.8s" repeatCount="indefinite"/><animate attributeName="opacity" values="0.6;0;0.6" dur="1.8s" repeatCount="indefinite"/></circle>'
                    '<ellipse cx="0" cy="14" rx="28" ry="9" fill="#000" opacity="0.28"/><circle r="27" cy="5" fill="#03432A"/><circle r="27" fill="url(#cNode)"/><circle r="27" fill="none" stroke="#FFFFFF" stroke-width="3"/>'
                    "<text y=\"8\" text-anchor=\"middle\" style=\"font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 24px;\" fill=\"#FFFFFF\">" + str(n) + '</text>'
                    '<g transform="translate(0 -44)"><animateTransform attributeName="transform" type="translate" values="0 -44; 0 -52; 0 -44" dur="1.4s" repeatCount="indefinite"/>'
                    '<path d="M0 14 C -14 0, -14 -16, 0 -16 C 14 -16, 14 0, 0 14 Z" fill="#E84B3C" stroke="#FFFFFF" stroke-width="2.5"/><circle cy="-4" r="5" fill="#FFFFFF"/></g></g>')
    else:
        nodesvg += ('<g transform="translate(' + str(x) + ' ' + str(y) + ')"><ellipse cx="0" cy="11" rx="21" ry="7" fill="#000" opacity="0.22"/>'
                    '<circle r="20" cy="4" fill="#6E746C"/><circle r="20" fill="url(#sNode)"/>'
                    "<text y=\"7\" text-anchor=\"middle\" style=\"font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 18px;\" fill=\"#4E554E\">" + str(n) + '</text></g>')
mapsvg = ('<svg aria-label="Level path" width="390" height="844" viewBox="0 0 390 844" style="position: absolute; inset: 0; z-index: 1;">'
          '<defs><radialGradient id="gNode" cx="0.38" cy="0.3" r="0.8"><stop offset="0" stop-color="#FFF2A8"/><stop offset="0.5" stop-color="#F9C93A"/><stop offset="1" stop-color="#D98E10"/></radialGradient>'
          '<radialGradient id="cNode" cx="0.38" cy="0.3" r="0.8"><stop offset="0" stop-color="#4FD08A"/><stop offset="0.55" stop-color="#13864D"/><stop offset="1" stop-color="#075B35"/></radialGradient>'
          '<radialGradient id="sNode" cx="0.38" cy="0.3" r="0.8"><stop offset="0" stop-color="#F4F2EA"/><stop offset="0.6" stop-color="#C9C8BE"/><stop offset="1" stop-color="#9DA197"/></radialGradient>'
          '<filter id="pathBlur"><feGaussianBlur stdDeviation="3"/></filter></defs>'
          '<path d="' + pathd + '" fill="none" stroke="#3E5F22" stroke-width="44" stroke-linecap="round" opacity="0.35" filter="url(#pathBlur)"/>'
          '<path d="' + pathd + '" fill="none" stroke="#B8915A" stroke-width="34" stroke-linecap="round"/>'
          '<path d="' + pathd + '" fill="none" stroke="#D9BC85" stroke-width="26" stroke-linecap="round"/>'
          '<path d="' + pathd + '" fill="none" stroke="#E9D3A2" stroke-width="10" stroke-linecap="round" stroke-dasharray="2 18" opacity="0.9"/>'
          '<path d="M 200 860 C 120 760, 110 660, 150 600 S 290 560, 252 528 S 120 480, 160 452" fill="none" stroke="#F4B72F" stroke-width="5" stroke-linecap="round" stroke-dasharray="1 12" opacity="0.9"/>'
          + nodesvg + '</svg>')
inner = ('<img src="' + B['mapbg'] + '" alt="" aria-hidden="true" style="position: absolute; inset: 0; width: 390px; height: 844px; object-fit: cover; z-index: 0;">'
  '<div aria-hidden="true" style="position: absolute; inset: 0 0 auto 0; height: 140px; z-index: 1; background: linear-gradient(180deg, rgba(4,40,22,0.55), rgba(4,40,22,0));"></div>'
  + mapsvg + '<div style="position: relative; z-index: 3;">' + status(True) +
  '<div style="height: 52px; padding: 0 16px; display: flex; align-items: center; gap: 10px;">'
  '<a href="Home.dc.html" aria-label="Back" class="ss-press" style="width: 40px; height: 40px; border-radius: 20px; background: ' + CARD + '; box-shadow: 0 3px 0 #C9BE9C, 0 8px 16px rgba(0,0,0,0.2); display: flex; align-items: center; justify-content: center; color: ' + INK + ';"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 5 L8 12 L15 19"/></svg></a>'
  "<h1 style=\"margin: 0; flex: 1; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 22px; color: #FFFFFF; text-shadow: 0 2px 6px rgba(0,0,0,0.35);\">Level Map</h1>"
  + pill(star(20), '5 / 24', None, False, True) + '</div></div>'
  '<div style="position: absolute; z-index: 3; left: 12px; right: 12px; bottom: 14px; animation: ssIn .5s .2s both;">' + card(
     '<div style="display: flex; align-items: flex-start; gap: 12px;"><div style="flex: 1;">'
     "<h2 style=\"margin: 0; font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 24px;\">Level 3</h2>"
     '<p style="margin: 2px 0 0; font-size: 14px; font-weight: 700; color: ' + MUTED + ';">Complete this level to earn rewards</p></div>'
     '<div style="display: flex; gap: 6px;"><span style="height: 30px; padding: 0 9px; border-radius: 15px; background: #FDF3D3; display: flex; align-items: center; gap: 4px; font-weight: 800; font-size: 14px;">' + coin(18) + '50</span>'
     '<span style="height: 30px; padding: 0 9px; border-radius: 15px; background: #E3F2D3; display: flex; align-items: center; gap: 4px; font-weight: 800; font-size: 14px;">' + gem(16) + '1</span></div></div>'
     '<div style="margin-top: 10px; display: flex; gap: 14px; font-size: 13px; font-weight: 800; color: ' + MUTED + ';"><span>Goal: 600 points</span><span>Fruits: 15</span></div>'
     '<div style="margin-top: 14px;">' + btn('Play', 'Play.dc.html', 56, '100%', 22) + '</div>', 'padding: 16px 16px 18px; border-radius: 24px;') + '</div>')
write('LevelMap.dc.html', head('Level map') + root(inner, '#3C8A2E') + foot())

# ---------------- Gameplay ----------------
def hudbox(label, value):
    return ('<div style="min-width: 86px; height: 50px; padding: 0 12px; box-sizing: border-box; border-radius: 14px; background: rgba(4,52,30,0.72); border: 1px solid rgba(255,255,255,0.16); box-shadow: 0 6px 14px rgba(0,0,0,0.2); display: flex; flex-direction: column; justify-content: center;">'
            '<span style="font-size: 11px; font-weight: 800; letter-spacing: 0.6px; color: #FFD84A;">' + label + '</span>'
            "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 22px; line-height: 1; color: #FFFFFF; font-variant-numeric: tabular-nums;\">" + value + '</span></div>')
dpad = ('<div aria-label="Direction pad" style="position: absolute; z-index: 3; right: 20px; bottom: 34px; width: 132px; height: 132px; border-radius: 66px; background: rgba(4,52,30,0.45); border: 2px solid rgba(255,255,255,0.25); box-shadow: inset 0 2px 8px rgba(0,0,0,0.2), 0 10px 20px rgba(0,0,0,0.2);">'
        + ''.join('<button aria-label="' + n + '" class="ss-press" style="position: absolute; ' + pos + ' width: 40px; height: 40px; border: 0; border-radius: 20px; background: rgba(255,255,255,0.16); cursor: pointer; display: flex; align-items: center; justify-content: center;"><svg width="18" height="18" viewBox="0 0 24 24" aria-hidden="true" style="transform: rotate(' + r + 'deg);"><path d="M12 5 L19 15 H5 Z" fill="#FFFFFF"/></svg></button>'
                  for n, pos, r in [('Up', 'left: 44px; top: 4px;', '0'), ('Down', 'left: 44px; bottom: 4px;', '180'), ('Left', 'left: 4px; top: 44px;', '-90'), ('Right', 'right: 4px; top: 44px;', '90')])
        + '<span aria-hidden="true" style="position: absolute; left: 46px; top: 46px; width: 36px; height: 36px; border-radius: 18px; background: radial-gradient(circle at 35% 30%, #FFFFFF, #CFE6C2); box-shadow: 0 4px 10px rgba(0,0,0,0.3);"></span></div>')
inner = ('<a href="{{ winHref }}" aria-label="Game board (prototype: tap to finish the level)" style="position: absolute; inset: 0; z-index: 0; display: block;"><img src="' + B['board'] + '" alt="Snake on the grass with apples" style="width: 390px; height: 844px; object-fit: cover; display: block;"></a>'
  '<div aria-hidden="true" style="position: absolute; inset: 0 0 auto 0; height: 150px; z-index: 1; pointer-events: none; background: linear-gradient(180deg, rgba(3,35,18,0.5), rgba(3,35,18,0));"></div>'
  '<span aria-hidden="true" style="position: absolute; z-index: 2; left: 262px; top: 188px; font-family: \'Fredoka\', sans-serif; font-weight: 700; font-size: 20px; color: #FFE27A; text-shadow: 0 2px 0 #7A4A00, 0 4px 8px rgba(0,0,0,0.35); animation: ssFloatUp 1.6s ease-out infinite; pointer-events: none;">+10</span>'
  '<div style="position: relative; z-index: 3;">' + status(True) +
  '<div style="padding: 4px 16px 0; display: flex; align-items: center; gap: 10px;">'
  '<a href="Pause.dc.html" aria-label="Pause" class="ss-press" style="width: 50px; height: 50px; border-radius: 25px; background: rgba(4,52,30,0.72); border: 1px solid rgba(255,255,255,0.16); box-shadow: 0 6px 14px rgba(0,0,0,0.2); display: flex; align-items: center; justify-content: center;"><svg width="20" height="20" viewBox="0 0 24 24" aria-hidden="true"><rect x="5" y="4" width="5" height="16" rx="1.5" fill="#FFFFFF"/><rect x="14" y="4" width="5" height="16" rx="1.5" fill="#FFFFFF"/></svg></a>'
  '<div style="flex: 1;"></div>'
  '<a href="{{ failHref }}" aria-label="Score (prototype: tap to fail)" style="display: block;">' + hudbox('SCORE', '{{ score }}') + '</a>' + hudbox('BEST', '{{ best }}') + '</div>'
  '<div style="margin: 10px 16px 0; height: 8px; border-radius: 4px; background: rgba(0,0,0,0.25); overflow: hidden;"><div style="width: {{ goalPct }}%; height: 100%; border-radius: 4px; background: linear-gradient(90deg, #FFE27A, ' + GOLD + ');"></div></div>'
  '<div style="margin: 4px 16px 0; display: flex; justify-content: space-between; font-size: 11px; font-weight: 800; color: rgba(255,255,255,0.9); text-shadow: 0 1px 2px rgba(0,0,0,0.4);"><span>{{ label }}</span><span>Goal {{ goal }}</span></div>'
  '</div>' + dpad +
  '<div style="position: absolute; z-index: 3; left: 16px; bottom: 40px; height: 34px; padding: 0 12px; border-radius: 17px; background: rgba(4,52,30,0.6); color: #FFFFFF; display: flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 800;">'
  '<svg width="16" height="16" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="13" r="8" fill="#E5322D"/><path d="M12 5 V2" stroke="#5A3A1A" stroke-width="2"/><ellipse cx="15" cy="4" rx="3" ry="1.4" fill="#4CAF50"/></svg>Length 22</div>')
play_js = """renderVals() {
    const p = this.props, score = p.score ?? 1240, goal = p.goal ?? 600;
    return { score: score.toLocaleString('en-US'), best: (p.best ?? 3520).toLocaleString('en-US'), goal, goalPct: Math.min(100, Math.round(score / goal * 100)),
      label: p.label ?? 'Level 3', winHref: p.winHref ?? 'Complete.dc.html', failHref: p.failHref ?? 'Failed.dc.html' };
  }"""
write('Play.dc.html', head('Gameplay') + root(inner, '#3C8A2E') + foot(play_js, '{"label":{"editor":"text","default":"Level 3"},"score":{"editor":"number","default":1240},"best":{"editor":"number","default":3520},"goal":{"editor":"number","default":600},"winHref":{"editor":"text","default":"Complete.dc.html"},"failHref":{"editor":"text","default":"Failed.dc.html"}}'))

# ---------------- Modal backdrop (dimmed board) ----------------
def dim(dark=0.55):
    return ('<img src="' + B['board'] + '" alt="" aria-hidden="true" style="position: absolute; inset: 0; width: 390px; height: 844px; object-fit: cover; z-index: 0; filter: blur(3px) saturate(0.9); transform: scale(1.04);">'
            '<div aria-hidden="true" style="position: absolute; inset: 0; z-index: 0; background: rgba(3,38,20,' + str(dark) + ');"></div>')

def confetti(n=22, seed=9):
    import random
    r = random.Random(seed); cols = ['#F4B72F', '#E84B3C', '#A8D94F', '#FFFFFF', '#3FB7E8', '#FF8DC0']; out = []
    for i in range(n):
        x = r.randint(0, 380); d = r.uniform(3.5, 7); dl = -r.uniform(0, 7); w = r.randint(6, 10); h = r.randint(10, 16)
        out.append('<span aria-hidden="true" style="position: absolute; z-index: 1; left: ' + str(x) + 'px; top: 0; width: ' + str(w) + 'px; height: ' + str(h) + 'px; border-radius: 2px; background: ' + r.choice(cols) + '; animation: ssConfetti ' + f'{d:.1f}s linear {dl:.1f}s' + ' infinite; pointer-events: none;"></span>')
    return ''.join(out)

modal_card = lambda inner_html: ('<div style="position: relative; z-index: 2; margin: 0 22px; padding: 26px 20px 20px; border-radius: 28px; background: ' + CARD + '; border: 1px solid #ECE5CF; '
                                 'box-shadow: inset 0 1px 0 #FFFFFF, 0 6px 0 #D6CBAA, 0 30px 60px rgba(0,0,0,0.35); display: flex; flex-direction: column; align-items: center; text-align: center; animation: ssPop .5s cubic-bezier(.2,1.2,.4,1) both;">' + inner_html + '</div>')

# ---------------- Pause ----------------
def roundtoggle(label, icon, on=True):
    return ('<button aria-pressed="' + ('true' if on else 'false') + '" aria-label="' + label + '" class="ss-press" style="width: 52px; height: 52px; border-radius: 26px; border: 0; cursor: pointer; ' + ('background: #E3F2D3; color: ' + EMERALD + ';' if on else 'background: #EDE6D0; color: #9AA59D;') + ' display: flex; align-items: center; justify-content: center;">'
            '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + icon + '</svg></button>')
inner = (dim(0.6) + '<div style="position: relative; z-index: 1;">' + status(True) + '</div>'
  '<div style="position: absolute; inset: 0; z-index: 2; display: flex; flex-direction: column; justify-content: center;">' + modal_card(
    "<h1 style=\"margin: 0; font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 30px;\">Paused</h1>"
    '<p style="margin: 4px 0 0; font-size: 14px; font-weight: 700; color: ' + MUTED + ';">Level 3 · Score 1,240</p>'
    '<div style="align-self: stretch; margin-top: 20px; display: flex; flex-direction: column; gap: 10px;">' + btn('Resume', 'Play.dc.html', 56, '100%', 21) + btn2('Restart', 'Play.dc.html') + btn2('Home', 'Home.dc.html') + '</div>'
    '<div style="margin-top: 18px; display: flex; gap: 14px;">'
    + roundtoggle('Sound', '<path d="M4 9 H8 L13 5 V19 L8 15 H4 Z"/><path d="M16.5 8.5 a5 5 0 0 1 0 7"/>')
    + roundtoggle('Music', '<path d="M9 17 V5 L19 3 V15"/><circle cx="7" cy="17" r="2.5"/><circle cx="17" cy="15" r="2.5"/>')
    + roundtoggle('Vibration', '<rect x="8" y="3" width="8" height="18" rx="2"/><path d="M4 8 V16 M20 8 V16"/>', False)
    + '<a href="Settings.dc.html" aria-label="Settings" class="ss-press" style="width: 52px; height: 52px; border-radius: 26px; background: #EDE6D0; color: ' + INK + '; display: flex; align-items: center; justify-content: center;"><svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" aria-hidden="true"><circle cx="12" cy="12" r="3.2"/><path d="M12 2.8 V5.2 M12 18.8 V21.2 M2.8 12 H5.2 M18.8 12 H21.2 M5.5 5.5 L7.2 7.2 M16.8 16.8 L18.5 18.5 M5.5 18.5 L7.2 16.8 M16.8 7.2 L18.5 5.5"/></svg></a>'
    '</div>') + '</div>')
write('Pause.dc.html', head('Pause') + root(inner, '#1E4A2A') + foot())

# ---------------- Level complete ----------------
bigstars = ('<div role="img" aria-label="3 of 3 stars" style="margin-top: 14px; display: flex; align-items: flex-end; gap: 4px;">'
            '<span style="transform: rotate(-12deg);"><span style="display: block; animation: ssPop .5s .25s both;">' + star(58) + '</span></span>'
            '<span style="margin-bottom: 14px; animation: ssPop .5s .45s both;">' + star(72) + '</span>'
            '<span style="transform: rotate(12deg);"><span style="display: block; animation: ssPop .5s .65s both;">' + star(58) + '</span></span></div>')
inner = (dim(0.5) + confetti() + '<div style="position: relative; z-index: 2;">' + status(True) + '</div>'
  '<div style="position: absolute; inset: 0; z-index: 2; display: flex; flex-direction: column; justify-content: center;">' + modal_card(
    '<span style="position: absolute; top: -18px; height: 34px; padding: 0 16px; border-radius: 17px; background: linear-gradient(180deg, #23A766, ' + FOREST + '); color: #FFF; display: flex; align-items: center; font-size: 14px; font-weight: 800; box-shadow: 0 4px 10px rgba(7,91,53,0.3);">LEVEL 3</span>'
    "<h1 style=\"margin: 6px 0 0; font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 30px;\">Level Complete!</h1>"
    + bigstars +
    '<div style="align-self: stretch; margin-top: 16px; padding: 12px; border-radius: 18px; background: #F5F0DF; display: grid; grid-template-columns: 1fr 1px 1fr; align-items: center;">'
    "<div style=\"display: flex; align-items: center; justify-content: center; gap: 8px; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 22px;\">" + coin(30) + '+120</div><span style="height: 30px; background: #E2D9BE;"></span>'
    "<div style=\"display: flex; align-items: center; justify-content: center; gap: 8px; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 22px;\">" + gem(28) + '+3</div></div>'
    '<div style="margin-top: 12px; display: flex; gap: 18px; font-size: 14px; font-weight: 800; color: ' + MUTED + ';"><span>Score <b style="color: ' + INK + ';">1,240</b></span><span>Best <b style="color: ' + INK + ';">3,520</b></span></div>'
    '<div style="align-self: stretch; margin-top: 18px; display: flex; flex-direction: column; gap: 10px;">' + btn('Next Level', 'Play.dc.html', 56, '100%', 21) + btn2('Home', 'Home.dc.html') + '</div>') + '</div>')
write('Complete.dc.html', head('Level complete') + root(inner, '#1E4A2A') + foot())

# ---------------- Level failed ----------------
inner = (dim(0.62) + '<div style="position: relative; z-index: 2;">' + status(True) + '</div>'
  '<div style="position: absolute; inset: 0; z-index: 2; display: flex; flex-direction: column; justify-content: center;">' + modal_card(
    "<h1 style=\"margin: 0; font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 30px;\">Level Failed!</h1>"
    '<img src="' + B['sad'] + '" alt="Sad snake mascot" style="margin-top: 8px; width: 230px; animation: ssBob 3.4s ease-in-out infinite;">'
    "<p style=\"margin: 4px 0 0; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 20px;\">Don't give up!</p>"
    '<p style="margin: 4px 0 0; font-size: 14px; font-weight: 700; color: ' + MUTED + ';">Try again to improve your score.</p>'
    '<div style="margin-top: 12px; height: 34px; padding: 0 14px; border-radius: 17px; background: #F5F0DF; display: flex; align-items: center; gap: 14px; font-size: 14px; font-weight: 800; color: ' + MUTED + ';"><span>Score <b style="color: ' + INK + ';">860</b></span><span>Best <b style="color: ' + INK + ';">3,520</b></span></div>'
    '<div style="align-self: stretch; margin-top: 18px; display: flex; flex-direction: column; gap: 10px;">' + btn('Retry', 'Play.dc.html', 56, '100%', 21, icon='<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="2.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" style="position: relative;"><path d="M4 12 a8 8 0 1 0 2.4-5.7"/><path d="M4 4 V8.5 H8.5"/></svg>') + btn2('Home', 'Home.dc.html') + '</div>') + '</div>')
write('Failed.dc.html', head('Level failed') + root(inner, '#1E4A2A') + foot())

# ---------------- Daily challenge ----------------
trophy = ('<svg width="150" height="150" viewBox="0 0 120 120" aria-hidden="true"><defs>'
          '<linearGradient id="tG" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#B9790A"/><stop offset="0.3" stop-color="#FFD84A"/><stop offset="0.45" stop-color="#FFF6C8"/><stop offset="0.65" stop-color="#F4B72F"/><stop offset="1" stop-color="#A56A00"/></linearGradient>'
          '<linearGradient id="tB" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1E9C5C"/><stop offset="1" stop-color="#075B35"/></linearGradient></defs>'
          '<ellipse cx="60" cy="112" rx="34" ry="5" fill="#000" opacity="0.15"/>'
          '<path d="M36 96 H84 L88 110 H32 Z" fill="url(#tB)"/><rect x="48" y="99" width="24" height="7" rx="1.5" fill="url(#tG)"/>'
          '<path d="M46 86 H74 L72 96 H48 Z" fill="url(#tG)"/><path d="M54 66 H66 L64 86 H56 Z" fill="url(#tG)"/>'
          '<path d="M30 22 C 14 22, 14 50, 36 52" fill="none" stroke="#B9790A" stroke-width="6" stroke-linecap="round"/><path d="M90 22 C 106 22, 106 50, 84 52" fill="none" stroke="#B9790A" stroke-width="6" stroke-linecap="round"/>'
          '<path d="M28 14 H92 V30 C 92 52, 78 68, 60 68 C 42 68, 28 52, 28 30 Z" fill="url(#tG)"/><ellipse cx="60" cy="14" rx="32" ry="5" fill="#9A6400"/>'
          '<path d="M38 22 C 38 44, 44 56, 52 62" fill="none" stroke="#FFFBE6" stroke-width="4" stroke-linecap="round" opacity="0.6"/>'
          '<path d="M60 26 l3.6 7.3 8 1.1 -5.8 5.6 1.4 8 -7.2-3.8 -7.2 3.8 1.4-8 -5.8-5.6 8-1.1z" fill="#FFF3B0" stroke="#B9790A" stroke-width="1.2"/></svg>')
objs = [('Play 3 games', 1, 3, 50, False), ('Collect 20 fruits', 12, 20, 80, False), ('Reach 500 score', 500, 500, 100, True)]
rows = ''
for i, (t, a, b, rw, done) in enumerate(objs):
    pct = int(a / b * 100)
    rows += ('<div class="ss-in" style="animation-delay: ' + str(0.1 + i * 0.1) + 's; display: flex; align-items: center; gap: 12px; padding: 12px 0; ' + ('border-top: 1px solid #EFE8D2;' if i else '') + '">'
             '<span style="width: 28px; height: 28px; flex: none; border-radius: 14px; display: flex; align-items: center; justify-content: center; ' + ('background: ' + EMERALD + ';' if done else 'background: #FFFFFF; border: 2px solid #D9D2BC; box-sizing: border-box;') + '">'
             + ('<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#FFFFFF" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5 L10 17 L19 7"/></svg>' if done else '') + '</span>'
             '<div style="flex: 1; min-width: 0;"><div style="display: flex; justify-content: space-between; font-size: 15px; font-weight: 800;"><span>' + t + '</span><span style="color: ' + MUTED + '; font-variant-numeric: tabular-nums;">' + str(a) + '/' + str(b) + '</span></div>'
             '<div style="margin-top: 6px; height: 8px; border-radius: 4px; background: #ECE5CF; overflow: hidden;"><div style="width: ' + str(pct) + '%; height: 100%; border-radius: 4px; background: linear-gradient(90deg, ' + (LEAF + ', ' + EMERALD if done else '#FFD84A, ' + GOLD) + ');"></div></div></div>'
             "<span style=\"width: 64px; flex: none; display: flex; align-items: center; justify-content: flex-end; gap: 4px; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 17px;\">" + coin(20) + str(rw) + '</span></div>')
inner = (corner_leaves() + status() + back('Home.dc.html', '', '<span style="height: 30px; padding: 0 12px; border-radius: 15px; background: #FDF0CC; display: flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 800; color: #9A5B00;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7 V12 L15 14"/></svg>6h 12m left</span>') +
  '<div style="position: relative; z-index: 2; display: flex; flex-direction: column; align-items: center; padding: 0 16px;">'
  '<div style="position: relative; width: 300px; height: 168px; display: flex; justify-content: center;">'
  '<div aria-hidden="true" style="position: absolute; top: 4px; width: 220px; height: 160px; border-radius: 50%; background: radial-gradient(circle, rgba(255,236,160,0.9), rgba(255,236,160,0) 70%);"></div>'
  '<div style="position: relative; animation: ssPop .6s both;">' + trophy + '</div>'
  '<span style="position: absolute; left: 18px; bottom: 10px; animation: ssBob 3s ease-in-out infinite;">' + gift(58, '#13864D', '#F4B72F') + '</span>'
  '<span style="position: absolute; right: 22px; bottom: 6px; animation: ssBob 3.4s ease-in-out .4s infinite;">' + gift(50, '#E84B3C', '#FFD84A') + '</span>'
  '<span style="position: absolute; right: 56px; top: 18px; animation: ssBob 2.8s ease-in-out .2s infinite;">' + gem(30) + '</span>'
  '<span style="position: absolute; left: 60px; top: 30px;">' + coin(26) + '</span></div>'
  "<h1 style=\"margin: 6px 0 0; font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 30px;\">Daily Challenge</h1>"
  '<p style="margin: 4px 0 0; max-width: 28ch; text-align: center; font-size: 15px; font-weight: 700; color: ' + MUTED + ';">Complete the challenge to earn special rewards!</p>'
  '<div style="align-self: stretch; margin-top: 16px;">' + card(rows, 'padding: 4px 16px;') + '</div>'
  '<div style="align-self: stretch; margin-top: 12px; padding: 12px 14px; border-radius: 18px; background: linear-gradient(90deg, #FFF5D6, #FDEBB8); border: 1px dashed #E9C774; display: flex; align-items: center; gap: 10px; font-size: 14px; font-weight: 800; color: #7A4A00;">'
  + gift(32, '#F4B72F', '#E84B3C') + '<span style="flex: 1;">Finish all 3 for a bonus chest</span><span style="display: flex; align-items: center; gap: 4px;">' + gem(18) + '+5</span></div>'
  '</div>'
  '<div style="position: absolute; z-index: 2; left: 16px; right: 16px; bottom: 34px;">' + btn('Play Now', 'Play.dc.html', 60, '100%', 22) + '</div>')
write('Daily.dc.html', head('Daily challenge') + root(inner) + foot())
print('core ok')
