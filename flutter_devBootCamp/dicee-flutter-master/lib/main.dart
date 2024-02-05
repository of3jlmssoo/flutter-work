import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  return runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Dicee'),
          backgroundColor: Colors.red,
        ),
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDiceNumber = 1;
  int rightDiceNumber = 1;

  void updateDices() {
    leftDiceNumber = Random().nextInt(6) + 1;
    rightDiceNumber = Random().nextInt(6) + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(children: [
        Expanded(
            // flex: 2,
            // child: Image(
            //   image: AssetImage('images/dice1.png'),
            // ),
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextButton(
            onPressed: () {
              setState(() {
                // leftDiceNumber = Random().nextInt(6) + 1;
                // rightDiceNumber = Random().nextInt(6) + 1;
                updateDices();
              });
              debugPrint('the left button pressed.');
            },
            child: Image.asset('images/dice$leftDiceNumber.png'),
          ),
        )),
        // SizedBox(
        //   width: 16.0,
        // ),
        Expanded(
          // flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton(
              onPressed: () {
                setState(() {
                  // leftDiceNumber = Random().nextInt(6) + 1;
                  // rightDiceNumber = Random().nextInt(6) + 1;
                  updateDices();
                });
                debugPrint('the right button pressed.');
              },
              child: Image(
                image: AssetImage('images/dice$rightDiceNumber.png'),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
