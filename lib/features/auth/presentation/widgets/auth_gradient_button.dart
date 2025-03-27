// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:flutter_blog_app/core/theme/app_palette.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback ontap;
  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            AppPallete.gradient1,
            AppPallete.gradient2,
          ], begin: Alignment.bottomLeft, end: Alignment.topRight),
          borderRadius: BorderRadius.circular(7)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            fixedSize: const Size(395, 55)),
        onPressed: ontap,
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
