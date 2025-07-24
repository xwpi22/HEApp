import 'package:flutter/material.dart';
import 'package:heapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: '登出',
    content: '確定要登出嗎？',
    optionsBuilder: () => {
      '取消': false,
      '確定登出': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
