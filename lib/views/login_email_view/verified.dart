import 'package:flutter/material.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/auth/auth_service.dart';

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
            const Text(
              '驗證E-mail',
              style: TextStyle(
                color: globColor,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                // fontFamily:
              ),
            ),
            const SizedBox(
              height: uiHight,
            ),
            const Text(
              "我們已向您發送了E-mail驗證。\n請開啟它並驗證您的E-mail帳戶。\n如果您尚未收到驗證E-mail\n請按下面的重新發送E-mail驗證信\n",
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            const SizedBox(
              height: uiHight,
            ),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
              },
              child: const Text(
                '重新發送E-mail驗證信',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: globColor,
                ),
              ),
            ),
            const SizedBox(
              height: uiHight,
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
                  color: globColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
