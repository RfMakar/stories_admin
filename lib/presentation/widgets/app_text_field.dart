import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.name,
    required this.hintText,
    this.initialValue,
    this.maxLines,
    this.onChanged,
  });

  final String name;
  final String hintText;
  final String? initialValue;
  final int? maxLines;
  final void Function(String)? onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _wordCount = countWords(_controller.text);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _wordCount = countWords(_controller.text);
    });
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  int countWords(String text) {
    if (text.trim().isEmpty) return 0;

    // Удаляем пунктуацию (всё кроме букв, цифр, пробелов и подчеркиваний)
    final cleanedText = text.replaceAll(RegExp(r'[^\w\sа-яА-ЯёЁ]'), '');

    // Разбиваем по пробелам
    final words = cleanedText.trim().split(RegExp(r'\s+'));

    return words.length;
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.name),
              Text('Слов: $_wordCount'),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _controller,
            maxLines: widget.maxLines,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: widget.hintText,
            ),
          ),
        ],
      ),
    );
  }
}
