class AccountModel {
  final String uid;
  final double balance;

  AccountModel({required this.uid, required this.balance});

  Map<String, dynamic> toJson() => {'uid': uid, 'balance': balance};

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(uid: json["uid"], balance: json["balance"]);
  }
}
