import 'package:flashchat/TMart/colors.dart';
import 'package:flutter/material.dart';

class TSectionHeading extends StatelessWidget {
  const TSectionHeading({
    super.key,
    required this.title,
    this.onPressed,
    this.buttonTitle='View all',
    this.showActionButton = true,

  });
  final title;
  final bool showActionButton;
  final void Function()? onPressed ;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            maxLines: 1,
            overflow:TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 20),),
          if(showActionButton) TextButton(onPressed: onPressed, child: Text(buttonTitle,style: const TextStyle(color: TColors.primary),)),

        ],
      ),
    );
  }
}
