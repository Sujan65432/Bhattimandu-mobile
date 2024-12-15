import 'dart:convert';
import 'dart:typed_data';

import 'package:bhattimandu/components/app_header.dart';
import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/cart_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
  String? errorMessage;
  Future<void> fetchCart() async {
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      final fetchedItems = await MyCartController().getCartItems(
        uuid: user!.uid,
        context: context,
        status: 'pending',
      );
      setState(() {
        cartItems = fetchedItems;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load cart items. Please try again.";
        isLoading = false;
      });
    }
  }

  int get totalPrice =>
      cartItems.fold(
          0, (total, item) =>
      total + int.parse(item['price']) * int.parse(item['quantity']));

  void updateQuantity(int index, int change) {
    setState(() {
      int currentQuantity = int.parse(cartItems[index]['quantity']);
      int newQuantity = currentQuantity + change;

      if (newQuantity < 1) {
        newQuantity = 1;
      }

      cartItems[index]['quantity'] = newQuantity.toString();
    });

    // TODO: Add backend update logic here.
  }

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const BhattiLoader()
          : errorMessage != null
          ? Center(
        child: Text(
          errorMessage!,
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      )
          : Column(
        children: [
          const AppHeader(title: 'My Cart'),
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
              child: Text(
                'No items in your cart.',
                style: TextStyle(fontSize: 16),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: cartItems.length,

                itemBuilder: (context, index) =>
                    _buildCartItem(index),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Total: Rs. $totalPrice",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CustomBhattiBtn(
                  text: 'Place Order',
                  onPressed: _placeOrder,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCartItem(int index) {
    final item = cartItems[index];
    final base64Image = item['image'] ?? '';
    Uint8List? _imageBytes;

    // Decoding base64 image data if available
    if (base64Image.isNotEmpty) {
      try {
        _imageBytes = base64Decode(base64Image);
      } catch (e) {
        print("Error decoding Base64: $e");
      }
    }

    return Card(
      color: const Color(0xff2C2C3E), // Dark color for the card background
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 80,
          child: _imageBytes != null
              ? Image.memory(
            _imageBytes,
            width: 60,
            height: 80,
            fit: BoxFit.cover, // Adjust the fit as needed
          )
              : const Icon(
            Icons.broken_image,
            size: 80, // Adjust size as necessary
            color: Colors.grey,
          ),
        ),
        title: Text(
          item['liquorName'],
          style: const TextStyle(color: Colors.white, fontFamily: 'poppins'),
        ),
        subtitle: Text(
          "Rs. ${item['price']}",
          style: const TextStyle(color: Colors.white, fontFamily: 'poppins'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white),
              onPressed: () => updateQuantity(index, -1),
            ),
            Text(
              item['quantity'],
              style: const TextStyle(color: Colors.white, fontFamily: 'poppins'),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => updateQuantity(index, 1),
            ),
          ],
        ),
      ),
    );
  }


  void _placeOrder() {
    final user = Provider.of<UserModel?>(context, listen: false);
    List<Map<String, dynamic>> checkoutData = cartItems.map((item) {

      return {
        'cartId': item['id'],
        'liquorId': item['liquorId'],
        'uuid': user!.uid,
        'liquorName': item['liquorName'],
        'quantity': item['quantity'],
        'image': item['image'],
        'price': item['price'],
        'createdBy': item['createdBy'],
        'totalPrice': int.parse(item['price']) * int.parse(item['quantity']),
      };
    }).toList();

    Navigator.pushNamed(
      context,
      '/checkout',
      arguments: {
        'cartItems': checkoutData,
        'totalPrice': totalPrice,
      },
    );
  }
}