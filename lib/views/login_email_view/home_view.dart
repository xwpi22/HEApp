import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Future<User>? thisAppUser;

  int _currentIndex = 0; //預設值
  final pages = [
    const GamesHomeView(),
    const RecordsView(),
    const AccountView(),
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(MdiIcons.controller), label: '遊戲'),
          BottomNavigationBarItem(icon: Icon(MdiIcons.podium), label: '我的遊戲紀錄'),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.faceAgent), label: '會員專區'),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemClick,
        selectedFontSize: 10.sp, // Use .sp for scaling text size
        unselectedFontSize: 10.sp, // Use .sp for scaling text size
        iconSize: 22.sp, // Adjust icon size using .sp
        // Optionally adjust bottom navigation bar height
        type:
            BottomNavigationBarType.fixed, // Ensure the bar doesn't move on tap
        selectedLabelStyle: TextStyle(fontSize: 10.sp),
        unselectedLabelStyle: TextStyle(fontSize: 10.sp),
      ),
      body: pages[_currentIndex],
    );
  }

  void _onItemClick(int index) {
    //use to change bottom navigationbar
    setState(() {
      _currentIndex = index;
    });
  }
}
