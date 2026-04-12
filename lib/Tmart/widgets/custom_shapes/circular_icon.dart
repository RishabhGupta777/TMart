import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';

class TCircularIcon extends StatelessWidget {
  const TCircularIcon({
    super.key,
    this.onTap,
    this.width=40,
    this.height=40,
    this.backgroundColor=Colors.white,
    this.icon,
    this.color,
    this.size,
    this.radius=40,
  });
  final VoidCallback? onTap;
  final double width;
  final double height;
  final Color backgroundColor;
  final IconData ? icon;
  final Color  ? color;
  final double ? size;
  final double ? radius;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      margin: 2,
        width: width,
        height: height,
        backgroundColor:backgroundColor,
        radius: 40,
        child:Center(child: IconButton(onPressed:onTap, icon:Icon(icon, color:color,size: size,)))
    );
  }
}