import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_game_view.dart';
import 'package:heapp/globals/gobals.dart';

class ColorsVsWordGameReadyView extends StatefulWidget {
  const ColorsVsWordGameReadyView({
    super.key,
  });

  @override
  State<ColorsVsWordGameReadyView> createState() =>
      _ColorsVsWordGameReadyViewState();
}

class _ColorsVsWordGameReadyViewState extends State<ColorsVsWordGameReadyView> {
  @override
  Widget build(BuildContext context) {
    const double sizeboxHeigt = 20.0;
    const double sizeboxWidth = 20.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '五顏配六色',
              style: Theme.of(context).textTheme.headlineLarge,
              textScaleFactor: 1.5,
            ),
            const SizedBox(height: sizeboxHeigt),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '字的顏色模式：',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Color(0xFF2E609C),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                Text(
                  '根據字體的顏色選出答案',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '字的意義模式：',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Color(0xFF2E609C),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                Text(
                  '根據字義代表的顏色選出答案',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '混合出題模式：',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Color(0xFF2E609C),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                Text(
                  '兩種模式隨機出題',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
              ],
            ),
            const SizedBox(height: sizeboxHeigt),
            Text(
              '選擇模式',
              style: GoogleFonts.permanentMarker(
                fontSize: 36.sp,
                fontWeight: FontWeight.bold,
              ),
              textScaleFactor: 1,
            ),
            const SizedBox(height: sizeboxHeigt),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    maximumSize: Size(120.w, 100.h),
                    minimumSize: Size(100.w, 80.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ColorvsWordGameView(
                              questionType: 1,
                            )));
                  },
                  child: Text(
                    '字的\n顏色',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.permanentMarker(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E609C),
                    ),
                    textScaleFactor: 1,
                  ),
                ),
                const SizedBox(width: sizeboxWidth),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    maximumSize: Size(120.w, 100.h),
                    minimumSize: Size(100.w, 80.h),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ColorvsWordGameView(
                              questionType: 0,
                            )));
                  },
                  child: Text(
                    '字的\n意義',
                    style: GoogleFonts.permanentMarker(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E609C),
                    ),
                    textScaleFactor: 1,
                  ),
                ),
                const SizedBox(width: sizeboxWidth),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    maximumSize: Size(120.w, 100.h),
                    minimumSize: Size(100.w, 80.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ColorvsWordGameView(
                              questionType: 2,
                            )));
                  },
                  child: Text(
                    '混合\n出題',
                    style: GoogleFonts.permanentMarker(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E609C),
                    ),
                    textScaleFactor: 1,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
