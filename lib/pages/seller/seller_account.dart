import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bhattimandu/components/app_header.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/authentication.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:bhattimandu/pages/seller/update_seller_pp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellerAccount extends StatefulWidget {
  const SellerAccount({super.key});

  @override
  State<SellerAccount> createState() => _SellerAccountState();
}

class _SellerAccountState extends State<SellerAccount> {
  bool isLoadingseller = true;
  Map<String, dynamic>? sellerData;
  File? _image;
  String _base64Image = "";
  bool isLoading = false;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchSellerData();
  }

  Future<void> fetchSellerData() async {
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      if (user == null || user.uid.isEmpty) {
        setState(() {
          isLoadingseller = false;
          sellerData = null;
        });
        return;
      }
      final data = await LiquorService().getSellerByID(user.uid);
      setState(() {
        sellerData = data.isNotEmpty ? data[0]['user'] : null;
        isLoadingseller =
            false; // Ensure that the loading flag is set to false after fetching the data
      });
    } catch (e) {
      print("Error fetching seller data: $e");
      setState(() {
        isLoadingseller = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final base64Image = sellerData?['image'] ?? '';
    Uint8List? imageBytes;

    if (base64Image.isNotEmpty) {
      try {
        imageBytes = base64Decode(base64Image);
      } catch (e) {
        print("Error decoding Base64: $e");
        imageBytes = null;
      }
    }

    return Scaffold(
      body: isLoadingseller
          ? const BhattiLoader() // A loader component to show while data is being fetched
          : LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    const AppHeader(title: 'My Account'),
                    Container(
                      color: const Color(0xff1C1C2E),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage: imageBytes != null
                                ? MemoryImage(imageBytes)
                                : const AssetImage('images/bhatti.png'),
                            maxRadius: 38,
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                sellerData?['fullName'] ??
                                    'Samyak Maharjan',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'lovelo',
                                    fontSize: 15),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                sellerData?['email'] ??
                                    'samyak@gmail.com',
                                style: TextStyle(
                                  fontSize: constraints.maxWidth * 0.04,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [


                              const SizedBox(height: 20),
                              _buildTiles(const Icon(Icons.person,color: Colors.white,), 'Account Information',
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateSellerPp(sellerData: sellerData),
                                  ),
                                );
                              }),
                              const SizedBox(height: 5),
                              _buildTiles(const FaIcon(FontAwesomeIcons.wineBottle,color: Colors.white,) , 'My Liquors', () {
                                Navigator.pushReplacementNamed(
                                    context, '/liquors');
                              }),
                              const SizedBox(height: 5),
                              _buildTiles(const Icon(Icons.shopping_cart,color: Colors.white,), 'Orders', () {
                                Navigator.pushReplacementNamed(
                                    context, '/orders');
                              }),
                              const SizedBox(height: 5),
                              _buildTiles(const Icon(Icons.reviews,color: Colors.white,), 'Reviews', () {
                                Navigator.pushReplacementNamed(
                                    context, '/liquors');
                              }),
                              const SizedBox(height: 5),
                              _buildTiles(
                                  const Icon(Icons.help,color: Colors.white,), 'Help and Support', () {}),
                              const SizedBox(height: 5),
                              _buildTiles(const Icon(Icons.logout,color: Colors.white,), 'Logout', () async {
                                await AuthenticationService()
                                    .userSignOut(context);
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildIconButton(
      IconData icon, String label, BoxConstraints constraints) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: constraints.maxWidth * 0.1, color: Colors.grey[800]),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: constraints.maxWidth * 0.03,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildTiles(Widget  icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'roboto',
            fontSize: 15),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: onTap,
    );
  }
}
