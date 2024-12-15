import 'package:bhattimandu/components/card/Layout.dart';
import 'package:bhattimandu/components/customer_liquor/liquorLayout.dart';
import 'package:bhattimandu/components/pages_header.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class DisplayCat extends StatefulWidget {
  final String? category;
  const DisplayCat({super.key, this.category});

  @override
  State<DisplayCat> createState() => _DisplayCatState();
}

class _DisplayCatState extends State<DisplayCat> {
  bool isLoading = true;
  List<Map<String, dynamic>> liquorData = [];
  List<Map<String, dynamic>> filteredLiquorData = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLiquors();
    searchController.addListener(_filterLiquors);
  }

  void _filterLiquors() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredLiquorData = query.isEmpty
          ? liquorData
          : liquorData.where((liquor) {
        final liquorName = liquor['liquor']?['liquorName']?.toLowerCase() ?? '';
        return liquorName.contains(query);
      }).toList();
    });
  }

  void _performSearch() {
    // Manually trigger search filtering
    _filterLiquors();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchLiquors() async {
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      final lqData = await LiquorService()
          .getLiquorsByCategory(widget.category ?? '');

      setState(() {
        liquorData = lqData;
        filteredLiquorData = lqData;
      });
    } catch (e) {
      print("Error fetching Liquors or user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
          child: SpinKitThreeInOut(color: Color(0xff4B6F39), size: 50.0),
        )
            : Container(
          width: double.infinity,
          child: Column(
            children: [
              PagesHeader(
                title: widget.category ?? 'Category',
                route: '/liquor_category',
              ),
              Container(
                color: const Color(0xff1C1C2E),
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Search",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: Color(0xff1C1C2E),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.8,
                              color: Colors.grey,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1.8,
                              color: Colors.black,
                              style: BorderStyle.solid,
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _performSearch,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: filteredLiquorData.isEmpty
                    ? const Center(
                  child: Text(
                    "No Liquors found.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                )
                    : LiquorLayout(categories: filteredLiquorData),
              ),
            ],
          ),
        ),
      ),
    );
  }
}