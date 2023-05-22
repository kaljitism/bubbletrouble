import 'dart:async';

import 'package:bubbletrouble/alien.dart';
import 'package:bubbletrouble/button.dart';
import 'package:bubbletrouble/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'missile.dart';

enum Direction {
  left,
  right,
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double playerX = 0;

  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  double alienX = 0.5;
  double alienY = 1;
  Direction alienDirection = Direction.left;

  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * (height / totalHeight);
    return position;
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
      } else {
        playerX -= 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
      } else {
        playerX += 0.1;
      }
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void resetMissile() {
    setState(() {
      missileX = playerX;
      missileHeight = 10;
      midShot = false;
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 5), (timer) {
        midShot = true;

        setState(() {
          missileHeight += 5;
        });

        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        if (alienY > heightToPosition(missileHeight) &&
            (alienX - playerX).abs() < 0.03) {
          resetMissile();
          alienX = 5;
          timer.cancel();
        }
      });
    }
  }

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 100;

    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      height = -5 * time * time + velocity * time;

      if (height < 0) {
        time = 0;
      }

      if (alienY > heightToPosition(missileHeight) &&
          (alienX - playerX).abs() < 0.03) {
        alienY = 5;
        timer.cancel();
        startGame();
      }

      setState(() {
        alienY = heightToPosition(height);
      });

      time += 0.1;

      if (alienX - 0.02 < -1) {
        alienDirection = Direction.right;
      } else if (alienX + 0.02 > 1) {
        alienDirection = Direction.left;
      }

      setState(() {
        if (alienDirection == Direction.left) {
          alienX -= 0.02;
        } else if (alienDirection == Direction.right) {
          alienX += 0.02;
        }
      });

      if (playerDies()) {
        timer.cancel();
        _showDialog();
      }
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[700],
            title: const Center(
              child: Text(
                'You are DEAD',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        });
  }

  bool playerDies() {
    if ((missileX - alienX).abs() < 0.05 && alienY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (value) {
        if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        } else if (value.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink[100],
                border: Border.all(
                  color: Colors.black,
                  width: 5.0,
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    Alien(
                      alienX: alienX,
                      alienY: alienY,
                    ),
                    Missile(
                      missileX: missileX,
                      missileHeight: missileHeight,
                    ),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 60.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: MyButton(
                        icon: const Icon(Icons.play_arrow),
                        function: startGame,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MyButton(
                            icon: const Icon(Icons.arrow_back_ios),
                            function: moveLeft,
                          ),
                          MyButton(
                            icon: const Icon(Icons.arrow_upward_rounded),
                            function: fireMissile,
                          ),
                          MyButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            function: moveRight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
