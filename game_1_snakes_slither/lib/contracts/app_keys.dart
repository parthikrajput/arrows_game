// SHARED CONTRACT. Integration tests find widgets by these keys, so a redesign
// never breaks them. UI must put each key on the matching widget.
import 'package:flutter/widgets.dart';

class AppKeys {
  const AppKeys._();
  // Home
  static const homeScreen = Key('home.screen');
  static const ageGateScreen = Key('age.screen');
  static const ageGateWheel = Key('age.wheel');
  static const ageGateContinue = Key('age.continue');
  static const homePlay = Key('home.play');
  static const homeMap = Key('home.map');
  static const homeSettings = Key('home.settings');
  static const settingsLanguage = Key('settings.language');
  static Key settingsLanguageOption(String code) => Key('settings.language.$code');
  static const settingsGuide = Key('settings.guide');
  static const settingsOdds = Key('settings.odds');
  static const settingsOddsSheet = Key('settings.odds.sheet');
  static const settingsPrivacy = Key('settings.privacy');
  static const settingsRestore = Key('settings.restore');
  static const settingsReport = Key('settings.report');
  // Map
  static const mapScreen = Key('map.screen');
  static const mapJumpToCurrent = Key('map.jump');
  static Key mapNode(int level) => Key('map.node.$level');
  static const mapBotsToggle = Key('map.bots');
  static const mapBotPlay = Key('map.botPlay');
  static const botChip = Key('game.botChip');
  // Gameplay
  static const gameplayScreen = Key('game.screen');
  static const pauseButton = Key('game.pause');
  static Key booster(String name) => Key('game.booster.$name'); // hint | shield | hammer
  static const hammerCancel = Key('game.hammer.cancel');
  static const hudGems = Key('game.hud.gems');
  static const tutorialTip = Key('tutorial.tip');
  static const tutorialGotIt = Key('tutorial.gotIt');
  static const introCard = Key('tutorial.intro');
  static const introGotIt = Key('tutorial.intro.gotIt');
  static const hudMongoose = Key('game.hud.mongoose');
  // Popups
  static const pausePopup = Key('popup.pause');
  static const resume = Key('popup.pause.resume');
  static const restart = Key('popup.pause.restart');
  static const secondChancePopup = Key('popup.secondChance');
  static const watchAd = Key('popup.secondChance.ad');
  static const refill = Key('popup.secondChance.refill');
  static const noThanks = Key('popup.secondChance.no');
  static const failedPopup = Key('popup.failed');
  static const retry = Key('popup.failed.retry');
  static const completePopup = Key('popup.complete');
  static const claimDouble = Key('popup.complete.double');
  static const next = Key('popup.complete.next');
  static const miniShop = Key('popup.miniShop');
  static const giftBasket = Key('popup.gift');
  static const giftCollect = Key('popup.gift.collect');
  // Home extras
  static const homeShop = Key('home.shop');
  static const homeWheel = Key('home.wheel');
  static const homeDaily = Key('home.daily');
  static const homeRanks = Key('home.ranks');
  static const homeVipChip = Key('home.vip');
  static const leaderboardsScreen = Key('ranks.screen');
  static const leaderboardsSignIn = Key('ranks.signIn');
  static Key leaderboardTab(String id) => Key('ranks.tab.$id');
  // Shop
  static const shopScreen = Key('shop.screen');
  static Key shopTile(String booster, int qty) => Key('shop.tile.$booster.$qty');
  static const shopFreeCoins = Key('shop.freeCoins');
  static const shopRestore = Key('shop.restore');
  static const shopTabCoins = Key('shop.tab.coins');
  static const shopTabOffers = Key('shop.tab.offers');
  static Key coinPack(String id) => Key('shop.pack.$id');
  static const starterBuy = Key('shop.starter.buy');
  static const vipOpen = Key('shop.vip.open');
  static const vipScreen = Key('vip.screen');
  static const vipSubscribe = Key('vip.subscribe');
  static const starterPopup = Key('popup.starter');
  static const starterPopupBuy = Key('popup.starter.buy');
  static const starterPopupNo = Key('popup.starter.no');
  // Wheel
  static const wheelScreen = Key('wheel.screen');
  static const wheelSpinFree = Key('wheel.spin.free');
  static const wheelSpinAd = Key('wheel.spin.ad');
  // Daily & Streak
  static const dailyScreen = Key('daily.screen');
  static const dailyPlay = Key('daily.play');
  static const dailySaver = Key('daily.saver');
  static const dailyResultPopup = Key('popup.dailyResult');
  static const dailyResultCollect = Key('popup.dailyResult.collect');
  static const saverPopup = Key('popup.saver');
  static const saverWatchAd = Key('popup.saver.ad');
  static const saverCoins = Key('popup.saver.coins');
  static const saverDecline = Key('popup.saver.decline');
  // Golden Slither Rush
  static const rushIntroDialog = Key('rush.intro');
  static const rushIntroStart = Key('rush.intro.start');
  static const rushIntroSkip = Key('rush.intro.skip');
  static const rushScreen = Key('rush.screen');
  static const rushTimer = Key('rush.timer');
  static const rushProgressBar = Key('rush.progress');
  static const rushCoins = Key('rush.coins');
  static const rushCounter = Key('rush.counter');
  static const rushSkipButton = Key('rush.skip');
  static const rushResultsDialog = Key('rush.results');
  static const rushResultsContinue = Key('rush.results.continue');
  static const rushResultsMap = Key('rush.results.map');

  static const phaseCompleteScreen = Key('phase.screen');
  static const gardenHeroBadge = Key('phase.badge');
  static const phaseReplay = Key('phase.replay');
  static const phaseHome = Key('phase.home');
}
