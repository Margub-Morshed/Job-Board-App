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
          return _buildJobDetailsWidget(
              jobDetails, application.status, context);
        }
      },
    );
  }

  Widget _buildJobDetailsWidget(JobPostModel? jobDetails,
      String applicationStatus, BuildContext context) {
    if (jobDetails != null) {
      return AppliedJobPost(
        jobPostModel: jobDetails,
        applicationStatus: applicationStatus,
        onTap: () {
          final hero_tag = "${jobDetails.id}_hero_tag";
          Utils.navigateTo(context,
              JobPostDetailsScreen(jobPostModel: jobDetails, tag: hero_tag));
        },
      );
      // return JobsCard(
      //     jobPostModel: jobDetails, applicationStatus: applicationStatus);
    } else {
      return Utils.noDataFound();
    }
  }
}

class AppliedJobPost extends StatefulWidget {
  const AppliedJobPost(
      {super.key,
        required this.jobPostModel,
        this.onTap,
        required this.applicationStatus});

  final VoidCallback? onTap;
  final JobPostModel jobPostModel;
  final String applicationStatus;

  @override
  State<AppliedJobPost> createState() => _AppliedJobPostState();
}

class _AppliedJobPostState extends State<AppliedJobPost> {
  late ValueNotifier<bool> isAlreadySelected;

  @override
  void initState() {
    super.initState();
    isAlreadySelected = ValueNotifier<bool>(false);
  }

  @override
  Widget build(BuildContext context) {
    final tag = "${widget.jobPostModel.id}_hero_tag";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
            spreadRadius: -8,
            offset: const Offset(-6, 4),
          ),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Stack(
          children: [
            SizedBox(
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        // Left Side Image Part
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          child: Hero(
                            tag: tag,
                            transitionOnUserGestures: true,
                            child: CachedNetworkImage(
                              imageUrl: widget.jobPostModel.image ??
                                  Utils.flutterDefaultImg,
                              width: 130,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Side Information Part
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          width: Utils.scrHeight * .225,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.jobPostModel.jobTitle,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: Utils.scrHeight * .003),
                              SizedBox(
                                width: 220,
                                child: Text(
                                  'Job Type: ${widget.jobPostModel.jobType}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: Utils.scrHeight * .003),
                              Text(
                                'Deadline: ${widget.jobPostModel.applicationDeadline}',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Status
            Positioned(
              top: Utils.scrHeight * 0.005,
              right: Utils.scrHeight * 0.005,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: _getTextColor(widget.applicationStatus)),
                    borderRadius: BorderRadius.circular(5),
                    color: _getContainerColor(widget.applicationStatus)),
                child: Text(
                  widget.applicationStatus,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    isAlreadySelected.dispose();
    super.dispose();
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


// Not Needed Right Now

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
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: _getTextColor(applicationStatus)),
                    borderRadius: BorderRadius.circular(5),
                    color: _getContainerColor(applicationStatus)),
                child: Text(
                  applicationStatus,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            )
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

