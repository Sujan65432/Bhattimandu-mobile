import 'dart:convert';

import 'package:bhattimandu/components/card/custom_button.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/pages/seller/editLiquor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:typed_data';

import '../../components/pages_header.dart';

class ViewLiquor extends StatefulWidget {
  final String liquorId;

  const ViewLiquor(
      {super.key,
      required this.liquorId});

  @override
  State<ViewLiquor> createState() => _ViewLiquorState();
}

class _ViewLiquorState extends State<ViewLiquor> {
  bool isLoading = true;
  List<Map<String, dynamic>> liquors = [];

  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    fetchLiquor();
  }

  Future<void> fetchLiquor() async {
    try {
      final data = await LiquorService().getLiquorsById(widget.liquorId);
      if (data.isEmpty) {
        print('No Liquor found.');
        return;
      }
      setState(() {
        liquors = data;
        isLoading = false;
      });

      final base64Image =
          liquors.isNotEmpty ? liquors[0]['liquor']['img'] ?? '' : '';
      if (base64Image.isNotEmpty) {
        try {
          imageBytes = base64Decode(base64Image);
        } catch (e) {
          print("Error decoding Base64: $e");
          imageBytes = null;
        }
      }
    } catch (e) {
      print("Error fetching liquors or farmer data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading? const BhattiLoader(): Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              PagesHeader(
                route: '/liquors',
                title: liquors[0]['liquor']['liquorName'],
              ),
              Container(
                  height: 220,
                  color: const Color(0xff1C1C2E),
                  child: imageBytes != null
                      ? Image.memory(
                    imageBytes!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  )
                      : const Icon(
                    Icons.broken_image,
                    size: 120,
                    color: Colors.grey,
                  ),),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Expanded(
                              child: Text(
                                liquors[0]['liquor']['liquorName'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'lovelo',
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                              ),
                            ),
                            const SizedBox(width:18),
                            CustomButtonIcon( onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditLiquor(
                                      liquorData: liquors,
                                    ),
                                  ),
                                );

                            }, icon: const Icon(Icons.edit))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomButtonIcon(
                                    onPressed: () {},
                                    icon: const FaIcon(FontAwesomeIcons.dollar,
                                        size: 15, color: Colors.green)),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Avg Price',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Rs. ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'poppins',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(
                                          liquors[0]['liquor']['price'],
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'lovelo',
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomButtonIcon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.storage,
                                        size: 15, color: Colors.green)),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Stock',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      liquors[0]['liquor']['stock'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'lovelo',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomButtonIcon(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.flag,
                                    size: 15, color: Colors.green)),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Country of origin',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  liquors[0]['liquor']['origin'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'lovelo',
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomButtonIcon(
                                onPressed: () {},
                                icon: const FaIcon(
                                    FontAwesomeIcons.brandsFontAwesome,
                                    size: 15,
                                    color: Colors.green)),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Brand Name',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  liquors[0]['liquor']['brandName'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'lovelo',
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomButtonIcon(
                                onPressed: () {},
                                icon: const Icon(Icons.category,
                                    size: 18, color: Colors.green)),
                            const SizedBox(width: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  liquors[0]['liquor']['category'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'lovelo',
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomButtonIcon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.nightlife,
                                        size: 15, color: Colors.green)),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Shelf Life',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      liquors[0]['liquor']['life'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'lovelo',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomButtonIcon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.storage,
                                        size: 15, color: Colors.green)),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Volume',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontFamily: 'poppins',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      liquors[0]['liquor']['volume'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'lovelo',
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomButtonIcon(
                                onPressed: () {},
                                icon: const Icon(Icons.wb_incandescent_outlined,
                                    size: 15, color: Colors.green)),
                            const SizedBox(width: 5),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Text(
                          liquors[0]['liquor']['desc'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
                          ),
                          textAlign: TextAlign.justify,
                          softWrap: true,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Review',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontFamily: 'poppins',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: liquors[0]['liquor']['reviews'].isNotEmpty
                              ? liquors[0]['liquor']['reviews'].map<Widget>((review) {
                            return Card(
                              color: const Color(0xff1C1C2E),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      children: [
                                        const Icon(Icons.star, color: Colors.amber),
                                        const SizedBox(width: 8),
                                        Text("Rating: ${review['rating']}/5"),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      review['review'],
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                              : [
                            const Card(
                              color:  Color(0xff1C1C2E),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    "No reviews available.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
