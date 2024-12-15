import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrder {
  final CollectionReference orderCollection =
  FirebaseFirestore.instance.collection('liquors_order');

  MyOrder();

  Future<void> addToCart(
      {required String liquorId,
        required String uuid,
        required String liquorName,
        required String quantity,
        required String totalPrice,
        required String createdBy,
        required String image,
        required String paymentMethod,
        required String status

      }) async {
    try {

      DocumentReference docRef = await orderCollection.add({
        'uuid': uuid,
        'liquorId': liquorId,
        'status': status,
        'quantity': quantity,
        'liquorName': liquorName,
        'image':image,
        'createdBy':createdBy,
        'payment': paymentMethod,
        'price': totalPrice,
        'updatedAt': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      print("Error updating cart data: $e");
      rethrow;
    }
  }
}
