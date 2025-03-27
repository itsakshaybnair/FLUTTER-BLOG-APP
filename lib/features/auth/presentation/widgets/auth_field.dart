// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hinText;
  final TextEditingController textEditingController;
  final bool isObsecureText;
  const AuthField({
    super.key,
    required this.hinText,
    required this.textEditingController,
    this.isObsecureText=false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hinText is missing';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hinText,
        
      ),
      obscureText: isObsecureText,
    );
  }
}
