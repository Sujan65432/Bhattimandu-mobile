import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bhattimandu/components/card/custom_button.dart';
import 'package:bhattimandu/components/customer_liquor/custom_cart_btn.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:bhattimandu/database/cart_controller.dart';
import 'package:bhattimandu/pages/seller/editLiquor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import '../../components/pages_header.dart';

class ViewLiquorData extends StatefulWidget {
  final String liquorId;

  const ViewLiquorData({super.key, required this.liquorId});

  @override
  State<ViewLiquorData> createState() => _ViewLiquorDataState();
}

class _ViewLiquorDataState extends State<ViewLiquorData> {
  bool isLoading = true;
  List<Map<String, dynamic>> liquors = [];
  int quantity = 1;
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
  }void addToCart() async {
    setState(() {
      isLoading=true;
    });
    try {

      final user = Provider.of<UserModel?>(context, listen: false);
      if (user == null) {
        throw Exception("User not logged in");
      }
      if (liquors.isEmpty || liquors[0]['liquor'] == null) {
        throw Exception("Liquor information is missing");
      }

      final liquor = liquors[0]['liquor'];
      final liquorId = liquor['id'];
      final liquorName = liquor['liquorName'];
      final price = liquor['price'];
      final image = liquor['img'];
      final createdBy = liquor['createdBy'];

      if (price == null || quantity == null) {
        throw Exception("Price or quantity is missing");
      }
      var total = price * quantity;

      await MyCartController().addCart(
        context: context,
        uuid: user.uid,
        liquorId: liquorId,
        liquorName: liquorName,
        createdBy: createdBy,
image:image,
        price: price,
        quantity: quantity.toString(),
        status: 'pending',
      );
      setState(() {
        isLoading=false;
      });
      Navigator.pushReplacementNamed(context, '/my_cart');

    } catch (e) {
      setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add item to cart: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const BhattiLoader()
        : Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    PagesHeader(
                      route: '/liquor_category',
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
                            ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                          icon: const FaIcon(
                                              FontAwesomeIcons.dollar,
                                              size: 15,
                                              color: Colors.green)),
                                      const SizedBox(width: 5),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      icon: const Icon(
                                          Icons.wb_incandescent_outlined,
                                          size: 15,
                                          color: Colors.green)),
                                  const SizedBox(width: 5),
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              const SizedBox(height: 10,),
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (quantity > 1) quantity--;
                                    });
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.minus,
                                    color: Colors.white,
                                    size: 16, // Icon size
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width: 20), // Space between buttons and text
                              SizedBox(
                                width:
                                    30, // Adjust width to fit number comfortably
                                child: Text(
                                  '$quantity',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white, // Text color
                                    fontSize: 16, // Font size
                                  ),
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      20), // Space between text and next button
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.green, // Button background color
                                  shape: BoxShape
                                      .circle, // Makes the background circular
                                ),
                                padding: const EdgeInsets.all(
                                    8), // Adds padding inside the circle
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                  child: const FaIcon(
                                    FontAwesomeIcons.plus,
                                    color: Colors.white, // Icon color
                                    size: 16, // Icon size
                                  ),
                                ),
                              ),

                            ],
                          ),  CustomCartBtn(
                            text: "Add to Cart",
                            icon:
                            const Icon(Icons.add_shopping_cart, size: 12),
                            onPressed: addToCart,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
