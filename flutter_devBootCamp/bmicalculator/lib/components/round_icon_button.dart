import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  // const RoundIconButton({super.key});
  RoundIconButton({required this.icon, required this.onPress});
  final IconData icon;
  final VoidCallback? onPress;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(icon),
      elevation: 0,
      // disabledElevation: 6,
      onPressed: onPress,
      constraints: BoxConstraints.tightFor(width: 56, height: 56),
      // shape: CircleBorder(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      fillColor: Color(0xFF4C4F5E),
    );
  }
}
