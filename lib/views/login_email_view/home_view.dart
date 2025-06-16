import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/services/crud_service.dart';
import 'package:heapp/utilities/dialogs/logout_dialog.dart';
import 'package:heapp/views/account_view/medication_record_view/medication_record_list_view.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:heapp/services/crud/models/users_and_records.dart';
import 'package:heapp/views/account_view/account_view.dart';
import 'package:heapp/views/game_home_view/games_home_view.dart';
import 'package:heapp/views/records_view/records_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0; //預設值

  late Future<User> _userFuture;
  late Services _services;
  late String _userEmail;

  @override
  void initState() {
    super.initState();
    _services = Services();
    _userEmail = AuthService.firebase().currentUser!.email;
    _userFuture = Future(() => _services.getDatabaseUser(email: _userEmail));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data!;

        return Scaffold(
          // extendBodyBehindAppBar: true,
          // floatingActionButton: Icon(Icons.arrow_back),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color:
                  Colors.white, // Set the desired color for the back icon here
            ),
            actions: <Widget>[
              IconButton.outlined(
                onPressed: () async {
                  final shouldLogOut = await showLogOutDialog(context);
                  // Check the user's decision
                  if (shouldLogOut) {
                    await _services.logOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (_) => false,
                    );
                  }
                },
                icon: Icon(
                  Icons.logout,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   'HE App',
                //   // style: Theme.of(context).textTheme.displayLarge,
                //   style: TextStyle(
                //     color: Colors.grey.shade800,
                //     fontSize: 50.sp,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // const SizedBox(
                //   height: 50,
                // ),
                Text(
                  'Hi, ${user.name ?? '使用者'} 👋',
                  style:
                      TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '歡迎回來，請選擇功能',
                  style: TextStyle(fontSize: 20.sp, color: Colors.grey),
                ),
                SizedBox(height: 50),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250.w, 60.h),
                    // maximumSize:
                    //     Size(250.w, 80.h), // Use ScreenUtil for responsive size
                    // minimumSize: Size(160.w, 60.h),
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
                    Navigator.of(context).pushNamed(gameListRoute);
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // icon 在左，文字跟著靠左排列
                    children: [
                      Icon(MdiIcons.gamepadSquare, color: Colors.white),
                      // SizedBox(width: 200), // icon 和文字間距
                      Text(
                        '遊戲選單',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250.w, 60.h),
                    // maximumSize:
                    //     Size(250.w, 80.h), // Use ScreenUtil for responsive size
                    // minimumSize: Size(160.w, 60.h),
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
                    Navigator.of(context).pushNamed(
                      medicationRoute,
                      arguments: user.id,
                    );
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // icon 在左，文字跟著靠左排列
                    children: [
                      Icon(MdiIcons.pill, color: Colors.white),
                      // SizedBox(width: 200), // icon 和文字間距
                      Text(
                        '每日用藥',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                  // label: Text(
                  //   '每日用藥紀錄',
                  //   style: TextStyle(
                  //     fontSize: 30.sp,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250.w, 60.h),
                    // maximumSize:
                    //     Size(250.w, 80.h), // Use ScreenUtil for responsive size
                    // minimumSize: Size(160.w, 60.h),
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
                    Navigator.of(context).pushNamed(
                      accountRoute,
                    );
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // icon 在左，文字跟著靠左排列
                    children: [
                      Icon(MdiIcons.account, color: Colors.white),
                      // SizedBox(width: 200), // icon 和文字間距
                      Text(
                        '會員專區',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        );
      },
    );
    // ScreenUtil.init(context);

    // return FutureBuilder<User>(
    //   future: _userFuture,
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return const Scaffold(
    //         body: Center(child: CircularProgressIndicator()),
    //       );
    //     }

    //     final user = snapshot.data!;

    //     final pages = [
    //       const GamesHomeView(),
    //       MedicationListView(userId: user.id),
    //       const AccountView(),
    //     ];

    //     return Scaffold(

    //       extendBodyBehindAppBar: true,
    //       bottomNavigationBar: BottomNavigationBar(
    //         items: <BottomNavigationBarItem>[
    //           BottomNavigationBarItem(
    //               icon: Icon(MdiIcons.controller), label: '遊戲'),
    //           BottomNavigationBarItem(
    //               icon: Icon(MdiIcons.podium), label: '我的遊戲紀錄'),
    //           BottomNavigationBarItem(
    //               icon: Icon(MdiIcons.faceAgent), label: '會員專區'),
    //         ],
    //         currentIndex: _currentIndex,
    //         onTap: _onItemClick,
    //         selectedFontSize: 10.sp, // Use .sp for scaling text size
    //         unselectedFontSize: 10.sp, // Use .sp for scaling text size
    //         iconSize: 22.sp, // Adjust icon size using .sp
    //         // Optionally adjust bottom navigation bar height
    //         type: BottomNavigationBarType
    //             .fixed, // Ensure the bar doesn't move on tap
    //         selectedLabelStyle: TextStyle(fontSize: 10.sp),
    //         unselectedLabelStyle: TextStyle(fontSize: 10.sp),
    //       ),
    //       body: pages[_currentIndex],
    //     );
    //   },
    // );
  }

  void _onItemClick(int index) {
    //use to change bottom navigationbar
    setState(() {
      _currentIndex = index;
    });
  }
}
