import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';

class NCEndingRecordView extends StatefulWidget {
  const NCEndingRecordView({super.key, required this.record});
  final DatabaseRecord record;

  @override
  State<NCEndingRecordView> createState() => _NCEndingRecordViewState();
}

class _NCEndingRecordViewState extends State<NCEndingRecordView> {
  @override
  Widget build(BuildContext context) {
    const double sizeboxHeigt = 20.0;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '數字點點名',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '遊戲結束',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: sizeboxHeigt.h,
            ),
            Text(
              '遊戲數據',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              width: 150.w,
              height: 10,
              child: const Divider(
                color: Colors.black,
              ),
            ),
            Table(
              columnWidths: const {
                0: FractionColumnWidth(0.5), // Adjust these widths as needed
                1: FractionColumnWidth(0.5),
              },
              children: [
                TableRow(
                  children: [
                    const Text(
                      '遊玩日期：',
                      // style: dataTextStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      widget.record.gameDateTime.split(" ")[0],
                      // style: dataTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '遊玩時間：',
                      // style: dataTextStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      widget.record.gameDateTime.split(" ")[1],
                      // style: dataTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '遊玩時長：',
                      // style: dataTextStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      widget.record.gameTime,
                      // style: dataTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '按鈕總數：',
                      // style: dataTextStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      ' $globButtonsCount',
                      // style: dataTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '按錯次數：',
                      // style: dataTextStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      ' $globWrongPressedCount',
                      // style: dataTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '遊玩分數：',
                      // style: dataTextStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      ' ${globButtonsCount - globWrongPressedCount}',
                      // style: dataTextStyle,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              width: 220,
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(140.w, 100.h),
                    minimumSize: Size(120.w, 80.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    backgroundColor: Color(0xFF2E609C),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      homeRoute,
                      (_) => false,
                    );
                  },
                  child: const Text(
                    '遊戲選單',
                    // style: GoogleFonts.permanentMarker(fontSize: 18),
                    style: TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(
                  width: 20,
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(140.w, 100.h),
                    minimumSize: Size(120.w, 80.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    backgroundColor: Color(0xFF2E609C),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      numberConnectionReadyRoute,
                      (_) => false,
                    );
                  },
                  child: const Text(
                    '再來一次',
                    // style: GoogleFonts.permanentMarker(fontSize: 18),
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
