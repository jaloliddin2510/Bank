import 'package:auto_size_text/auto_size_text.dart';
import 'package:bank/features/screens/add_card/add_card.dart';
import 'package:bank/features/utils/size_media.dart';
import 'package:bank/features/widgets/build_card_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import '../../../data/json/transactions.dart';
import '../../../utils/generated/assets.dart';
import '../../../utils/generated/extensions.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final user1 = FirebaseAuth.instance.currentUser;
    setState(() {
      user = user1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Material(
      color: AppColor().white,
      elevation: 0,
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.46,
            width: double.maxFinite,
            color: AppColor().primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 50),
                appBar(user, context),
                const SizedBox(height: 25),
                buildCardList(context, user!.uid),
                const SizedBox(height: 15),
                walletContainer(context),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transactions',
                      style: TextStyle(
                        color: AppColor().primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Today',
                          style: TextStyle(
                            color: AppColor().primaryColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: AppColor().primaryColor,
                          size: 17,
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(child: transactionsWidget(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

appBar(User? user, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: getScreenWith(context, resize: 0.6),
            child: ReadMoreText(
              user!.displayName ?? 'User name',
              style: TextStyle(color: Colors.white, fontSize: 16),
              trimLines: 1,
              trimMode: TrimMode.Line,
              trimCollapsedText: ' more',
              trimExpandedText: ' short',
            ),
          ),
          SizedBox(height: 3),
          const Text(
            'Welcome back',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      InkWell(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Image.asset(
            Assets.notification,
            color: AppColor().accentColor,
            height: 20,
            width: 20,
          ),
        ),
      ),
    ],
  );
}

walletContainer(context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddCard()),
      );
    },
    child: Container(
      height: getScreenHeight(context, resize: 0.1),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor().greyWhiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text("data")],
      ),
    ),
  );
}

transactionsWidget(context) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
    itemCount: transactions.length,
    itemBuilder: (c, i) {
      final trs = transactions[i];
      return ListTile(
        isThreeLine: true,
        minLeadingWidth: 10,
        minVerticalPadding: 20,
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColor().accentColor,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                color: Colors.white.withOpacity(0.1),
                blurRadius: 2,
                spreadRadius: 1,
              ),
            ],
            image:
                i == 0
                    ? null
                    : DecorationImage(
                      image: AssetImage(trs['avatar']),
                      fit: BoxFit.cover,
                    ),
            shape: BoxShape.circle,
          ),
          child:
              i == 0
                  ? Icon(trs['icon'], color: const Color(0xFFFF736C), size: 20)
                  : const SizedBox(),
        ),
        title: Text(
          trs['name'],
          style: TextStyle(
            color: AppColor().primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          trs['date'],
          style: TextStyle(color: AppColor().primaryColor),
        ),
        trailing: Text(
          trs['amount'],
          style: const TextStyle(fontSize: 17, color: Colors.white),
        ),
      );
    },
  );
}
