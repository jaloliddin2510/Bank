import 'package:auto_size_text/auto_size_text.dart';
import 'package:bank/features/screens/bottom_bar/profile/security/security_page.dart';
import 'package:bank/features/utils/generated/extensions.dart';
import 'package:bank/features/utils/size_media.dart';

import 'package:bank/features/widgets/custom_profile_configuration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/generated/assets.dart';
import '../../../widgets/custom_list_tile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user;
  bool imageType = false;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() async {
    user = FirebaseAuth.instance.currentUser;
    if (user?.photoURL != null) {
      imageType = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: getScreenHeight(context, resize: 0.05)),
            Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 50),
                    Container(
                      width: getScreenWith(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColor().greyWhiteColor,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 60),
                          SizedBox(
                            width: getScreenWith(context, resize: 0.6),
                            height: 60,
                            child: AutoSizeText(
                              user?.displayName ?? "User Name",
                              style: TextStyle(
                                color: AppColor().primaryColor,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              maxFontSize: 25,
                              minFontSize: 14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 25,
                                color: AppColor().purple,
                              ),
                              SizedBox(width: 12),
                              Text(
                                user?.email ?? "examlple@gmail.com",
                                style: TextStyle(
                                  color: AppColor().black,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          imageType
                              ? NetworkImage(user!.photoURL!)
                              : AssetImage(Assets.dash),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 35),
            ProfileConfig(
              asset: Assets.security,
              title: 'Security',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SecurityPage()));
              },
            ),

            CustomListTile(
              icon: Icons.email,
              color: const Color(0xFFe17a0a),
              title: 'Contact us',
              context: context,
            ),
            // CustomListTile(
            //   icon: Image.asset(Assets.guide),
            //   color: const Color(0xFF064c6d),
            //   title: 'Support',
            //   context: context,
            // ),
            CustomListTile(
              icon: Icons.dark_mode,
              color: const Color(0xFF0536e8),
              title: 'Dark Mode',
              isDarkMode: true,
              context: context,
            ),
          ],
        ),
      ),
    );
  }
}
