import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String userName;
  final String email;
  final int balance;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    this.balance = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'fullName': userName,
    'email': email,
    'balance': balance,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory UserModel.fromJson(String uid, Map<String, dynamic> json) {
    return UserModel(
      uid: uid,
      userName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      balance: json['balance'] ?? 0,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}