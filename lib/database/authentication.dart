import 'package:bhattimandu/components/alert/quick_alert.dart';
import 'package:bhattimandu/database/user_db.dart';
import 'package:bhattimandu/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _userFromFirebaseUser(User? user, Map<String, dynamic>? userData) {
    return user != null && userData != null
        ? UserModel(
            uid: user.uid,
            email: userData['email'] ?? '',
            password: '',
            role: userData['role'] ?? '',
          )
        : null;
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((User? user) async {
      if (user == null) return null;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) return null;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return _userFromFirebaseUser(user, userData);
    });
  }

  Future<bool> registration(
      BuildContext context,
      String email,
      String password,
      String fullName,
      String phone,
      String role,
      String? img,
      ) async {
    try {
      if (role != 'seller' && role != 'buyer') {
        QuickAlert.showAlert(
          context,
          "Incorrect role specified!!",
          AlertType.error,
        );
        return false;
      }
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user == null) {
        QuickAlert.showAlert(
          context,
          "Registration failed!!",
          AlertType.error,
        );
        return false;
      }
      await UserDb(uid: user.uid).updateUser(
        name: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
        img: img ?? "",
      );
      QuickAlert.showAlert(
        context,
        "User Registered",
        AlertType.success,
      );
      print("User registered successfully as $role: ${user.uid}");
      return true;
    } catch (e) {
      print("$e");
      QuickAlert.showAlert(
        context,
        "Error: $e",
        AlertType.error,
      );
      return false;
    }
  }

  Future<UserModel?> logIn(
      BuildContext context, String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      QuickAlert.showAlert(
        context,
        "User Logged In",
        AlertType.success,
      );
      User? user = result.user;
      if (user == null) {
        QuickAlert.showAlert(
          context,
          "Login failed! Please try again!",
          AlertType.error,
        );
        return null;
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        QuickAlert.showAlert(
          context,
          "User not found!!",
          AlertType.error,
        );
        return null;
      }

      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      return _userFromFirebaseUser(user, data);
    } catch (e) {
      print(e);
      QuickAlert.showAlert(
        context,
        "Error during login: ${e.toString()}",
        AlertType.error,
      );
      return null;
    }
  }

  
  Future resetPassword(BuildContext context, email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      QuickAlert.showAlert(
        context,
        'Email  sent to your Gmail account!',
        AlertType.success,
      );
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Email does not exist",
        AlertType.error,
      );
    }
  }

  Future<void> userSignOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Navigator.pushReplacementNamed(context, '/sign_in');
      QuickAlert.showAlert(
        context,
        "You have successfully logged out.",
        AlertType.success,
      );
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error during logout: ${e.toString()}",
        AlertType.error,
      );
    }
  }

  Future<void> updateUserImage(
      BuildContext context, String uid, String imageUrl) async {
    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(uid);
      await userDocRef.update({
        'image': imageUrl,
      });
      QuickAlert.showAlert(
        context,
        "User image updated successfully!",
        AlertType.success,
      );
    } catch (e) {
      QuickAlert.showAlert(
        context,
        "Error updating user image: ${e.toString()}",
        AlertType.error,
      );
    }
  }


  Future<void> updateUserProfile(
      BuildContext context, String uuid, Map<String, dynamic> updates) async {
    try {
      DocumentReference userDocRef =
      FirebaseFirestore.instance.collection('users').doc(uuid);

      await userDocRef.update(updates);

      QuickAlert.showAlert(
        context,
        "User profile updated successfully!",
        AlertType.success,
      );
    } catch (e) {
      // Handle and display error alert
      QuickAlert.showAlert(
        context,
        "Error updating user profile: ${e.toString()}",
        AlertType.error,
      );
    }
  }
}
