import 'package:bhattimandu/components/card/LiquorCategory.dart';
import 'package:bhattimandu/components/customer_liquor/display_cat.dart';
import 'package:bhattimandu/pages/buyer/HorizontalCat.dart';
import 'package:flutter/material.dart';

class HoriizontalCategory extends StatelessWidget {
  const HoriizontalCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'text': 'Wine', 'img': 'images/wine.png'},
      {'text': 'Whiskey', 'img': 'images/Whiskey.png'},
      {'text': 'Rum', 'img': 'images/rum.png'},
      {'text': 'Beer', 'img': 'images/beer.png'},
      {'text': 'Vodka', 'img': 'images/vodka.png'},
      {'text': 'Tequila', 'img': 'images/tequila.png'},
      {'text': 'Gin', 'img': 'images/gin.png'},
      {'text': 'Cognac', 'img': 'images/cognac.png'},
      {'text': 'Brandy', 'img': 'images/brandy.png'},
      {'text': 'Champagne', 'img': 'images/champaigne.png'},
      {'text': 'Absinthe', 'img': 'images/abisnthe.png'},
      {'text': 'Liqueur', 'img': 'images/liqueur.png'},
      {'text': 'Sake', 'img': 'images/sake.png'},
      {'text': 'Mead', 'img': 'images/mead.png'},
      {'text': 'Cider', 'img': 'images/cider.png'},
      {'text': 'Port Wine', 'img': 'images/port.png'},
      {'text': 'Sherry', 'img': 'images/sherry.png'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((category) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: HorizontalLiquorCategory(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DisplayCat(category: category['text']!),
                  ),
                );
              },
              text: category['text']!,
              img: category['img']!,
            ),
          );
        }).toList(),
      ),
    );
  }
}
