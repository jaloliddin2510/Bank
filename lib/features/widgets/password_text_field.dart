import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/generated/extensions.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? errorText;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.errorText,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.errorText != null;
    final Color activeColor =
        hasError
            ? AppColor().red
            : _isFocused
            ? AppColor().brightBlue
            : AppColor().grey;

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      style: TextStyle(color: AppColor().black),
      cursorColor: AppColor().brightBlue,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: activeColor),
        floatingLabelStyle: TextStyle(color: AppColor().brightBlue),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: activeColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: activeColor),
        ),
        errorText: widget.errorText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColor().black,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
