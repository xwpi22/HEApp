import 'package:flutter/material.dart';
import 'package:heapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showRangeCheckingDialog(BuildContext context,
    {required int startingnum, required int endingnum}) {
  if (startingnum >= endingnum) {
    return showGenericDialog<bool>(
      context: context,
      title: '數字範圍選取錯誤',
      content: '起始數字必須小於結束數字',
      optionsBuilder: () => {
        '我瞭解了': false,
      },
    ).then(
      (value) => value ?? false,
    );
  }
  return showGenericDialog<bool>(
    context: context,
    title: '範圍',
    content: '起始數字：$startingnum\n結束數字：$endingnum',
    optionsBuilder: () => {
      '重選數字': false,
      '好的，開始遊戲': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
