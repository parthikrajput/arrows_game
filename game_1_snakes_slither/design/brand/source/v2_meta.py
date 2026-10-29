from v2_common import *

SKINS = [('Classic', 'green', 0, 'Equipped'), ('Red', 'red', 200, ''), ('Blue', 'blue', 200, ''), ('Rainbow', 'rainbow', 300, ''), ('Gold', 'gold', 500, ''), ('Ninja', 'ninja', 500, '')]
SKINS_JS = '[' + ','.join("{ name: '%s', key: '%s', price: %d, img: '%s', pv: '%s', owned: %s }" % (n, k, p, B['skin_' + k], B['pv_' + k], 'true' if st else 'false') for n, k, p, st in SKINS) + ']'
THEMES = [('Forest', 'forest', 0), ('Desert', 'desert', 200), ('Snow', 'snow', 200), ('Space', 'space', 300), ('Beach', 'beach', 300), ('Candy', 'candy', 300)]

# ---------------- Shop ----------------
skin_cards = ('<div style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px;">'
  '<sc-for list="{{ skins }}" as="s" hint-placeholder-count="6">'
  '<a href="SkinPreview.dc.html" class="ss-press ss-in" style="{{ s.cardStyle }}">'
  '<div style="height: 92px; border-radius: 14px; background: radial-gradient(circle at 50% 60%, #FFFFFF, #EFE9D6); display: flex; align-items: center; justify-content: center; overflow: hidden;"><img src="{{ s.img }}" alt="{{ s.name }} snake" style="height: 82px;"></div>'
  "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 15px;\">{{ s.name }}</span>"
  '<sc-if value="{{ s.equipped }}" hint-placeholder-val="{{ false }}"><span style="height: 22px; padding: 0 8px; border-radius: 11px; background: ' + EMERALD + '; color: #FFF; display: flex; align-items: center; font-size: 11px; font-weight: 800;">Equipped</span></sc-if>'
  '<sc-if value="{{ s.ownedNotEquipped }}" hint-placeholder-val="{{ false }}"><span style="height: 22px; padding: 0 8px; border-radius: 11px; background: #E3F2D3; color: ' + FOREST + '; display: flex; align-items: center; font-size: 11px; font-weight: 800;">Owned</span></sc-if>'
  '<sc-if value="{{ s.locked }}" hint-placeholder-val="{{ true }}"><span style="height: 22px; display: flex; align-items: center; gap: 4px; font-size: 14px; font-weight: 800;">' + coin(16) + '{{ s.price }}</span></sc-if>'
  '</a></sc-for></div>')
foods = [('Apple', 'Classic fruit · +10 points', 'Owned', '#E5322D'), ('Golden Apple', 'Double points for 10 s', '150', '#F4B72F'), ('Berry Mix', 'Slows time for 5 s', '200', '#7A3FB8'), ('Magic Melon', 'Shrinks the snake by 3', '250', '#3FB24A')]
food_rows = ''.join(
  '<div class="ss-in" style="animation-delay: ' + str(i * 0.06) + 's; display: flex; align-items: center; gap: 12px; padding: 10px 12px; border-radius: 18px; background: ' + CARD + '; border: 1px solid #ECE5CF; box-shadow: 0 6px 14px rgba(22,59,40,0.06);">'
  '<span style="width: 52px; height: 52px; border-radius: 16px; background: radial-gradient(circle at 50% 60%, #FFFFFF, #EFE9D6); display: flex; align-items: center; justify-content: center;">'
  '<svg width="34" height="34" viewBox="0 0 24 24" aria-hidden="true"><ellipse cx="12" cy="22" rx="7" ry="1.4" fill="#000" opacity="0.12"/><circle cx="12" cy="13.5" r="8" fill="' + c + '"/><ellipse cx="9" cy="10.5" rx="2.6" ry="1.6" fill="#FFF" opacity="0.5"/><path d="M12 6 V3" stroke="#5A3A1A" stroke-width="1.8" stroke-linecap="round"/><path d="M12.5 4.5 C 15 2.5, 18 3.5, 18 3.5 C 17 5.5, 14 6, 12.5 4.5 Z" fill="#4CAF50"/></svg></span>'
  "<div style=\"flex: 1;\"><div style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px;\">" + n + '</div><div style="font-size: 13px; font-weight: 700; color: ' + MUTED + ';">' + d + '</div></div>'
  + ('<span style="height: 30px; padding: 0 10px; border-radius: 15px; background: #E3F2D3; color: ' + FOREST + '; display: flex; align-items: center; font-size: 12px; font-weight: 800;">Owned</span>' if pr == 'Owned' else
     '<button class="ss-press" style="height: 34px; padding: 0 12px; border: 0; border-radius: 17px; cursor: pointer; background: linear-gradient(180deg, #23A766, ' + FOREST + '); color: #FFF; display: flex; align-items: center; gap: 4px; font-family: Fredoka, sans-serif; font-weight: 600; font-size: 15px; box-shadow: 0 3px 0 #03432A;">' + coin(16) + pr + '</button>')
  + '</div>' for i, (n, d, pr, c) in enumerate(foods))
theme_mini = ('<div style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px;">' + ''.join(
  '<a href="Themes.dc.html" class="ss-press" style="display: flex; flex-direction: column; gap: 4px; align-items: center; padding: 6px; border-radius: 16px; background: ' + CARD + '; border: 1px solid #ECE5CF;">'
  '<img src="' + B['theme_' + k] + '" alt="' + n + ' theme" style="width: 100%; aspect-ratio: 1; object-fit: cover; border-radius: 12px; display: block;">'
  "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 14px;\">" + n + '</span></a>' for n, k, p in THEMES) + '</div>'
  '<div style="margin-top: 12px;">' + btn2('See all themes', 'Themes.dc.html') + '</div>')
inner = (status() + back('Home.dc.html', 'Shop', pill(coin(22), '8,420', None, True)) +
  '<div style="position: relative; z-index: 2; padding: 4px 16px 0; display: flex; flex-direction: column; gap: 14px;">' + tabs_markup('tabs', 3) +
  '<sc-if value="{{ onSkins }}" hint-placeholder-val="{{ true }}">' + skin_cards + '</sc-if>'
  '<sc-if value="{{ onFood }}" hint-placeholder-val="{{ false }}"><div style="display: flex; flex-direction: column; gap: 10px;">' + food_rows + '</div></sc-if>'
  '<sc-if value="{{ onThemes }}" hint-placeholder-val="{{ false }}">' + theme_mini + '</sc-if>'
  '</div>'
  '<div style="position: absolute; z-index: 2; left: 16px; right: 16px; bottom: 112px;"><div style="margin: 0 4px 8px; display: flex; justify-content: space-between; font-size: 12px; font-weight: 800; letter-spacing: 0.6px; color: ' + MUTED + ';"><span>COIN PACKS</span><span style="color: #D9822B;">Best value: 3,000</span></div>'
  '<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px;">' + ''.join(
    '<button class="ss-press" style="position: relative; padding: 10px 4px 8px; border-radius: 18px; cursor: pointer; font: inherit; color: ' + INK + '; background: ' + CARD + '; ' + ('border: 2px solid #F4B72F;' if best else 'border: 1px solid #ECE5CF;') + ' box-shadow: 0 6px 14px rgba(22,59,40,0.07); display: flex; flex-direction: column; align-items: center; gap: 2px;">'
    + ('<span style="position: absolute; top: -10px; padding: 1px 8px; border-radius: 8px; background: #E84B3C; color: #FFF; font-size: 10px; font-weight: 800;">+25%</span>' if best else '')
    + '<span style="display: flex; margin-bottom: 2px;">' + ''.join('<span style="margin-left: -8px;">' + coin(26) + '</span>' for _ in range(k)) + '</span>'
    "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 17px;\">" + amt + '</span>'
    '<span style="height: 24px; padding: 0 10px; border-radius: 12px; background: #E3F2D3; color: ' + FOREST + '; display: flex; align-items: center; font-size: 13px; font-weight: 800;">' + price + '</span></button>'
    for amt, price, k, best in [('500', '₹49', 1, False), ('1,200', '₹99', 2, False), ('3,000', '₹199', 3, True)]) + '</div></div>'
  '<div style="position: absolute; z-index: 2; left: 16px; right: 16px; bottom: 30px;">' + card(
    '<div style="display: flex; align-items: center; gap: 12px;"><span style="width: 46px; height: 46px; border-radius: 14px; background: #FDF0CC; display: flex; align-items: center; justify-content: center;">' + coin(30) + '</span>'
    "<div style=\"flex: 1;\"><div style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px;\">Free coins</div><div style=\"font-size: 13px; font-weight: 700; color: " + MUTED + ";\">Watch a short video · 3 left today</div></div>"
    '<button class="ss-press" style="height: 38px; padding: 0 14px; border: 0; border-radius: 19px; cursor: pointer; background: linear-gradient(180deg, #FFD84A, #E39A12); color: #5A3400; display: flex; align-items: center; gap: 4px; font-family: Fredoka, sans-serif; font-weight: 600; font-size: 15px; box-shadow: 0 3px 0 #B8730A;">+50</button></div>', 'padding: 12px;') + '</div>')
shop_js = ("constructor(props) { super(props); this.state = { tab: 'Skins' }; }\n  " + TABS_JS + """
  renderVals() {
    const tab = this.state.tab;
    const skins = %s.map((s, i) => {
      const equipped = i === 0;
      return { ...s, equipped, ownedNotEquipped: s.owned && !equipped, locked: !s.owned,
        cardStyle: 'display: flex; flex-direction: column; align-items: center; gap: 4px; padding: 8px 6px 10px; border-radius: 18px; background: #FFFEF8; animation-delay: ' + (i * 0.05) + 's; ' +
          (equipped ? 'border: 2px solid #13864D; box-shadow: 0 6px 16px rgba(19,134,77,0.18);' : 'border: 1px solid #ECE5CF; box-shadow: 0 6px 14px rgba(22,59,40,0.06);') };
    });
    return { tabs: this.tabsOf(['Skins', 'Food', 'Themes'], tab, 'tab'), onSkins: tab === 'Skins', onFood: tab === 'Food', onThemes: tab === 'Themes', skins };
  }""" % SKINS_JS)
write('Shop.dc.html', head('Shop') + root(inner) + foot(shop_js))

# ---------------- Skin preview ----------------
arrow = lambda d, fn: ('<button aria-label="' + ('Previous skin' if d < 0 else 'Next skin') + '" onClick="{{ ' + fn + ' }}" class="ss-press" style="position: absolute; z-index: 3; top: 210px; ' + ('left: 14px;' if d < 0 else 'right: 14px;') + ' width: 44px; height: 44px; border: 0; border-radius: 22px; cursor: pointer; background: ' + CARD + '; box-shadow: 0 3px 0 #DDD3B6, 0 8px 16px rgba(22,59,40,0.12); display: flex; align-items: center; justify-content: center; color: ' + INK + ';">'
                     '<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="' + ('M15 5 L8 12 L15 19' if d < 0 else 'M9 5 L16 12 L9 19') + '"/></svg></button>')
inner = (corner_leaves() + status() + back('Shop.dc.html', '{{ title }}') +
  arrow(-1, 'prev') + arrow(1, 'next') +
  '<div style="position: relative; z-index: 2; height: 380px; display: flex; align-items: flex-end; justify-content: center;">'
  '<div aria-hidden="true" style="position: absolute; bottom: 30px; width: 320px; height: 320px; border-radius: 50%; background: radial-gradient(circle, rgba(255,255,255,0.95), rgba(255,255,255,0) 68%);"></div>'
  '<img src="{{ pv }}" alt="{{ title }} preview" style="position: relative; width: 330px; animation: ssSway 5s ease-in-out infinite;"></div>'
  '<div style="position: relative; z-index: 2; margin-top: 8px; display: flex; justify-content: center; gap: 8px;">'
  '<sc-for list="{{ dots }}" as="d" hint-placeholder-count="6"><span style="{{ d }}"></span></sc-for></div>'
  '<p style="position: relative; z-index: 2; margin: 10px 0 0; text-align: center; font-size: 13px; font-weight: 800; color: ' + MUTED + '; display: flex; align-items: center; justify-content: center; gap: 6px;">'
  '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" aria-hidden="true"><path d="M4 12 a8 4 0 1 0 16 0"/><path d="M17 9 L20 12 L23 9"/></svg>Drag to rotate</p>'
  '<div style="position: relative; z-index: 2; margin: 14px 16px 0;">' + card(
    '<div style="display: grid; grid-template-columns: repeat(3, 1fr); text-align: center;">'
    '<div><div style="font-size: 12px; font-weight: 800; color: ' + MUTED + ';">RARITY</div><div style="font-family: Fredoka, sans-serif; font-weight: 600; font-size: 16px;">{{ rarity }}</div></div>'
    '<div style="border-left: 1px solid #ECE5CF; border-right: 1px solid #ECE5CF;"><div style="font-size: 12px; font-weight: 800; color: ' + MUTED + ';">TRAIL</div><div style="font-family: Fredoka, sans-serif; font-weight: 600; font-size: 16px;">{{ trail }}</div></div>'
    '<div><div style="font-size: 12px; font-weight: 800; color: ' + MUTED + ';">STATUS</div><div style="font-family: Fredoka, sans-serif; font-weight: 600; font-size: 16px;">{{ status }}</div></div></div>', 'padding: 12px;') + '</div>'
  '<div style="position: absolute; z-index: 2; left: 40px; right: 40px; bottom: 40px;">'
  '<sc-if value="{{ locked }}" hint-placeholder-val="{{ true }}">' + btn('<span style="display: flex; flex-direction: column; align-items: center; line-height: 1.05;"><span>Unlock</span><span style="display: flex; align-items: center; gap: 4px; font-size: 16px;">' + coin(18) + '{{ price }}</span></span>', 'Shop.dc.html', 62, '100%', 20) + '</sc-if>'
  '<sc-if value="{{ owned }}" hint-placeholder-val="{{ false }}">' + btn('{{ ownedLabel }}', 'Shop.dc.html', 62, '100%', 20) + '</sc-if></div>')
pv_js = ("constructor(props) { super(props); this.state = { i: 3 }; }\n  renderVals() {\n    const skins = " + SKINS_JS + """;
    const n = skins.length, i = ((this.state.i %% n) + n) %% n, s = skins[i];
    const rar = { Classic: 'Common', Red: 'Common', Blue: 'Common', Rainbow: 'Rare', Gold: 'Epic', Ninja: 'Epic' }[s.name];
    const trail = { Classic: 'Leaf', Red: 'Ember', Blue: 'Bubble', Rainbow: 'Sparkle', Gold: 'Glitter', Ninja: 'Smoke' }[s.name];
    return { title: s.name + ' Snake', pv: s.pv, price: s.price, rarity: rar, trail, status: s.owned ? 'Owned' : 'Locked',
      locked: !s.owned, owned: s.owned, ownedLabel: i === 0 ? 'Equipped' : 'Equip',
      prev: () => this.setState({ i: i - 1 }), next: () => this.setState({ i: i + 1 }),
      dots: skins.map((_, k) => 'height: 8px; border-radius: 4px; transition: width .2s; ' + (k === i ? 'width: 22px; background: #13864D;' : 'width: 8px; background: #D9D2BC;')) };
  }""").replace('%%', '%')
write('SkinPreview.dc.html', head('Skin preview') + root(inner) + foot(pv_js))

# ---------------- Rewards ----------------
gift_cols = ['#E84B3C', '#13864D', '#3FA0E8', '#F4B72F', '#8E5BD8', '#E84B3C', '#13864D']
gift_svgs = ''.join('<sc-if value="{{ r.g%d }}" hint-placeholder-val="{{ %s }}">%s</sc-if>' % (i, 'true' if i == 0 else 'false', gift(40, c, '#FFD84A' if c != '#F4B72F' else '#E84B3C')) for i, c in enumerate(gift_cols))
daily_rows = ('<sc-for list="{{ days }}" as="r" hint-placeholder-count="7">'
  '<div class="ss-in" style="{{ r.style }}">'
  '<span style="width: 50px; height: 50px; flex: none; border-radius: 16px; background: radial-gradient(circle at 50% 60%, #FFFFFF, #EFE9D6); display: flex; align-items: center; justify-content: center;">' + gift_svgs + '</span>'
  "<div style=\"flex: 1;\"><div style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px;\">{{ r.day }}</div>"
  '<div style="display: flex; align-items: center; gap: 4px; font-size: 14px; font-weight: 800;"><sc-if value="{{ r.isCoin }}" hint-placeholder-val="{{ true }}">' + coin(16) + '</sc-if><sc-if value="{{ r.isGem }}" hint-placeholder-val="{{ false }}">' + gem(16) + '</sc-if>{{ r.amount }}</div></div>'
  '<sc-if value="{{ r.claimable }}" hint-placeholder-val="{{ false }}"><button onClick="{{ r.claim }}" class="ss-press" style="height: 36px; padding: 0 18px; border: 0; border-radius: 18px; cursor: pointer; background: linear-gradient(180deg, #23A766, ' + FOREST + '); color: #FFF; font-family: Fredoka, sans-serif; font-weight: 600; font-size: 15px; box-shadow: 0 3px 0 #03432A; animation: ssPulse 1.8s ease-in-out infinite;">Claim</button></sc-if>'
  '<sc-if value="{{ r.claimed }}" hint-placeholder-val="{{ true }}"><span style="height: 32px; padding: 0 12px; border-radius: 16px; background: #E3F2D3; color: ' + FOREST + '; display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: 800;"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.4" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12.5 L10 17 L19 7"/></svg>Claimed</span></sc-if>'
  '<sc-if value="{{ r.locked }}" hint-placeholder-val="{{ false }}"><span style="height: 32px; padding: 0 12px; border-radius: 16px; background: #EFE9D6; color: #9A9580; display: flex; align-items: center; gap: 4px; font-size: 13px; font-weight: 800;"><svg width="13" height="13" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><rect x="5" y="10" width="14" height="11" rx="2.5"/><path d="M8 10 V7.5 a4 4 0 0 1 8 0 V10" fill="none" stroke="currentColor" stroke-width="2.6"/></svg>Locked</span></sc-if>'
  '</div></sc-for>')
miles = ('<sc-for list="{{ miles }}" as="m" hint-placeholder-count="4">'
  '<div class="ss-in" style="display: flex; flex-direction: column; gap: 8px; padding: 12px 14px; border-radius: 18px; background: ' + CARD + '; border: 1px solid #ECE5CF; box-shadow: 0 6px 14px rgba(22,59,40,0.06);">'
  "<div style=\"display: flex; align-items: center; gap: 10px;\"><span style=\"flex: 1; font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px;\">{{ m.name }}</span>"
  '<span style="display: flex; align-items: center; gap: 4px; font-size: 14px; font-weight: 800;">' + gem(16) + '{{ m.gems }}</span></div>'
  '<div style="display: flex; align-items: center; gap: 10px;"><div style="flex: 1; height: 8px; border-radius: 4px; background: #ECE5CF; overflow: hidden;"><div style="{{ m.bar }}"></div></div>'
  '<span style="font-size: 12px; font-weight: 800; color: ' + MUTED + '; font-variant-numeric: tabular-nums;">{{ m.prog }}</span></div></div></sc-for>')
inner = (status() + back('Home.dc.html', 'Rewards') +
  '<div style="position: relative; z-index: 2; padding: 4px 16px 0; display: flex; flex-direction: column; gap: 10px;">' + tabs_markup('tabs', 2) +
  '<div style="display: flex; align-items: center; gap: 8px; padding: 2px 4px; font-size: 13px; font-weight: 800; color: #9A5B00;"><svg width="16" height="16" viewBox="0 0 24 24" aria-hidden="true"><path d="M12 2.5c1.2 4.6 6 5.6 6 11.2a6 6 0 0 1-12 0c0-3.4 2.3-4.6 2.3-8 2.4 1.2 3.6 2.4 3.6 4.7" fill="#FF8F00"/></svg>{{ streakText }}</div>'
  '<sc-if value="{{ onDaily }}" hint-placeholder-val="{{ true }}"><div style="display: flex; flex-direction: column; gap: 8px;">' + daily_rows + '</div></sc-if>'
  '<sc-if value="{{ onMiles }}" hint-placeholder-val="{{ false }}"><div style="display: flex; flex-direction: column; gap: 10px;">' + miles + '</div></sc-if>'
  '</div>')
rw_js = ("constructor(props) { super(props); this.state = { tab: 'Daily', claimed: 1 }; }\n  " + TABS_JS + """
  renderVals() {
    const tab = this.state.tab, claimed = this.state.claimed;
    const rewards = [['coin', 50], ['coin', 75], ['coin', 100], ['gem', 1], ['coin', 150], ['coin', 200], ['gem', 5]];
    const days = rewards.map(([kind, amt], i) => {
      const isClaimed = i < claimed, today = i === claimed;
      const g = {}; for (let k = 0; k < 7; k++) g['g' + k] = k === i;
      return { ...g, day: 'Day ' + (i + 1) + (i === 6 ? ' · Big chest' : ''), amount: (kind === 'gem' ? '' : '') + amt, isCoin: kind === 'coin', isGem: kind === 'gem',
        claimable: today, claimed: isClaimed, locked: !isClaimed && !today, claim: () => this.setState({ claimed: claimed + 1 }),
        style: 'animation-delay: ' + (i * 0.04) + 's; display: flex; align-items: center; gap: 12px; padding: 7px 10px 7px 7px; border-radius: 18px; background: #FFFEF8; ' +
          (today ? 'border: 2px solid #A8D94F; box-shadow: 0 6px 16px rgba(19,134,77,0.16);' : 'border: 1px solid #ECE5CF; box-shadow: 0 4px 10px rgba(22,59,40,0.05);') + (!isClaimed && !today ? ' opacity: 0.85;' : '') };
    });
    const ms = [['Reach level 10', 10, 10, 3], ['Collect 1,000 fruits', 640, 1000, 5], ['Unlock 3 skins', 1, 3, 5], ['Play 7 days in a row', 4, 7, 10]];
    const miles = ms.map(([name, a, b, gems]) => ({ name, gems, prog: a.toLocaleString('en-US') + ' / ' + b.toLocaleString('en-US'),
      bar: 'height: 100%; border-radius: 4px; width: ' + Math.round(a / b * 100) + '%; background: linear-gradient(90deg, ' + (a >= b ? '#A8D94F, #13864D' : '#FFD84A, #F4B72F') + ');' }));
    return { tabs: this.tabsOf(['Daily', 'Milestones'], tab, 'tab'), onDaily: tab === 'Daily', onMiles: tab === 'Milestones', days, miles,
      streakText: 'Login streak: ' + claimed + ' day' + (claimed === 1 ? '' : 's') + ' · come back tomorrow for more' };
  }""")
write('Rewards.dc.html', head('Rewards') + root(inner) + foot(rw_js))

# ---------------- Profile ----------------
menu = [('Statistics', '#', '<path d="M4 20 V13 H9 V20 Z M9.5 20 V8 H14.5 V20 Z M15 20 V11 H20 V20 Z"/>'), ('Achievements', 'Rewards.dc.html', '<circle cx="12" cy="9" r="5"/><path d="M8.5 13 L7 21 L12 18.5 L17 21 L15.5 13"/>'),
        ('Leaderboard', 'Leaderboards.dc.html', '<path d="M8 21 H16 M12 17 V21 M6 4 H18 V8 a6 6 0 0 1 -12 0 Z M6 6 H3 a3 3 0 0 0 3 4 M18 6 H21 a3 3 0 0 1 -3 4"/>'), ('Settings', 'Settings.dc.html', '<circle cx="12" cy="12" r="3.2"/><path d="M12 2.8 V5.2 M12 18.8 V21.2 M2.8 12 H5.2 M18.8 12 H21.2 M5.5 5.5 L7.2 7.2 M16.8 16.8 L18.5 18.5 M5.5 18.5 L7.2 16.8 M16.8 7.2 L18.5 5.5"/>'),
        ('Log out', 'Main.dc.html', '<path d="M10 4 H5 V20 H10"/><path d="M14 8 L18 12 L14 16 M18 12 H9"/>')]
menu_html = ''.join('<a href="' + h + '" class="ss-press" style="display: flex; align-items: center; gap: 12px; padding: 13px 4px; ' + ('border-top: 1px solid #EFE8D2;' if i else '') + ' color: ' + ('#B23A2E' if n == 'Log out' else INK) + ';">'
                    '<span style="width: 34px; height: 34px; border-radius: 11px; background: ' + ('#FBE3DF' if n == 'Log out' else '#E3F2D3') + '; display: flex; align-items: center; justify-content: center; color: ' + ('#B23A2E' if n == 'Log out' else EMERALD) + ';"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + ic + '</svg></span>'
                    '<span style="flex: 1; font-size: 16px; font-weight: 800;">' + n + '</span>'
                    '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#A5AE9F" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 5 L16 12 L9 19"/></svg></a>' for i, (n, h, ic) in enumerate(menu))
stat = lambda icon, v, l: ('<div style="display: flex; flex-direction: column; align-items: center; gap: 2px;">' + icon + "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 20px;\">" + v + '</span><span style="font-size: 12px; font-weight: 800; color: ' + MUTED + ';">' + l + '</span></div>')
trophy_ic = '<svg width="26" height="26" viewBox="0 0 24 24" aria-hidden="true"><path d="M7 3 H17 V8 a5 5 0 0 1 -10 0 Z" fill="#F4B72F"/><path d="M7 5 H4 a3 3 0 0 0 3 4 M17 5 H20 a3 3 0 0 1 -3 4" fill="none" stroke="#C98200" stroke-width="1.6"/><path d="M10.5 13 H13.5 L13 17 H11 Z M8 21 H16 L15 17 H9 Z" fill="#C98200"/></svg>'
crown_ic = '<svg width="26" height="26" viewBox="0 0 24 24" aria-hidden="true"><path d="M3 8 L7.5 12 L12 5 L16.5 12 L21 8 L19 18 H5 Z" fill="#F4B72F" stroke="#C98200" stroke-width="1.2" stroke-linejoin="round"/><rect x="5" y="18" width="14" height="2.5" rx="1" fill="#C98200"/></svg>'
apple_ic = '<svg width="26" height="26" viewBox="0 0 24 24" aria-hidden="true"><circle cx="12" cy="14" r="7.5" fill="#E5322D"/><ellipse cx="9.5" cy="11" rx="2.2" ry="1.4" fill="#FFF" opacity="0.5"/><path d="M12 6.5 V3.5" stroke="#5A3A1A" stroke-width="1.8" stroke-linecap="round"/><path d="M12.5 5 C 15 3, 18 4, 18 4 C 17 6, 14 6.5, 12.5 5 Z" fill="#4CAF50"/></svg>'
inner = (status() + back('Home.dc.html', 'Profile') +
  '<div style="position: relative; z-index: 2; padding: 0 16px; display: flex; flex-direction: column; align-items: center;">'
  '<div style="position: relative; width: 96px; height: 96px; border-radius: 48px; border: 4px solid #FFFFFF; box-shadow: 0 0 0 3px ' + EMERALD + ', 0 10px 20px rgba(22,59,40,0.18); overflow: hidden;">' + avatar(88) + '</div>'
  "<div style=\"margin-top: 10px; display: flex; align-items: center; gap: 8px;\"><span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 24px;\">Player123</span>"
  '<button aria-label="Edit name" class="ss-press" style="width: 30px; height: 30px; border: 0; border-radius: 15px; background: #EFE9D6; cursor: pointer; display: flex; align-items: center; justify-content: center; color: ' + INK + ';"><svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 20 H8 L19 9 L15 5 L4 16 Z"/></svg></button></div>'
  '<div style="align-self: stretch; margin-top: 14px;">' + card(
    '<div style="display: flex; justify-content: space-between; align-items: baseline;"><span style="font-family: Fredoka, sans-serif; font-weight: 600; font-size: 17px; color: ' + EMERALD + ';">Level 5</span><span style="font-size: 13px; font-weight: 800; color: ' + MUTED + '; font-variant-numeric: tabular-nums;">320 / 500 XP</span></div>'
    '<div style="margin-top: 8px; height: 12px; border-radius: 6px; background: #ECE5CF; overflow: hidden;"><div style="width: 64%; height: 100%; border-radius: 6px; background: linear-gradient(90deg, ' + LEAF + ', ' + EMERALD + ');"></div></div>', 'padding: 14px;') + '</div>'
  '<div style="align-self: stretch; margin-top: 12px;">' + card('<div style="display: grid; grid-template-columns: repeat(3, 1fr);">' + stat(trophy_ic, '12', 'Levels') + stat(crown_ic, '3,240', 'Best score') + stat(apple_ic, '1,284', 'Fruits') + '</div>', 'padding: 14px 6px;') + '</div>'
  '<div style="align-self: stretch; margin-top: 12px;">' + card(menu_html, 'padding: 2px 12px;') + '</div>'
  '</div>')
write('Profile.dc.html', head('Profile') + root(inner) + foot())

# ---------------- Settings ----------------
def srow(i, icon, label, right):
    return ('<div style="display: flex; align-items: center; gap: 12px; padding: 12px 4px; ' + ('border-top: 1px solid #EFE8D2;' if i else '') + '">'
            '<span style="width: 34px; height: 34px; border-radius: 11px; background: #E3F2D3; color: ' + EMERALD + '; display: flex; align-items: center; justify-content: center;"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + icon + '</svg></span>'
            '<span style="flex: 1; font-size: 16px; font-weight: 800;">' + label + '</span>' + right + '</div>')
chev = lambda t='': ('<span style="display: flex; align-items: center; gap: 6px; font-size: 14px; font-weight: 700; color: ' + MUTED + ';">' + t + '<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#A5AE9F" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 5 L16 12 L9 19"/></svg></span>')
g1 = (srow(0, '<path d="M4 9 H8 L13 5 V19 L8 15 H4 Z"/><path d="M16.5 8.5 a5 5 0 0 1 0 7"/>', 'Sound', toggle_markup('sound'))
      + srow(1, '<path d="M9 17 V5 L19 3 V15"/><circle cx="7" cy="17" r="2.5"/><circle cx="17" cy="15" r="2.5"/>', 'Music', toggle_markup('music'))
      + srow(2, '<rect x="8" y="3" width="8" height="18" rx="2"/><path d="M4 8 V16 M20 8 V16"/>', 'Vibration', toggle_markup('vibe'))
      + srow(3, '<path d="M6 8 a6 6 0 0 1 12 0 c0 7 3 8 3 8 H3 s3-1 3-8"/><path d="M10 20 a2 2 0 0 0 4 0"/>', 'Notifications', toggle_markup('notif')))
g2 = (srow(0, '<circle cx="12" cy="12" r="9"/><path d="M3 12 H21 M12 3 C 8 7, 8 17, 12 21 C 16 17, 16 7, 12 3"/>', 'Language', chev('English'))
      + srow(1, '<path d="M12 3 l2.7 5.6 6.1.9 -4.4 4.3 1 6.1 -5.4-2.9 -5.4 2.9 1-6.1 -4.4-4.3 6.1-.9z"/>', 'Rate Us', chev())
      + srow(2, '<path d="M12 3 L20 6 V12 C 20 17, 16 20, 12 21 C 8 20, 4 17, 4 12 V6 Z"/>', 'Privacy Policy', chev())
      + srow(3, '<path d="M4 6 H20 V18 H4 Z"/><path d="M4 6 L12 13 L20 6"/>', 'Contact Us', chev())
      + srow(4, '<circle cx="12" cy="12" r="9"/><path d="M12 11 V16 M12 7.5 V8"/>', 'About', '<span style="font-size: 14px; font-weight: 700; color: ' + MUTED + ';">v1.0.0</span>'))
inner = (status() + back('Home.dc.html', 'Settings') +
  '<div style="position: relative; z-index: 2; padding: 4px 16px 0; display: flex; flex-direction: column; gap: 8px;">'
  '<span style="padding: 0 6px; font-size: 12px; font-weight: 800; letter-spacing: 0.6px; color: ' + MUTED + ';">GAME</span>' + card(g1, 'padding: 2px 12px;') +
  '<span style="margin-top: 6px; padding: 0 6px; font-size: 12px; font-weight: 800; letter-spacing: 0.6px; color: ' + MUTED + ';">MORE</span>' + card(g2, 'padding: 2px 12px;') +
  '</div>'
  '<p style="position: absolute; z-index: 2; left: 0; right: 0; bottom: 30px; margin: 0; text-align: center; font-size: 12px; font-weight: 700; color: #8A9A8E;">Snake Slither · made with care in the garden</p>')
st_js = "constructor(props) { super(props); this.state = { sound: true, music: true, vibe: true, notif: false }; }\n  " + TOGGLE_JS + "\n  renderVals() { return { sound: this.toggle('sound'), music: this.toggle('music'), vibe: this.toggle('vibe'), notif: this.toggle('notif') }; }"
write('Settings.dc.html', head('Settings') + root(inner) + foot(st_js))

# ---------------- Leaderboard ----------------
lb_rows = ('<sc-for list="{{ rows }}" as="r" hint-placeholder-count="8">'
  '<div class="ss-in" style="{{ r.style }}">'
  '<span style="{{ r.badge }}">{{ r.rank }}</span>'
  '<span style="width: 36px; height: 36px; border-radius: 18px; overflow: hidden; flex: none; background: {{ r.av }}; display: flex; align-items: flex-end; justify-content: center;"><svg width="36" height="36" viewBox="0 0 40 40" aria-hidden="true"><circle cx="20" cy="16" r="7" fill="{{ r.avc }}"/><path d="M7 34 C 9 25, 31 25, 33 34 A 20 20 0 0 1 7 34 Z" fill="{{ r.avc }}"/></svg></span>'
  '<span style="flex: 1; font-size: 15px; font-weight: 800;">{{ r.name }}</span>'
  "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 16px; font-variant-numeric: tabular-nums;\">{{ r.score }}</span></div></sc-for>")
inner = (status() + back('Home.dc.html', 'Leaderboard') +
  '<div style="position: relative; z-index: 2; padding: 4px 16px 0; display: flex; flex-direction: column; gap: 10px;">' + tabs_markup('tabs', 2) +
  '<div style="display: flex; flex-direction: column; gap: 6px;">' + lb_rows + '</div></div>'
  '<div style="position: absolute; z-index: 2; left: 16px; right: 16px; bottom: 30px; padding: 12px 16px; border-radius: 18px; background: linear-gradient(180deg, #23A766, ' + FOREST + '); color: #FFF; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 4px 0 #03432A, 0 12px 22px rgba(7,91,53,0.25);">'
  "<span style=\"font-size: 14px; font-weight: 800; opacity: 0.9;\">Your rank</span><span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 20px;\">{{ myRank }} · {{ myScore }}</span></div>")
lb_js = ("constructor(props) { super(props); this.state = { tab: 'Global' }; }\n  " + TABS_JS + """
  renderVals() {
    const tab = this.state.tab;
    const G = [['SnakeKing', 15240], ['SlitherPro', 12890], ['GreenNinja', 10560], ['Player123', 8420], ['SnakeBoss', 7980], ['NagaPlay', 6720], ['QuickTail', 5430], ['LeafLord', 4910]];
    const F = [['GreenNinja', 10560], ['Player123', 8420], ['Mia', 6200], ['Arjun', 5980], ['Ravi', 4100], ['Zoe', 3550], ['Kabir', 2900], ['Lena', 1880]];
    const data = tab === 'Global' ? G : F;
    const medal = ['#F4B72F', '#B8C2C8', '#D58A4B'], dark = ['#8A5A00', '#55626A', '#7A4318'];
    const avs = [['#FDE7C2', '#D98E10'], ['#DDEFD0', '#13864D'], ['#DDEBFA', '#3A7BC8'], ['#F6DDEB', '#C2457E'], ['#EDE3FA', '#7A4FC2']];
    const rows = data.map(([name, s], i) => {
      const me = name === 'Player123', a = avs[i % avs.length];
      return { rank: i + 1, name: me ? name + ' (you)' : name, score: s.toLocaleString('en-US'), av: a[0], avc: a[1],
        badge: 'width: 30px; height: 30px; flex: none; border-radius: 15px; display: flex; align-items: center; justify-content: center; font-family: Fredoka, sans-serif; font-weight: 700; font-size: 15px; ' +
          (i < 3 ? 'background: ' + medal[i] + '; color: ' + dark[i] + '; box-shadow: inset 0 -2px 0 rgba(0,0,0,0.15), 0 2px 6px rgba(0,0,0,0.15);' : 'background: transparent; color: #6B7F70;'),
        style: 'animation-delay: ' + (i * 0.04) + 's; display: flex; align-items: center; gap: 10px; padding: 8px 12px; border-radius: 16px; ' +
          (me ? 'background: #E3F2D3; border: 2px solid #A8D94F;' : 'background: #FFFEF8; border: 1px solid #ECE5CF;') };
    });
    const mi = data.findIndex((d) => d[0] === 'Player123');
    return { tabs: this.tabsOf(['Global', 'Friends'], tab, 'tab'), rows, myRank: '#' + (mi + 1), myScore: data[mi][1].toLocaleString('en-US') };
  }""")
write('Leaderboards.dc.html', head('Leaderboard') + root(inner) + foot(lb_js))

# ---------------- Themes ----------------
THEMES_JS = '[' + ','.join("{ name: '%s', img: '%s', price: %d }" % (n, B['theme_' + k], p) for n, k, p in THEMES) + ']'
th_cards = ('<div style="display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 10px;">'
  '<sc-for list="{{ themes }}" as="t" hint-placeholder-count="6">'
  '<button onClick="{{ t.pick }}" class="ss-press ss-in" style="{{ t.style }}">'
  '<img src="{{ t.img }}" alt="{{ t.name }} theme" style="width: 100%; aspect-ratio: 1; object-fit: cover; border-radius: 12px; display: block;">'
  "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 15px; color: " + INK + ";\">{{ t.name }}</span>"
  '<sc-if value="{{ t.equipped }}" hint-placeholder-val="{{ false }}"><span style="height: 22px; padding: 0 8px; border-radius: 11px; background: ' + EMERALD + '; color: #FFF; display: flex; align-items: center; font-size: 11px; font-weight: 800;">Equipped</span></sc-if>'
  '<sc-if value="{{ t.forSale }}" hint-placeholder-val="{{ true }}"><span style="height: 22px; display: flex; align-items: center; gap: 4px; font-size: 14px; font-weight: 800; color: ' + INK + ';">' + coin(16) + '{{ t.price }}</span></sc-if>'
  '</button></sc-for></div>')
inner = (status() + back('Shop.dc.html', 'Themes', pill(coin(22), '8,420', None, False)) +
  '<div style="position: relative; z-index: 2; padding: 4px 16px 0; display: flex; flex-direction: column; gap: 12px;">'
  '<div style="position: relative; height: 170px; border-radius: 22px; overflow: hidden; box-shadow: 0 10px 24px rgba(22,59,40,0.16);">'
  '<img src="{{ sel.img }}" alt="{{ sel.name }} theme preview" style="position: absolute; inset: 0; width: 100%; height: 100%; object-fit: cover;">'
  '<div style="position: absolute; inset: auto 0 0 0; padding: 30px 14px 12px; background: linear-gradient(180deg, rgba(0,0,0,0), rgba(0,0,0,0.55)); color: #FFF; display: flex; align-items: flex-end; justify-content: space-between;">'
  "<span style=\"font-family: 'Fredoka', sans-serif; font-weight: 600; font-size: 22px;\">{{ sel.name }}</span><span style=\"font-size: 13px; font-weight: 800; opacity: 0.9;\">Preview</span></div></div>"
  + th_cards + '</div>'
  '<div style="position: absolute; z-index: 2; left: 16px; right: 16px; bottom: 30px;">'
  '<sc-if value="{{ isEquipped }}" hint-placeholder-val="{{ true }}">' + btn2('Equipped', 'Shop.dc.html', 58, 19) + '</sc-if>'
  '<sc-if value="{{ canBuy }}" hint-placeholder-val="{{ false }}">' + btn('<span style="display: flex; align-items: center; gap: 6px;">Unlock {{ sel.name }} · ' + coin(20) + '{{ sel.price }}</span>', 'Play.dc.html', 58, '100%', 19) + '</sc-if></div>')
th_js = ("constructor(props) { super(props); this.state = { sel: 0 }; }\n  renderVals() {\n    const list = " + THEMES_JS + """;
    const sel = this.state.sel;
    const themes = list.map((t, i) => ({ ...t, equipped: i === 0, forSale: i !== 0, pick: () => this.setState({ sel: i }),
      style: 'display: flex; flex-direction: column; align-items: center; gap: 4px; padding: 6px 6px 8px; border-radius: 18px; background: #FFFEF8; cursor: pointer; font: inherit; animation-delay: ' + (i * 0.05) + 's; ' +
        (i === sel ? 'border: 2px solid #13864D; box-shadow: 0 6px 16px rgba(19,134,77,0.2);' : 'border: 1px solid #ECE5CF; box-shadow: 0 6px 14px rgba(22,59,40,0.06);') }));
    return { themes, sel: list[sel], isEquipped: sel === 0, canBuy: sel !== 0 };
  }""")
write('Themes.dc.html', head('Themes') + root(inner) + foot(th_js))
print('meta ok')
