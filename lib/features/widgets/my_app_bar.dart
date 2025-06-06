import 'package:bank/features/utils/generated/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar myAppBar({
  required String title,
  String? stringColor,
  required bool implyLeading,
  required BuildContext context,
  bool? hasAction,
}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(color: AppColor().primaryColor, fontSize: 18),
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading:
        implyLeading == true
            ? Transform.scale(
              scale: 0.7,
              child: IconButton(
                icon: Icon(
                  Icons.keyboard_backspace_rounded,
                  size: 33,
                  color: AppColor().primaryColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            )
            : const SizedBox(),
    actions:
        hasAction == true
            ? const [Icon(Icons.search), SizedBox(height: 15)]
            : null,
  );
}
