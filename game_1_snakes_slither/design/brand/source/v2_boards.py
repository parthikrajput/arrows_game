from v2_common import *

# ---------------- Brand board ----------------
W, H = 1640, 940
sw = [('Forest', FOREST, '#FFF'), ('Emerald', EMERALD, '#FFF'), ('Leaf', LEAF, INK), ('Gold', GOLD, INK), ('Cream', CREAM, INK), ('Card', CARD, INK), ('Text', INK, '#FFF')]
swatches = ''.join('<div style="display: flex; flex-direction: column; align-items: center; gap: 8px;">'
                   '<span style="width: 74px; height: 74px; border-radius: 37px; background: ' + c + '; box-shadow: inset 0 0 0 1px rgba(0,0,0,0.08), 0 8px 18px rgba(22,59,40,0.14);"></span>'
                   "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px;\">" + n + '</span><span style="font-size: 13px; font-weight: 700; color: ' + MUTED + ';">' + c + '</span></div>' for n, c, t in sw)
lab = lambda t: "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 18px; color: " + MUTED + ";\">" + t + '</span>'
inner = ('<div style="position: absolute; left: 48px; top: 36px;"><h1 style="margin: 0; font-family: \'Fredoka\', sans-serif; font-weight: 700; font-size: 40px;">Snake Slither · Brand</h1>'
  '<span style="font-size: 17px; font-weight: 700; color: ' + MUTED + ';">One mascot, one palette, one type pair, used on every screen.</span></div>'
  # icon
  '<div style="position: absolute; left: 48px; top: 140px; display: flex; flex-direction: column; align-items: center; gap: 14px;">'
  '<img src="' + B['icon'] + '" alt="App icon: green 3D snake mascot on a grass island, forest background" style="width: 320px; height: 320px; border-radius: 72px; box-shadow: 0 24px 48px rgba(7,60,30,0.3);">' + lab('App Icon · 1024')
  + '<div style="display: flex; align-items: flex-end; gap: 18px;"><img src="' + B['icon'] + '" alt="" style="width: 96px; height: 96px; border-radius: 22px; box-shadow: 0 8px 16px rgba(7,60,30,0.25);"><img src="' + B['icon'] + '" alt="" style="width: 60px; height: 60px; border-radius: 30px; box-shadow: 0 6px 12px rgba(7,60,30,0.25);"><img src="' + B['icon'] + '" alt="" style="width: 40px; height: 40px; border-radius: 9px;"></div></div>'
  # logo
  '<div style="position: absolute; left: 430px; top: 120px; width: 560px; display: flex; flex-direction: column; align-items: center; gap: 6px;">'
  '<img src="' + B['logo'] + '" alt="Snake Slither 3D game logo" style="width: 520px; animation: ssBob 4s ease-in-out infinite;">' + lab('Game Logo') + '</div>'
  # palette
  '<div style="position: absolute; left: 1030px; top: 150px; width: 560px;">' + card(
    '<div style="display: grid; grid-template-columns: repeat(4, 1fr); row-gap: 22px;">' + swatches + '</div>', 'padding: 26px 18px;') +
  '<div style="margin-top: 10px; text-align: center;">' + lab('Color Palette') + '</div></div>'
  # banner
  '<div style="position: absolute; left: 430px; top: 560px; width: 700px; height: 340px; border-radius: 28px; overflow: hidden; box-shadow: 0 24px 48px rgba(7,60,30,0.3);">'
  '<img src="' + B['icon'] + '" alt="" aria-hidden="true" style="position: absolute; inset: -40px; width: calc(100% + 80px); height: calc(100% + 80px); object-fit: cover; filter: blur(14px) saturate(1.1) brightness(0.9);">'
  '<div aria-hidden="true" style="position: absolute; inset: 0; background: radial-gradient(ellipse at 50% 55%, rgba(168,217,79,0.25), rgba(4,40,20,0.55));"></div>'
  '<img src="' + B['logo'] + '" alt="Banner: logo over a blurred forest" style="position: absolute; left: 50%; top: 50%; width: 380px; transform: translate(-50%, -50%);"></div>'
  '<div style="position: absolute; left: 430px; top: 908px;">' + lab('Store banner · 1024 × 500') + '</div>'
  # type & components
  '<div style="position: absolute; left: 1170px; top: 560px; width: 420px;">' + card(
    "<div style=\"font-family: 'Fredoka', sans-serif; font-weight: 700; font-size: 34px; line-height: 1.1;\">Fredoka · Headlines</div>"
    '<div style="margin-top: 4px; font-size: 16px; font-weight: 700; color: ' + MUTED + ';">Nunito · body text, labels and numbers</div>'
    '<div style="margin-top: 18px; display: flex; flex-direction: column; gap: 10px;">' + btn('Play', '#', 54, '100%', 21) + btn2('Home', '#') + '</div>'
    '<div style="margin-top: 14px; display: flex; gap: 8px;">' + pill(coin(22), '8,420', None, True) + pill(gem(20), '96', None, True) + pill(star(20), '3 / 3') + '</div>', 'padding: 20px;') + '</div>')
write('Brand.dc.html', head('Brand') + '<div style="width: ' + str(W) + 'px; height: ' + str(H) + 'px; position: relative; overflow: hidden; background: radial-gradient(ellipse at 40% 20%, #FFFEF8, ' + CREAM + ' 60%, #EEE7D0); color: ' + INK + "; font-family: 'Nunito', system-ui, sans-serif;\">" + inner + '</div>' + foot(w=W, h=H))

# ---------------- Screen flow ----------------
S = 0.42
TW, TH = round(390 * S), round(844 * S)
LBL = 40
CW, RH = 236, TH + LBL + 96
X0, Y0 = 170, 150
cx = lambda c: X0 + c * CW
ry = lambda r: Y0 + r * RH
G = {'hub': EMERALD, 'play': '#1E88E5', 'win': '#E0A100', 'fail': '#E53935', 'meta': '#8E24AA'}
N = [('splash', 'Main', 0, 0, 'Splash', 'hub'), ('home', 'Home', 1, 0, 'Home', 'hub'), ('map', 'LevelMap', 2, 0, 'Level Map', 'hub'),
     ('play', 'Play', 3, 0, 'Gameplay', 'play'), ('complete', 'Complete', 4, 0, 'Level Complete', 'win'),
     ('pause', 'Pause', 3, 1, 'Pause', 'play'), ('failed', 'Failed', 4, 1, 'Level Failed', 'fail'),
     ('daily', 'Daily', 0, 2, 'Daily Challenge', 'hub'), ('rewards', 'Rewards', 1, 2, 'Rewards', 'meta'), ('shop', 'Shop', 2, 2, 'Shop', 'meta'),
     ('skin', 'SkinPreview', 3, 2, 'Skin Preview', 'meta'), ('themes', 'Themes', 4, 2, 'Themes', 'meta'), ('ranks', 'Leaderboards', 5, 2, 'Leaderboard', 'meta'),
     ('profile', 'Profile', 6, 2, 'Profile', 'meta'), ('settings', 'Settings', 7, 2, 'Settings', 'meta')]
pos = {k: (cx(c), ry(r)) for k, _, c, r, _, _ in N}
box = lambda k: (pos[k][0], pos[k][1], pos[k][0] + TW, pos[k][1] + LBL + TH)
ctop = lambda k: ((box(k)[0] + box(k)[2]) / 2, box(k)[1])
cbot = lambda k: ((box(k)[0] + box(k)[2]) / 2, box(k)[3])
left = lambda k: (box(k)[0], box(k)[1] + LBL + TH / 2)
right = lambda k: (box(k)[2], box(k)[1] + LBL + TH / 2)
E = []
def line(pts, label='', dashed=False, lp=None, arrow=True):
    E.append(('M' + ' L'.join('%.0f %.0f' % p for p in pts), label, dashed, lp or pts[0], arrow))
def h(a, b, label=''):
    p, q = right(a), left(b); line([(p[0] + 4, p[1]), (q[0] - 6, q[1])], label, lp=((p[0] + q[0]) / 2, p[1] - 12))
for a, b, l in [('splash', 'home', 'Tap'), ('home', 'map', 'Play'), ('map', 'play', 'Play'), ('play', 'complete', 'goal')]:
    h(a, b, l)
gapTop = ry(0) - 40
line([(ctop('complete')[0], ctop('complete')[1] - 4), (ctop('complete')[0], gapTop), (ctop('play')[0] + 30, gapTop), (ctop('play')[0] + 30, ctop('play')[1] - 6)], 'Next Level', True, (ctop('complete')[0] - 70, gapTop - 10))
gap1 = ry(1) - 40
line([(cbot('play')[0] - 20, cbot('play')[1] + 4), (cbot('play')[0] - 20, ctop('pause')[1] - 6)], 'pause', lp=(cbot('play')[0] - 52, gap1))
line([(cbot('play')[0] + 40, cbot('play')[1] + 4), (cbot('play')[0] + 40, gap1 + 12), (ctop('failed')[0], gap1 + 12), (ctop('failed')[0], ctop('failed')[1] - 6)], 'hit', lp=(ctop('failed')[0] - 40, gap1 + 2))
line([(right('failed')[0] + 4, right('failed')[1]), (right('failed')[0] + 40, right('failed')[1]), (right('failed')[0] + 40, gapTop + 16), (ctop('play')[0] + 60, gapTop + 16), (ctop('play')[0] + 60, ctop('play')[1] - 6)], 'Retry', True, (right('failed')[0] + 74, right('failed')[1] - 120))
gap2 = ry(2) - 40
hb = (cbot('home')[0], cbot('home')[1] + 4)
line([hb, (hb[0], gap2)], 'nav & cards', lp=(hb[0] + 56, gap2 - 160), arrow=False)
line([(ctop('daily')[0], gap2), (ctop('settings')[0], gap2)], arrow=False)
for k in ['daily', 'rewards', 'shop', 'ranks', 'profile', 'settings']:
    line([(ctop(k)[0], gap2), (ctop(k)[0], ctop(k)[1] - 6)])
h('shop', 'skin', 'tap skin')
gb = cbot('shop')[1] + 30
line([(cbot('shop')[0], cbot('shop')[1] + 4), (cbot('shop')[0], gb), (cbot('themes')[0], gb), (cbot('themes')[0], cbot('themes')[1] + 6)], 'Themes tab', lp=((cbot('shop')[0] + cbot('themes')[0]) / 2, gb + 22))
dx = box('daily')[0] - 26
line([(dx + 26, left('daily')[1]), (dx, left('daily')[1]), (dx, gap1 + 30), (box('play')[0] - 30, gap1 + 30), (box('play')[0] - 30, right('play')[1] + 40), (box('play')[0] - 6, right('play')[1] + 40)], 'Play Now', True, (dx + 70, gap1 + 20))
SW = cx(7) + TW + 80
SH = ry(2) + LBL + TH + 90
lanes = [(0, 'Main path'), (1, 'In-game'), (2, 'Hub & meta')]
out = [head('Screen flow', '.sf{color:' + INK + '}')]
out.append('<div style="width: %dpx; height: %dpx; position: relative; overflow: hidden; background: radial-gradient(ellipse at 30%% 0%%, #FFFEF8, %s 60%%, #EEE7D0); font-family: \'Nunito\', system-ui, sans-serif; color: %s;">' % (SW, SH, CREAM, INK))
out.append('<div style="position: absolute; left: 40px; top: 30px; white-space: nowrap;"><h1 style="margin: 0; font-family: \'Fredoka\', sans-serif; font-weight: 700; font-size: 42px;">Snake Slither · screen flow</h1><span style="display: block; margin-top: 4px; font-size: 18px; font-weight: 700; color: %s;">The real screens in game order. Click a screen to open it; Play mode runs the whole prototype.</span></div>' % MUTED)
for r, t in lanes:
    y = ry(r) + LBL + TH / 2
    out.append('<div style="position: absolute; left: 16px; top: %dpx; width: 120px; height: 120px; display: flex; align-items: center; justify-content: center; text-align: center; font-family: \'Fredoka\', sans-serif; font-weight: 600; font-size: 17px; color: %s; border-right: 3px solid #E2D9BE;">%s</div>' % (y - 60, MUTED, t))
out.append('<svg width="%d" height="%d" viewBox="0 0 %d %d" style="position: absolute; left: 0; top: 0;" aria-hidden="true"><defs><marker id="sfA" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse"><path d="M0 0 L10 5 L0 10 Z" fill="#7D8C80"/></marker></defs>' % (SW, SH, SW, SH))
for d, label, dashed, lp, arrow in E:
    out.append('<path d="%s" fill="none" stroke="#8C9A8E" stroke-width="3" stroke-linejoin="round"%s%s/>' % (d, ' stroke-dasharray="8 6"' if dashed else '', ' marker-end="url(#sfA)"' if arrow else ''))
    if label:
        out.append('<text x="%.0f" y="%.0f" text-anchor="middle" style="font-family: \'Nunito\', sans-serif; font-weight: 800; font-size: 15px;" fill="#4C6152" stroke="%s" stroke-width="5" paint-order="stroke">%s</text>' % (lp[0], lp[1], CREAM, label))
out.append('</svg>')
for k, name, c, r, title, g in N:
    x, y = pos[k]; col = G[g]
    out.append('<a class="sf" href="%s.dc.html" style="position: absolute; left: %dpx; top: %dpx; width: %dpx; display: flex; flex-direction: column; gap: 6px; text-decoration: none;">' % (name, x, y, TW)
               + '<span style="height: %dpx; display: flex; align-items: center; gap: 6px; font-family: \'Fredoka\', sans-serif; font-weight: 600; font-size: 15px; white-space: nowrap;"><span style="width: 10px; height: 10px; border-radius: 5px; background: %s;"></span>%s</span>' % (LBL - 6, col, title)
               + '<span style="width: %dpx; height: %dpx; border-radius: 18px; overflow: hidden; position: relative; box-shadow: 0 0 0 3px %s, 0 14px 28px rgba(20,50,20,0.2); background: #FFFFFF;">' % (TW, TH, col)
               + '<span style="position: absolute; left: 0; top: 0; width: 390px; height: 844px; transform: scale(%s); transform-origin: 0 0; pointer-events: none;"><dc-import name="%s" hint-size="390px,844px"></dc-import></span></span></a>' % (S, name))
out.append('</div>')
open('/tmp/claude-0/-home-claude/1f41784e-164b-58df-a754-ab2665eda5af/scratchpad/ss/project/ScreenFlow.dc.html', 'w').write('\n'.join(out) + foot(w=SW, h=SH))
print('boards ok', SW, SH)
