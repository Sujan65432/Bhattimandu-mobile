import 'package:bhattimandu/components/card/Layout.dart';
import 'package:bhattimandu/components/customer_liquor/liquorLayout.dart';
import 'package:bhattimandu/components/pages_header.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:bhattimandu/pages/buyer/filterLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'dart:async'; // For debouncing the search

class FilterDashboard extends StatefulWidget {
  const FilterDashboard({super.key});

  @override
  State<FilterDashboard> createState() => _FilterDashboardState();
}

class _FilterDashboardState extends State<FilterDashboard> {
  bool isLoading = true;
  List<Map<String, dynamic>> liquorData = [];
  List<Map<String, dynamic>> filteredLiquorData = [];
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fetchLiquors();
    searchController.addListener(_filterLiquors);
  }

  // Debounced search filtering function
  void _filterLiquors() {
    final query = searchController.text.toLowerCase();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        filteredLiquorData = query.isEmpty
            ? liquorData
            : liquorData.where((liquor) {
          final liquorName = liquor['liquor'] != null
              ? liquor['liquor']!['liquorName']?.toLowerCase() ?? ''
              : '';
          return liquorName.contains(query);
        }).toList();
      });
    });
  }

  void _performSearch() {
    // Manually trigger search filtering
    _filterLiquors();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel(); // Cancel the debounce timer when the widget is disposed
    super.dispose();
  }

  Future<void> fetchLiquors() async {
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      final lqData = await LiquorService().getLiquors();

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        liquorData = lqData;
        filteredLiquorData = lqData;
      });
      print(lqData);
    } catch (e) {
      if (!mounted) return; // Ensure that we only update if still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load liquors. Please try again later.')),
      );
      print("Error fetching Liquors or user data: $e");
    } finally {
      if (!mounted) return; // Ensure that we only update if still mounted
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
      child: SpinKitThreeInOut(color: Color(0xff4B6F39), size: 50.0),
    )
        : Column(
      children: [
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
              : FilterLayout(categories: filteredLiquorData),
        ),
      ],
    );
  }
}
