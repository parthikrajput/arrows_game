# Shared building blocks for the reference-style Snake Slither screens (v2).
import json

B = {k: '/_blob/' + v.split(':')[0] for k, v in json.load(open('/tmp/claude-0/-home-claude/1f41784e-164b-58df-a754-ab2665eda5af/scratchpad/assets_v2.json')).items()}

FOREST, EMERALD, LEAF, GOLD, CREAM, CARD, INK = '#075B35', '#13864D', '#A8D94F', '#F4B72F', '#F7F4E8', '#FFFEF8', '#163B28'
MUTED = '#6B7F70'

CSS = """body{margin:0}
a{color:inherit;text-decoration:none}
.ss-press{transition:transform .14s cubic-bezier(.3,1.6,.5,1),box-shadow .14s}
.ss-press:hover{transform:translateY(-1px)}
.ss-press:active{transform:translateY(2px) scale(.97)}
@keyframes ssBob{0%,100%{transform:translateY(0)}50%{transform:translateY(-7px)}}
@keyframes ssPulse{0%,100%{transform:scale(1)}50%{transform:scale(1.04)}}
@keyframes ssGlow{0%,100%{box-shadow:0 0 0 0 rgba(168,217,79,.55)}60%{box-shadow:0 0 0 14px rgba(168,217,79,0)}}
@keyframes ssIn{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:none}}
@keyframes ssPop{0%{opacity:0;transform:scale(.6)}70%{opacity:1;transform:scale(1.06)}100%{transform:scale(1)}}
@keyframes ssFall{0%{transform:translate(0,-60px) rotate(0)}100%{transform:translate(60px,920px) rotate(260deg)}}
@keyframes ssSway{0%,100%{transform:perspective(600px) rotateY(-10deg)}50%{transform:perspective(600px) rotateY(10deg)}}
@keyframes ssFloatUp{0%{opacity:0;transform:translateY(6px)}20%{opacity:1}100%{opacity:0;transform:translateY(-34px)}}
@keyframes ssConfetti{0%{transform:translateY(-40px) rotate(0)}100%{transform:translateY(860px) rotate(540deg)}}
@keyframes ssShine{0%{transform:translateX(-120%) skewX(-20deg)}60%,100%{transform:translateX(220%) skewX(-20deg)}}
.ss-in{animation:ssIn .5s cubic-bezier(.2,.9,.3,1) both}
"""

def head(title, extra_css=''):
    return ('<!doctype html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n<title>' + title + '</title>\n'
            '<script src="./support.js"></script>\n</head>\n<body>\n<x-dc>\n<helmet>\n'
            '<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fredoka:wght@500;600;700&amp;family=Nunito:wght@500;700;800&amp;display=swap">\n'
            '<style>\n' + CSS + extra_css + '</style>\n</helmet>\n')

def foot(script_body='renderVals() { return {}; }', props='{}', w=390, h=844):
    p = json.loads(props); p['$preview'] = {'width': w, 'height': h}
    return ('\n</x-dc>\n<script type="text/x-dc" data-dc-script data-props=\'' + json.dumps(p, separators=(',', ':')) + '\'>\n'
            'class Component extends DCLogic {\n  ' + script_body + '\n}\n</script>\n</body>\n</html>\n')

def root(inner, bg=None, extra=''):
    bg = bg or ('radial-gradient(ellipse 120% 70% at 50% 0%, #FFFEF8 0%, ' + CREAM + ' 55%, #EFE9D3 100%)')
    return ('<div style="width: 390px; height: 844px; box-sizing: border-box; position: relative; overflow: hidden; isolation: isolate; '
            'background: ' + bg + '; color: ' + INK + "; font-family: 'Nunito', system-ui, sans-serif; " + extra + '">\n' + inner + '\n</div>')

def status(dark=False):
    c = '#FFFFFF' if dark else INK
    return ('<div aria-hidden="true" style="position: relative; z-index: 3; height: 44px; padding: 0 22px 0 26px; display: flex; align-items: center; justify-content: space-between; '
            "font-family: 'Nunito', sans-serif; font-weight: 800; font-size: 15px; color: " + c + ';">'
            '<span>9:41</span><span style="display: flex; gap: 6px; align-items: center;">'
            '<svg width="18" height="12" viewBox="0 0 18 12"><g fill="' + c + '"><rect x="0" y="8" width="3" height="4" rx="1"/><rect x="5" y="5.5" width="3" height="6.5" rx="1"/><rect x="10" y="3" width="3" height="9" rx="1"/><rect x="15" y="0" width="3" height="12" rx="1"/></g></svg>'
            '<svg width="16" height="12" viewBox="0 0 16 12"><path d="M8 11.5 L5.6 9 A3.4 3.4 0 0 1 10.4 9 Z M2.8 6.3 A7.4 7.4 0 0 1 13.2 6.3 L11.8 7.7 A5.4 5.4 0 0 0 4.2 7.7 Z M0 3.5 A11.4 11.4 0 0 1 16 3.5 L14.6 4.9 A9.4 9.4 0 0 0 1.4 4.9 Z" fill="' + c + '"/></svg>'
            '<svg width="26" height="12" viewBox="0 0 26 12"><rect x="0.5" y="0.5" width="22" height="11" rx="3" fill="none" stroke="' + c + '" opacity="0.45"/><rect x="2" y="2" width="17" height="8" rx="2" fill="' + c + '"/><rect x="23.5" y="4" width="1.8" height="4" rx="1" fill="' + c + '" opacity="0.45"/></svg>'
            '</span></div>')

def coin(s=20):
    return ('<svg width="' + str(s) + '" height="' + str(s) + '" viewBox="0 0 24 24" aria-hidden="true" style="flex: none;"><defs><radialGradient id="cg' + str(s) + '" cx="0.35" cy="0.3" r="0.8"><stop offset="0" stop-color="#FFF2A8"/><stop offset="0.45" stop-color="#F9C93A"/><stop offset="1" stop-color="#D98E10"/></radialGradient></defs>'
            '<circle cx="12" cy="12.6" r="10.4" fill="#B8730A"/><circle cx="12" cy="11.6" r="10.4" fill="url(#cg' + str(s) + ')"/><circle cx="12" cy="11.6" r="7" fill="none" stroke="#C98200" stroke-width="1.4" opacity="0.7"/>'
            '<path d="M12 7.2 l1.3 2.7 3 .4 -2.2 2.1 .5 3 -2.6-1.4 -2.6 1.4 .5-3 -2.2-2.1 3-.4z" fill="#FFE27A" stroke="#C98200" stroke-width="0.6"/></svg>')

def gem(s=20):
    return ('<svg width="' + str(s) + '" height="' + str(s) + '" viewBox="0 0 24 24" aria-hidden="true" style="flex: none;">'
            '<path d="M7 3.5 H17 L22 9.5 L12 21.5 L2 9.5 Z" fill="#0C7A43"/>'
            '<path d="M7 3.5 H17 L22 9.5 H2 Z" fill="#3FD07E"/><path d="M2 9.5 H22 L12 21.5 Z" fill="#17A35A"/>'
            '<path d="M7 3.5 L9.5 9.5 L12 3.5 L14.5 9.5 L17 3.5" fill="none" stroke="#B8FFD6" stroke-width="0.9" stroke-linejoin="round" opacity="0.9"/>'
            '<path d="M9.5 9.5 L12 21.5 L14.5 9.5" fill="none" stroke="#0C7A43" stroke-width="0.8" opacity="0.6"/><path d="M5 8.5 L7.5 5" stroke="#FFFFFF" stroke-width="1.2" stroke-linecap="round" opacity="0.8"/></svg>')

def star(s=24, on=True):
    f = 'url(#stg)' if on else '#E2DCC8'
    st = '#C98200' if on else '#CFC7AE'
    return ('<svg width="' + str(s) + '" height="' + str(s) + '" viewBox="0 0 24 24" aria-hidden="true" style="flex: none;"><defs><linearGradient id="stg" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#FFE98A"/><stop offset="0.5" stop-color="#F9C93A"/><stop offset="1" stop-color="#E39A12"/></linearGradient></defs>'
            '<path d="M12 2.2l2.95 6.1 6.7.85-4.95 4.6 1.3 6.65L12 17.1l-6 3.3 1.3-6.65L2.35 9.15l6.7-.85z" fill="' + f + '" stroke="' + st + '" stroke-width="1.1" stroke-linejoin="round"/>'
            + ('<path d="M8.6 8.9 L11 8.6" stroke="#FFFBE0" stroke-width="1.4" stroke-linecap="round"/>' if on else '') + '</svg>')

def leaf_svg(s=22, c1='#7CC24A', c2='#2E8B3A', rot=0, extra=''):
    return ('<svg width="' + str(s) + '" height="' + str(s) + '" viewBox="0 0 24 24" aria-hidden="true" style="transform: rotate(' + str(rot) + 'deg); ' + extra + '">'
            '<defs><linearGradient id="lf' + c1[1:] + '" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="' + c1 + '"/><stop offset="1" stop-color="' + c2 + '"/></linearGradient></defs>'
            '<path d="M12 1.5 C 19.5 6.5, 19.5 16.5, 12 22.5 C 4.5 16.5, 4.5 6.5, 12 1.5 Z" fill="url(#lf' + c1[1:] + ')"/>'
            '<path d="M12 3.5 V21" stroke="#E4F7C8" stroke-width="0.9" opacity="0.75"/></svg>')

def btn(text, href, h=56, w='100%', size=20, icon='', extra='', anim=''):
    return ('<a href="' + href + '" class="ss-press" style="position: relative; overflow: hidden; height: ' + str(h) + 'px; width: ' + w + '; box-sizing: border-box; border-radius: ' + str(min(h // 2, 20)) + 'px; '
            'background: linear-gradient(180deg, #23A766 0%, ' + EMERALD + ' 42%, ' + FOREST + ' 100%); '
            'box-shadow: inset 0 2px 0 rgba(255,255,255,0.32), inset 0 -2px 0 rgba(0,0,0,0.12), 0 4px 0 #03432A, 0 12px 22px rgba(7,91,53,0.28); '
            "display: flex; align-items: center; justify-content: center; gap: 10px; color: #FFFFFF; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: " + str(size) + 'px; '
            'text-shadow: 0 1px 0 rgba(0,0,0,0.18); ' + (('animation: ' + anim + '; ') if anim else '') + extra + '">'
            '<span aria-hidden="true" style="position: absolute; inset: 0 auto 0 0; width: 40%; background: linear-gradient(90deg, transparent, rgba(255,255,255,0.22), transparent); animation: ssShine 3.6s ease-in-out infinite;"></span>'
            + icon + '<span style="position: relative;">' + text + '</span></a>')

def btn2(text, href, h=50, size=17, extra=''):
    return ('<a href="' + href + '" class="ss-press" style="height: ' + str(h) + 'px; box-sizing: border-box; border-radius: 18px; background: #EFE9D6; border: 1px solid #E2D9BE; '
            'box-shadow: inset 0 1px 0 #FFFFFF, 0 3px 0 #D6CBAA; display: flex; align-items: center; justify-content: center; color: ' + INK + "; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: " + str(size) + 'px; ' + extra + '">' + text + '</a>')

def card(inner, extra=''):
    return ('<div style="background: ' + CARD + '; border: 1px solid #ECE5CF; border-radius: 20px; box-shadow: inset 0 1px 0 #FFFFFF, 0 2px 0 rgba(180,165,120,0.18), 0 10px 24px rgba(22,59,40,0.07); ' + extra + '">' + inner + '</div>')

def back(href, title='', right=''):
    return ('<header style="position: relative; z-index: 2; height: 56px; padding: 0 16px; display: flex; align-items: center; gap: 12px;">'
            '<a href="' + href + '" aria-label="Back" class="ss-press" style="width: 40px; height: 40px; flex: none; border-radius: 20px; background: ' + CARD + '; border: 1px solid #ECE5CF; box-shadow: 0 3px 0 #DDD3B6, 0 6px 14px rgba(22,59,40,0.1); display: flex; align-items: center; justify-content: center; color: ' + INK + ';">'
            '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 5 L8 12 L15 19"/></svg></a>'
            "<h1 style=\"margin: 0; flex: 1; text-align: center; padding-right: " + ('0' if right else '52px') + "; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 22px;\">" + title + '</h1>'
            + right + '</header>')

def pill(icon, text, href=None, plus=False, dark=False):
    bgc = 'rgba(4,52,30,0.55)' if dark else CARD
    col = '#FFFFFF' if dark else INK
    inner = (icon + "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px; font-variant-numeric: tabular-nums;\">" + text + '</span>'
             + ('<span aria-hidden="true" style="width: 20px; height: 20px; border-radius: 10px; background: ' + EMERALD + '; color: #FFF; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 15px; line-height: 1;">+</span>' if plus else ''))
    style = ('height: 36px; padding: 0 8px 0 7px; border-radius: 18px; background: ' + bgc + '; border: 1px solid ' + ('rgba(255,255,255,0.18)' if dark else '#ECE5CF') + '; box-shadow: 0 4px 12px rgba(22,59,40,0.1); display: flex; align-items: center; gap: 6px; color: ' + col + ';')
    if href:
        return '<a href="' + href + '" class="ss-press" style="' + style + '">' + inner + '</a>'
    return '<div style="' + style + '">' + inner + '</div>'

def tabs_markup(state_list_name='tabs', n=3):
    return ('<div role="tablist" style="display: grid; grid-template-columns: repeat(' + str(n) + ', minmax(0, 1fr)); gap: 4px; padding: 4px; border-radius: 16px; background: #EDE6D0; box-shadow: inset 0 1px 2px rgba(0,0,0,0.06);">'
            '<sc-for list="{{ ' + state_list_name + ' }}" as="t" hint-placeholder-count="3">'
            '<button role="tab" aria-selected="{{ t.on }}" onClick="{{ t.pick }}" style="{{ t.style }}">{{ t.name }}</button>'
            '</sc-for></div>')

TABS_JS = """tabsOf(names, cur, key) {
    return names.map((name) => {
      const on = cur === name;
      return { name, on: on ? 'true' : 'false', pick: () => this.setState({ [key]: name }),
        style: 'height: 36px; border: 0; border-radius: 12px; cursor: pointer; font-family: Fredoka, sans-serif; font-weight: 600; font-size: 15px; transition: background .2s, color .2s; ' +
          (on ? 'background: linear-gradient(180deg, #1E9C5C, #0B6B3E); color: #FFFFFF; box-shadow: 0 3px 8px rgba(7,91,53,0.3);' : 'background: transparent; color: #4C6152;') };
    });
  }"""

def avatar(s=40, hue='#13864D', bg='#DDEFD0'):
    return ('<svg width="' + str(s) + '" height="' + str(s) + '" viewBox="0 0 40 40" aria-hidden="true" style="flex: none;"><circle cx="20" cy="20" r="20" fill="' + bg + '"/>'
            '<circle cx="20" cy="16" r="7" fill="' + hue + '"/><path d="M7 34 C 9 25, 31 25, 33 34 A 20 20 0 0 1 7 34 Z" fill="' + hue + '"/></svg>')

def falling_leaves(n=7, seed=3, opacity=0.9):
    import random
    r = random.Random(seed); out = []
    for i in range(n):
        x = r.randint(-10, 360); d = r.uniform(9, 16); dl = -r.uniform(0, 16); s = r.randint(16, 30)
        cols = r.choice([('#9BD25A', '#3E9B3A'), ('#B6DE6A', '#5DAA3C'), ('#7CC24A', '#2E8B3A')])
        out.append('<div aria-hidden="true" style="position: absolute; left: ' + str(x) + 'px; top: 0; opacity: ' + str(opacity) + '; animation: ssFall ' + f'{d:.1f}' + 's linear ' + f'{dl:.1f}' + 's infinite; pointer-events: none; z-index: 1;">' + leaf_svg(s, cols[0], cols[1], r.randint(0, 180)) + '</div>')
    return ''.join(out)

def corner_leaves():
    # soft, out-of-focus leaves in the corners, like the reference splash
    return ('<div aria-hidden="true" style="position: absolute; left: -46px; top: 70px; filter: blur(2px); opacity: 0.85; z-index: 0;">' + leaf_svg(120, '#9BD25A', '#3E9B3A', 130) + '</div>'
            '<div aria-hidden="true" style="position: absolute; right: -50px; top: 260px; filter: blur(3px); opacity: 0.7; z-index: 0;">' + leaf_svg(110, '#B6DE6A', '#5DAA3C', -120) + '</div>'
            '<div aria-hidden="true" style="position: absolute; left: -30px; bottom: 60px; filter: blur(1px); opacity: 0.9; z-index: 0;">' + leaf_svg(130, '#7CC24A', '#2E8B3A', 60) + '</div>'
            '<div aria-hidden="true" style="position: absolute; right: -40px; bottom: -20px; opacity: 0.95; z-index: 0;">' + leaf_svg(150, '#9BD25A', '#2E8B3A', -40) + '</div>')

def gift(s=44, body='#E84B3C', ribbon='#F4B72F'):
    return ('<svg width="' + str(s) + '" height="' + str(s) + '" viewBox="0 0 48 48" aria-hidden="true" style="flex: none;">'
            '<ellipse cx="24" cy="44" rx="16" ry="2.6" fill="#000" opacity="0.12"/>'
            '<rect x="7" y="20" width="34" height="23" rx="3" fill="' + body + '"/><rect x="7" y="20" width="34" height="5" fill="#000" opacity="0.12"/>'
            '<rect x="5" y="14" width="38" height="9" rx="2.5" fill="' + body + '"/><rect x="5" y="14" width="38" height="3" rx="1.5" fill="#FFF" opacity="0.25"/>'
            '<rect x="21" y="14" width="6" height="29" fill="' + ribbon + '"/><rect x="21" y="14" width="2" height="29" fill="#FFF" opacity="0.35"/>'
            '<path d="M24 14 C 16 4, 8 10, 14 14 Z M24 14 C 32 4, 40 10, 34 14 Z" fill="' + ribbon + '" stroke="#C98200" stroke-width="1"/></svg>')

def toggle_markup(var):
    return ('<button role="switch" aria-checked="{{ ' + var + '.on }}" onClick="{{ ' + var + '.flip }}" style="{{ ' + var + '.track }}"><span style="{{ ' + var + '.knob }}"></span></button>')

TOGGLE_JS = """toggle(key) {
    const on = this.state[key];
    return { on: on ? 'true' : 'false', flip: () => this.setState({ [key]: !on }),
      track: 'position: relative; width: 50px; height: 30px; flex: none; border: 0; border-radius: 15px; cursor: pointer; padding: 0; transition: background .2s; ' + (on ? 'background: #13864D;' : 'background: #D9D2BC;'),
      knob: 'position: absolute; top: 3px; left: ' + (on ? '23px' : '3px') + '; width: 24px; height: 24px; border-radius: 12px; background: #FFFFFF; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: left .2s cubic-bezier(.3,1.4,.5,1);' };
  }"""

def write(name, html):
    open('/tmp/claude-0/-home-claude/1f41784e-164b-58df-a754-ab2665eda5af/scratchpad/ss/project/' + name, 'w').write(html)
