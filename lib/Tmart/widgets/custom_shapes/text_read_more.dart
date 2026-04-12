import 'package:flashchat/TMart/colors.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class TextReadMore extends StatelessWidget {
  const TextReadMore({
    super.key,
    required this.text
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      text,
      trimLines: 2,
      trimMode: TrimMode.Line,
      trimCollapsedText: 'show more',
      trimExpandedText: 'Show less',
      moreStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w800,color: TColors.primary),
      lessStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w800,color: TColors.primary),
    );
  }
}
