import 'package:bhattimandu/components/form/custom_bhatti_btn.dart';
import 'package:bhattimandu/components/pages_header.dart';
import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _addressController = TextEditingController();
  String? selectedPaymentMethod;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? data =
    ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (data == null || data['cartItems'] == null || data['totalPrice'] == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Invalid data passed.",
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    final List<Map<String, dynamic>> cartItems =
    List<Map<String, dynamic>>.from(data['cartItems']);
    final int totalPrice = int.tryParse(data['totalPrice'].toString()) ?? 0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const PagesHeader(title: 'Payment', route: '/my_cart'),
            const SizedBox(height: 10),
            const StepProgressBar(currentStep: 1),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _addressController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your delivery address",
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Payment Methods",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _paymentMethodTile("Khalti", Icons.account_balance_wallet,
                          Colors.red.shade600),
                      _paymentMethodTile("Esewa", Icons.payment, Colors.green),
                      _paymentMethodTile(
                          "Cash on Delivery", Icons.money, Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: CustomBhattiBtn(
                text: 'Place Order',
                onPressed: () {
                  if (_addressController.text.isEmpty ||
                      selectedPaymentMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all details."),
                      ),
                    );
                    return;
                  }

                  final combinedData = cartItems.map((item) {
                    final price = int.tryParse(item['price']?.toString() ?? '0') ?? 0;
                    final quantity =
                        int.tryParse(item['quantity']?.toString() ?? '0') ?? 0;
                    final indTotal = price * quantity;

                    return {
                      'cartId': item['cartId'],
                      'liquorId': item['liquorId'] ?? '',
                      'uuid': item['uuid'] ?? '',
                      'liquorName': item['liquorName'] ?? '',
                      'quantity': quantity.toString(),
                      'totalPrice': item['totalPrice'] ?? '',
                      'createdBy': item['createdBy'],
                      'delivery': _addressController.text,
                      'image': item['image'] ?? '',
                      'payment_method': selectedPaymentMethod ?? '',
                    };
                  }).toList();

                  Navigator.pushReplacementNamed(
                    context,
                    '/summary',
                    arguments: {
                      'orderDetails': combinedData,
                      'totalPrice': totalPrice,
                      'delivery': _addressController.text,
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentMethodTile(String title, IconData icon, Color iconColor) {
    final isSelected = selectedPaymentMethod == title;

    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.green : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      tileColor: isSelected ? Colors.green.shade100 : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: () {
        setState(() {
          selectedPaymentMethod = title;
        });
      },
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
          isActive: currentStep >= 1,
          isCompleted: currentStep > 1,
          stepNumber: 1,
          label: 'Payment',
        ),
        _buildStepDivider(isCompleted: currentStep > 1),
        _buildStepCircle(
          isActive: currentStep >= 2,
          isCompleted: currentStep > 2,
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
                color: isActive || isCompleted
                    ? Colors.white
                    : Colors.black,
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
