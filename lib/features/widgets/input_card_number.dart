import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/generated/assets.dart';
import '../utils/generated/extensions.dart';

class CardNumberInput extends StatefulWidget {
  final TextEditingController controller;
  final Stream<bool> stopStream;
  final VoidCallback? onInputComplete;
  final Color borderColor;
  final Color backgroundColor;

  CardNumberInput({
    super.key,
    required this.controller,
    required this.stopStream,
    this.onInputComplete,
    Color? borderColor,
    Color? backgroundColor,
  })  : borderColor = borderColor ?? AppColor().black,
        backgroundColor = backgroundColor ?? AppColor().white;

  @override
  State<CardNumberInput> createState() => _CardNumberInputState();
}

class _CardNumberInputState extends State<CardNumberInput> {
  bool isSearching = false;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      if (widget.controller.text.length == 19 && !isSearching) {
        isSearching = true;
        widget.onInputComplete?.call();
      }
    });

    widget.stopStream.listen((stop) {
      if (stop) {
        setState(() {
          isSearching = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 16, color: AppColor().black),
            maxLength: 19,
            decoration: InputDecoration(
              hintText: '0000 0000 0000 0000',
              counterText: '',
              hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: widget.backgroundColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 0,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.borderColor, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.borderColor, width: 1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: widget.borderColor, width: 1),
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(19),
              CardNumberFormatter(),
            ],
          ),
        ),
        SizedBox(width: 12),
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColor().greyWhiteColor,
          child: Image.asset(Assets.scanner, color: AppColor().primaryColor,height: 25,width: 25,),
        ),
      ],
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digitsOnly = newValue.text.replaceAll(' ', '');
    final newText = StringBuffer();

    for (int i = 0; i < digitsOnly.length; i++) {
      newText.write(digitsOnly[i]);
      if ((i + 1) % 4 == 0 && i != digitsOnly.length - 1) {
        newText.write(' ');
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
