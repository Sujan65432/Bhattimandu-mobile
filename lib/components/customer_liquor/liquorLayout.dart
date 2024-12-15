import 'dart:convert';
import 'dart:typed_data';
import 'package:bhattimandu/components/card/individual_liquor.dart';
import 'package:bhattimandu/pages/buyer/view_liquor_data.dart';
import 'package:bhattimandu/pages/seller/view_liquor.dart';
import 'package:flutter/material.dart';

class LiquorLayout extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  const LiquorLayout({super.key, required this.categories});

  @override
  State<LiquorLayout> createState() => _LiquorLayoutState();
}

class _LiquorLayoutState extends State<LiquorLayout> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.categories.isEmpty
          ? const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        shrinkWrap: false,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final liquor = widget.categories[index];
          final category = liquor['liquor'] ?? {};
          final base64Image = category['img'] ?? '';
          Uint8List? imageBytes;

          if (base64Image.isNotEmpty) {
            try {
              imageBytes = base64Decode(base64Image);
            } catch (e) {
              print("Error decoding Base64 for index $index: $e");
            }
          }

          return IndividualLiquor(
            liquorName: category['liquorName'] ?? 'Unknown Liquor',
            img: imageBytes != null
                ? Image.memory(
              imageBytes,
              width: 120,
              height: 140,
              fit: BoxFit.cover,
            )
                : const Icon(
              Icons.broken_image,
              size: 120,
              color: Colors.grey,
            ),
            pp: category['price']?.toString() ?? '0.0',
            rate: '',
            brandName: category['brandName'] ?? 'Unknown Brand',
            category: category['category'] ?? 'Unknown Category',
            origin: category['origin'] ?? 'Unknown Origin',
            onPressed: () {
              final liquorId = category['id']?.toString();
              if (liquorId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewLiquorData(
                      liquorId: liquorId,
                    ),
                  ),
                );
              } else {
                print("Error: Vegetable ID is null");
              }
            },
          );
        },
      ),
    );
  }
}
