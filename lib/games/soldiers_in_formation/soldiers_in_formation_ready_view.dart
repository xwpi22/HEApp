import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/games/soldiers_in_formation/soldiers_in_formation_game_view.dart';
import 'package:heapp/globals/gobals.dart';

class SoldiersInFormationGameReadyView extends StatefulWidget {
  const SoldiersInFormationGameReadyView({
    super.key,
  });

  @override
  State<SoldiersInFormationGameReadyView> createState() =>
      _SoldiersInFormationGameReadyViewState();
}

class _SoldiersInFormationGameReadyViewState
    extends State<SoldiersInFormationGameReadyView> {
  @override
  Widget build(BuildContext context) {
    const double sizeboxHeigt = 20.0;

    return Scaffold(
      extendBodyBehindAppBar: true,
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
              '按鈕排排站',
              style: Theme.of(context).textTheme.headlineLarge,
              textScaleFactor: 1.5,
            ),
            const SizedBox(height: sizeboxHeigt),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '遊戲玩法：',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Color(0xFF2E609C),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                Text(
                  '請快速的依照由左至右\n由上而下的順序',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
                Text(
                  '將綠色按鈕點擊成紅色',
                  style: GoogleFonts.permanentMarker(
                    fontSize: 22.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1,
                ),
              ],
            ),
            const SizedBox(height: sizeboxHeigt * 1.5),
            Image.asset(
              'assets/images/SIFGameRule.JPG',
              width: 250.w,
              height: 125.h,
              fit: BoxFit.cover, // Adjust according to your requirement
            ),
            const SizedBox(height: sizeboxHeigt * 1.5),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                maximumSize: Size(140.w, 80.h),
                minimumSize: Size(120.w, 60.h),
                shape: const RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const SoldiersInFormationGame()));
              },
              child: Text(
                '開始遊戲',
                textAlign: TextAlign.center,
                style: GoogleFonts.permanentMarker(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E609C),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
