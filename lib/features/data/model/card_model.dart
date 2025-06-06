import 'package:cloud_firestore/cloud_firestore.dart';

class CardModel {
  final String id;           // Kartaning unikal identifikatori (Firestore document ID)
  final String userId;       // Kartani qo‘shgan foydalanuvchi uidsi
  final String cardNumber;   // Kartaning raqami (shifrlash tavsiya qilinadi)
  final String expiryDate;   // Kartaning amal qilish muddati (masalan: "12/25")
  final String cardType;     // Kartaning turi (Visa, Mastercard, Humo, Uzcard)
  final String? cvv;         // CVV kodi (Visa va Mastercard uchun majburiy, Humo/Uzcard uchun bo‘lishi shart emas)
  final DateTime createdAt;  // Kartaning tizimga qo‘shilgan sana va vaqti
  final double balance;      // Kartaning balansini saqlash uchun (agar kerak bo‘lsa)

  CardModel({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardType,
    this.cvv,
    DateTime? createdAt,
    this.balance=0,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'cardNumber': cardNumber,
    'expiryDate': expiryDate,
    'cardType': cardType,
    if (cvv != null) 'cvv': cvv,
    'createdAt': Timestamp.fromDate(createdAt),
    'balance': balance,
  };

  factory CardModel.fromJson(String id, Map<String, dynamic> json) {
    return CardModel(
      id: id,
      userId: json['userId'] ?? '',
      cardNumber: json['cardNumber'] ?? '',
      expiryDate: json['expiryDate'] ?? '',
      cardType: json['cardType'] ?? '',
      cvv: json['cvv'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      balance: (json['balance'] ?? 0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'CardModel(cardNumber: $cardNumber, balance: $balance, userId: $userId, cardType: $cardType)';
  }

}
