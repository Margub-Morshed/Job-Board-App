import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_board_app/model/company_model.dart';
import 'package:job_board_app/model/super_admin_model.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/utils/utils.dart';

class AuthService {
  static Future<User?> signUpWithEmailAndPassword(
      dynamic model, BuildContext context, String role) async {
    try {
      UserCredential authResult = await Utils.auth
          .createUserWithEmailAndPassword(
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
    CollectionReference userCollection = Utils.getRefPathBasedOnRole(role);
    model.id = user.uid;

    print("_createUserDoc: ${model.toString()}");

    await userCollection.doc(user.uid).set((model).toMap());
  }

  // Private method to fetch user data from Firestsore based on the role
  static Future<dynamic> fetchUserDataFromFireStore(
      String authId, String role) async {
    CollectionReference fireStorePath = Utils.getRefPathBasedOnRole(role);

    DocumentSnapshot userSnapshot = await fireStorePath.doc(authId).get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

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

  static Future<dynamic> companySignInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential authResult = await Utils.auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (authResult.user != null) {
        String authId = authResult.user!.uid;

        final model = await fetchCompanyDataFromFireStore(authId);

        if (model != null) {
          Utils.showSnackBar(context, "Company successfully signed in ✓");
          // Utils.showSnackBar(context, userModel.toString());
          return model;
        } else {
          Utils.showSnackBar(context, "Company data not found in Firestore!");
        }
      } else {
        Utils.showSnackBar(context, "Authentication failed!");
      }
    } catch (e) {
      _handleError(context, "signInWithEmailAndPassword: ${e.toString()}");
    }
  }

  // Private method to fetch user data from Firestsore based on the role
  static Future<dynamic> fetchCompanyDataFromFireStore(String authId) async {
    CollectionReference fireStorePath = Utils.companyAdminsRef;

    DocumentSnapshot userSnapshot = await fireStorePath.doc(authId).get();
    Map<String, dynamic>? userData =
        userSnapshot.data() as Map<String, dynamic>?;

    print(userData);

    return userData != null ? CompanyModel.fromMap(userData) : null;
  }

  static Future adminSignInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential authResult = await Utils.auth
          .signInWithEmailAndPassword(email: email, password: password);

      if (authResult.user != null) {
        String authId = authResult.user!.uid;
        final model = await adminFetchUserDataFromFireStore(authId);

        if (model != null) {
          Utils.showSnackBar(context, "Admin successfully signed in ✓");
          // Utils.showSnackBar(context, userModel.toString());
          return model;
        } else {
          Utils.showSnackBar(context, "Admin data not found in Firestore!");
        }
      } else {
        Utils.showSnackBar(context, "Authentication failed!");
      }
    } catch (e) {
      _handleError(context, "adminSignInWithEmailAndPassword: ${e.toString()}");
    }
  }

  // Private method to fetch user data from Firestsore based on the role
  static Future<SuperAdminModel?> adminFetchUserDataFromFireStore(
      String authId) async {
    CollectionReference fireStorePath = Utils.superAdminsRef;

    DocumentSnapshot adminSnapshot = await fireStorePath.doc(authId).get();
    Map<String, dynamic>? adminData =
        adminSnapshot.data() as Map<String, dynamic>?;
    print(adminData);
    return adminData != null ? SuperAdminModel.fromMap(adminData) : null;
  }


  static Future<void> signOut() async {
    try {
      await Utils.auth.signOut();
      print("User signed out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
