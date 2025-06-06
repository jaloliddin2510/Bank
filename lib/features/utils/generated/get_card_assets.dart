import 'assets.dart';

String getCardAsset(String cardType) {
  switch (cardType) {
    case 'Visa':
      return Assets.cardsVisa;
    case 'Mastercard':
      return Assets.cardsMastercard;
    case 'Uzcard':
      return Assets.cardsUzcard;
    case 'Humo':
      return Assets.cardsHumo;
    default:
      return Assets.cardsVisa; // fallback asset
  }
}
