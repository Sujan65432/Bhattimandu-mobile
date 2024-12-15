import 'dart:convert';
import 'dart:typed_data';
import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/pages_header.dart';
import 'package:bhattimandu/database/cart_controller.dart';
import 'package:bhattimandu/database/product_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({Key? key}) : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  Map<String, dynamic>? buyerData;
  bool isLoadingbuyer = false;


 void placeOrder() async {
   setState(() {
     bool isLoadingbuyer = true;
   });
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final orderedItems = List<Map<String, dynamic>>.from(data?['orderDetails'] ?? []);


    try {
      final combinedData = orderedItems.map((item) {
        return {
          'cartId':item['cartId'],
          'status':'pending',
          'liquorId': item['liquorId'] ?? '',
          'uuid': item['uuid'] ?? '',
          'liquorName': item['liquorName'] ?? '',
          'quantity': item['quantity'],
          'totalPrice': item['totalPrice'],
          'createdBy': item['createdBy'],
          'delivery': item['delivery'],
          'image': item['image'] ?? '',
          'payment_method': item['payment'] ?? '',
        };
      }).toList();

      final fetchedItems = await MyCartController().placeOrder(
        context: context, orderedData: combinedData,
      );
      setState(() {
        isLoadingbuyer = false;
      });
      Navigator.pushReplacementNamed(context, '/my_order');
    } catch (e) {

      setState(() {
        isLoadingbuyer = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error placing order: $e')));
    }
  }

  Future<void> fetchBuyerData() async {
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      if (user == null || user.uid.isEmpty) {
        setState(() {
          isLoadingbuyer = false;
          buyerData = null;
        });
        return;
      }
      final data = await LiquorService().getBuyerByID(user.uid);
      setState(() {
        buyerData = data.isNotEmpty ? data[0]['user'] : null;
        isLoadingbuyer =
            false;
      });
    } catch (e) {
      print("Error fetching buyer data: $e");
      setState(() {
        isLoadingbuyer = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBuyerData();
  }

  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final orderedItems =
        List<Map<String, dynamic>>.from(data?['orderDetails'] ?? []);
    final totalPrice = data?['totalPrice'] ?? 0;
    final delivery = data?['delivery'] ?? 'No Address';

    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoadingbuyer
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                width:double.infinity,
                child: Column(
                  children: [
                    const PagesHeader(title: 'Order Summary', route: '/my_cart'),
                    const SizedBox(height: 30),
                    const StepProgressBar(currentStep: 2),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _buildAddressSection(delivery),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _buildPriceDetails(totalPrice),
                    ),
                    const Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            if (orderedItems.isEmpty)
                              const Center(
                                child: Text(
                                  'No items in your cart.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: orderedItems.length,
                                itemBuilder: (context, index) =>
                                    _buildCartItem(orderedItems[index]),
                              ),
                          ],
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 12.0),
                      child: CustomBhattiBtn(
                        text: 'Confirm Order',
                        onPressed:placeOrder,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAddressSection(String delivery) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Delivery to",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lovelo',
                    color: Colors.white),
              ),
              Text(delivery,
                  style: const TextStyle(
                      fontFamily: 'lovelo', color: Colors.white)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Contact Number",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'lovelo',
                    color: Colors.white),
              ),
              Text(
                buyerData?['phone'] ?? 'No Phone Available',
                style:
                    const TextStyle(fontFamily: 'lovelo', color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(int totalPrice) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          _buildPriceRow("Sub Total", "₹${totalPrice - 0}"),
          _buildPriceRow("Delivery", "₹0"),
          _buildPriceRow(
            "Total",
            "₹$totalPrice",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'lovelo',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'lovelo',
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    final base64Image = item['image'] ?? '';
    Uint8List? imageBytes;
print(item['totalPrice']);
    try {
      if (base64Image.isNotEmpty) {
        imageBytes = base64Decode(base64Image);
      }
    } catch (e) {
      debugPrint("Error decoding Base64: $e");
    }

    return Card(
      color: const Color(0xff2C2C3E),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 80,
          child: imageBytes != null
              ? Image.memory(imageBytes, fit: BoxFit.cover)
              : const Icon(Icons.broken_image, color: Colors.grey),
        ),
        title: Text(
          item['liquorName'] ?? 'Unknown',
          style: const TextStyle(fontFamily: 'lovelo', color: Colors.white),
        ),
        subtitle: Text(
          "Rs. ${item['totalPrice'] ?? ''}",
          style: const TextStyle(fontFamily: 'lovelo', color: Colors.white),
        ),
        trailing: Text(
          "${item['quantity'] ?? 0}",
          style: const TextStyle(fontFamily: 'lovelo', color: Colors.white),
        ),
      ),
    );
  }
}

class StepProgressBar extends StatelessWidget {
  final int currentStep;

  const StepProgressBar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(
          isActive: false,
          isCompleted: true,
          stepNumber: 1,
          label: 'Payment',
        ),
        _buildStepDivider(isCompleted: currentStep > 1),
        _buildStepCircle(
          isActive: true,
          isCompleted: false,
          stepNumber: 2,
          label: 'Summary',
        ),

      ],
    );
  }

  Widget _buildStepCircle({
    required bool isActive,
    required bool isCompleted,
    required int stepNumber,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.purple
                : isCompleted
                    ? Colors.green
                    : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      color:
                          isActive || isCompleted ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive || isCompleted ? Colors.white : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider({required bool isCompleted}) {
    return Container(
      width: 70,
      height: 2,
      color: isCompleted ? Colors.green : Colors.grey,
    );
  }
}
