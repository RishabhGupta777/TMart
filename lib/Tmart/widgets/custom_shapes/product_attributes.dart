import 'package:flutter/material.dart';
import 'package:flashchat/TMart/widgets/custom_shapes/chice_chip.dart';

class ProductAttributes extends StatelessWidget {
  const ProductAttributes({
    super.key,
    required this.attributes,
    required this.onAttributeSelected,
  });
  final List<Map<String, dynamic>> attributes;
  final Function(String attValue) onAttributeSelected;


  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> attribute = attributes[0];

    final String name=attribute['name'] ?? " ";
    final List<String> sizeStrings = List<String>.from(attribute['value'] ?? []);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        // Text('Colors', style:Theme.of(context).textTheme.labelLarge),
        // const SizedBox(height: 2),
        // TChoiceChip(
        //   isCircular: true,
        //   colors: [Colors.red, Colors.blue, Colors.green], // Pass colors
        // ),
        //
        // const SizedBox(height:5),
        Text(name, style:Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 3),
        TChoiceChip(
          onAttributeSelected: (attValue){
            onAttributeSelected(attValue);
          },
          isCircular: false,
          texts:sizeStrings, // Pass text options
        ),
      ],
    );
  }
}

