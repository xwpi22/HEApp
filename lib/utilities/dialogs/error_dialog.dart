import 'package:flutter/material.dart';
import 'package:heapp/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String title,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
