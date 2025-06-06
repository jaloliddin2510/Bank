import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/data/model/card_model.dart';
import '../../features/data/model/transaction_model.dart';
import '../../features/data/model/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Save user
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  // 🔹 Get user
  Future<UserModel?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.id, doc.data()!);
    }
    return null;
  }

  // 🔹 Get user by card number
  Future<UserModel?> getUserByCardNumber(String cardNumber) async {
    final cardSnapshot =
        await _firestore
            .collectionGroup('cards')
            .where('cardNumber', isEqualTo: cardNumber)
            .limit(1)
            .get();
    if (cardSnapshot.docs.isEmpty) return null;

    final userId = cardSnapshot.docs.first.reference.parent.parent!.id;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (!userDoc.exists) return null;
    return UserModel.fromJson(userDoc.id, userDoc.data()!);
  }
  Future<CardModel?> getCardByCardNumber(String cardNumber) async {
    final cardSnapshot =
    await _firestore
        .collectionGroup('cards')
        .where('cardNumber', isEqualTo: cardNumber)
        .limit(1)
        .get();
    if (cardSnapshot.docs.isEmpty) return null;
    final cardDoc = cardSnapshot.docs.first;
    return CardModel.fromJson(cardDoc.id, cardDoc.data());
  }

  // 🔹 Listen to user realtime changes
  Stream<UserModel?> listenToUser(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromJson(doc.id, doc.data()!);
      }
      return null;
    });
  }

  // 🔹 Update user
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // 🔹 Add new card for user
  Future<void> addCard(String uid, CardModel card) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(card.id)
        .set(card.toJson());
  }

  // 🔹 Get all cards of user realtime
  Stream<List<CardModel>> listenToCards(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('cards')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => CardModel.fromJson(doc.id, doc.data()))
                  .toList(),
        );
  }

  // 🔹 Get all cards of user
  Future<List<CardModel>> getCards(String uid) async {
    final cardsSnapshot =
        await _firestore.collection('users').doc(uid).collection('cards').get();
    return cardsSnapshot.docs
        .map((doc) => CardModel.fromJson(doc.id, doc.data()))
        .toList();
  }

  // 🔹 Delete a card
  Future<void> deleteCard(String uid, String cardId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('cards')
        .doc(cardId)
        .delete();
  }
  // 🔹 Listen to transactions for a user
  Stream<List<TransactionModel>> listenToTransactions(String uid) {
    return _firestore
        .collection('transactions')
        .where('from', isEqualTo: uid)
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromJson(doc.id, doc.data()))
                  .toList(),
        );
  }

  // 🔹 Listen to all user transactions
  Stream<List<TransactionModel>> listenAllUserTransactions(String uid) {
    return _firestore
        .collection('transactions')
        .where('participants', arrayContains: uid)
        .orderBy('time', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromJson(doc.id, doc.data()))
                  .toList(),
        );
  }

  // Pul o'tkazish: transaction ichida balanslarni yangilash va transaction yozish

  Future<void> sendTransaction({
    required String senderUserId,
    required String receiverUserId,
    required CardModel senderCard,
    required CardModel receiverCard,
    required int amount,
  }) async {
    final txRefSender =
        FirebaseFirestore.instance
            .collection('transactions')
            .doc(senderUserId)
            .collection('transactions')
            .doc();

    final txRefReceiver =
        FirebaseFirestore.instance
            .collection('transactions')
            .doc(receiverUserId)
            .collection('transactions')
            .doc();

    final senderCardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(senderUserId)
        .collection('cards')
        .doc(senderCard.id);

    final receiverCardRef = FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUserId)
        .collection('cards')
        .doc(receiverCard.id);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final senderSnap = await transaction.get(senderCardRef);
      final receiverSnap = await transaction.get(receiverCardRef);

      final senderBalance = senderSnap.get('balance');
      final receiverBalance = receiverSnap.get('balance');

      if (senderBalance < amount) {
        throw Exception("Yetarli mablag' mavjud emas");
      }

      transaction.update(senderCardRef, {'balance': senderBalance - amount});
      transaction.update(receiverCardRef, {
        'balance': receiverBalance + amount,
      });

      final now = DateTime.now();

      final senderTx = TransactionModel(
        id: txRefSender.id,
        senderUserId: senderUserId,
        receiverUserId: receiverUserId,
        senderCardId: senderCard.id,
        receiverCardId: receiverCard.id,
        amount: amount,
        timestamp: now,
        status: 'sent',
      );

      final receiverTx = TransactionModel(
        id: txRefReceiver.id,
        senderUserId: senderUserId,
        receiverUserId: receiverUserId,
        senderCardId: senderCard.id,
        receiverCardId: receiverCard.id,
        amount: amount,
        timestamp: now,
        status: 'received',
      );

      transaction.set(txRefSender, senderTx.toJson());
      transaction.set(txRefReceiver, receiverTx.toJson());
    });
  }
}
