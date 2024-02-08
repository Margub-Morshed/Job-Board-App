import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/job_post_model.dart';
import '../../utils/utils.dart';
import '../show_applicant_list/super_admin_applications_list_screen.dart';

class SuperAdminJobPostDetailsScreen extends StatefulWidget {
  final JobPostModel jobPostModel;
  final String tag;

  const SuperAdminJobPostDetailsScreen(
      {Key? key, required this.jobPostModel, required this.tag})
      : super(key: key);

  @override
  State<SuperAdminJobPostDetailsScreen> createState() => _SuperAdminJobPostDetailsScreenState();
}

class _SuperAdminJobPostDetailsScreenState extends State<SuperAdminJobPostDetailsScreen> {
  late String jobId;
  @override
  void initState() {
    super.initState();
    jobId = widget.jobPostModel.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Job Details")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Job Post Details
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Utils.scrHeight * .02,
                  vertical: Utils.scrHeight * .02),
              children: [
                // Job Post Image
                Hero(
                  tag: widget.tag,
                  transitionOnUserGestures: true,
                  child: ClipRRect(
                    borderRadius:
                    BorderRadius.circular(Utils.scrHeight * .02),
                    child: CachedNetworkImage(
                      imageUrl: widget.jobPostModel.image ??
                          Utils.flutterDefaultImg,
                      width: double.infinity,
                      height: Utils.scrHeight * .25,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                //Company name
                Text(
                  widget.jobPostModel.createdBy,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: Utils.scrHeight * .02),


                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Job Title and Company
                    Text(
                      widget.jobPostModel.jobTitle,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: _getTextColor(widget.jobPostModel.status)),
                          borderRadius: BorderRadius.circular(10),
                          color: _getContainerColor(widget.jobPostModel.status)),
                      child: Text(
                        ' ${widget.jobPostModel.status}',
                        style: const TextStyle(
                            fontSize: 16),
                      )
                    )
                  ],
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Other Job Details
                Text('Type: ${widget.jobPostModel.jobType}'),
                SizedBox(height: Utils.scrHeight * .02),

                Row(
                  children: [
                    const Text('Salary Range:', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white),
                      child: Text(
                          widget.jobPostModel.salaryRange ?? "Not specified",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black)),
                    ),
                  ],
                ),

                SizedBox(height: Utils.scrHeight * .02),

                // Application Deadline
                Text(
                    'Application Deadline: ${widget.jobPostModel.applicationDeadline}'),

                SizedBox(height: Utils.scrHeight * .025),

                // Job Description
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white),
                  child: Text(
                    widget.jobPostModel.description,
                    style: const TextStyle(
                        fontSize: 15, color: Colors.black54, height: 2.2),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Add more details as needed
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuperAdminApplicantListScreen(
                          jobPostModel: widget.jobPostModel,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: Utils.scrHeight * .02,
                        vertical: Utils.scrHeight * .005),
                    height: Utils.scrHeight * .055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xff5872de),
                    ),
                    child: const Text("See All Application on this post",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                ),

                SizedBox(height: Utils.scrHeight * .01),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getContainerColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green.shade100;
      case 'Suspend':
        return Colors.orange.shade100;
      case 'Remove':
        return Colors.red.shade100;
    // Add more cases if needed
      default:
        return Colors.black; // Default color
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Suspend':
        return Colors.orange;
      case 'Remove':
        return Colors.red;
    // Add more cases if needed
      default:
        return Colors.black; // Default color
    }
  }
}

