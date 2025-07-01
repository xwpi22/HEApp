import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_game_ending_record_view.dart';
import 'package:heapp/games/number_connection_game/number_connection_game_exceptions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIStopWatch extends StatefulWidget {
  const UIStopWatch({
    super.key,
    required this.start,
  });
  final bool start;
  // final bool isRunning;

  @override
  State<UIStopWatch> createState() => _UIStopWatchState();
}

class _UIStopWatchState extends State<UIStopWatch> {
  Duration duration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    int addSeconds = 1;
    setState(() {
      () async {
        try {} on WrongOrderException {
          addSeconds = 6;
        }
      };
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
      if (seconds > 180) {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildTime(),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTimecard(time: minutes, header: 'MINUTES'),
        SizedBox(
          width: 3.w,
        ),
        buildTimecard(time: seconds, header: 'SECONDS'),
      ],
    );
  }
}

Widget buildTimecard({
  required String time,
  required String header,
}) =>
    Container(
      width: 40.w,
      height: 40.h,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 16.sp,
        ),
      ),
    );
