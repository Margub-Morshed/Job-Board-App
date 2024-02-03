import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/view/common_widgets/custom_textfield.dart';
import 'package:job_board_app/view/home/job_seeker_home_screen1.dart';

import '../../model/job_post_model.dart';
import '../../utils/utils.dart';
import '../home/job_seeker_home_screen.dart';

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
  final TextEditingController salaryRangeController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController careerLevelController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  String? _jobImage;
  bool _isLoading = false;

  void _pushData() async {
    JobPostModel jobPost = createJobPostModel();
    print("job post: " + jobPost.toString());
    await fireStoreService.addPost(jobPost);
    Utils.navigateTo(context, const JobSeekerHomeScreen());
  }

  JobPostModel createJobPostModel() {
    return JobPostModel(
      id: "",
      companyId: SessionManager.companyModel!.id,
      categoryId: 0,
      cityId: 0,
      jobTitle: titleController.text.trim(),
      description: descController.text.trim(),
      email: emailController.text.trim(),
      jobType: typeController.text.trim(),
      applicationDeadline: deadlineController.text.trim(),
      address: addressController.text.trim(),
      experience: experienceController.text.trim(),
      careerLevel: careerLevelController.text.trim(),
      qualification: qualificationController.text.trim(),
      salaryRange: salaryRangeController.text.trim(),
      status: "Active",
      createdAt: DateFormat("d-MMM-yyyy, h:mm a").format(DateTime.now()),
      createdBy: SessionManager.companyModel!.name,
    );
  }

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: [
              _buildPickImage(),

              // Job Title Input
              CustomTextField(controller: titleController, label: "Job Title"),
              const SizedBox(height: 30),

              // Job Description Input
              CustomTextField(
                  controller: descController, label: "Job Description"),
              const SizedBox(height: 30),

              // Job Email Input
              CustomTextField(controller: emailController, label: "Job Email"),
              const SizedBox(height: 30),

              // Job Type Input
              CustomTextField(controller: typeController, label: "Job Type"),
              const SizedBox(height: 30),

              // Job Address Input
              CustomTextField(
                  controller: addressController, label: "Job Address"),
              const SizedBox(height: 30),

              // Date & Time
              CustomTextField(
                controller: deadlineController,
                label: "Job Deadline",
                readOnly: true,
                onTap: () =>
                    Utils.showDateTimePicker(context, deadlineController),
              ),
              const SizedBox(height: 30),

              // Experience Input
              CustomTextField(
                  controller: experienceController, label: "Experience"),
              const SizedBox(height: 30),

              // Career Level Input
              CustomTextField(
                  controller: careerLevelController, label: "Career Level"),
              const SizedBox(height: 30),

              // Qualification Input
              CustomTextField(
                  controller: qualificationController, label: "Qualification"),
              const SizedBox(height: 30),

              // Salary Range Input
              CustomTextField(
                  controller: salaryRangeController, label: "Salary Range"),

              const SizedBox(height: 30),
              _buildJobPostButton(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickImage() {
    return SizedBox(
      height: Utils.scrHeight * .2,
      child: Stack(
        children: [
          // Profile Image
          Positioned(
            child: _jobImage != null
                ?
                //local image
                Center(
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Utils.scrHeight * .15),
                        child: Image.file(File(_jobImage!),
                            width: Utils.scrHeight * .15,
                            height: Utils.scrHeight * .15,
                            fit: BoxFit.cover)),
                  )
                : //local image

                //take picture from camera button
                Center(
                    child: Container(
                        width: Utils.scrWidth * .3,
                        height: Utils.scrHeight * .15,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.add_a_photo_sharp,
                            size: 50, color: Colors.deepPurple)),
                  ),
          ),

          // Image Picker Camera Button
          Positioned(
            bottom: Utils.scrHeight * 0.018,
            right: Utils.scrHeight * 0.12,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              elevation: 1,
              onPressed: () {
                setState(() {});
                _showBottomSheet("job_post_image", _jobImage);
              },
              shape: const CircleBorder(),
              color: Colors.white.withOpacity(0.5),
              child: Icon(Icons.camera_enhance_rounded,
                  color: Colors.deepPurple, size: Utils.scrHeight * .024),
            ),
          ),
        ],
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
              const Text('Pick Job Post Image Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

              //for adding some space
              const SizedBox(height: 20),

              //buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            source: ImageSource.gallery, imageQuality: 40);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                            log('_Image Path: $_image');

                            _jobImage = _image;
                          });
                          _updateJobPostImage(field, _image!);
                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.image_outlined, size: 80)),

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
                            _jobImage = _image;
                          });
                          _updateJobPostImage(field, _image!);

                          // for hiding bottom sheet
                          Navigator.pop(context);
                        }
                      },
                      child: const Icon(Icons.camera_alt, size: 80)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          );
        });
  }

  void _updateJobPostImage(String field, String imagePath) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await JobService.updateJobPostImage(File(imagePath));

      Utils.showSnackBar(context, 'Job post image updated successfully ✓');
    } catch (e) {
      Utils.showSnackBar(context, 'Error updating job post image: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
