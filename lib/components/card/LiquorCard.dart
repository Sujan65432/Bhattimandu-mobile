import 'package:bhattimandu/components/card/LiquorCategory.dart';
import 'package:bhattimandu/components/liquor_card/liqour_detail.dart';
import 'package:flutter/material.dart';


class LiquorCard extends StatelessWidget {
  const LiquorCard({super.key});

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

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return LiquorCategory(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiqourDetail(category: categories[index]['text']),
              ),
            );
          },
          text: categories[index]['text']!,
          img: categories[index]['img']!,
        );
      },
    );
  }
}
