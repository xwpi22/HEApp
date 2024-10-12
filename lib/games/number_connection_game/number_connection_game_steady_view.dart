import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/games/number_connection_game/number_connection_game_view.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/utilities/dialogs/show_range_check_dialog.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberConnectionSteadyView extends StatefulWidget {
  const NumberConnectionSteadyView({
    super.key,
    required this.mode,
  });
  final bool mode;

  @override
  State<NumberConnectionSteadyView> createState() =>
      _NumberConnectionSteadyViewState();
}

class _NumberConnectionSteadyViewState
    extends State<NumberConnectionSteadyView> {
  int _startingNumber = 1;
  int _endingNumber = 1;

  void _updateEndingNumber(int newStartNumber) {
    int newMaxEndNumber = newStartNumber + 24;

    setState(() {
      _startingNumber = newStartNumber;
      // Ensure the ending number is within the new range.
      if (_endingNumber > newMaxEndNumber) {
        _endingNumber = newMaxEndNumber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double sizeboxWidth = 50.0;
    const double sizeboxHeigt = 20.0;
    int maxEndingNumber = _startingNumber + 24;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // floatingActionButton: Icon(Icons.arrow_back),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '數字點點名',
              style: Theme.of(context).textTheme.headlineLarge,
              textScaleFactor: 1.5,
            ),
            const SizedBox(height: sizeboxHeigt),
            Text(
              '遊戲規則：\n螢幕上將出現隨機分布的數字\n請從起始數字開始\n將綠色按鈕長按成紅色\n按到結束數字時遊戲結束',
              style: GoogleFonts.permanentMarker(
                fontSize: 22.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
              textScaleFactor: 1,
            ),
            const SizedBox(height: sizeboxHeigt),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      '起始數字',
                      style: GoogleFonts.permanentMarker(
                        fontSize: 18.sp,
                        color: Colors.grey.shade800,
                      ),
                      textScaleFactor: 1.5,
                    ),
                    NumberPicker(
                      value: _startingNumber,
                      itemWidth: 60.w,
                      itemHeight: 40.h,
                      textStyle: Theme.of(context).textTheme.labelMedium,
                      selectedTextStyle: TextStyle(
                          fontSize: 20.0.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                      minValue: 1,
                      maxValue: 25,
                      haptics: true,
                      onChanged: (value) => _updateEndingNumber(value),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 2.0, color: Colors.grey.shade400),
                          right: BorderSide(
                              width: 2.0, color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: sizeboxWidth),
                Column(
                  children: [
                    Text(
                      '結束數字',
                      style: GoogleFonts.permanentMarker(
                        fontSize: 18.sp,
                        color: Colors.grey.shade800,
                      ),
                      textScaleFactor: 1.5,
                    ),
                    NumberPicker(
                      value: _endingNumber,
                      itemWidth: 60.w,
                      itemHeight: 40.h,
                      minValue: 1,
                      maxValue: maxEndingNumber,
                      textStyle: Theme.of(context).textTheme.labelMedium,
                      selectedTextStyle: TextStyle(
                          fontSize: 20.0.sp,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                      onChanged: (value) =>
                          setState(() => _endingNumber = value),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 2.0, color: Colors.grey.shade400),
                          right: BorderSide(
                              width: 2.0, color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                maximumSize: Size(140.w, 120.h),
                minimumSize: Size(120.w, 100.h),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              onPressed: () async {
                final rangeOk = await showRangeCheckingDialog(
                  context,
                  startingnum: _startingNumber,
                  endingnum: _endingNumber,
                );
                if (rangeOk && mounted) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NumberConnectionGameView(
                            startNum: _startingNumber,
                            endNum: _endingNumber,
                            mode: widget.mode,
                          )));
                }
              },
              child: Text(
                '開始遊戲',
                style: GoogleFonts.permanentMarker(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: globColor,
                ),
                textScaleFactor: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
