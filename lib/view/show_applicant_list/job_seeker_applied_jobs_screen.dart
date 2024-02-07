import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/services/application/application_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
import '../../model/application_model.dart';
import '../../services/job_post/job_post_service.dart';
import '../../utils/utils.dart';
import '../job_post_details/job_post_details_screen.dart';

class JobSeekerAppliedJobsScreen extends StatelessWidget {
  const JobSeekerAppliedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = SessionManager.userModel!.id;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Applied Jobs List'),
      ),
      body: _buildAppliedJobsList(userId),
    );
  }

  Widget _buildAppliedJobsList(String userId) {
    return StreamBuilder<List<ApplicationModel>>(
      stream: ApplicationService.getApplicationsForUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (snapshot.hasError) {
          return _buildErrorWidget('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Utils.noDataFound();
        } else {
          List<ApplicationModel> userApplications =
              snapshot.data!.reversed.toList();
          return _buildApplicationsListView(userApplications);
        }
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Center(
      child: Text(errorMessage),
    );
  }

  Widget _buildApplicationsListView(List<ApplicationModel> userApplications) {
    return ListView.builder(
      itemCount: userApplications.length,
      itemBuilder: (context, index) {
        ApplicationModel application = userApplications[index];
        return _buildJobDetailsTile(application);
      },
    );
  }

  Widget _buildJobDetailsTile(ApplicationModel application) {
    return ListTile(
      title: _buildJobDetailsStream(application),
    );
  }

  Widget _buildJobDetailsStream(ApplicationModel application) {
    return StreamBuilder<JobPostModel?>(
      stream: JobService.getJobDetailsStream(application.jobPost),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          JobPostModel? jobDetails = snapshot.data;
          return _buildJobDetailsWidget(jobDetails, application.status);
        }
      },
    );
  }

  Widget _buildJobDetailsWidget(
      JobPostModel? jobDetails, String applicationStatus) {
    if (jobDetails != null) {
      return JobsCard(
          jobPostModel: jobDetails, applicationStatus: applicationStatus);
    } else {
      return Utils.noDataFound();
    }
  }
}

class JobsCard extends StatelessWidget {
  const JobsCard(
      {Key? key, required this.jobPostModel, required this.applicationStatus})
      : super(key: key);

  final JobPostModel jobPostModel;
  final String applicationStatus;

  @override
  Widget build(BuildContext context) {
    final hero_tag = "${jobPostModel.id}_hero_tag";

    return Container(
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
          Utils.navigateTo(context,
              JobPostDetailsScreen(jobPostModel: jobPostModel, tag: hero_tag));
        },
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(30),
                    // Left Side Image
                    leading: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      // Right Side Padding
                      child: JobProfileImage(
                          imageUrl: jobPostModel.image,
                          imageName: "${jobPostModel.id}_hero_tag",
                          tag: hero_tag),
                    ),

                    // Right Side Information
                    title: Text(jobPostModel.jobTitle,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: ProfileDetails(
                      email: jobPostModel.email,
                      teamSize: 20,
                      jobType: jobPostModel.jobType,
                    ),
                  ),
                ),
              ),
            ),
            // Status
            Positioned(
              top: Utils.scrHeight * 0.02,
              right: Utils.scrHeight * 0.02,
              child:
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: _getTextColor(applicationStatus)),
                  borderRadius: BorderRadius.circular(5),
                  color: _getContainerColor(applicationStatus)),
              child: Text(applicationStatus,style: const TextStyle(fontSize: 12),),
            ),)
          ],
        ),
      ),
    );
  }
}

class JobProfileImage extends StatelessWidget {
  const JobProfileImage(
      {Key? key, required this.imageUrl, this.imageName, required this.tag})
      : super(key: key);

  final String? imageUrl;
  final String? imageName;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: tag,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          // Image Elevation
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 10,
              spreadRadius: -2,
              offset: const Offset(-10, 4),
            ),
          ],
        ),
        child: CachedNetworkImage(imageUrl: imageUrl!, fit: BoxFit.cover),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails(
      {Key? key,
      required this.email,
      required this.teamSize,
      required this.jobType})
      : super(key: key);

  final String email;
  final int teamSize;
  final String jobType;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text('Type: $jobType',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 8),

      ],
    );
  }
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
