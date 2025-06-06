import 'package:bank/features/data/model/card_model.dart';
import 'package:bank/features/widgets/card_item.dart';
import 'package:bank/features/widgets/input_card_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../core/firebase_services/firestore_service.dart';
import '../../utils/generated/assets.dart';
import '../../utils/generated/card_type.dart';
import '../../utils/generated/extensions.dart';
import '../../utils/generated/text_formatters.dart';
import '../../utils/size_config.dart';
import '../../widgets/buttons.dart';
import '../../widgets/my_app_bar.dart';

class AddCard extends StatefulWidget {
  const AddCard({Key? key}) : super(key: key);

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  final TextEditingController _cardNumber = TextEditingController();
  final TextEditingController _cardExpiryDate = TextEditingController();
  final TextEditingController _cardCVV = TextEditingController();

  String cardTypes = CardTypes.VISA;
  int selectedCard = 0;

  final List<String> paymentCardsList = [
    Assets.cardsVisa,
    Assets.cardsMastercard,
    Assets.cardsHumo,
    Assets.cardsUzcard,
  ];

  @override
  void initState() {
    super.initState();
    _cardNumber.addListener(() => setState(() {}));
    _cardExpiryDate.addListener(() => setState(() {}));
    _cardCVV.addListener(() => setState(() {}));
  }

  Future<void> _addNewCard() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foydalanuvchi aniqlanmadi ❌')),
      );
      return;
    }

    final cardNumber = _cardNumber.text.trim();
    final expiryDate = _cardExpiryDate.text.trim();
    final cvv = _cardCVV.text.trim();

    if (cardNumber.isEmpty || expiryDate.isEmpty || (selectedCard <= 1 && cvv.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Iltimos, barcha kerakli maydonlarni to‘ldiring")),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    final cardId = DateTime.now().millisecondsSinceEpoch.toString();

    final card = CardModel(
      id: cardId,
      userId: user.uid,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      cardType: cardTypes,
      cvv: selectedCard <= 1 ? cvv : null,
    );

    try {
      await FirebaseService().addCard(user.uid, card);
      Navigator.of(context).pop(); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Karta muvaffaqiyatli qo‘shildi")),
      );
      Navigator.of(context).pop(); // Return to previous screen
    } catch (e) {
      Navigator.of(context).pop(); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik yuz berdi: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor:AppColor().white,
      appBar: myAppBar(title: 'Add Card', implyLeading: true, context: context),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CardItem(
              cardNumber: _cardNumber.text.isEmpty ? "0000 0000 0000 0000" : _cardNumber.text,
              cardCVV: selectedCard <= 1 ? _cardCVV.text : '___',
              cardBalance: 0,
              cardType: cardTypes,
              onTap: () {},
              expiryDate: _cardExpiryDate.text,
            ),
          ),
          SizedBox(height: 20),
          selectType(),
          SizedBox(height: 30),
          CardNumberInput(controller: _cardNumber, stopStream: Stream.value(false)),
          SizedBox(height: 16),
          Row(
            children: [
              Flexible(
                child: TextFormField(
                  controller: _cardExpiryDate,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  inputFormatters: [ExpiryDateFormatter()],
                  decoration: _inputDecoration("MM/YY"),
                ),
              ),
              SizedBox(width: 10),
              selectedCard <= 1
                  ? Flexible(
                child: TextFormField(
                  controller: _cardCVV,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  decoration: _inputDecoration("CVV"),
                ),
              )
                  : SizedBox(),
            ],
          ),
          SizedBox(height: 22),
          elevatedButton(
            color:AppColor().greenColor,
            context: context,
            callback: _addNewCard,
            text: 'Add Card',
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      counterText: '',
      filled: true,
      fillColor: AppColor().white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor().black, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColor().brightBlue, width: 1),
      ),
    );
  }

  Widget selectType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: paymentCardsList.map<Widget>((paymentCard) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedCard = paymentCardsList.indexOf(paymentCard);
              switch (selectedCard) {
                case 0:
                  cardTypes = CardTypes.VISA;
                  break;
                case 1:
                  cardTypes = CardTypes.MASTER_CARD;
                  break;
                case 2:
                  cardTypes = CardTypes.HUMO;
                  break;
                case 3:
                  cardTypes = CardTypes.UZ_CARD;
                  break;
              }
            });
          },
          child: Container(
            width: 75,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: AppColor().accentColor),
              borderRadius: BorderRadius.circular(13),
              color: AppColor().greyWhiteColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(paymentCard),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Icon(
                  selectedCard == paymentCardsList.indexOf(paymentCard)
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: selectedCard == paymentCardsList.indexOf(paymentCard)
                      ? AppColor().greenColor
                      : Colors.grey,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
