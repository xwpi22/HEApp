import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';

class SIFEndingRecordView extends StatefulWidget {
  const SIFEndingRecordView({super.key, required this.record});
  final DatabaseRecord record;

  @override
  State<SIFEndingRecordView> createState() => _SIFEndingRecordViewState();
}

class _SIFEndingRecordViewState extends State<SIFEndingRecordView> {
  @override
  Widget build(BuildContext context) {
    const double sizeboxHeigt = 20.0;
    // const TextStyle dataTextStyle = TextStyle(fontSize: 20);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '按鈕排排站',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
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
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      widget.record.gameDateTime.split(" ")[0],
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '遊玩時間：',
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      widget.record.gameDateTime.split(" ")[1],
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '遊玩時長：',
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      widget.record.gameTime,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '按鈕總數：',
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      ' $globButtonsCount',
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '按錯次數：',
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      ' $globWrongPressedCount',
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Text(
                      '遊玩分數：',
                      textAlign: TextAlign.right,
                    ),
                    Text(
                      ' $globScore',
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
                    backgroundColor: globColor,
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
                    backgroundColor: globColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      soldiersInFormationGameReadyRoute,
                      (_) => false,
                    );
                  },
                  child: const Text(
                    '再來一次',
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
