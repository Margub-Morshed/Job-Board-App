import 'package:flutter/material.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import 'package:job_board_app/view/common_widgets/custom_textfield.dart';

import '../../model/job_post_model.dart';
import '../../utils/utils.dart';
import '../display/display_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  InputScreenState createState() => InputScreenState();
}

class InputScreenState extends State<InputScreen> {
  final JobService fireStoreService = JobService();
  TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  void _pushData() async {
    JobPostModel jobPost = createJobPostModel();
    await fireStoreService.addPost(jobPost);
    _navigateTo(
      DisplayScreen(
        jobTitle: jobPost.jobTitle,
        description: jobPost.description,
        // ... pass other data
      ),
    );
  }

  JobPostModel createJobPostModel() => JobPostModel(
      id: "",
      companyId: 0,
      categoryId: 0,
      cityId: 0,
      jobTitle: titleController.text.trim(),
      description: descController.text.trim(),
      email: emailController.text.trim(),
      jobType: typeController.text.trim(),
      qualification: "",
      applicationDeadline: deadlineController.text.trim(),
      address: addressController.text.trim(),
      status: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Job Post"),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent),
      body: Align(
        // In order to center align the children's of listview
        heightFactor: 1.0,
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),

            children: [
              // Job Title Input
              CustomTextField(controller: titleController, label: "Job Title"),
              const SizedBox(height: 30),

              // Job Description Input
              CustomTextField(controller: descController, label: "Job Description"),
              const SizedBox(height: 30),

              // Job Email Input
              CustomTextField(controller: emailController, label: "Job Email"),
              const SizedBox(height: 30),

              // Job Type Input
              CustomTextField(controller: typeController, label: "Job Type"),
              const SizedBox(height: 30),

              // Job Address Input
              CustomTextField(controller: addressController, label: "Job Address"),
              const SizedBox(height: 30),

              // Date & Time
              CustomTextField(
                controller: deadlineController,
                label: "Job Deadline",
                readOnly: true,
                onTap: () => Utils.showDateTimePicker(context, deadlineController),
              ),
              const SizedBox(height: 50),
              _buildJobPostButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobPostButton() {
    return ElevatedButton(
      onPressed: _pushData,
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Utils.scrHeight * .02,
            horizontal: Utils.scrHeight * .025),
        child: Text(
          'Post Job',
          style: TextStyle(
            fontSize: Utils.scrHeight * .022,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
