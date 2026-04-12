import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flashchat/TMart/colors.dart';

class TButton extends StatelessWidget {
  final double ? width;
  final double ? height;
  final Color backgroundColor;
  final String ? text;
  final VoidCallback onTap;
  final double radius;
  final Color textColor ;

  const TButton({
    super.key,
    this.width ,
    this.height ,
    this.backgroundColor = TColors.primary,
    this.textColor = Colors.white,
    required this.text ,
    required this.onTap,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TRoundedContainer(
        backgroundColor: backgroundColor,
        width: width,
        height: height,
        radius: radius,
        child: Center(
          child: Text(
            text!,
            style: TextStyle(color:textColor,fontWeight: FontWeight.w600,fontSize:18),
          ),
        ),
      ),
    );
  }
}
