import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../utils/generated/assets.dart';
import '../utils/generated/card_type.dart';
import '../utils/generated/extensions.dart';

class CardItem extends StatelessWidget {
  final String cardNumber;
  final String cardCVV;
  final double cardBalance;
  final String cardType;
  final VoidCallback? onTap;
  final String expiryDate;

  const CardItem({
    super.key,
    required this.cardNumber,
    required this.cardCVV,
    required this.cardBalance,
    required this.cardType,
    required this.onTap,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    String cardIcon = Assets.cardsVisa;
    if (cardType == CardTypes.VISA) {
      cardIcon = Assets.cardsVisa;
    } else if (cardType == CardTypes.MASTER_CARD) {
      cardIcon = Assets.cardsMastercard;
    } else if (cardType == CardTypes.HUMO) {
      cardIcon = Assets.cardsHumo;
    } else if (cardType == CardTypes.UZ_CARD) {
      cardIcon = Assets.cardsUzcard;
    }
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 190,
        width: 310,
        child: Stack(
          children: [
            Image.asset('assets/cards/card_item.png',width: 310,),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8,
              ),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 300),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(width: 207),
                        SizedBox(
                          height: 42,
                          width: 62,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Image.asset(cardIcon, fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 34),
                    Row(
                      children: [
                        AutoSizeText(
                          '${formatBalance(cardBalance)} UZS',
                          maxLines: 1,
                          minFontSize: 12,
                          maxFontSize: 22,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: AppColor().white,
                          ),
                        ),
                        SizedBox(width: 50),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CARD NUMBER',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColor().white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'MM/YY',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor().white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              expiryDate,
                              style: TextStyle(
                                color: AppColor().white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          castCardNumber(cardNumber),
                          style: TextStyle(
                            color: AppColor().white,
                            fontSize: 16,
                          ),
                        ),

                        Row(
                          children: [
                            Text(
                              'CVV',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor().white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              cardCVV,
                              style: TextStyle(
                                color: AppColor().white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatBalance(double balance) {
  if (balance >= 1e9) return '${(balance / 1e9).toStringAsFixed(1)} Mlrd';
  return balance.toStringAsFixed(2);
}

String castCardNumber(String cardNumber) {
  if (cardNumber.length < 19) {
    return '**** **** **** Total';
  } else {
    final lastNumber = cardNumber.substring(cardNumber.length - 4);
    return '**** **** **** $lastNumber';
  }
}
