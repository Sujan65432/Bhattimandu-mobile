import 'dart:convert';
import 'dart:typed_data';
import 'package:bhattimandu/components/app_header.dart';
import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/database/cart_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> activeOrders = [];
  List<Map<String, dynamic>> completedOrders = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchOrder();
  }

  Future<void> fetchOrder() async {
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      final fetchedActiveOrders = await MyCartController().getSellerOrderItems(
        uuid: user!.uid,
        context: context,
        status: 'pending',
      );
      final fetchedCompletedOrders = await MyCartController().getSellerOrderItems(
        uuid: user.uid,
        context: context,
        status: 'completed',
      );
      setState(() {
        activeOrders = fetchedActiveOrders;
        completedOrders = fetchedCompletedOrders;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load orders. Please try again.";
        isLoading = false;
      });
    }
  }


  Future<void> deleteOrder(String id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      final fetchedActiveOrders = await MyCartController().deleteOrder(
        context: context, orderId: id,
      );
      fetchOrder();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load orders. Please try again.";
        isLoading = false;
      });
    }
  }

  Future<void> updateOrder(String id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      final fetchedActiveOrders = await MyCartController().updateOrder(
        context: context, orderId: id,status: 'completed'
      );
      fetchOrder();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to updaye orders. Please try again.";
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildOrderList(String status) {
    List<Map<String, dynamic>> orders = (status == "Active Orders")
        ? activeOrders
        : completedOrders;

    if (isLoading) {
      return const BhattiLoader();
    }

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No $status",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final base64Image = order['image'] ?? '';
        Uint8List? imageBytes;

        if (base64Image.isNotEmpty) {
          try {
            imageBytes = base64Decode(base64Image);
          } catch (e) {
            debugPrint("Error decoding Base64: $e");
          }
        }

        return Card(
          color: const Color(0xff2C2C3E),
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: imageBytes != null
                ? Image.memory(imageBytes, width: 50, height: 50)
                : Image.asset(
              'images/beer.png',
              width: 50,
              height: 50,
            ),
            title: Text(
              order["liquorName"] ?? "Unknown",
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "Rs. ${order['totalPrice'] ?? 'N/A'}",
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Qty: ${order['quantity'] ?? 0}",
                  style: const TextStyle(color: Colors.white),
                ),
                if (status == "Active Orders")
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.red),
                        onPressed: () {
                          updateOrder(order['id']);
                        },
                      ),const SizedBox(width:1),
                      IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () {
                          deleteOrder(order['id']);
                        },
                      ),
                    ],
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const BhattiLoader(): Scaffold(
      body: Column(
        children: [
          const AppHeader(title: 'My Order'),
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Active Orders"),
              Tab(text: "Completed"),
            ],
            labelColor: Colors.green,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.green,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList("Active Orders"),
                _buildOrderList("Completed Orders"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
