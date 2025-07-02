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
        leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                homeRoute,
                (_) => false,
              );
            },
            icon: const Icon(
              Icons.home_filled,
            )),
        backgroundColor: Color(0xFF2E609C),
        // iconTheme: IconThemeData(
        //   color: Colors.white,
        // ),
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
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize:
                    Size(220.w, 80.h), // Use ScreenUtil for responsive size
                minimumSize: Size(160.w, 60.h),
                backgroundColor: Color(0xFF2E609C),
                padding: EdgeInsets.all(20.0),
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
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize:
                    Size(220.w, 80.h), // Use ScreenUtil for responsive size
                minimumSize: Size(160.w, 60.h),
                backgroundColor: Color(0xFF2E609C),
                padding: EdgeInsets.all(20.0),
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
            SizedBox(
              height: 50.h,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                maximumSize:
                    Size(220.w, 80.h), // Use ScreenUtil for responsive size
                minimumSize: Size(160.w, 60.h),
                backgroundColor: Color(0xFF2E609C),
                padding: EdgeInsets.all(20.0),
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
