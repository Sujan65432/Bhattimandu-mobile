import 'package:bhattimandu/components/alert/quick_alert.dart';
import 'package:bhattimandu/database/product_db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class LiquorService {
  Future<void> addLiquor(
      BuildContext context,
      String img,
      String liquorName,
      String brandName,
      String life,
      String volume,
      String category,
      String type,
      String origin,
      String stock,
      String desc,
      String price,
      String? createdBy, {
        String? review,
      }) async {
    try {
      if (liquorName.isEmpty || category.isEmpty || desc.isEmpty || price.isEmpty || stock.isEmpty) {
        throw Exception('All fields must be filled.');
      }

      LiquorDatabaseService liquorDatabaseService = LiquorDatabaseService(createdBy: createdBy!);
      await liquorDatabaseService.addLiquorsData(
        img: img,
        liquorName: liquorName,
        brandName: brandName,
        price: price,
        stock: stock,
        life: life,
        origin: origin,
        volume: volume,
        desc: desc,
        reviews: {},
        category: category,
        type: type, createdBy: createdBy,
      );

      QuickAlert.showAlert(
        context,
        "Liquor added successfully!",
        AlertType.success,
      );
    } catch (e) {
      print("Error in addLiquor: $e");
      QuickAlert.showAlert(
        context,
        "Failed to add liquor: ${e.toString()}",
        AlertType.error,
      );
    }
  }



  Future<List<Map<String, dynamic>>> getUserByID(String uid) async {

    try {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userSnapshot.exists) {
        return [];
      }

      final data = userSnapshot.data() as Map<String, dynamic>;
      return [
        {
          'user': {...data, 'id': userSnapshot.id},
        }
      ];
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getSellerByID(String uid) async {
    try {

      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, isEqualTo: uid)
          .where('role', isEqualTo: 'seller')
          .get();

      if (userSnapshot.docs.isEmpty) {
        return [];
      }

      final data = userSnapshot.docs.first.data() as Map<String, dynamic>;
      return [
        {
          'user': {...data, 'id': userSnapshot.docs.first.id},
        }
      ];
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }
  Future<List<Map<String, dynamic>>> getBuyerByID(String uid) async {
    try {

      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, isEqualTo: uid)
          .where('role', isEqualTo: 'buyer')
          .get();

      if (userSnapshot.docs.isEmpty) {
        return [];
      }

      final data = userSnapshot.docs.first.data() as Map<String, dynamic>;
      return [
        {
          'user': {...data, 'id': userSnapshot.docs.first.id},
        }
      ];
    } catch (e) {
      throw Exception("Failed to fetch user data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getLiquors() async {
    try {
      final QuerySnapshot liquorSnapshot = await FirebaseFirestore.instance
          .collection('liquors')
          .get();


      return liquorSnapshot.docs.map((liquorDoc) {
        final liquorData = liquorDoc.data() as Map<String, dynamic>;
        return {
          'liquor': {...liquorData, 'id': liquorDoc.id},

        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch liquors with user data: $e");
    }
  }
  Future<List<Map<String, dynamic>>> getAllLiquorsWithUser() async {
    try {
      final QuerySnapshot liquorSnapshot = await FirebaseFirestore.instance
          .collection('liquors')
          .get();

      final userIds = liquorSnapshot.docs
          .map((doc) => doc['createdBy'] as String)
          .toSet();

      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds.toList())
          .get();

      final userMap = {
        for (var doc in userSnapshot.docs) doc.id: doc.data() as Map<String, dynamic>
      };

      return liquorSnapshot.docs.map((liquorDoc) {
        final liquorData = liquorDoc.data() as Map<String, dynamic>;
        final userId = liquorData['created_by'];
        final userData = userMap[userId];
        return {
          'liquor': {...liquorData, 'id': liquorDoc.id},
          'user': userData,
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch liquors with user data: $e");
    }
  }
  Future<List<Map<String, dynamic>>> getLiquorsById(String? id) async {
    try {
      final DocumentSnapshot liquorSnapshot = await FirebaseFirestore.instance
          .collection('liquors')
          .doc(id)
          .get();

      if (!liquorSnapshot.exists) {
        return [];
      }

      final liquorData = liquorSnapshot.data() as Map<String, dynamic>;
      return [
        {
          'liquor': {...liquorData, 'id': liquorSnapshot.id},
        }
      ];
    } catch (e) {
      throw Exception("Failed to fetch liquor data: $e");
    }
  }
  Future<List<Map<String, dynamic>>> getAllLiquorsCatWithUsers(String category) async {
    try {
      final QuerySnapshot liquorSnapshot = await FirebaseFirestore.instance
          .collection('liquors')
          .where('category', isEqualTo: category)
          .get();

      final userIds = liquorSnapshot.docs
          .map((doc) => doc['user_id'] as String)
          .toSet();

      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds.toList())
          .get();

      final userMap = {
        for (var doc in userSnapshot.docs) doc.id: doc.data() as Map<String, dynamic>
      };

      return liquorSnapshot.docs.map((liquorDoc) {
        final liquorData = liquorDoc.data() as Map<String, dynamic>;
        final userId = liquorData['user_id'];
        final userData = userMap[userId];
        return {
          'liquor': {...liquorData, 'id': liquorDoc.id},
          'user': userData,
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch liquors with user data: $e");
    }
  }
  Future<List<Map<String, dynamic>>> getLiquorsByCategory(String category) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('liquors')
          .where('category', isEqualTo: category)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs.map((doc) {
        final liquorData = doc.data() as Map<String, dynamic>;
        return {'liquor': {...liquorData, 'id': doc.id}
        };  // Add the doc ID to the data
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch liquors by category: $e");
    }
  }




  Future<List<Map<String, dynamic>>> getLiquorsByCategoryAndUserWithDetails(
      String category, String userId) async {
    try {

      print(userId);
      final QuerySnapshot liquorSnapshot = await FirebaseFirestore.instance
          .collection('liquors')
          .where('category', isEqualTo: category)
          .where('createdBy', isEqualTo: userId)
          .get();

      if (liquorSnapshot.docs.isEmpty) {
        return [];
      }

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('user with ID $userId does not exist.');
      }

      final userData = userDoc.data() as Map<String, dynamic>;

      return liquorSnapshot.docs.map((liquorDoc) {
        final liquorData = liquorDoc.data() as Map<String, dynamic>;
        return {
          'liquor': {...liquorData, 'id': liquorDoc.id},
          'user': {...userData, 'id': userDoc.id},
        };
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch liquors and user data: $e");
    }
  }

  // Future<Map<String, dynamic>?> getliquorByuserAndliquorId(
  //     String liquorId, String userId) async {
  //   try {
  //     final querySnapshot = await FirebaseFirestore.instance
  //         .collection('liquors')
  //         .where(FieldPath.documentId, isEqualTo: liquorId)
  //         .where('user_id', isEqualTo: userId)
  //         .get();
  //     if (querySnapshot.docs.isEmpty) {
  //       throw Exception("No matching liquor found for user with ID $userId.");
  //     }
  //     final liquorDoc = querySnapshot.docs.first;
  //     final liquorData = liquorDoc.data();
  //     if (liquorData['user_id'] != userId) {
  //       throw Exception("liquor does not belong to user with ID $userId.");
  //     }
  //     final userSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .get();
  //
  //     if (!userSnapshot.exists) {
  //       throw Exception("user with ID $userId does not exist.");
  //     }
  //     final userData = userSnapshot.data() as Map<String, dynamic>;
  //     return {
  //       'liquor': {...liquorData, 'id': liquorDoc.id},
  //       'user': {...userData, 'id': userSnapshot.id},
  //     };
  //   } catch (e) {
  //     throw Exception("Failed to fetch liquor and user data: $e");
  //   }
  // }
  Future updateLiquor(
      BuildContext context, String liquorId, Map<String, dynamic> updates) async {
    try {

      DocumentReference liquorDocRef =
      FirebaseFirestore.instance.collection('liquors').doc(liquorId);


      await liquorDocRef.update(updates);

      QuickAlert.showAlert(
        context,
        "Liquor updated successfully!",
        AlertType.success,
      );
    } catch (e) {
      // Handle and display error alert
      QuickAlert.showAlert(
        context,
        "Error updating liquor profile: ${e.toString()}",
        AlertType.error,
      );
    }
  }


}

