import 'package:bhattimandu/components/alert/quick_alert.dart';
import 'package:bhattimandu/database/my_cart_liquor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyCartController {
  /// Adds an item to the consumer's cart
  Future<void> addCart({
    required BuildContext context,
    required String uuid,
    required String liquorId,
    required String liquorName,
    required String price,
    required String image,
    required String createdBy,
    required String status,
    required String quantity,
  }) async {
    try {
      await MyCartLiquor().addToCart(
          uuid: uuid,
          liquorId: liquorId,
          status: status,
          quantity: quantity,
          liquorName: liquorName,
          createdBy: createdBy,
          image: image,
          price: price);

      // Show success alert
      QuickAlert.showAlert(
        context,
        "Item added to cart successfully!",
        AlertType.success,
      );
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error adding item to cart: $e",
        AlertType.error,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getCartItems(
      {required BuildContext context,
        required String uuid,
        required String status}) async {
    try {
      final cartCollection =
      FirebaseFirestore.instance.collection('liquor_carts');

      final querySnapshot = await cartCollection
          .where('uuid', isEqualTo: uuid)
          .where('status', isEqualTo: status)
          .get();

      final cartItems = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      return cartItems;
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error adding item to cart: $e",
        AlertType.error,
      );
      return [];
    }
  }

  Future<void> placeOrder({
    required BuildContext context,
    required List<Map<String, dynamic>> orderedData,
  }) async {
    try {
      final orderCollection =
      FirebaseFirestore.instance.collection('liquor_orders');
      final myCartCollection =
      FirebaseFirestore.instance.collection('liquor_carts');

      for (var item in orderedData) {
        await orderCollection.add(item);
      }

      for (var item in orderedData) {
        final cartItemRef = myCartCollection.doc(item['cartId']);
        await cartItemRef.update({'status': 'completed'});
      }
      QuickAlert.showAlert(
        context,
        "Order Placed Successfully!!",
        AlertType.success,
      );
    } catch (e) {
      // Show error alert if there's an issue
      QuickAlert.showAlert(
        context,
        "Error placing order $e",
        AlertType.error,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getCustOrderItems(
      {required BuildContext context,
        required String uuid,
        required String status}) async {
    try {
      final orderCollection =
      FirebaseFirestore.instance.collection('liquor_orders');

      final querySnapshot = await orderCollection
          .where('uuid', isEqualTo: uuid)
          .where('status', isEqualTo: status)
          .get();

      final orderItems = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
      return orderItems;
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error adding item to cart: $e",
        AlertType.error,
      );
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getSellerOrderItems(
      {required BuildContext context,
        required String uuid,
        required String status}) async {
    try {
      final orderCollection =
      FirebaseFirestore.instance.collection('liquor_orders');

      final querySnapshot = await orderCollection
          .where('createdBy', isEqualTo: uuid)
          .where('status', isEqualTo: status)
          .get();

      final orderItems = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
      return orderItems;
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error adding item to cart: $e",
        AlertType.error,
      );
      return [];
    }
  }

  Future<void> deleteOrder({
    required BuildContext context,
    required String orderId,
  }) async {
    try {
      final orderCollection =
      FirebaseFirestore.instance.collection('liquor_orders');
      await orderCollection.doc(orderId).delete();
      QuickAlert.showAlert(
        context,
        "Order cancelled successfully",
        AlertType.success,
      );
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error deleting order: $e",
        AlertType.error,
      );
    }
  }

  Future<void> updateOrder({
    required BuildContext context,
    required String orderId, required String status
  }) async {
    try {
      final orderCollection =
      FirebaseFirestore.instance.collection('liquor_orders');
      final orderItem = orderCollection.doc(orderId);
      await orderItem.update({'status': 'completed'});
      QuickAlert.showAlert(
        context,
        "Order completed successfully",
        AlertType.success,
      );
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error deleting order: $e",
        AlertType.error,
      );
    }
  }

  Future<void> updateReview(
      {required BuildContext context,
      required String productId,
      required String customerId,
      required String reviewText,
      required String rating}) async {
    try {
      CollectionReference reviewsCollection = FirebaseFirestore.instance
          .collection('liquors');

      // Create the review map to be updated
      Map<String, dynamic> reviewData = {
        'customerId': customerId,
        'review': reviewText,
        'rating': rating,
      };


      await reviewsCollection.doc(productId).update({
        'reviews': FieldValue.arrayUnion([reviewData])
      });
      QuickAlert.showAlert(
        context,
        "Review Updated Successfully!!",
        AlertType.success,
      );
      print('Review updated successfully!');
    } catch (e) {
      print('Error updating review: $e');
    }
  }
}

