import 'package:cloud_firestore/cloud_firestore.dart';

class UserDb {
  final String uid;

  UserDb({required this.uid});

  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  Future<void> updateUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
     String? img,
  }) async {
    try {
      await userCollection.doc(uid).set({
        'fullName': name,
        'email': email,
        'phone': phone,
        'image': img,
        'role': role,
        'password':password,

      });
      print("Consumer data successfully updated in Firestore.");
    } catch (e) {
      print("Error updating consumer data: $e");
      rethrow;
    }
  }
}