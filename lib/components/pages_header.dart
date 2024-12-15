import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class PagesHeader extends StatefulWidget {
  final String title;
  final String route;
  const PagesHeader({super.key, required this.title, required this.route});

  @override
  State<PagesHeader> createState() => _PagesHeaderState();
}

class _PagesHeaderState extends State<PagesHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      color: const Color(0xff1C1C2E),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'lovelo',
                    fontWeight: FontWeight.w400,
                    fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, widget.route);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color:  Colors.grey,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),child: const Icon(Icons.arrow_back_ios_new_rounded,color:Colors.white)),
              ),


            ],
          ),
        ],
      ),
    );
  }
}
