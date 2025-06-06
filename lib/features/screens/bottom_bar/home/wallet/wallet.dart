import 'package:bank/features/utils/generated/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/generated/assets.dart';
import '../../../../widgets/my_app_bar.dart';
import '../../../add_card/add_card.dart';


class Wallet extends StatelessWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().white,
      appBar: myAppBar(
        title: 'All Cards',
        implyLeading: false,
        context: context,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            appBarWidget(context),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
appBarWidget(context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const AddCard()),
              ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor().accentColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.add,
                  color: AppColor().primaryColor,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'ADD NEW CARD',
                  style: TextStyle(color: AppColor().primaryColor),
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(width: 8),
      CircleAvatar(
        backgroundColor: AppColor().accentColor,
        radius: 23,
        child: Image.asset(Assets.scanner,color: AppColor().primaryColor,),
      ),
    ],
  );
}
