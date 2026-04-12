import 'package:flashchat/TMart/widgets/custom_shapes/rounded_container.dart';
import 'package:flutter/material.dart';

class TChoiceChip extends StatefulWidget {
  const TChoiceChip({
    super.key,
    this.isCircular=false,
    this.texts, // Pass texts when using text chips
    this.colors, // Accept colors from parent
    required this.onAttributeSelected,
  });
  final bool isCircular;
  final List<String>? texts; // List of text options
  final List<Color> ? colors; // List of colors for chips
  final Function(String attValue) onAttributeSelected;

  @override
  State<TChoiceChip> createState() => _TChoiceChipState();
}

class _TChoiceChipState extends State<TChoiceChip> {
  int? _value;

  @override
  Widget build(BuildContext context) {
    final int itemCount = widget.isCircular ? widget.colors!.length : widget.texts!.length; // Get count
    return  Wrap(
      spacing: widget.isCircular ? 0.0 : 5.0,
      children:
      List<Widget>.generate(itemCount, (int index) {    //List.generate() is a constructor that creates a list with a specified number of elements (itemCount).
                      //A function (int index) {...} that defines how each element is created.
        return ChoiceChip(
          label:  widget.isCircular ? const SizedBox() : Text(widget.texts![index]),
          avatar: widget.isCircular ? TRoundedContainer(backgroundColor:  widget.colors![index],) :null ,
          shape:  widget.isCircular ?CircleBorder() : null,
          backgroundColor: widget.isCircular ?  widget.colors![index]: null,
          labelPadding: widget.isCircular ? EdgeInsets.all(0) : null,
          padding:  widget.isCircular ? EdgeInsets.all(0) : null,
          selectedColor:widget.isCircular ?  widget.colors![index]: null ,
          selected: _value == index,
          onSelected: (bool selected) {
            setState(() {
              _value = selected ? index : null;
            });
            widget.onAttributeSelected(widget.texts![_value!]);
          },
        );
      }).toList(),
    );
  }
}
