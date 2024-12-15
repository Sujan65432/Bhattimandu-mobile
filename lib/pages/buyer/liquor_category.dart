import 'package:bhattimandu/components/app_header.dart';
import 'package:bhattimandu/components/card/LiquorCard.dart';
import 'package:bhattimandu/components/customer_liquor/cus_liq_card.dart';
import 'package:flutter/material.dart';

class LiquorCategory extends StatefulWidget {
  const LiquorCategory({super.key});

  @override
  State<LiquorCategory> createState() => _LiquorCategoryState();
}

class _LiquorCategoryState extends State<LiquorCategory> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Widget
            AppHeader(
              title: 'Liquor Category',
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:15),
                child:CusLiqCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
