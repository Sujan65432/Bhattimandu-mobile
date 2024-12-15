import 'package:bhattimandu/components/app_header.dart';
import 'package:bhattimandu/components/card/LiquorCard.dart';
import 'package:flutter/material.dart';

class Liquors extends StatefulWidget {
  const Liquors({super.key});

  @override
  State<Liquors> createState() => _LiquorsState();
}

class _LiquorsState extends State<Liquors> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Widget
            AppHeader(
              title: 'Liquors',
            ),


            // Body Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:15),
                child:LiquorCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
