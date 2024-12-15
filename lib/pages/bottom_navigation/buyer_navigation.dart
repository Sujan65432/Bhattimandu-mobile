import 'package:bhattimandu/model/user_model.dart';
import 'package:bhattimandu/pages/buyer/buyer_dash.dart';
import 'package:bhattimandu/pages/buyer/filterDashboard.dart';
import 'package:bhattimandu/pages/buyer/liquor_category.dart';
import 'package:bhattimandu/pages/buyer/my_account.dart';
import 'package:bhattimandu/pages/buyer/my_cart.dart';
import 'package:bhattimandu/pages/buyer/my_order.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BuyerNavigation extends StatefulWidget {
  final int index;
  const BuyerNavigation({super.key, required this.index});

  @override
  State<BuyerNavigation> createState() => _BuyerNavigationState();
}

class _BuyerNavigationState extends State<BuyerNavigation> {
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
      const LiquorCategory(),
      const MyCart(),
      const FilterDashboard(),
      const MyOrder(),
      const MyAccount()
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
              icon: FaIcon(FontAwesomeIcons.cartShopping),
              label: "My Cart",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.dashcube),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.cartShopping),
              label: "My Order",
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
