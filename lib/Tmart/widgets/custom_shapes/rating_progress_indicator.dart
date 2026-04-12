import 'package:flashchat/TMart/colors.dart';
import 'package:flutter/material.dart';

class TRatingProgressIndicator extends StatelessWidget {
  const TRatingProgressIndicator({
    super.key,
    required this.text,
    required this.value,
  });
  final String text;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex:1,child: Text(text,style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          flex:13,
          child: SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              value:value,
              minHeight:12,
              backgroundColor: Colors.grey,
              borderRadius: BorderRadius.circular(7),
              valueColor: AlwaysStoppedAnimation(TColors.primary),
            ),
          ),
        )
      ],
    );
  }
}
