import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/application_model.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/services/application/application_service.dart';
import 'package:job_board_app/view/show_applicant_list/super_admin_application_details_screen.dart';
import '../../utils/utils.dart';
import '../filter/company_admin_filter_screen.dart';
import 'company_applications_details_screen.dart';

class SuperAdminApplicantListScreen extends StatefulWidget {
  const SuperAdminApplicantListScreen({super.key, required this.jobPostModel});

  final JobPostModel jobPostModel;

  @override
  State<SuperAdminApplicantListScreen> createState() =>
      _SuperAdminApplicantListScreenState();
}

class _SuperAdminApplicantListScreenState
    extends State<SuperAdminApplicantListScreen> {
  List<String> applicationStatus = [
    'All',
    'Pending',
    'Short Listed',
    'Rejected'
  ];
  String selectedStatusFilter = "All";
  List<ApplicationModel> allApplications = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Application List'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utils.scrHeight * .01),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Utils.scrHeight * .015),
              child: Row(
                children: [
                  Expanded(
                    child: CustomDropDown(
                      selectedFilter: selectedStatusFilter,
                      filterOptions: applicationStatus,
                      onFilterChanged: (newFilter) {
                        setState(() {
                          selectedStatusFilter = newFilter;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ApplicationModel>>(
                stream: ApplicationService.getApplicationsByPostId(
                  widget.jobPostModel.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  allApplications = snapshot.data ?? [];

                  List<ApplicationModel> filteredApplications =
                      filterApplicationsByStatus(allApplications);

                  return filteredApplications.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredApplications.length,
                          itemBuilder: (context, index) {
                            ApplicationModel application =
                                filteredApplications[index];
                            return StreamBuilder<List<UserModel>>(
                              stream: ApplicationService.getUserInfo(
                                application.userId,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                      'Error: ${snapshot.error}',
                                    ),
                                  );
                                }
                                List<UserModel> userInfo = snapshot.data ?? [];
                                return ApplicationListCard(
                                  userModel: userInfo[0],
                                  applicationModel: application,
                                );
                              },
                            );
                          },
                        )
                      : Center(
                          child: Utils.noDataFound(),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ApplicationModel> filterApplicationsByStatus(
      List<ApplicationModel> applications) {
    if (selectedStatusFilter == "All") {
      return applications;
    } else {
      return applications
          .where((application) => application.status == selectedStatusFilter)
          .toList();
    }
  }
}

class ApplicationListCard extends StatelessWidget {
  const ApplicationListCard(
      {Key? key, required this.userModel, required this.applicationModel})
      : super(key: key);

  final ApplicationModel applicationModel;
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final hero_tag = "${applicationModel.id}_hero_tag";
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 16,
            spreadRadius: -10,
            offset: const Offset(-10, 4),
          ),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Utils.navigateTo(
              context,
              SuperAdminApplicationDetailsScreen(
                  tag: "${applicationModel.id}_hero_tag",
                  applicationModel: applicationModel,
                  userModel: userModel));
        },
        child: Stack(
          children: [
            SizedBox(
              height: Utils.scrHeight * .23,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Side Image
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          // Right Side Padding
                          child: ProfileImage(
                            imageUrl: userModel.userAvatar,
                            imageName: "${applicationModel.id}_hero_tag",
                          ),
                        ),

                        // Right Side Information
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userModel.name!,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              ProfileDetails(
                                email: userModel.email,
                                phone: userModel.phoneNumber!,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Utils.scrHeight * 0.025,
              right: Utils.scrHeight * 0.025,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: _getTextColor(applicationModel.status)),
                    borderRadius: BorderRadius.circular(12),
                    color: _getContainerColor(applicationModel.status)),
                child: Text(
                  applicationModel.status,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getContainerColor(String status) {
    switch (status) {
      case 'Short Listed':
        return Colors.green.shade100;
      case 'Pending':
        return Colors.orange.shade100;
      case 'Rejected':
        return Colors.red.shade100;
      default:
        return Colors.black; // Default color
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Short Listed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.black; // Default color
    }
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key, required this.imageUrl, this.imageName})
      : super(key: key);

  final String? imageUrl;
  final String? imageName;

  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: imageName.toString(),
      child: Container(
        padding: const EdgeInsets.all(2.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: imageUrl ?? '',
            fit: BoxFit.cover,
            height: double.infinity,
            width: 100,
          ),
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({
    Key? key,
    required this.email,
    required this.phone,
  }) : super(key: key);

  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text('Email : $email',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text('Phone: $phone',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
      ],
    );
  }
}
