import 'dart:math';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:heapp/games/number_connection_game/number_connection_game_buttons_view.dart';
import 'package:heapp/games/number_connection_game/number_connection_game_exceptions.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/services/crud_service.dart';

class NumberConnectionGameView extends StatefulWidget {
  const NumberConnectionGameView({
    super.key,
    required this.startNum,
    required this.endNum,
    required this.mode,
  });
  final int startNum;
  final int endNum;
  final bool mode;

  @override
  State<NumberConnectionGameView> createState() =>
      _NumberConnectionGameViewState();
}

class _NumberConnectionGameViewState extends State<NumberConnectionGameView> {
  late final Services _services;
  // late final _now = DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now());
  late final String _gametime;
  final stopwatch = Stopwatch();
  late final int _range;
  late final int _nodesNumber;
  static const _gameid = 0; // gameMap[0]
  List<Offset> _buttonPositions = [];

  @override
  void initState() {
    _services = Services();
    globWrongPressedCount = 0;
    globButtonsCount = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buttonPositions = generateButtonPositions(context);
      setState(() {});
    });
    stopwatch.start();
    super.initState();
  }

  List<Offset> generateButtonPositions(BuildContext context) {
    final List<Offset> positions = [];
    final Random random = Random();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    _nodesNumber = widget.endNum - widget.startNum + 1;
    if (_nodesNumber > 1 && _nodesNumber < 15) {
      _range = 80;
    } else if (_nodesNumber >= 15 && _nodesNumber < 35) {
      _range = 65;
    } else if (_nodesNumber >= 35 && _nodesNumber <= 50) {
      _range = 55;
    } else {
      throw WrongRangeException;
    }
    int totalButtons = (widget.endNum - widget.startNum) + 1;
    int more = 0;
    if (widget.mode) more = 10;
    for (int i = 0; i < totalButtons + more; i++) {
      Offset position;
      bool isTooClose;
      do {
        // Generate a random position within the screen boundaries
        position = Offset(
          (random.nextDouble() * screenWidth) % (screenWidth * (0.8)),
          (random.nextDouble() * screenHeight) % (screenHeight * (0.8)),
        );
        if (positions.isEmpty) {
          isTooClose = false;
        } else {
          isTooClose = isPositionTooClose(position, positions);
        }
      } while (isTooClose);

      positions.add(position);
    }

    if (positions.length < totalButtons) {
      return generateButtonPositions(context);
    }
    globButtonsCount = _nodesNumber;
    return positions;
  }

  bool isPositionTooClose(Offset newPosition, List<Offset> existingPositions) {
    // if (existingPositions.isEmpty) return false;
    for (final Offset existingPosition in existingPositions) {
      final double distance = (newPosition - existingPosition).distance;

      if (distance < _range) {
        return true; // Too close
      }
    }
    return false;
  }

  void _createAndSaveNewRecord() async {
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _services.getDatabaseUser(email: email);
    await _services.createDatabaseRecord(
      userId: owner.id,
      gameId: _gameid,
      gameTime: _gametime,
      score: _nodesNumber,
    );
  }

  @override
  void deactivate() {
    stopwatch.stop;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(stopwatch.elapsed.inMinutes.remainder(60));
    final seconds = twoDigits(stopwatch.elapsed.inSeconds.remainder(60));
    _gametime = '$minutes:$seconds';

    _createAndSaveNewRecord();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globGamingNumber = widget.startNum - 1;
    return Center(
      child: Scaffold(
        // extendBodyBehindAppBar: true,
        // backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: Color(0xFF2E609C),
          elevation: 0,
        ),
        extendBody: false,
        body: widget.mode
            ? Stack(
                children: [
                  for (int i = 0; i < _buttonPositions.length; i++)
                    if (i < (widget.endNum - widget.startNum + 1))
                      Positioned(
                        left: _buttonPositions[i].dx,
                        top: _buttonPositions[i].dy,
                        child: WrapperButton(
                          labelnum: widget.startNum + i,
                          endnum: widget.endNum,
                          postiions: _buttonPositions,
                        ),
                      )
                    else
                      Positioned(
                        left: _buttonPositions[i].dx,
                        top: _buttonPositions[i].dy,
                        child: WrapperButton(
                          labelnum: (widget.endNum - widget.startNum + 1) - i,
                          endnum: widget.endNum,
                          postiions: _buttonPositions,
                        ),
                      )
                ],
              )
            : Stack(
                children: [
                  for (int i = 0;
                      i < (widget.endNum - widget.startNum + 1);
                      i++)
                    if (i < _buttonPositions.length)
                      Positioned(
                        left: _buttonPositions[i].dx,
                        top: _buttonPositions[i].dy,
                        child: WrapperButton(
                          labelnum: widget.startNum + i,
                          endnum: widget.endNum,
                          postiions: _buttonPositions,
                        ),
                      ),
                ],
              ),
      ),
    );
  }
}
