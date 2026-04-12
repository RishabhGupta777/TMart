import 'package:flutter/material.dart';

class TProductTitleText extends StatelessWidget {
  const TProductTitleText({
    super.key,
    required this.title,
    this.isLarge = true,
    this.lineThrough = false,
    this.maxLines = 1,
  });
  final String title;
  final bool isLarge;
  final int maxLines;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,overflow:
      TextOverflow.ellipsis,
      maxLines: maxLines,
      style: isLarge
          ? Theme.of(context).textTheme.headlineSmall!.apply(
          decoration: lineThrough ? TextDecoration.lineThrough : null)
          : Theme.of(context).textTheme.titleMedium!.apply(
          decoration: lineThrough ? TextDecoration.lineThrough : null),
    );
  }
}
