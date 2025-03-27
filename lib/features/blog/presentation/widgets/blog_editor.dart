// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: null,
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return '$hintText is missing';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}
