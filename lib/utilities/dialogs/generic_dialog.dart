import 'package:flutter/material.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_game_ending_record_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder optionsBuilder,
}) {
  final options = optionsBuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontSize: 30.sp),
        ),
        content: Text(content),
        actions: [
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 12.w,
            runSpacing: 8.h,
            children: options.entries.map((entry) {
              return TextButton(
                onPressed: () => Navigator.of(context).pop(entry.value),
                child: Text(
                  entry.key,
                  style: TextStyle(fontSize: 20.sp),
                ),
              );
            }).toList(),
          ),
        ],
      );
    },
  );
}
