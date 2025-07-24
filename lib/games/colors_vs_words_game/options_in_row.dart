import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Expanded genrow(
    {required int btn1,
    required int btn2,
    required bool questionType,
    required String btn1ListString,
    required String btn2ListString,
    required Color buttonBackgroundColor1,
    required Color buttonBackgroundColor2,
    required void Function(String) updatestate}) {
  return Expanded(
    flex: 2,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: genbutton(
                btnNum: btn1,
                questionType: questionType,
                btnStr: btn1ListString,
                updatestate: updatestate,
                buttonBackgroundColor: buttonBackgroundColor1),
          ),
          SizedBox(width: 5.0.w),
          Expanded(
            child: genbutton(
                questionType: questionType,
                btnNum: btn2,
                btnStr: btn2ListString,
                updatestate: updatestate,
                buttonBackgroundColor: buttonBackgroundColor2),
          ),
        ],
      ),
    ),
  );
}

ElevatedButton genbutton(
    {required int btnNum,
    required var btnStr,
    required bool questionType,
    required Color buttonBackgroundColor,
    required void Function(String) updatestate}) {
  return ElevatedButton(
    onPressed: () {
      var userAns = btnStr;
      updatestate(userAns);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: buttonBackgroundColor,
      side: BorderSide(
        width: 2.0.w,
        style: BorderStyle.solid,
        color: Colors.black,
      ),
    ),
    child: Text(
      questionType ? btnStr : "",
      style: TextStyle(
        fontSize: 50.0.sp,
        fontFamily: 'KGB',
        color: Colors.black,
        // fontWeight: FontWeight.bold,
      ),
    ),
  );
}
