import 'package:flutter/material.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/view/login/login_screen.dart';

import '../../model/company_model.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/utils.dart';
import '../../utils/validation.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _userNameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isObscureConfirm = true;

  final List<String> userRoles = ["Company Admin", "Job Seeker"];
  String selectedRole = "Job Seeker";

  @override
  void initState() {
    // selectedRole = userRoles.last;
    super.initState();
  }

  void clearUserTextFiled(){
    _emailController.clear();
    _passwordController.clear();
    _confirmPassController.clear();
    _userNameController.clear();
    _fullNameController.clear();
  }
  void clearCompanyTextFiled(){
    _companyEmailController.clear();
    _passwordController.clear();
    _confirmPassController.clear();
    _companyNameController.clear();
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
            const Text('Registration',
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
            const SizedBox(height: 24),

            if (selectedRole == userRoles.last) ..._buildJobSeekerInput(),
            if (selectedRole == userRoles.first) ..._buildCompanyAdminInput(),

            const SizedBox(height: 16),

            // Input Your Password
            const Text(
              'PASSWORD',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff1E1F20)),
            ),
            const SizedBox(height: 8),
            _passwordTextFiled(_passwordController),
            const SizedBox(height: 16),

            const Text('Confirm Password',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff1E1F20))),
            const SizedBox(height: 8),
            _confirmPassword(_confirmPassController),
            const SizedBox(height: 24),

            const Text('Role Type',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff1E1F20))),
            const SizedBox(height: 8),
            // Drop Down Role
            CustomDropDown(
              selectedRole: selectedRole,
              userRoles: userRoles,
              onRoleChanged: (newRole) {
                setState(() {
                  selectedRole = newRole;
                });
              },
            ),
            const SizedBox(height: 35),

            // Registration button to login with email and password
            _buildRegisterButton(context),

            const SizedBox(height: 26),
            buildGoToLoginSection()
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          dynamic model;

          if (selectedRole == userRoles.last) {
            model = _createUserModel();
            clearUserTextFiled();
          } else if (selectedRole == userRoles.first) {
            model = _createCompanyModel();
            clearCompanyTextFiled();
          }

          await AuthService.signUpWithEmailAndPassword(
              model, context, selectedRole);

          // Handle successful registration
          Utils.showSnackBar(context, 'Registration successful ✓');
        } catch (e) {
          // Handle registration failure
          Utils.showSnackBar(context, 'Registration failed: $e');
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Utils.scrHeight * .015),
        child: Text(
          'Register',
          style: TextStyle(
            fontSize: Utils.scrHeight * .022,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Extracted method to create UserModel
  UserModel _createUserModel() {
    return UserModel(
      id: '',
      username: _userNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      role: selectedRole,
    );
  }

  // Extracted method to create CompanyModel
  CompanyModel _createCompanyModel() {
    return CompanyModel(
      id: '',
      userId: '',
      // Set appropriate value
      cityId: '',
      // Set appropriate value
      name: _companyNameController.text.trim(),
      email: _companyEmailController.text.trim(),
      phone: '',
      teamSize: 0,
      // Set appropriate value
      address: '',
      // Set appropriate value
      status: CompanyStatus.Disabled,
      password: _passwordController.text.trim(),
      role: selectedRole,
    );
  }

  Row buildGoToLoginSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "If have an account?",
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
                    builder: (context) => const LoginScreen(),
                  ));
            },
            style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero),
            child: const Text('Login',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212223))))
      ],
    );
  }

  TextFormField _nameTextFiled(TextEditingController controller,
      {String hint = 'Enter User Name'}) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(borderSide: BorderSide(width: 5)),
            hintText: hint,
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.grey)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your user name.';
          } else {
            return null;
          }
        });
  }

  TextFormField _emailTextFiled(TextEditingController controller,
      {String hint = 'example@email.com'}) {
    return TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: const OutlineInputBorder(borderSide: BorderSide(width: 5)),
            hintText: hint,
            hintStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.grey)),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email address.';
          } else if (!Validation.isValidEmail(value)) {
            return 'Please enter a valid email address.';
          }
          return null;
        });
  }

  TextFormField _passwordTextFiled(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: isObscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: const OutlineInputBorder(borderSide: BorderSide(width: 5)),
          hintText: '* * * * * *',
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.grey),
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
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
    );
  }

  TextFormField _confirmPassword(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: isObscureConfirm,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: const OutlineInputBorder(borderSide: BorderSide(width: 5)),
          hintText: '* * * * * *',
          hintStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.grey),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isObscureConfirm = !isObscureConfirm;
                });
              },
              icon: Icon(
                  !isObscureConfirm
                      ? Icons.visibility_off_outlined
                      : Icons.remove_red_eye_outlined,
                  color: const Color(0xff1E1F20),
                  size: 24))),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password.';
        } else if (value != _passwordController.text) {
          return 'Password doesn\'t match';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _confirmPassController.dispose();
    _fullNameController.dispose();
    _companyEmailController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  List<Widget> _buildJobSeekerInput() => [
        // User Name Text Filed
        const Text('User Name',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff1E1F20))),
        const SizedBox(height: 8),
        _nameTextFiled(_userNameController),
        const SizedBox(height: 16),
        // User Name Text Filed
        const Text('Name',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff1E1F20))),
        const SizedBox(height: 8),
        _nameTextFiled(_fullNameController, hint: 'Enter Name'),
        const SizedBox(height: 16),

        // Input Your Email
        const Text('Email',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff1E1F20))),
        const SizedBox(height: 8),
        _emailTextFiled(_emailController),
      ];

  List<Widget> _buildCompanyAdminInput() => [
        // User Name Text Filed
        const Text('Company Name',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff1E1F20))),
        const SizedBox(height: 8),

        _buildTextField(
            _companyNameController, 'Enter Company Name'),

        const SizedBox(height: 16),

        // User Name Text Filed
        const Text('Company Email',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xff1E1F20))),
        const SizedBox(height: 8.0),
        _buildTextField(
            _companyEmailController, 'companyltd@email.com'),
      ];

  Widget _buildTextField(
      TextEditingController controller, String hint) {
    return _nameTextFiled(controller, hint: hint);
  }
}

class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    Key? key,
    required this.selectedRole,
    required this.userRoles,
    required this.onRoleChanged,
  }) : super(key: key);

  String selectedRole;
  final List<String> userRoles;
  final ValueChanged<String> onRoleChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: widget.selectedRole,
        onChanged: (String? newValue) {
          if (newValue != null) {
            widget.onRoleChanged(newValue);
          }
        },
        items: widget.userRoles.map((String role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 36,
        underline: const SizedBox(), // Remove the default underline
      ),
    );
  }
}
