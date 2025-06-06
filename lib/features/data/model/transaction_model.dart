import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;   //Tranzaksiya ID (Firestore hujjat ID)
  final String senderUserId;  // Yuboruvchi foydalanuvchi ID
  final String receiverUserId; // Qabul qiluvchi foydalanuvchi ID
  final String senderCardId;  //Yuborilgan karta IDsi
  final String receiverCardId; //Qabul qilinuvchi karta IDsi
  final int amount; //Pul miqdori
  final DateTime timestamp; //Tranzaksiya sanasi
  final String status; // 'sent' or 'received'

  TransactionModel({
    required this.id,
    required this.senderUserId,
    required this.receiverUserId,
    required this.senderCardId,
    required this.receiverCardId,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'senderUserId': senderUserId,
    'receiverUserId': receiverUserId,
    'senderCardId': senderCardId,
    'receiverCardId': receiverCardId,
    'amount': amount,
    'timestamp': Timestamp.fromDate(timestamp),
    'status': status,
  };

  factory TransactionModel.fromJson(String id, Map<String, dynamic> json) {
    return TransactionModel(
      id: id,
      senderUserId: json['senderUserId'],
      receiverUserId: json['receiverUserId'],
      senderCardId: json['senderCardId'],
      receiverCardId: json['receiverCardId'],
      amount: json['amount'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      status: json['status'],
    );
  }
}
