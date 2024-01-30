import 'package:flutter/material.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/login/login_screen.dart';

class SplashServices {
  void navigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    Utils.navigateTo(context, const LoginScreen());
  }
}
