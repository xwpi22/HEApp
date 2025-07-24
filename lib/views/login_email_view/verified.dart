import 'package:flutter/material.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    const uiHight = 20.0;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '驗證 E-mail',
              style: TextStyle(
                color: Color(0xFF2E609C),
                fontSize: 50.sp,
                fontWeight: FontWeight.bold,
                // fontFamily:
              ),
            ),
            SizedBox(
              height: uiHight.h,
            ),
            Text(
              "我們已向您發送了 E-mail 驗證信。請開啟它以驗證您的 E-mail 帳戶。\n\n如果您尚未收到，請按下面的重新發送 E-mail 驗證信。",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 24.sp,
              ),
            ),
            SizedBox(
              height: uiHight.h,
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text(
                '重新發送 E-mail 驗證信',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E609C),
                  // fontSize: 24,
                ),
              ),
            ),
            SizedBox(
              height: uiHight.h,
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
              child: const Text(
                '已驗證完畢，重新登入',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E609C),
                  // fontSize: 24,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
