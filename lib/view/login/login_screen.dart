import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/profile/profile_screen.dart';
import 'package:job_board_app/view/register/register_screen.dart';

import '../../services/auth/auth_service.dart';
import '../../utils/validation.dart';

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
  final List<String> userRoles = ["Company Admin", "Job Seeker"];
  late String selectedRole;

  @override
  void initState() {
    selectedRole = userRoles.last;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
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
            Row(
              children: [
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff1E1F20)),
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Color(0xff1E1F20),
                          decoration: TextDecoration.underline),
                    ))
              ],
            ),
            buildPasswordSection(),
            const SizedBox(height: 26),

            const Text('Role Type',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff1E1F20))),
            const SizedBox(height: 8),
            CustomDropDown(
              selectedRole: selectedRole,
              userRoles: userRoles,
              onRoleChanged: (newRole) {
                setState(() {
                  selectedRole = newRole;
                });
              },
            ),
            const SizedBox(height: 26),

            // Login button for login with email and password
            _buildLoginButton(context),
            const SizedBox(height: 26),

            // Go to register page to create account
            buildCreateAccountSection(),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        User? user = await AuthService.signInWithEmailAndPassword(
            _emailController.text.trim(),
            _passwordController.text.trim(),
            selectedRole,
            context)
            .then((value) {
          if (selectedRole == userRoles.first && value != null) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ProfileScreen(companyModel: value, role: selectedRole);
              },
            ));
          } else if (selectedRole == userRoles.last && value != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfileScreen(userModel: value, role: selectedRole);
            }));
          } else {
            Utils.showSnackBar(context, "Select Specific User Role!");
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Utils.scrHeight * .015),
        child: Text(
          'Log In',
          style: TextStyle(
              fontSize: Utils.scrHeight * .022, fontWeight: FontWeight.bold),
        ),
      ),
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
            hintText: 'Email',
            hintStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff1E1F20))),
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
            hintText: 'Password',
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff1E1F20)),
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: Icon(
                    isObscure
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
