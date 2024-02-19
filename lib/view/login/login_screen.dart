import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/login/company_login_screen.dart';
import 'package:job_board_app/view/register/register_screen.dart';

import '../../services/auth/auth_service.dart';
import '../../utils/validation.dart';
import '../home/job_seeker_home_screen.dart';
import '../home/new_widget/new_job_seeker_home_screen.dart';
import 'admin_login_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                const Text('Log In',
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
                const Row(
                  children: [
                    Text(
                      'PASSWORD',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1E1F20)),
                    ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                buildPasswordSection(),
                const SizedBox(height: 26),

                // Login button for login with email and password
                _buildLoginButton(context),
                const SizedBox(height: 26),

                // Go to register page to create account
                buildCreateAccountSection(),

                // Go to company login page to create account
                buildLoginAsCompanySection(),
                //
                // // Go to admin login page to create account
                buildLoginAsAdminSection(),
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
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        User? user = await AuthService.signInWithEmailAndPassword(
                _emailController.text.trim(),
                _passwordController.text.trim(),
                "Job Seeker",
                context)
            .then((value) {
          if (value != null) {
            setState(() {
              isLoading = false;
            });
            SessionManager.setUserModel(value);
            Utils.navigateTo(context, const NewJobSeekerHomeScreen());
          } else {
            setState(() {
              isLoading = false;
            });
            Utils.showSnackBar(context, "Error Occurred At: Login Screen");
          }
          return null;
        });
      },
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xff5872de)),
      ),
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

  Row buildLoginAsAdminSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Login as ",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff8E8F8F)),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdminLoginScreen(),
                  ));
            },
            style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero),
            child: const Text('Super Admin',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212223))))
      ],
    );
  }

  Row buildLoginAsCompanySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Login as ",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff8E8F8F)),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompanyLoginScreen(),
                  ));
            },
            style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero),
            child: const Text('Company Admin',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212223))))
      ],
    );
  }

  Row buildCreateAccountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account?",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xff8E8F8F)),
        ),
        TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegistrationScreen(),
                  ));
            },
            style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero),
            child: const Text('Register',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212223))))
      ],
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
