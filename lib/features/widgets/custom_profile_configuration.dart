import 'package:bank/features/utils/generated/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileConfig extends StatelessWidget {
  final String asset;
  final String title;
  final Function() onTap;
  const ProfileConfig({super.key,required this.asset, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Image.asset(asset,height: 40,width: 40,),
        SizedBox(width: 20),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              color: AppColor().black,
            ),
          ),
        ),
        IconButton(
          onPressed: (){
            onTap;
          },
          icon: Icon(Icons.navigate_next,size: 25),
          color: AppColor().black,
        ),
      ],
    );
  }
}
