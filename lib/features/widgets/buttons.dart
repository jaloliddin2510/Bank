import 'package:bank/features/utils/generated/extensions.dart';
import 'package:flutter/material.dart';
import '../utils/size_config.dart';
import '../utils/styles.dart';

Widget elevatedButton({
  required BuildContext context,
  required VoidCallback callback,
  required String text,
  Color? color,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Styles.primaryColor, // ⬅️ oldingi 'primary' o‘rniga
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 15),

      ),
      child: Text(text,style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: AppColor().white
      ),),
    ),
  );
}

Widget outlinedButton({
  required BuildContext context,
  required VoidCallback callback,
  required Widget child,
  String? color,
}) {
  return OutlinedButton(
    onPressed: callback,
    child: child,
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Styles.primaryColor, // ⬅️ oldingi 'primary' o‘rniga
      elevation: 0,
      side: BorderSide(color: Colors.grey.shade400, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(getProportionateScreenWidth(10)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),
    ),
  );
}
