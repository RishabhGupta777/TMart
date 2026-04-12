import 'package:flutter/material.dart';

class TBrandName extends StatelessWidget {
  const TBrandName({
    super.key,
    this.title = 'Nike',
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,),
        SizedBox( width: 4,),
        Icon(Icons.verified,color: Colors.blue,)
      ],
    );
  }
}

