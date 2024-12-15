import 'package:flutter/material.dart';

class AlcoholList extends StatefulWidget {
  final String label;
  final int wid;
  final Function(String?) onChanged;

  const AlcoholList({
    super.key,
    required this.label,
    required this.wid,
    required this.onChanged,
  });

  final border = const OutlineInputBorder(
    borderSide: BorderSide(
      width: 1.5,
      color: Colors.white,
      style: BorderStyle.solid,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );

  @override
  State<AlcoholList> createState() => _AlcoholListState();
}

class _AlcoholListState extends State<AlcoholList> {
  final List<String> items = [
    'Wine',
    'Whiskey',
    'Rum',
    'Beer',
    'Vodka',
    'Tequila',
    'Gin',
    'Cognac',
    'Brandy',
    'Champagne',
    'Absinthe',
    'Liqueur',
    'Sake',
    'Mead',
    'Cider',
    'Port Wine',
    'Sherry',
  ];
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'poppins',
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width / widget.wid,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: widget.border,
              focusedBorder: widget.border,
            ),
            value: selectedCategory,
            hint: const Text('Select Category',style: TextStyle(
              fontSize: 14,
              fontFamily: 'poppins',
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
              });
              widget.onChanged(newValue);
            },
          ),
        ),
      ],
    );
  }
}
