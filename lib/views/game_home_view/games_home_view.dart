import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:sqflite/utils/utils.dart';

class GamesHomeView extends StatefulWidget {
  const GamesHomeView({super.key});

  @override
  State<GamesHomeView> createState() => _GamesHomeViewState();
}

class _GamesHomeViewState extends State<GamesHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // floatingActionButton: Icon(Icons.arrow_back),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E609C),
        iconTheme: IconThemeData(
          color: Colors.white, // Set the desired color for the back icon here
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '遊戲選單',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize:
                    Size(200.w, 80.h), // Use ScreenUtil for responsive size
                minimumSize: Size(160.w, 60.h),
                backgroundColor: Color(0xFF2E609C),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    // color: Colors.black,
                    color: Colors.black,
                    width: 1.5.w,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(numberConnectionReadyRoute);
              },
              child: Text(
                '數字點點名',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize:
                    Size(200.w, 80.h), // Use ScreenUtil for responsive size
                minimumSize: Size(160.w, 60.h),
                backgroundColor: Color(0xFF2E609C),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    // color: Colors.black,
                    color: Colors.black,
                    width: 1.5.w,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(colorVsWordsGameReadyRoute);
              },
              child: Text(
                '五顏配六色',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize:
                    Size(200.w, 80.h), // Use ScreenUtil for responsive size
                minimumSize: Size(160.w, 60.h),
                backgroundColor: Color(0xFF2E609C),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    // color: Colors.black,
                    color: Colors.black,
                    width: 1.5.w,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(soldiersInFormationGameReadyRoute);
              },
              child: Text(
                '按鈕排排站',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
