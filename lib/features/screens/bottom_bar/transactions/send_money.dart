import 'dart:async';
import 'package:bank/features/data/model/card_model.dart';
import 'package:bank/features/data/model/user_model.dart';
import 'package:bank/features/screens/bottom_bar/transactions/payment_confirmation.dart';
import 'package:bank/features/widgets/input_card_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/firebase_services/firestore_service.dart';
import '../../../data/model/transaction_model.dart';
import '../../../utils/generated/extensions.dart';
import '../../../utils/generated/get_card_assets.dart';
import '../../../utils/size_config.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/my_app_bar.dart';
import '../home/cards/cards_page.dart';

class SendMoney extends StatefulWidget {
  const SendMoney({super.key});

  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  late TextEditingController cardSearchController;
  late TextEditingController priceMoneyController;
  final _stopController = StreamController<bool>.broadcast();
  final firebaseService = FirebaseService();
  UserModel? _receiverName;
  bool _hasSearched = false;
  bool isLoading = false;
  User? user;
  List<CardModel> userCards = [];
  CardModel? receiverCard;
  int selectedCard = 0;

  @override
  void initState() {
    super.initState();
    cardSearchController = TextEditingController();
    priceMoneyController = TextEditingController();
    cardSearchController.addListener(() {
      if (cardSearchController.text.length < 19) {
        setState(() {
          _hasSearched = false;
          _receiverName = null;
        });
      }
    });
    _stopController.stream.listen((stop) {
      if (stop && !_hasSearched) {
        _hasSearched = true;
        _searchUserName();
      }
    });
    getCardsAll();
  }

  Future<void> getCardsAll() async {
    user = FirebaseAuth.instance.currentUser;
    userCards = await firebaseService.getCards(user!.uid);
    setState(() {});
  }

  void _searchUserName() async {
    setState(() {
      isLoading = true;
      _receiverName = null;
    });
    _receiverName = await firebaseService.getUserByCardNumber(
      cardSearchController.text,
    );
    receiverCard = await firebaseService.getCardByCardNumber(
      cardSearchController.text,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _stopController.close();
    cardSearchController.dispose();
    priceMoneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: AppColor().white,
      appBar: myAppBar(
        title: 'Send Money',
        implyLeading: true,
        context: context,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CardNumberInput(
                  controller: cardSearchController,
                  stopStream: _stopController.stream,
                  onInputComplete: () {
                    _stopController.add(true);
                  },
                ),
                SizedBox(height: 12),
                if (isLoading)
                  Text("Loading...", style: TextStyle(color: Colors.grey))
                else if (_receiverName == null && _hasSearched)
                  Text("User not found", style: TextStyle(color: Colors.red))
                else if (_receiverName != null)
                  Text(
                    _receiverName!.userName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )
                else
                  SizedBox(),
                SizedBox(height: 20),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: AppColor().greyWhiteColor,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Yuboruvchi kartani tanlang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor().black,
                        ),
                      ),
                      Divider(
                        indent: 2,
                        height: 1,
                        color: AppColor().greyWhiteColor,
                      ),
                      SizedBox(height: 5),
                      userCards.isEmpty
                          ? Center(child: CircularProgressIndicator())
                          : InkWell(
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CardsPage(),
                                ),
                              );
                              setState(() {
                                selectedCard = result;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: AppColor().white,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Image.asset(
                                        getCardAsset(
                                          userCards[selectedCard].cardType,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${userCards[selectedCard].balance.toString()}  UZS',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor().black,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        userCards[selectedCard].cardNumber,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColor().black,
                                        ),
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
                SizedBox(height: 20),
                TextFormField(
                  controller: priceMoneyController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16, color: AppColor().black),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: '10000',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: AppColor().white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor().black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor().black, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColor().black, width: 1),
                    ),
                  ),
                ),
                SizedBox(height: 300),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: sendButton(
        context,
        _receiverName,
        receiverCard,
        priceMoneyController,
        selectedCard,
        firebaseService,
        user,
        userCards,
      ),
    );
  }
}

Widget sendButton(
  context,
  UserModel? _receiverName,
  CardModel? receiverCard,
  TextEditingController priceMoneyController,
  int selectedCard,
  FirebaseService firebaseService,
  User? user,
  List<CardModel> userCards,
) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      color: AppColor().white,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: elevatedButton(
        color: AppColor().greenColor,
        context: context,
        callback: () async {
          if (_receiverName == null || receiverCard == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Xatolik yuz berdi")));
            return;
          }

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
          );

          try {
            await firebaseService.sendTransaction(
              senderUserId: user!.uid,
              receiverUserId: _receiverName.uid,
              senderCard: userCards[selectedCard],
              receiverCard: receiverCard,
              amount: int.parse(priceMoneyController.text),
            );

            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder:
                    (context) => PaymentConfirmation(
                      transaction: TransactionModel(
                        id: '',
                        senderUserId: user.displayName.toString(),
                        receiverUserId: _receiverName.userName,
                        senderCardId: userCards[selectedCard].id,
                        receiverCardId: receiverCard.id,
                        amount: int.parse(priceMoneyController.text),
                        timestamp: DateTime.now(),
                        status: 'sent',
                      ),
                    ),
              ),
            );
          } catch (e) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Xatolik: ${e.toString()}")));
          }
        },
        text: 'Send Money',
      ),
    ),
  );
}
