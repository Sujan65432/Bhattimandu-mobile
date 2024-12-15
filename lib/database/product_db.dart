import 'package:cloud_firestore/cloud_firestore.dart';

class LiquorDatabaseService {
  final String createdBy;

  LiquorDatabaseService({required this.createdBy});

  final CollectionReference liquorCollection =
      FirebaseFirestore.instance.collection('liquors');

  Future<void> addLiquorsData({
    required String img,
    required String liquorName,
    required String brandName,
    required String life,
    required String volume,
    required String category,
    required String type,
    required String origin,
    required String price,
    required String stock,
    required String desc,
    required String createdBy,
     required Map<String, dynamic> reviews,
  }) async {
    try {
      DocumentReference docRef = await liquorCollection.add({
        'createdBy': createdBy,
        'liquorName': liquorName,
        'brandName': brandName,
        'life': life,
        'volume': volume,
        'img': img,
        'category': category,
        'type': type,
        'origin': origin,
        'price': price,
        'stock': stock,
        'desc': desc,
        'reviews': reviews,
      });

      print("Liquor added successfully with ID: ${docRef.id}");
    } catch (e) {
      print("Error adding liquor data: $e");
      rethrow;
    }
  }

  Future<void> updateLiquorsData({
    required String createdBy,
    required String img,
    required String liquorName,
    required String brandName,
    required String life,
    required String volume,
    required String category,
    required String type,
    required String origin,
    required String price,
    required String stock,
    required String desc,
    required Map<String, dynamic> reviews,
  }) async {
    try {
      await liquorCollection.doc(createdBy).set({
        'createdBy': createdBy,
        'liquorName': liquorName,
        'brandName': brandName,
        'life': life,
        'volume': volume,
        'img': img,
        'category': category,
        'type': type,
        'origin': origin,
        'price': price,
        'stock': stock,
        'desc': desc,
        'reviews': reviews,
      }, SetOptions(merge: true));

      print("liquor updated successfully in Firestore.");
    } catch (e) {
      print("Error updating liquor data: $e");
      rethrow;
    }
  }
}
