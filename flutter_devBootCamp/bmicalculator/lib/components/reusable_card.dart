import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  // const ReusableCard({
  //   super.key,
  // });

  ReusableCard({required this.color, this.cardChild, this.onPress});
  final Color color;
  final Widget? cardChild; // nullable
  // final Function? onPress;
  final VoidCallback? onPress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: cardChild,
        // color: mainCardColor,
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          // color: Color(0XFFFFFFFF),
          borderRadius: BorderRadius.circular(10),
        ),
        // height: 200,
        // width: 170,
      ),
      onTap: onPress,
    );
  }
}
