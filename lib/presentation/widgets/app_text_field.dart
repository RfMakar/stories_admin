import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {super.key, required this.name, required this.hintText, this.onChanged});
  final String name;
  final String hintText;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
