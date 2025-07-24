import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/games/number_connection_game/number_connection_game_steady_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heapp/globals/gobals.dart';

class NumberConnectionReadyView extends StatefulWidget {
  const NumberConnectionReadyView({
    super.key,
  });

  @override
  State<NumberConnectionReadyView> createState() =>
      _NumberConnectionReadyViewState();
}

class _NumberConnectionReadyViewState extends State<NumberConnectionReadyView> {
  @override
  Widget build(BuildContext context) {
    const double sizeboxHeigt = 30.0;

    return Scaffold(
      // extendBodyBehindAppBar: true,
      // floatingActionButton: Icon(Icons.arrow_back),
      appBar: AppBar(
        backgroundColor: Color(0xFF2E609C),
        // iconTheme: IconThemeData(
        //   color: Colors.white, // Set the desired color for the back icon here
        // ),
        leading: BackButton(
          onPressed: () async {
            Navigator.of(context).pushNamedAndRemoveUntil(
              gameListRoute,
              (_) => false,
            );
          },
        ),
      ),
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () async {
      //         Navigator.of(context).pushNamedAndRemoveUntil(
      //           homeRoute,
      //           (_) => false,
      //         );
      //       },
      //       icon: const Icon(
      //         Icons.home_filled,
      //         color: Colors.black,
      //       )),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '數字點點名',
              style: Theme.of(context).textTheme.headlineLarge,
              textScaleFactor: 1.5,
            ),
            const SizedBox(height: sizeboxHeigt),
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '普通模式：',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Color(0xFF2E609C),
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                Text(
                  '僅出現數字',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                const SizedBox(height: 10),
                Text(
                  '進階模式：',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Color(0xFF2E609C),
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                Text(
                  '英文字母來搗亂！別被騙了！',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.left,
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
                color: Colors.grey.shade800,
              ),
              textScaleFactor: 1,
            ),
            SizedBox(height: sizeboxHeigt.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(140.w, 100.h),
                    minimumSize: Size(120.w, 80.h),
                    // backgroundColor: const Color.fromARGB(255, 27, 97, 149),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    // padding: EdgeInsets.all(20),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NumberConnectionSteadyView(
                              mode: false,
                            )));
                  },
                  child: Text(
                    '普通\n模式',
                    style: GoogleFonts.permanentMarker(
                      fontSize: 27.sp,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E609C),
                    ),
                    textScaleFactor: 1,
                  ),
                ),
                SizedBox(width: 20.w),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: Size(140.w, 100.h),
                    minimumSize: Size(120.w, 80.h),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        // color: Colors.black,
                        color: Colors.white,
                        width: 1.5.w,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const NumberConnectionSteadyView(
                              mode: true,
                            )));
                  },
                  child: Text(
                    '進階\n模式',
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
