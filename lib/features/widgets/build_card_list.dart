import 'package:flutter/material.dart';
import '../../core/firebase_services/firestore_service.dart';
import '../../features/data/model/card_model.dart';
import '../screens/bottom_bar/home/cards/cards_page.dart';
import '../utils/generated/card_type.dart';
import '../utils/generated/get_card_assets.dart';
import '../widgets/card_item.dart';

Widget buildCardList(BuildContext context, String userId) {
  final firebaseService = FirebaseService();

  return StreamBuilder<List<CardModel>>(
    stream: firebaseService.listenToCards(userId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data == null) {
        return const Center(child: Text("Karta topilmadi"));
      }

      final userCards = snapshot.data!;

      final double totalBalance = userCards.fold(
        0.0,
        (sum, card) => sum + (card.balance),
      );
      final List<Widget> cards = [

        CardItem(
          cardNumber: "Umumiy Balans",
          cardCVV: "***",
          cardBalance: totalBalance,
          cardType: CardTypes.VISA,

          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CardsPage()),
            );
          },
         expiryDate: '** / **',
        ),
        ...userCards.map(
          (card) => CardItem(
            cardNumber: card.cardNumber,
            cardBalance: card.balance,
            cardType: getCardAsset(card.cardType),
            cardCVV: card.cvv ?? '---',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardsPage()),
              );
            },
            expiryDate: card.expiryDate,
          ),
        ),
      ];
      return SizedBox(
        height: 190,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: cards.length,
          itemBuilder: (_, i) => cards[i],
          separatorBuilder: (_, __) => const SizedBox(width: 12),
        ),
      );
    },
  );
}
