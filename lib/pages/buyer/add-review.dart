import 'package:bhattimandu/components/loader/bhatti_loader.dart';
import 'package:bhattimandu/components/pages_header.dart';
import 'package:bhattimandu/database/cart_controller.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class AddReview extends StatefulWidget {
  final String productId;
  const AddReview({super.key, required this.productId});

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();
  bool isLoading = false;

  Future<void> addReview(String id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = Provider.of<UserModel?>(context, listen: false);
      await MyCartController().updateReview(
        context: context,
        productId: widget.productId,
        customerId: user!.uid,
        reviewText: _reviewController.text,
        rating: _rating.toString(),
      );

    } catch (e) {
      debugPrint('Error adding review: $e');
      setState(() {
        isLoading = false;
        _reviewController.clear();
        _rating = 0.0;
      });
    } finally {
      setState(() {
        isLoading = false;
        _reviewController.clear();
        _rating = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1C1C2E),
      body: SafeArea(
        child: isLoading
            ? const BhattiLoader()
            : Container(
          width: double.infinity,
          child: Column(
            children: [
              const PagesHeader(title: 'Review', route: '/my_order'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Rate the Product',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'lovelo',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: RatingBar.builder(
                          initialRating: _rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Write a Review',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'lovelo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _reviewController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: 'Share your experience...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_rating == 0.0 || _reviewController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please provide a rating and review.'),
                                ),
                              );
                              return;
                            }
                            await addReview(widget.productId);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 10.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Submit Review',
                            style: TextStyle(
                              fontFamily: 'lovelo',
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
