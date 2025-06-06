// // Hisobni real-time o‘qish
// StreamBuilder<AccountModel?>(
// stream: _firebaseService.listenToAccount(user.uid),
// builder: (context, snapshot) {
// if (snapshot.hasData) {
// return Text('Balans: \$${snapshot.data!.balance}');
// }
// return CircularProgressIndicator();
// },
// );

/// Firebase realtime database bilan ishlash UserMalumotlarini real time o'qib turish