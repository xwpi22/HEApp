import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_game_ending_view.dart';
import 'package:heapp/games/colors_vs_words_game/colors_vs_word_ready_view.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/firebase_options.dart';
import 'package:heapp/games/number_connection_game/number_connection_game_over_view.dart';
import 'package:heapp/games/number_connection_game/number_connection_game_ready_view.dart';
import 'package:heapp/games/soldiers_in_formation/soldiers_in_formation_game_ending_view.dart';
import 'package:heapp/games/soldiers_in_formation/soldiers_in_formation_ready_view.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/views/account_view/account_view.dart';
import 'package:heapp/views/login_email_view/forget_password_view.dart';
import 'package:heapp/views/login_email_view/home_view.dart';
import 'package:heapp/views/login_email_view/login_view.dart';
import 'package:heapp/views/records_view/records_view.dart';
import 'package:heapp/views/login_email_view/register_view.dart';
import 'package:heapp/views/login_email_view/verified.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // lock the device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

const Color appBarBackgroundColor = Color(0xFF2E609C);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        // Corrected here
        title: 'Number Connection Test',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF2E609C),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF2E609C),
            toolbarHeight: 60.h,
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  // Use textTheme here
                  color: Theme.of(context)
                      .colorScheme
                      .onSecondary, // Ensure visibility
                ),
          ),
          // primarySwatch: Colors.white,
          primaryColor: Colors.grey,
          secondaryHeaderColor: Colors.white,
          textTheme: TextTheme(
            displayLarge: TextStyle(
              fontSize: 50.0.sp,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E609C),
            ),
            headlineLarge: TextStyle(
              fontSize: 36.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            headlineMedium: TextStyle(
              fontSize: 30.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            headlineSmall: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            titleLarge: TextStyle(fontSize: 30.0.sp),
            bodyLarge: TextStyle(fontSize: 24.0.sp),
            bodyMedium: TextStyle(fontSize: 20.0.sp),
            bodySmall: TextStyle(fontSize: 14.0.sp, color: Colors.black),
            labelLarge: TextStyle(fontSize: 20.0.sp),
            labelMedium:
                TextStyle(fontSize: 16.0.sp, color: Colors.grey.shade400),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF2E609C),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              foregroundColor: Color(0xFF2E609C),
            ),
          ),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English
          Locale('zh', 'TW'), // Traditional Chinese
        ],
        home: const MyHomePage(title: 'Home'),
        routes: {
          numberConnectionReadyRoute: (context) =>
              const NumberConnectionReadyView(),
          colorVsWordsGameReadyRoute: (context) =>
              const ColorsVsWordGameReadyView(),
          soldiersInFormationGameReadyRoute: (context) =>
              const SoldiersInFormationGameReadyView(),
          homeRoute: (context) => const HomeView(),
          loginRoute: (context) => const LoginView(),
          registerRoute: (context) => const RegisterView(),
          accountRoute: (context) => const AccountView(),
          recordsRoute: (context) => const RecordsView(),
          verifyEmailRoute: (context) => const VerifyEmailView(),
          ncgameoverRoute: (context) => const NCGameOverView(),
          cwgameoverRoute: (context) => const CWGameOverView(),
          sifgameoverRoute: (context) => const SIFGameOverView(),
          forgotPasswordRoute: (context) => const ForgetPassView(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const HomeView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
