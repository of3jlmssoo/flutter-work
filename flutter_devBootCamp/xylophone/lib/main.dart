import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(XylophoneApp());

class XylophoneApp extends StatelessWidget {
  void playSound(int i) {
    final player = AudioPlayer();
    player.play(AssetSource('note$i.wav'));
  }

  Expanded buildKey({int soundNumber = 1, Color bkgcolor = Colors.black}) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          playSound(soundNumber);
        },
        child: Text(''),
        style: TextButton.styleFrom(backgroundColor: bkgcolor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildKey(soundNumber: 1, bkgcolor: Colors.red),
            buildKey(soundNumber: 2, bkgcolor: Colors.orange),
            buildKey(soundNumber: 3, bkgcolor: Colors.yellow),
            buildKey(soundNumber: 4, bkgcolor: Colors.green),
            buildKey(soundNumber: 5, bkgcolor: Colors.green.shade900),
            buildKey(soundNumber: 6, bkgcolor: Colors.blue),
            buildKey(soundNumber: 7, bkgcolor: Colors.purple),
          ],
        )
            // child: Center(
            //   child: TextButton(
            //     onPressed: () {
            //       final player = AudioPlayer();
            //       // player.setSource(AssetSource('note1.wav'));
            //       player.play(AssetSource('note1.wav'));
            //     },
            //     child: Text('click me'),
            //   ),
            // ),

            ),
      ),
    );
  }
}
