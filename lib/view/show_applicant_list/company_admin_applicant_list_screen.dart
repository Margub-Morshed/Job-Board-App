import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/application_model.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/services/application/application_service.dart';
import '../../utils/utils.dart';
import '../filter/company_admin_filter_screen.dart';
import 'company_applications_details_screen.dart';

class ShowApplicantList extends StatefulWidget {
  const ShowApplicantList({Key? key, required this.jobPostModel});

  final JobPostModel jobPostModel;

  @override
  State<ShowApplicantList> createState() => _ShowApplicantListState();
}

class _ShowApplicantListState extends State<ShowApplicantList> {
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
        padding: EdgeInsets.symmetric(
          horizontal: Utils.scrHeight * .01,
        ),
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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
            spreadRadius: -2,
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
              CompanyApplicationDetailsScreen(
                  tag: "${applicationModel.id}_hero_tag",
                  applicationModel: applicationModel,
                  userModel: userModel));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                // Left Side Image
                leading: Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  // Right Side Padding
                  child: ProfileImage(
                      imageUrl: userModel.coverImage,
                      imageName: "${applicationModel.id}_hero_tag"),
                ),

                // Right Side Information
                title: Text(userModel.name!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: ProfileDetails(
                    email: userModel.email,
                    teamSize: userModel.phoneNumber!,
                    address: applicationModel.message),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: _getTextColor(applicationModel.status)),
                      borderRadius: BorderRadius.circular(10),
                      color: _getContainerColor(applicationModel.status)),
                  child: Text(applicationModel.status),
                ),
              ),
            ),
          ),
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
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 10,
              spreadRadius: -2,
              offset: const Offset(-10, 4),
            ),
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl ?? ''),
          ),
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails(
      {Key? key,
      required this.email,
      required this.teamSize,
      required this.address})
      : super(key: key);

  final String email;
  final String teamSize;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text('Phone: $teamSize',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(address, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
