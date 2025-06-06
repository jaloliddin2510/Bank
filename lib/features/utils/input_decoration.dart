import 'package:bank/features/utils/generated/extensions.dart';
import 'package:bank/features/utils/styles.dart';
import 'package:flutter/material.dart';


inputDecoration({String? text, IconData? prefixIcon, Widget? suffixIcon, required BuildContext context}) {
  return InputDecoration(
      hintText: text,
      hintStyle: TextStyle(color: AppColor().grey),
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, color: Styles.primaryColor,),
      suffixIcon: suffixIcon,
      contentPadding: prefixIcon == null ? const EdgeInsets.only(top: 15, left: 15) : const EdgeInsets.only(top: 0),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor().grey, width: 1.6), borderRadius: BorderRadius.circular(10)),
      border: OutlineInputBorder(borderSide: BorderSide(color: AppColor().grey, width: 1.6), borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColor().grey, width: 1.6), borderRadius: BorderRadius.circular(10)),
  );
}