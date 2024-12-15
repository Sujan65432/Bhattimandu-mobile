import 'package:cloud_firestore/cloud_firestore.dart';

class MyCartLiquor {
  final CollectionReference myCartCollection =
  FirebaseFirestore.instance.collection('liquor_carts');

  MyCartLiquor();

  /// Adds or updates an item in the cart
  Future<void> addToCart(
      {required String uuid,
        required String liquorId,
        required String status,
        required String quantity,
        required String liquorName,
        required String createdBy,
        required String image,
        required String price
      }) async {
    try {
      DocumentReference docRef = await myCartCollection.add({
        'uuid': uuid,
        'liquorId': liquorId,
        'status': status,
        'quantity': quantity,
        'liquorName': liquorName,
'image':image,
        'createdBy':createdBy,
        'price': price,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      print("Cart data successfully updated in Firestore.");
    } catch (e) {
      print("Error updating cart data: $e");
      rethrow;
    }
  }
}
