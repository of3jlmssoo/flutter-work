import 'package:flutter/material.dart';
import '../constants.dart';

class childColumn extends StatelessWidget {
  childColumn({required this.childIcon, required this.text});
  final IconData childIcon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(childIcon, size: 80),
        SizedBox(
          height: 15,
        ),
        Text(
          text,
          style: kLabelTextStyle,
        )
      ],
    );
  }
}
