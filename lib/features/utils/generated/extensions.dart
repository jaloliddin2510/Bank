import 'dart:ui';

class AppColor{
  // 1. static private instance
  static final AppColor _instance = AppColor._();

  // 2. private constructor
  AppColor._();

  // 3. factory constructor
  factory AppColor() => _instance;

  final Color primaryColor = Color(0xFF161D28);
  final Color accentColor = Color(0xFF030C10);
  final Color primaryWithOpacityColor = Color(0xFF212E3E);
  final Color yellowColor = Color(0xFFDFE94B);
  final Color greenColor = Color(0xFF024751);
  final Color greyWhiteColor = Color(0xFFE6E8E8);
  final Color buttonColor = Color(0xFF4C66EE);
  final Color blueColor = Color(0xFF4BACF7);
  final Color brightBlue=Color(0xFF0166FF);
  final Color black=Color(0xFF000000);
  final Color white=Color(0xFFFFFFFF);
  final Color grey=Color(0xFF808080);
  final Color red =Color(0xFFFF0000);
  final Color defaultCard =Color(0x802A3447);
  final Color purple =Color(0xFFD400FF);
  final Color green =Color(0xFF43B600);

}