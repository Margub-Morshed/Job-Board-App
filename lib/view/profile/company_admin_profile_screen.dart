import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_board_app/model/company_model.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/services/profile/profile_service.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/home/company_admin_home_screen.dart';
import 'package:job_board_app/view/input/input_screen.dart';
import '../common_widgets/custom_textfield.dart';
import '../home/job_seeker_home_screen.dart';

class CompanyAdminProfileScreen extends StatefulWidget {
  const CompanyAdminProfileScreen(
      {Key? key, this.userModel, this.companyModel, required this.role})
      : super(key: key);

  final UserModel? userModel;
  final CompanyModel? companyModel;
  final String role;

  @override
  CompanyAdminProfileScreenState createState() => CompanyAdminProfileScreenState();
}

class CompanyAdminProfileScreenState extends State<CompanyAdminProfileScreen> {
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

  String? _profileImage;
  String? _logoImage;

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            children: [
              ..._buildHeader((widget.role == "Job Seeker")
                  ? widget.userModel
                  : widget.companyModel),
              if (widget.role == "Job Seeker") ..._buildJobSeekerFields(),
              if (widget.role == 'Company Admin') ..._buildCompanyFields(),
              const SizedBox(height: 28.0),
              _buildUpdateButton(),
              const SizedBox(height: 16.0),
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
      _buildTextField(
          _companyNameController, 'Company Name', 'Enter your company name'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Company Email"),
      const SizedBox(height: 8),
      _buildTextField(
          _companyEmailController, 'Company Email', 'Enter your company email',readOnly: true),
      const SizedBox(height: 16.0),
      const TitleText(title: "Company Phone"),
      const SizedBox(height: 8),
      _buildTextField(
          _companyPhoneController, 'Company Phone', 'Enter your company phone'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Team Size"),
      const SizedBox(height: 8),
      _buildTextField(_teamSizeController, 'Team Size', 'Enter your team size'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Short Description"),
      const SizedBox(height: 8),
      _buildTextField(_shortDescriptionController, 'Short Description',
          'Enter your short description'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Long Description"),
      const SizedBox(height: 8),
      _buildTextField(_longDescriptionController, 'Long Description',
          'Enter your long description'),
      const SizedBox(height: 16.0),
      const TitleText(title: "Address"),
      const SizedBox(height: 8),
      _buildTextField(_addressController, 'Address', 'Enter your address'),
    ];
  }

  Widget _buildAvatar(dynamic model) {
    return Stack(
      children: [
        //profile picture
        _profileImage != null
            ?
        //local image
        ClipRRect(
            borderRadius: BorderRadius.circular(Utils.scrHeight * .1),
            child: Image.file(File(_profileImage!),
                width: Utils.scrHeight * .2,
                height: Utils.scrHeight * .2,
                fit: BoxFit.cover))
            : ClipOval(
          child: CachedNetworkImage(
            imageUrl: (widget.role == "Company Admin")
                ? model.logoImage!
                : model.userAvatar!,
            fit: BoxFit.cover,
            width: Utils.scrHeight * .2,
            height: Utils.scrHeight * .2,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: MaterialButton(
            elevation: 1,
            onPressed: () {
              setState(() {});
              _showBottomSheet("user_avatar", _profileImage);
            },
            shape: const CircleBorder(),
            color: Colors.white,
            child: const Icon(Icons.edit, color: Colors.blue),
          ),
        )
      ],
    );
  }

  Widget _buildCoverImage(dynamic model) {
    final image =
    (widget.role == "Company Admin") ? model.logoImage : model.userAvatar;

    return SizedBox(
      height: Utils.scrHeight * .2,
      child: Stack(
        children: [
          _logoImage != null
              ? SizedBox(
            height: Utils.scrHeight * .15,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Utils.scrHeight * .02),
              child: Image.file(File(_logoImage!), fit: BoxFit.cover),
            ),
          )
              : Container(
            height: Utils.scrHeight * .18,
            width: double.infinity,
            decoration: BoxDecoration(
              // color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(Utils.scrHeight * .02),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Utils.scrHeight * .02),
              child: model.logoImage != null
                  ? Image.network(model.logoImage!, fit: BoxFit.fill)
                  : Image.asset('assets/images/profile.png'),
            ),
          ),
          Positioned(
            bottom: -Utils.scrHeight * 0.0056,
            right: -Utils.scrHeight * 0.01,
            child: MaterialButton(
              elevation: 1,
              onPressed: () {
                _showBottomSheet("cover_image", _logoImage);
              },
              shape: const CircleBorder(),
              color: Colors.white.withOpacity(0.6),
              child: Icon(Icons.camera_enhance_rounded,
                  color: const Color(0xff5872de), size: Utils.scrHeight * .024),
            ),
          ),

          // // Profile Image
          // Positioned(
          //   bottom: Utils.scrHeight * 0.005,
          //   left: Utils.scrHeight * 0.025,
          //   child: _profileImage != null
          //       ?
          //   //local image
          //   ClipRRect(
          //       borderRadius: BorderRadius.circular(Utils.scrHeight * .15),
          //       child: Image.file(File(_profileImage!),
          //           width: Utils.scrHeight * .13,
          //           height: Utils.scrHeight * .13,
          //           fit: BoxFit.cover))
          //       : ClipOval(
          //     child: (image != null)
          //         ? Image.network(image,
          //         fit: BoxFit.cover,
          //         width: Utils.scrHeight * .13,
          //         height: Utils.scrHeight * .13)
          //         : Image.asset('assets/images/profile.png'),
          //   ),
          // ),
          // // Profile Image Update Button
          // Positioned(
          //   bottom: Utils.scrHeight * 0.002,
          //   left: Utils.scrHeight * 0.08,
          //   child: MaterialButton(
          //     padding: EdgeInsets.zero,
          //     elevation: 1,
          //     onPressed: () {
          //       setState(() {});
          //       _showBottomSheet("user_avatar", _profileImage);
          //     },
          //     shape: const CircleBorder(),
          //     color: Colors.white.withOpacity(0.6),
          //     child: Icon(Icons.camera_enhance_rounded,
          //         color: const Color(0xff5872de), size: Utils.scrHeight * .024),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint,
      {bool readOnly = false}) {
    return CustomTextField(
      controller: controller,
      label: "",
      hint: hint,
      readOnly: readOnly,
    );
  }

  Widget _buildUpdateButton() {
    return ElevatedButton(
      style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff5872de)),),
      onPressed: _updateProfile,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Utils.scrHeight * .02,
            horizontal: Utils.scrHeight * .025),
        child: Text('Update Profile',
            style: TextStyle(fontSize: Utils.scrHeight * .02,color: Colors.white)),
      ),
    );
  }

  void setUserDataToTextFields() {
    if (widget.role == "Job Seeker") {
      _usernameController.text = widget.userModel!.username;
      _nameController.text = widget.userModel?.name ?? '';
      _phoneNumberController.text = widget.userModel?.phoneNumber ?? '';
      _companyEmailController.text = widget.userModel?.email ?? '';
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
        Utils.showSnackBar(context, 'Profile updated successfully ✓');
        Utils.navigateTo(
            context,
            widget.role == "Company Admin"
                ? const CompanyAdminHomeScreen()
                : const JobSeekerHomeScreen());
      });
    } catch (e) {
      Utils.showSnackBar(context, 'Error updating profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfileImage(String field, String imagePath) async {
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

      await ProfileService.updateProfilePicture(
          field, model, widget.role, File(imagePath));

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
        userAvatar: userModel.userAvatar,
        coverImage: userModel.coverImage);
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
      status: model.status,
      longDescription: _longDescriptionController.text.trim(),
      shortDescription: _shortDescriptionController.text.trim(),
      teamSize: int.parse(_teamSizeController.text),
      role: model.role,
      logoImage: model.logoImage
    );
  }

  List<Widget> _buildJobSeekerFields() => [
    const TitleText(title: "User Name"),
    const SizedBox(height: 8),
    _buildTextField(_usernameController, '', 'Enter your username'),
    const SizedBox(height: 16.0),
    const TitleText(title: "Name"),
    const SizedBox(height: 8),
    _buildTextField(_nameController, '', 'Enter your name'),
    const SizedBox(height: 16.0),
    const TitleText(title: "Email"),
    const SizedBox(height: 8),
    _buildTextField(_companyEmailController, '', 'Enter your Email',
        readOnly: true),
    const SizedBox(height: 16.0),
    const TitleText(title: "Phone Number"),
    const SizedBox(height: 8),
    _buildTextField(_phoneNumberController, '', 'Enter your phone number'),
  ];

  void _showBottomSheet(String field, String? _image) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            shrinkWrap: true,
            children: [
              //pick profile picture label
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              const SizedBox(height: 20),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //pick from gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize:
                          Size(Utils.scrWidth * .3, Utils.scrHeight * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                            log('_Image Path: $_image');

                            field == "user_avatar"
                                ? _profileImage = _image
                                : _logoImage = _image;
                          });
                          _updateProfileImage(field, _image!);
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.image_outlined,
                        size: 80,
                      )),

                  //take picture from camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize:
                          Size(Utils.scrWidth * .3, Utils.scrHeight * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        // Pick an image
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                            field == "user_avatar"
                                ? _profileImage = _image
                                : _logoImage = _image;
                          });
                          _updateProfileImage(field, _image!);

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        size: 80,
                      )),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        });
  }

  List<Widget> _buildHeader(dynamic model) => [_buildCoverImage(model)];
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
