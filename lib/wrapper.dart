import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:bhattimandu/pages/bottom_navigation/buyer_navigation.dart';
import 'package:bhattimandu/pages/bottom_navigation/seller_navigation.dart';
import 'package:bhattimandu/pages/flashing_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool _isLoad = true;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);

    if (user == null) {
      _isLoad = true;
      return const BhattiLoader();
    }

    if (_isLoad) {
      _isLoad = false;
    }

    if (!_isLoad) {
      if (user.role == 'seller') {
        return const SellerNavigation(index: 1);
      } else if (user.role == 'buyer') {
        return const BuyerNavigation(index: 2);
      } else {
        return const BhattiFlashingPage();
      }
    }

    return const BhattiLoader();
  }
}
