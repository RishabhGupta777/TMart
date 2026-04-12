import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/circular_icon.dart';


class TProductQuantityWithAddRemoveButton extends StatefulWidget {
  final int initialQuantity;
  final ValueChanged<int> onQuantityChanged;

  const TProductQuantityWithAddRemoveButton({
    super.key,
    this.initialQuantity = 1,
    required this.onQuantityChanged,
  });

  @override
  State<TProductQuantityWithAddRemoveButton> createState() => _TProductQuantityWithAddRemoveButtonState();
}

class _TProductQuantityWithAddRemoveButtonState extends State<TProductQuantityWithAddRemoveButton> {
  late int quantity;


  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void _increment() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged(quantity);
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TCircularIcon(icon: Icons.remove,width:35,height: 35,radius:35,size:19, onTap: _decrement),
        SizedBox(width:8),
        Text(quantity.toString(), style: TextStyle(fontSize: 18)),
        SizedBox(width:8),
        TCircularIcon(icon: Icons.add,width: 35,height: 35,radius:35,size:19 , onTap: _increment),
      ],
    );
  }
}
