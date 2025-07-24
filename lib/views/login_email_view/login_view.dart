//login View
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/services/auth/auth_exceptions.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/services/crud_service.dart';
import 'package:heapp/services/crud/sqlite/crud_exceptions.dart';
import 'package:heapp/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const uiHight = 20.0;
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '肝肝好',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 30.h,
              ),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                style: Theme.of(context).textTheme.bodySmall,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: '請輸入您的e-mail',
                  icon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                height: uiHight.h,
              ),
              TextField(
                controller: _password,
                obscureText: !_isPasswordVisible,
                enableSuggestions: false,
                autocorrect: false,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  hintText: '請輸入您的密碼',
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(
                        () {
                          _isPasswordVisible = !_isPasswordVisible;
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: uiHight.h,
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await Services().getDatabaseUser(email: email);
                    try {
                      await AuthService.firebase().logIn(
                        email: email,
                        password: password,
                      );
                      final user = AuthService.firebase().currentUser;
                      if (user?.isEmailVerified ?? false) {
                        //user's email is verified
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          homeRoute,
                          (route) => false,
                        );
                      } else {
                        //user's email is NOT verified
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute,
                          (route) => false,
                        );
                      }
                    } on WrongPasswordOrUserNotFoundAuthException {
                      await showErrorDialog(
                        context,
                        '用戶問題',
                        '找不到輸入的用戶或輸入的密碼錯誤',
                      );
                    } on InvalidEmailAuthException {
                      await showErrorDialog(
                        context,
                        '用戶問題',
                        '輸入的Email格式錯誤',
                      );
                    } on GenericAuthException {
                      await showErrorDialog(
                        context,
                        '驗證問題',
                        '驗證問題',
                      );
                    }
                  } on DBCouldNotFindUser {
                    await showErrorDialog(context, '資料庫', '找不到用戶');
                  } on DatabaseIsNotOpen {
                    await showErrorDialog(context, '資料庫', '資料庫未開啟');
                  }
                },
                // style: Theme.of(context).textButtonTheme.style,
                child: const Text(
                  '登入',
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(forgotPasswordRoute);
                },
                child: const Text(
                  '忘記密碼',
                ),
              ),
              SizedBox(
                height: uiHight.h,
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      qrcodescanningRoute, (route) => false);
                },
                child: const Text(
                  '點擊此處註冊',
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
