import 'package:flutter/material.dart';
import 'package:job_board_app/model/company_model.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/services/profile/profile_service.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/input/input_screen.dart';

import '../common_widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(
      {Key? key, this.userModel, this.companyModel, required this.role})
      : super(key: key);

  final UserModel? userModel;
  final CompanyModel? companyModel;
  final String role;

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyEmailController = TextEditingController();
  final TextEditingController _companyPhoneController = TextEditingController();
  final TextEditingController _teamSizeController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _longDescriptionController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    setUserDataToTextFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("role: ${widget.role}");

    print("userModel: ${widget.userModel.toString()}");
    print("companyModel: ${widget.companyModel.toString()}");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildAvatar(),
              const SizedBox(height: 16.0),
              _buildCoverImage(),
              const SizedBox(height: 16.0),
              if (widget.role == "Job Seeker") ..._buildJobSeekerFields(),
              if (widget.role == 'Company Admin') ..._buildCompanyFields(),
              const SizedBox(height: 22.0),
              _buildUpdateButton(),
              const SizedBox(height: 26.0),
            ],
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox.shrink()
        ],
      ),
    );
  }

  List<Widget> _buildCompanyFields() {
    return [
      const TitleText(title: "Company Name"),
      const SizedBox(height: 8),
      _buildTextField(_companyNameController, 'Enter your company name'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Company Email"),
      const SizedBox(height: 8),
      _buildTextField(_companyEmailController, 'Enter your company email'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Company Phone"),
      const SizedBox(height: 8),
      _buildTextField(_companyPhoneController, 'Enter your company phone'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Team Size"),
      const SizedBox(height: 8),
      _buildTextField(_teamSizeController, 'Enter your team size'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Short Description"),
      const SizedBox(height: 8),
      _buildTextField(
          _shortDescriptionController, 'Enter your short description'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Long Description"),
      const SizedBox(height: 8),
      _buildTextField(
          _longDescriptionController, 'Enter your long description'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Address"),
      const SizedBox(height: 8),
      _buildTextField(_addressController, 'Enter your address'),
    ];
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: Utils.scrHeight * .08,
      backgroundImage: const AssetImage(
          'assets/avatar_placeholder.jpg'), // Placeholder image
    );
  }

  Widget _buildCoverImage() {
    return Container(
      height: Utils.scrHeight * .1,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        image: const DecorationImage(
          image: AssetImage('assets/cover_placeholder.jpg'),
          // Placeholder image
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(Utils.scrHeight * .02),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return CustomTextField(controller: controller, hint: hint);
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: _updateProfile,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Utils.scrHeight * .02,
            horizontal: Utils.scrHeight * .025),
        child: Text('Update Profile',
            style: TextStyle(fontSize: Utils.scrHeight * .02)),
      ),
    );
  }

  void setUserDataToTextFields() {
    if (widget.role == "Job Seeker") {
      _usernameController.text = widget.userModel!.username;
      _nameController.text = widget.userModel?.name ?? '';
      _phoneNumberController.text = widget.userModel?.phoneNumber ?? '';
    }

    // Set values for company fields if the role is Company Admin
    if (widget.role == 'Company Admin') {
      _companyNameController.text = widget.companyModel?.name ?? '';
      _companyEmailController.text = widget.companyModel?.email ?? '';
      _companyPhoneController.text = widget.companyModel?.phone ?? '';
      _teamSizeController.text = widget.companyModel?.teamSize.toString() ?? '';
      _shortDescriptionController.text =
          widget.companyModel?.shortDescription ?? '';
      _longDescriptionController.text =
          widget.companyModel?.longDescription ?? '';
      _addressController.text = widget.companyModel?.address ?? '';
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    late dynamic model;
    try {
      if (widget.role == "Company Admin") {
        model = setUpdatedCompanyModel(widget.companyModel!);
      } else {
        model = setUpdatedUserModel(widget.userModel!);
      }

      await ProfileService.updateProfile(model, widget.role).then((value) {
        Utils.navigateTo(context, const InputScreen());
      });

      Utils.showSnackBar(context, 'Profile updated successfully ✓');
    } catch (e) {
      Utils.showSnackBar(context, 'Error updating profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  UserModel setUpdatedUserModel(UserModel userModel) {
    // Get updated values from text controllers
    String username = _usernameController.text.trim();
    String name = _nameController.text.trim();
    String phoneNumber = _phoneNumberController.text.trim();

    // Update the existing userModel with the new values
    return UserModel(
      id: userModel.id,
      username: username,
      name: name,
      phoneNumber: phoneNumber,
      email: userModel.email,
      password: userModel.password,
      role: userModel.role,
    );
  }

  CompanyModel setUpdatedCompanyModel(CompanyModel companyModel) {
    // Update the existing userModel with the new values
    final model = widget.companyModel!;
    return CompanyModel(
      id: model.id,
      userId: model.userId,
      cityId: "",
      password: companyModel.password,
      name: _companyNameController.text.trim(),
      email: _companyEmailController.text.trim(),
      phone: _companyPhoneController.text.trim(),
      address: _addressController.text.trim(),
      shortDescription: _shortDescriptionController.text.trim(),
      longDescription: _longDescriptionController.text.trim(),
      status: model.status,
      teamSize: int.parse(_teamSizeController.text),
      role: model.role,
    );
  }

  List<Widget> _buildJobSeekerFields() => [
        const TitleText(title: "User Name"),
        const SizedBox(height: 8),
        _buildTextField(_usernameController, 'Enter your username'),
        const SizedBox(height: 16.0),
        const TitleText(title: "Name"),
        const SizedBox(height: 8),
        _buildTextField(_nameController, 'Enter your name'),
        const SizedBox(height: 16.0),
        const TitleText(title: "Phone Number"),
        const SizedBox(height: 8),
        _buildTextField(_phoneNumberController, 'Enter your phone number'),
      ];
}

class TitleText extends StatelessWidget {
  final String title;

  const TitleText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Color(0xff1E1F20),
      ),
    );
  }
}
