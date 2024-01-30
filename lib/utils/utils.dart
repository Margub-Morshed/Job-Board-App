import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static late double scrHeight;
  static late double scrWidth;

  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseStorage firestorage = FirebaseStorage.instance;

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
          content: Text(message),
          duration: const Duration(seconds: 1)),
    );
  }

  static CollectionReference<Map<String, dynamic>> getRefPathBasedOnRole(
      String role) {
    switch (role) {
      case "Job Seeker":
        return Utils.jobSeekersRef;
      case "Super Admin":
        return Utils.superAdminsRef;
      case "Company Admin":
        return Utils.companyAdminsRef;
      default:
        throw Exception('Invalid role');
    }
  }

  static Future<void> showDateTimePicker(BuildContext context,
      TextEditingController controller) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    void updateJobDeadline() {
      if (selectedDate != null && selectedTime != null) {
        DateTime combinedDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );

        String formattedDateTime =
            DateFormat("d-MMM-yyyy, h:mm a").format(combinedDateTime);

        controller.text = formattedDateTime;
      }
    }

    Future<void> selectTime() async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && pickedTime != selectedTime) {
        selectedTime = pickedTime;
        updateJobDeadline();
      }
    }

    Future<void> selectDate() async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 1),
      );

      if (pickedDate != null && pickedDate != selectedDate) {
        selectedDate = pickedDate;
        selectTime();
      }
    }

    await selectDate();
  }

  static void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
