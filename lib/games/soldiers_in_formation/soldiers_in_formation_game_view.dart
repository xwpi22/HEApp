import 'package:flutter/material.dart';
import 'package:heapp/constants/routes.dart';
import 'package:heapp/globals/gobals.dart';
import 'package:heapp/services/auth/auth_service.dart';
import 'package:heapp/services/crud/services/crud_service.dart';

class SoldiersInFormationGame extends StatefulWidget {
  const SoldiersInFormationGame({super.key});

  @override
  State<SoldiersInFormationGame> createState() =>
      _SoldiersInFormationGameState();
}

class _SoldiersInFormationGameState extends State<SoldiersInFormationGame> {
  int _lastPressed = -1; // To keep track of the last pressed button index.
  final int _totalButtons = 64;

  late final Services _services;
  late final String _gametime;
  final stopwatch = Stopwatch();
  static const _gameid = 2; // gameMap[2]

  @override
  void initState() {
    _services = Services();
    stopwatch.start();
    globScore = 0;
    globWrongPressedCount = 0;
    globButtonsCount = 64;
    super.initState();
  }

  void _createAndSaveNewRecord() async {
    stopwatch.stop;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(stopwatch.elapsed.inMinutes.remainder(60));
    final seconds = twoDigits(stopwatch.elapsed.inSeconds.remainder(60));
    _gametime = '$minutes : $seconds';
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _services.getDatabaseUser(email: email);
    await _services.createDatabaseRecord(
      userId: owner.id,
      gameId: _gameid,
      gameTime: _gametime,
      score: globScore,
    );
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth = MediaQuery.of(context).size.width; // 80% of screen width
    double gridHeight =
        MediaQuery.of(context).size.height * 0.8; // 60% of screen height
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Color(0xFF2E609C),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: gridWidth,
          height: gridHeight,
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8, // 8 columns
              childAspectRatio:
                  1.0, // Adjust child aspect ratio for square buttons
              crossAxisSpacing: 4, // Spacing between the buttons horizontally
              mainAxisSpacing: 4, // Spacing between the buttons vertically
            ),
            itemCount: _totalButtons,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Logic to check if the button is pressed in the correct order.
                  if (index == _lastPressed + 1) {
                    setState(() {
                      _lastPressed = index;
                    });
                    // Check for game over condition
                    if (_lastPressed == _totalButtons - 1) {
                      globScore = _totalButtons - globWrongPressedCount;
                      _createAndSaveNewRecord();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          sifgameoverRoute, (_) => false);
                    }
                  } else {
                    globWrongPressedCount += 1;
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: index <= _lastPressed
                        ? Colors.grey
                        : Color.fromARGB(255, 77, 144,
                            231), // Change color based on click order.
                    borderRadius:
                        BorderRadius.circular(8), // Rounded corners for buttons
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
