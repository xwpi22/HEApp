import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/games/colors_vs_words_game/options_in_row.dart';
import 'package:heapp/games/colors_vs_words_game/questions.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/services/crud_service.dart';

class ColorvsWordGameView extends StatefulWidget {
  const ColorvsWordGameView({super.key, required this.questionType});
  final int questionType;
  @override
  State<ColorvsWordGameView> createState() => _ColorvsWordGameViewState();
}

class _ColorvsWordGameViewState extends State<ColorvsWordGameView> {
  // DatabaseRecords? _record;
  late final Services _services;
  late final String _gametime;
  final stopwatch = Stopwatch();
  static const _gameid = 1; // gameMap[1]

  //
  int _currAnsIndex = 0;
  int _currinterferenceOptionIndex = 1;
  List ansIndexList = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8];
  List optionsUsedList = <int>[0, 1, 2, 3, 4, 5, 6, 7, 8];
  List optionsIndexList = <int>[1, 2, 3, 4];

  void checkAnswer(userAns, bool questionType, BuildContext context) {
    // print(userAns + wordsList[ansIndexList[_currindex]]);

    if (userAns == wordsList[ansIndexList[_currAnsIndex - 1]]) {
      globScore += 1;
    }

    if (_currinterferenceOptionIndex == 0) {
      stopwatch.stop;
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(stopwatch.elapsed.inMinutes.remainder(60));
      final seconds = twoDigits(stopwatch.elapsed.inSeconds.remainder(60));
      _gametime = '$minutes:$seconds';
      Navigator.of(context)
          .pushNamedAndRemoveUntil(cwgameoverRoute, (_) => false);
    }
  }

  @override
  void initState() {
    _services = Services();
    ansIndexList.shuffle();
    stopwatch.start();
    globScore = 0;

    optionsUsedList.remove(ansIndexList[_currAnsIndex]);
    optionsUsedList.remove(ansIndexList[_currinterferenceOptionIndex]);
    optionsUsedList.shuffle();
    optionsIndexList.clear();

    optionsIndexList = optionsUsedList.take(2).toList();
    optionsIndexList.add(ansIndexList[_currAnsIndex]);
    optionsIndexList.add(ansIndexList[_currinterferenceOptionIndex]);

    optionsIndexList.shuffle();
    optionsUsedList.add(ansIndexList[_currAnsIndex]);
    optionsUsedList.add(ansIndexList[_currinterferenceOptionIndex]);

    super.initState();
  }

  void _createAndSaveNewRecord() async {
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _services.getDatabaseUser(email: email);
    await _services.createDatabaseRecord(
      userId: owner.id,
      gameId: _gameid,
      gameTime: _gametime,
      score: globScore,
    );
  }

  @override
  void setState(VoidCallback fn) {
    _currAnsIndex += 1;
    _currinterferenceOptionIndex =
        (_currinterferenceOptionIndex + 1) % (ansIndexList.length);
    optionsUsedList.remove(ansIndexList[_currAnsIndex]);
    optionsUsedList.remove(ansIndexList[_currinterferenceOptionIndex]);
    optionsUsedList.shuffle();
    optionsIndexList.clear();
    optionsIndexList = optionsUsedList.take(2).toList();
    optionsIndexList.add(ansIndexList[_currAnsIndex]);
    optionsIndexList.add(ansIndexList[_currinterferenceOptionIndex]);
    optionsIndexList.shuffle();
    optionsUsedList.add(ansIndexList[_currAnsIndex]);
    optionsUsedList.add(ansIndexList[_currinterferenceOptionIndex]);

    super.setState(fn);
  }

  @override
  void deactivate() {
    _createAndSaveNewRecord();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late bool questionType;
    if (widget.questionType == 2) {
      questionType = Random().nextBool();
    } else {
      questionType = widget.questionType == 1 ? true : false;
    }
    // For both question types, the title is represented by a Chinese character denoting color,
    // harmoniously paired with a distinct background color.
    // 1. Present a selection of 4 colors, each accompanied by a background of a different hue,
    //    empowering users to discern and choose the color that aligns with the intended significance
    //    of the text in the question.
    // 2. Offer a set of 4 color words as alternatives, enabling users to align their choice
    //    with the background color of the Chinese text within the question.

    return Scaffold(
      // extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 255, 240, 219),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBody: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            children: [
              /// Question Container
              Expanded(
                flex: 7,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      /// Score and icons
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: const EdgeInsets.all(3.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[900],
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    width: 2.0,
                                  ),
                                ),
                                child: Text(
                                  'Score: $globScore',
                                  style: TextStyle(
                                    fontSize: 20.0.sp,
                                    fontFamily: 'KGB',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Question
                      Expanded(
                        flex: 8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Question
                            questionType
                                ? const Text(
                                    '字的顏色是什麼顏色',
                                    // style: TextStyle(fontSize: 25),
                                  )
                                : const Text(
                                    '字的意義代表什麼顏色',
                                    // style: TextStyle(fontSize: 25),
                                  ),
                            SizedBox(
                              height: 50.h,
                            ),
                            Center(
                              child: Text(
                                questionType
                                    ? wordsList[ansIndexList[
                                        _currinterferenceOptionIndex]]
                                    : wordsList[ansIndexList[_currAnsIndex]],
                                style: TextStyle(
                                  fontSize: 120.0.sp,
                                  fontFamily: 'RussoOne',
                                  color: questionType
                                      ? colorsList[ansIndexList[_currAnsIndex]]
                                      : colorsList[ansIndexList[
                                          _currinterferenceOptionIndex]],
                                  height: 1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Answer row 1
              genrow(
                  btn1: 0,
                  btn2: 1,
                  questionType: questionType,
                  btn1ListString: wordsList[optionsIndexList[0]],
                  btn2ListString: wordsList[optionsIndexList[1]],
                  buttonBackgroundColor1: questionType
                      ? Colors.white
                      : colorsList[optionsIndexList[0]],
                  buttonBackgroundColor2: questionType
                      ? Colors.white
                      : colorsList[optionsIndexList[1]],
                  updatestate: (String userAns) {
                    setState(() {
                      checkAnswer(userAns, questionType, context);
                    });
                  }),
              const SizedBox(height: 5.0),

              /// Answer row 2
              genrow(
                  btn1: 2,
                  btn2: 3,
                  questionType: questionType,
                  btn1ListString: wordsList[optionsIndexList[2]],
                  btn2ListString: wordsList[optionsIndexList[3]],
                  buttonBackgroundColor1: questionType
                      ? Colors.white
                      : colorsList[optionsIndexList[2]],
                  buttonBackgroundColor2: questionType
                      ? Colors.white
                      : colorsList[optionsIndexList[3]],
                  updatestate: (String userAns) {
                    setState(() {
                      checkAnswer(userAns, questionType, context);
                    });
                  }),
              const SizedBox(height: 5.0),
            ],
          ),
        ),
      ),
    );
  }
}
