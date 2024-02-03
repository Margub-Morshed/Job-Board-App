import 'package:flutter/material.dart';
import 'package:job_board_app/model/application_model.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/services/application/application_service.dart';
import 'package:job_board_app/services/session/session_services.dart';

import '../../utils/utils.dart';
import '../common_widgets/custom_textfield.dart';
import '../home/job_seeker_home_screen.dart';
import '../home/job_seeker_home_screen1.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key, required this.jobPostModel});

  final JobPostModel jobPostModel;

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final ApplicationService fireStoreService = ApplicationService();
  late TextEditingController jobTitlecontroller = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController massageController = TextEditingController();

  @override
  void initState() {
    jobTitlecontroller.text = widget.jobPostModel.jobTitle;
    emailController.text = SessionManager.userModel!.email;
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
      cv: '',
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
                controller: jobTitlecontroller,
                label: "Job Title",
                readOnly: true,
              ),
              const SizedBox(height: 30),

              // Applicant Name Input
              CustomTextField(
                  controller: nameController, label: "Applicant Name"),
              const SizedBox(height: 30),

              // Applicant Date of Birth Input
              // CustomTextField(
              //     controller: dobController, label: "Date of Birth"),
              // const SizedBox(height: 30),

              // Applicant Email Input
              CustomTextField(
                  controller: emailController, label: "Applicant Email"),
              const SizedBox(height: 30),

              // Applicant Contact Input
              CustomTextField(
                  controller: numberController, label: "Contact Number"),
              const SizedBox(height: 30),

              // Applicant Address Input
              // CustomTextField(
              //     controller: addressController, label: "Applicant Address"),
              // const SizedBox(height: 30),

              // Date & Time
              // CustomTextField(
              //   controller: controller,
              //   label: "Job Deadline",
              //   readOnly: true,
              //   onTap: () =>
              //       Utils.showDateTimePicker(context, controller),
              // ),
              // const SizedBox(height: 30),

              // Applicant Experience Input
              // CustomTextField(
              //     controller: experienceController, label: "Experience"),
              // const SizedBox(height: 30),

              // Career Level Input
              // CustomTextField(
              //     controller: controller, label: "Career Level"),
              // const SizedBox(height: 30),

              // Applicant Qualification Input
              // CustomTextField(
              //     controller: qualificationController, label: "Qualification"),
              // const SizedBox(height: 30),

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

              // const Text(
              //   'Confirm The All Information is Correct, You Can Not Edit From After Confirmation',
              //   style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.red),
              //   textAlign: TextAlign.center,
              // ),

              const SizedBox(height: 30),
              _buildJobPostButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobPostButton() {
    return ElevatedButton(
      onPressed: () => _pushData(),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Utils.scrHeight * .02,
            horizontal: Utils.scrHeight * .025),
        child: Text(
          'Confirm',
          style: TextStyle(
            fontSize: Utils.scrHeight * .022,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
