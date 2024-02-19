
import 'package:flutter/material.dart';
import 'package:job_board_app/view/login/admin_login_screen.dart';
import 'package:job_board_app/view/login/company_login_screen.dart';
import 'package:job_board_app/view/login/login_screen.dart';

import '../../utils/utils.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Utils.scrHeight * 0.02,
          vertical: Utils.scrHeight * 0.02,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Choose Job Type',
                  style: Theme.of(context).textTheme.displayMedium),
              SizedBox(height: Utils.scrHeight * 0.02),
              const Text(
                  'Choose whether you are looking for a job or you are an organization/company that needs employees.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xff686360),
                      fontWeight: FontWeight.w500,
                      fontSize: 16)),
              SizedBox(height: Utils.scrHeight * 0.016),
              Divider(
                  height: Utils.scrHeight * 0.002,
                  color: const Color(0xffEBEBEB)),
              SizedBox(height: Utils.scrHeight * 0.03),

              // Company And User Login Part
              _buildCompanyUserLogin(context),
              SizedBox(height: Utils.scrHeight * 0.04),

              // Super Admin Login Part
              ActionButton(
                onTap: (){
                  Utils.navigateReplaceTo(context, const AdminLoginScreen());
                },
                  buttonName: 'Login Super Admin',
                  buttonColor: Color(0xff246BFD))
            ],
          ),
        ),
      ),
    );
  }

  Row _buildCompanyUserLogin(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomLoginButton(
          onTap: (){
            Utils.navigateReplaceTo(context, const LoginScreen());
          },
          buttonTitle: 'Find a Job',
          buttonDesc: 'I want to find a job for me.',
          icon: Icons.shopping_bag_outlined,
        ),
        SizedBox(width: Utils.scrHeight * 0.01),
        CustomLoginButton(
            onTap: (){
              Utils.navigateReplaceTo(context, const CompanyLoginScreen());
            },
            buttonTitle: 'Find an Employee',
            buttonDesc: 'I want to find employees.',
            icon: Icons.person)
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    required this.buttonName,
    this.onTap,
    this.buttonColor,
  }) : super(key: key);

  final String buttonName;
  final VoidCallback? onTap;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: Utils.scrHeight * 0.05,
        width: Utils.scrHeight * 0.35,
        decoration: BoxDecoration(
          color: buttonColor ?? Colors.transparent,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              buttonName,
              style: const TextStyle(
                color: Colors.white, // Convert Color to int value
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class CustomLoginButton extends StatelessWidget {
  const CustomLoginButton(
      {super.key,
        required this.buttonTitle,
        required this.buttonDesc,
        this.onTap,
        required this.icon});

  final String buttonTitle;
  final IconData icon;
  final String buttonDesc;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(Utils.scrHeight * 0.02),
          height: Utils.scrHeight * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Utils.scrHeight * 0.03),
              border: Border.all(
                color: const Color(0xffEBEBEB),
                width: 2.0,
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: Utils.scrHeight * 0.1,
                  height: Utils.scrHeight * 0.1,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffEFF4FF),
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: const Color(0xff246BFD),
                  )),
              SizedBox(height: Utils.scrHeight * 0.012),
              Text(buttonTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222))),
              SizedBox(height: Utils.scrHeight * 0.012),
              Text(buttonDesc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff8B8885))),
            ],
          ),
        ),
      ),
    );
  }
}
