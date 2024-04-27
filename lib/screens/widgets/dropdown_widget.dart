import 'package:flutter/material.dart';

class ColorItem {
  ColorItem(this.name, this.color);
  final String name;
  final Color color;
}

class ColorSelector extends StatefulWidget {
  final List<ColorItem> items;

  const ColorSelector({required this.items});

  @override
  _ColorSelectorState createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  late ColorItem currentChoice;

  @override
  void initState() {
    currentChoice = widget.items[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.face,
          color: currentChoice.color,
          size: 100.0,
        ),
        DropdownButton<ColorItem>(
          isExpanded: true,
          style: Theme.of(context).textTheme.headline6,
          value: currentChoice,
          items: widget.items
              .map<DropdownMenuItem<ColorItem>>(
                (ColorItem item) => DropdownMenuItem<ColorItem>(
                  value: item,
                  child: Center(child: Text(item.name)),
                ),
              )
              .toList(),
          onChanged: (ColorItem? value) =>
              setState(() => currentChoice = value!),
        ),
      ],
    );
  }
}
