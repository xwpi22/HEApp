library my_prj.globals;


import 'package:flutter/material.dart';

int globGamingNumber = -1;
int globScore = 0;
String globFinishedTime = '';

// 遊戲id 對應 遊戲名稱
const Map gameMap = <int, String>{
  0: '數字點點名',
  1: '五顏配六色',
  2: '按鈕排排站',
};

// current game ending record info
int globWrongPressedCount = 0;
int globButtonsCount = 0;

//
const int globNumOfCWProblems = 8;

const globColor = Color.fromARGB(255, 120, 169, 140);
var globFontColor = Colors.grey.shade700;
