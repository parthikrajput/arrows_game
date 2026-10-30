// SHARED CONTRACT. Integration tests find widgets by these keys, so a redesign
// never breaks them. UI must put each key on the matching widget.
import 'package:flutter/widgets.dart';

class AppKeys {
  const AppKeys._();
  // Home
  static const homeScreen = Key('home.screen');
  static const homePlay = Key('home.play');
  static const homeMap = Key('home.map');
  static const homeSettings = Key('home.settings');
  // Map
  static const mapScreen = Key('map.screen');
  static Key mapNode(int level) => Key('map.node.$level');
  // Gameplay
  static const gameplayScreen = Key('game.screen');
  static const pauseButton = Key('game.pause');
  static Key booster(String name) => Key('game.booster.$name'); // hint | shield | hammer
  static const hammerCancel = Key('game.hammer.cancel');
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
  // Shop
  static const shopScreen = Key('shop.screen');
  static Key shopTile(String booster, int qty) => Key('shop.tile.$booster.$qty');
  static const shopFreeCoins = Key('shop.freeCoins');
  // Wheel
  static const wheelScreen = Key('wheel.screen');
  static const wheelSpinFree = Key('wheel.spin.free');
  static const wheelSpinAd = Key('wheel.spin.ad');
}
