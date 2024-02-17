
import 'package:flutter/material.dart';
import 'package:job_board_app/services/login_session/login_session.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/home/company_admin_home_screen.dart';
import 'package:job_board_app/view/home/job_seeker_home_screen.dart';
import 'package:job_board_app/view/home/super_admin_home_screen.dart';
import 'package:job_board_app/view/login/login_screen.dart';

class SplashServices {
  void navigate(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3), () async {
      // if (await LoginSession.isLoggedIn()) {
      //   print(LoginSession.getRole());
      //   if (await LoginSession.getRole() == 'Job Seeker') {
      //     Utils.navigateTo(context, const JobSeekerHomeScreen());
      //   } else if (await LoginSession.getRole() == 'Company Admin') {
      //     Utils.navigateTo(context, const CompanyAdminHomeScreen());
      //   } else {
      //     Utils.navigateTo(context, const SuperAdminHomeScreen());
      //   }
      // } else {
      //   print(LoginSession.getRole());
      //   print(LoginSession.isLoggedIn());
      //   Utils.navigateTo(context, const LoginScreen());
      // }
      Utils.navigateTo(context, const LoginScreen());
    });
  }

  // void _checkAuthStatus(BuildContext context) async {
  //   // Check if user is already signed in
  //   User? user = Utils.auth.currentUser;
  //   if (user != null) {
  //     // If user is signed in, navigate to the home screen
  //     Utils.navigateTo(context, const LoginScreen());
  //   } else {
  //     // If user is not signed in, navigate to the authentication screen
  //     // You can replace `AuthScreen` with your authentication screen
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (context) => const LoginScreen()),
  //     );
  //   }
  // }
}
