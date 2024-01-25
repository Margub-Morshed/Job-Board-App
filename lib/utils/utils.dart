import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Utils {
  static late double scrHeight;
  static late double scrWidth;

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final jobSeekersRef = _firestore.collection('job_seekers');
  static final companyAdminsRef = _firestore.collection('company_admins');
  static final superAdminsRef = _firestore.collection('super_admins');

  static void initScreenSize(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    scrHeight = size.height;
    scrWidth = size.width;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.deepOrangeAccent,
          content: Text(message), duration: const Duration(seconds: 5)),
    );
  }
}
