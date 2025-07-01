import 'package:flutter/material.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_game_ending_record_view.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_game_ending_view.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:heapp/utilities/dialogs/error_dialog.dart';

class WrapperButton extends StatefulWidget {
  const WrapperButton({
    super.key,
    required this.labelnum,
    required this.endnum,
    required this.postiions,
  });
  final int labelnum;
  final int endnum;
  final List<Offset> postiions;
  @override
  State<WrapperButton> createState() => _WrapperButtonState();
}

class _WrapperButtonState extends State<WrapperButton> {
  bool _pressedFlag = false;

  @override
  void initState() {
    super.initState();
  }

  void _changeButtonStateandCheckEnding(int nowValue, int endValue) {
    if (globGamingNumber == (nowValue - 1)) {
      setState(() {
        _pressedFlag = true;
        globGamingNumber = nowValue;
      });
      if (nowValue == endValue) {
        // game over
        Navigator.of(context)
            .pushNamedAndRemoveUntil(ncgameoverRoute, (_) => false);
      }
    } else {
      setState(() {
        _pressedFlag = _pressedFlag;
      });
      globWrongPressedCount++;
      // Don't need to let patient know they push wrong button
      // if (nowValue > 0) {
      //   showErrorDialog(context, '阿喔錯了', '請按照按鈕上的數字順序點選按鈕喔');
      // } else {
      //   showErrorDialog(context, '阿喔錯了', '不要被字母干擾了，請按照順序點選數字');
      // }
      // throw WrongOrderException();
    }
  }

  @override
  Widget build(BuildContext context) {
    // bool makeBig = Random().nextBool();
    // Offset position = widget.postiions[widget.labelnum - 1];
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          // alignment: const Alignment(0.0, 0.0),
          shape: const CircleBorder(),
          padding: EdgeInsets.all(10.0.w),
          backgroundColor: _pressedFlag ? Colors.red : Color(0xFF2E609C),
          foregroundColor: Colors.white,
          shadowColor: const Color.fromARGB(247, 186, 184, 184),
          textStyle: TextStyle(
            fontSize: 30.sp,
            color: Colors.white,
            // wordSpacing: -1,
            fontWeight: FontWeight.bold,
          ),
          side: _pressedFlag
              ? const BorderSide(
                  color: Colors.red,
                )
              : const BorderSide(
                  color: Colors.white,
                ),

          maximumSize: Size(100.w, 100.h),
        ),
        onPressed: () {},
        onLongPress: () {
          _changeButtonStateandCheckEnding(
            widget.labelnum,
            widget.endnum,
          );
        },
        child: widget.labelnum > 0
            ? Text(
                widget.labelnum.toString(),
              )
            : Text(String.fromCharCode(65 - widget.labelnum)));
  }
}
