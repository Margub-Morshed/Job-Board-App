import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/home/super_admin_home_screen.dart';

import '../../services/auth/auth_service.dart';
import '../../utils/validation.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Align(
          heightFactor: 1.0,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                const SizedBox(height: 40),

                // Header Section
                const Text('Log In As Admin',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 38,
                        color: Color(0xff1E1F20))),
                const SizedBox(height: 9),
                const Text('Welcome back!',
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Color(0xff1E1F20))),
                const SizedBox(height: 44),

                // Input Your Email
                const Text('EMAIL',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xff1E1F20))),
                const SizedBox(height: 8),
                buildEmailSection(),
                const SizedBox(height: 24),

                // Input Your Password
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1E1F20)),
                ),
                const SizedBox(height: 8),
                buildPasswordSection(),
                const SizedBox(height: 26),

                // Login button for login with email and password
                _buildLoginButton(context),
                const SizedBox(height: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xff5872de)),
      ),
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        User? user = await AuthService.adminSignInWithEmailAndPassword(
                _emailController.text.trim(),
                _passwordController.text.trim(),
                context)
            .then((value) {
          if (value != null) {
            SessionManager.setSuperAdminModel(value);
            setState(() {
              isLoading = false;
            });
            print(value.toString());
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return const SuperAdminHomeScreen();
              },
            ));
          } else {
            Utils.showSnackBar(context, "Admin Login Screen Problem Occurred!");
          }
          return null;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Utils.scrHeight * .015),
        child: !isLoading ? Text(
          'Log In',
          style: TextStyle(
              color: Colors.white,
              fontSize: Utils.scrHeight * .022, fontWeight: FontWeight.w400),
        ) : const Center(child: CircularProgressIndicator(color: Colors.white,),),
      ),
    );
  }

  TextFormField buildEmailSection() {
    return TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(borderSide: BorderSide(width: 5)),
            hintText: 'example@email.com',
            hintStyle: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email address.';
          } else if (!Validation.isValidEmail(value)) {
            return 'Please enter a valid email address.';
          }
          return null;
        });
  }

  TextFormField buildPasswordSection() {
    return TextFormField(
        controller: _passwordController,
        keyboardType: TextInputType.text,
        obscureText: isObscure,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(borderSide: BorderSide(width: 5)),
            hintText: '* * * * * *',
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                    !isObscure
                        ? Icons.visibility_off_outlined
                        : Icons.remove_red_eye_outlined,
                    color: const Color(0xff1E1F20),
                    size: 24))),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password.';
          } else if (value.length < 6) {
            return 'Password must be at least 6 characters long.';
          }
          // You can add more password validation criteria as needed
          return null;
        });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
