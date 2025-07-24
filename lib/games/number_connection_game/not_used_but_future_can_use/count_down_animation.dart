import 'package:flutter/material.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_game_ending_record_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountDownAnimation extends StatefulWidget {
  const CountDownAnimation({
    super.key,
  });

  @override
  State<CountDownAnimation> createState() => _CountDownAnimationState();
}

class _CountDownAnimationState extends State<CountDownAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  String get timerString {
    Duration duration = _controller.duration! * _controller.value;
    return '${(duration.inSeconds % 60)}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                timerString,
                style: TextStyle(fontSize: 112.0.sp, color: Colors.brown),
              ),
            ],
          );
        });
  }
}
