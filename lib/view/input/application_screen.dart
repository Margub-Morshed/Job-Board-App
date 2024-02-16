import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/application_model.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/services/application/application_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/utils.dart';
import '../common_widgets/custom_textfield.dart';
import '../common_widgets/dotted_container.dart';
import '../home/job_seeker_home_screen.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key, required this.jobPostModel});

  final JobPostModel jobPostModel;

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final ApplicationService fireStoreService = ApplicationService();
  late TextEditingController jobTitleController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController massageController = TextEditingController();

  String? _fileName;

  String? _path;

  String? downloadRef = '';

  bool isUploading = false;

  // the function for open pdf from storage


  @override
  void initState() {
    jobTitleController.text = widget.jobPostModel.jobTitle;
    emailController.text = SessionManager.userModel!.email;
    numberController.text = SessionManager.userModel!.phoneNumber!;
    nameController.text = SessionManager.userModel!.name!;
    super.initState();
  }

  void _pushData() async {
    ApplicationModel applicantModel = createApplicationModel();
    print("application: " + applicantModel.toString());


    await fireStoreService.addApplication(applicantModel).then((value) =>
        Utils.showSnackBar(context, 'Application Submit Successfully'));
    Utils.navigateTo(context, const JobSeekerHomeScreen());
  }

  ApplicationModel createApplicationModel() {
    return ApplicationModel(
      id: '',
      userId: SessionManager.userModel!.id,
      jobPost: widget.jobPostModel.id,
      message: massageController.text,
      expectedSalary: salaryController.text,
      cv: downloadRef.toString(),
      status: 'Pending',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application'),
      ),
      body: Align(
        // In order to center align the children's of listview
        heightFactor: 1.0,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              const Text(
                'Please Fill The From Carefully',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              const SizedBox(height: 30),
              // Job Title Input
              CustomTextField(
                controller: jobTitleController,
                label: "Job Title",
                readOnly: true,
              ),
              const SizedBox(height: 30),

              // Applicant Name Input
              CustomTextField(
                  controller: nameController, label: "Applicant Name"),
              const SizedBox(height: 30),
              CustomTextField(
                  controller: emailController, label: "Applicant Email"),
              const SizedBox(height: 30),

              // Applicant Contact Input
              CustomTextField(
                  controller: numberController, label: "Contact Number"),
              const SizedBox(height: 30),

              // Application Expected Salary Range Input
              CustomTextField(
                  controller: salaryController, label: "Expected Salary"),
              const SizedBox(height: 30),

              // Application Massage
              const Text(
                'Why We Select You For this Post',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                  maxLines: 3, controller: massageController, label: "Massage"),

              const SizedBox(height: 30),
              DottedContainer(onTap: () async{
                Map<Permission, PermissionStatus> statuses = await [
                Permission.storage,
                    Permission.camera,
                ].request();
                if(statuses[Permission.storage]!.isGranted || statuses[Permission.camera]!.isGranted){
                _openFileExplorer();
                } else {

                }}, fileName: _fileName,isLoading: isUploading,),

              const SizedBox(height: 30),
              _buildJobPostButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }


  void _openFileExplorer() async {
    try {
      isUploading = true;
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          // pick the file and save the path
          _fileName = result.files.single.name;
          _path = result.files.single.path;
          print('filename $_fileName');
          print('filepath $_path');
        });
          downloadRef = await ApplicationService.uploadApplicationCV(File(_path!));
        print(downloadRef);
        setState(() {
          isUploading = false;
        });
        Utils.showSnackBar(context, 'Cv Uploded');
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print("Error while picking the file: $e");
    }
  }

  Widget _buildJobPostButton() {
    return ElevatedButton(
      onPressed: () => _pushData(),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Color(0xff5872de)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Utils.scrHeight * .02,
            horizontal: Utils.scrHeight * .025),
        child: Text(
          'Confirm',
          style: TextStyle(
            color: Colors.white,
            fontSize: Utils.scrHeight * .022,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
