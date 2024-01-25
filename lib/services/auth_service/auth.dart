import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/utils/utils.dart';

class AuthService {
  static Future<User?> signUpWithEmailAndPass(
      UserModel userModel, BuildContext context) async {
    try {
      UserCredential credential = await Utils.auth
          .createUserWithEmailAndPassword(
              email: userModel.email, password: userModel.password);
      User? user = credential.user;

      // Create a user document in Firestore based on the role
      if (user != null) {
        CollectionReference userCollection;

        switch (userModel.role) {
          case 'Company Admin':
            userCollection = Utils.companyAdminsRef;
            break;
          case 'Job Seeker':
            userCollection = Utils.jobSeekersRef;
            break;
          default:
            // Handle other roles or throw an exception
            throw Exception('Invalid role');
        }

        userModel.id = user.uid;

        await userCollection.doc(user.uid).set(userModel.toMap());
      }

      return user;
    } catch (e) {
      Utils.showSnackBar(context, "signUpWithEmailAndPass: ${e.toString()}");
      return null;
    }
  }

  static Future<dynamic> signInWithEmailAndPass(
      String email, String password, String role, BuildContext context) async {
    try {
      UserCredential credential = await Utils.auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch additional user information from Firestore based on the role and authId
      if (credential.user != null) {
        String authId = credential.user!.uid;

        CollectionReference firestorePath;
        switch (role) {
          case "Job Seeker":
            firestorePath = Utils.jobSeekersRef;
            break;
          case "Super Admin":
            firestorePath = Utils.superAdminsRef;
            break;
          case "Company Admin":
            firestorePath = Utils.companyAdminsRef;
            break;
          default:
            firestorePath = Utils.jobSeekersRef;
        }

        DocumentSnapshot userSnapshot = await firestorePath.doc(authId).get();
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        late final userModel;
        if (userData != null) {
          userModel = UserModel.fromMap(userData);
          Utils.showSnackBar(
              context, "User successfully signed in: $userModel");
        } else {
          Utils.showSnackBar(context, "User data not found in Firestore.");
        }

        return userModel;
      } else {
        Utils.showSnackBar(context, "Authentication failed.");
      }
    } catch (e) {
      Utils.showSnackBar(context, "signInWithEmailAndPass: ${e.toString()}");
    }
  }
}
