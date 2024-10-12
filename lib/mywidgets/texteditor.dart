import 'package:flutter/material.dart';

class TextEditorWidget extends StatefulWidget {
  String text;
  TextEditorWidget({super.key, required this.text});

  @override
  State<TextEditorWidget> createState() => _TextEditorWidgetState();
}

class _TextEditorWidgetState extends State<TextEditorWidget> {
  bool _isEditingText = false;
  final TextEditingController _editingController = TextEditingController();
  late String initialText;
  @override
  void initState() {
    _editingController.addListener(() {
      final String text = _editingController.text;
      _editingController.value = _editingController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isEditingText
        ? Center(
            child: TextField(
            onSubmitted: (newValue) {
              setState(() {
                initialText = newValue;
                _isEditingText = false;
              });
            },
            autofocus: true,
            controller: _editingController,
          ))
        : InkWell(
            onTap: () {
              setState(() {
                _isEditingText = true;
              });
            },
            child: Text(
              initialText,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ));
  }
}
