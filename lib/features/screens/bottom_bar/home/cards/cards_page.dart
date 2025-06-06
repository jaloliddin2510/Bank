import 'package:bank/features/widgets/card_item.dart';
import 'package:bank/features/widgets/my_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/firebase_services/firestore_service.dart';
import '../../../../data/model/card_model.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  User? user;
  List<CardModel> userCards = [];

  @override
  void initState() {
    super.initState();
    getCards();
  }

  getCards() async {
    user = FirebaseAuth.instance.currentUser;
    final firebaseService = FirebaseService();
    userCards = await firebaseService.getCards(user!.uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Cards', implyLeading: true, context: context),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: userCards.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: userCards.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  CardItem(
                    cardNumber: userCards[index].cardNumber,
                    cardCVV: userCards[index].cvv ?? "---",
                    cardBalance: userCards[index].balance,
                    cardType: userCards[index].cardType,
                    onTap: () {
                      Navigator.pop(context, index);
                    },
                    expiryDate: userCards[index].expiryDate,
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          ),
        )
    );
  }
}
