import 'package:bhattimandu/model/user_model.dart';
import 'package:bhattimandu/pages/seller/add-liquor.dart';
import 'package:bhattimandu/pages/seller/liquors.dart';
import 'package:bhattimandu/pages/seller/order-list.dart';
import 'package:bhattimandu/pages/seller/seller_account.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SellerNavigation extends StatefulWidget {
  final int index;
  const SellerNavigation({super.key, required this.index});

  @override
  State<SellerNavigation> createState() => _SellerNavigationState();
}

class _SellerNavigationState extends State<SellerNavigation> {
  late int pageIndex;

  @override
  void initState() {
    super.initState();
    pageIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    List screenList = [
      const Liquors(),
      const AddLiquor(),
      const OrderList(),
      const SellerAccount()
    ];

    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xff1C1C2E),
        ),
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              pageIndex = index;
            });
          },
          iconSize: 30,
          type: BottomNavigationBarType.shifting,
          currentIndex: pageIndex,
          backgroundColor: const Color(0xff1C1C2E),
          selectedItemColor: Colors.white, // Selected item color
          unselectedItemColor: const Color(0xFF6B7380), // Unselected item color
          items: const [
           BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.wineBottle),
              label: "Liquors",

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.liquor_sharp),
              label: "Add Liquor",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cartShopping),
              label: "Order",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              label: "My Account",
            ),
          ],
        ),
      ),
      body: screenList[pageIndex],
    );
  }
}
