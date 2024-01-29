import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_board_app/model/company_model.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/utils/utils.dart';

class AuthService {
  static Future<User?> signUpWithEmailAndPassword(
      dynamic model, BuildContext context, String role) async {
    try {
      UserCredential authResult = await Utils.auth.createUserWithEmailAndPassword(
          email: model.email, password: model.password);
      User? user = authResult.user;

      // Create a user document in Firestore based on the role
      if (user != null) {
      await _createUserDocument(user!, model, role);
      }
      return user;
    } catch (e) {
      _handleError(context, "signUpWithEmailAndPassword: ${e.toString()}");
      return null;
    }
  }

  static Future<dynamic> signInWithEmailAndPassword(
      String email, String password, String role, BuildContext context) async {
    try {
      UserCredential authResult = await Utils.auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (authResult.user != null) {
        String authId = authResult.user!.uid;

        final model = await fetchUserDataFromFireStore(authId, role);

        if (model != null) {
          Utils.showSnackBar(context, "User successfully signed in ✓");
          // Utils.showSnackBar(context, userModel.toString());
          return model;
        } else {
          Utils.showSnackBar(context, "User data not found in Firestore!");
        }
      } else {
        Utils.showSnackBar(context, "Authentication failed!");
      }
    } catch (e) {
      _handleError(context, "signInWithEmailAndPassword: ${e.toString()}");
    }
  }

  // Private method to create a user document in Firestore
  static Future<void> _createUserDocument(
      User user, dynamic model, String role) async {
    CollectionReference userCollection =
    Utils.getRefPathBasedOnRole(role);
    model.id = user.uid;

    print("_createUserDoc: ${model.toString()}");

    await userCollection.doc(user.uid).set((model).toMap());
  }

  // Private method to fetch user data from Firestsore based on the role
  static Future<dynamic> fetchUserDataFromFireStore(String authId, String role) async {
    CollectionReference fireStorePath = Utils.getRefPathBasedOnRole(role);

    DocumentSnapshot userSnapshot = await fireStorePath.doc(authId).get();
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

    print(userData);

    return userData != null
        ? (role == "Company Admin"
        ? CompanyModel.fromMap(userData)
        : UserModel.fromMap(userData))
        : null;
  }

  // Private method to handle errors and show a snackbar
  static void _handleError(BuildContext context, String errorMessage) {
    Utils.showSnackBar(context, errorMessage);
  }
}
