import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/job_post_model.dart';
import '../../utils/utils.dart';
import '../input/application_screen.dart';

class JobPostDetailsScreen extends StatefulWidget {
  final JobPostModel jobPostModel;
  final String tag;

  const JobPostDetailsScreen(
      {Key? key, required this.jobPostModel, required this.tag})
      : super(key: key);

  @override
  State<JobPostDetailsScreen> createState() => _JobPostDetailsScreenState();
}

class _JobPostDetailsScreenState extends State<JobPostDetailsScreen> {
  late String selectedStatus;

  @override
  void initState() {
    selectedStatus = widget.jobPostModel.status;
    super.initState();
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
                  tag: "${widget.tag}_hero_tag",
                  transitionOnUserGestures: true,
                  child: ClipRRect(
                      borderRadius:
                      BorderRadius.circular(Utils.scrHeight * .02),
                      child: CachedNetworkImage(
                        imageUrl: widget.jobPostModel.image ??
                            Utils.flutterDefaultImg,
                        width: double.infinity,
                        // height: Utils.scrHeight * .180,
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Job Title and Company
                Text(
                  widget.jobPostModel.jobTitle,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: Utils.scrHeight * .01),

                // Job Description
                const Text(
                  "Description",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: Utils.scrHeight * .01),

                Text(
                  widget.jobPostModel.description,
                  style: const TextStyle(fontSize: 14),
                ),
                SizedBox(height: Utils.scrHeight * .01),

                // Other Job Details
                Text('Type: ${widget.jobPostModel.jobType}'),
                SizedBox(height: Utils.scrHeight * .01),

                Text(
                    'Salary Range: ${widget.jobPostModel.salaryRange ?? "Not specified"}'),

                SizedBox(height: Utils.scrHeight * .01),

                // Application Deadline
                Text(
                    'Application Deadline: ${widget.jobPostModel.applicationDeadline}'),

                SizedBox(height: Utils.scrHeight * .02),

                // Add more details as needed

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ApplicationScreen(jobPostModel: widget.jobPostModel,)));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: Utils.scrHeight * .02,
                        vertical: Utils.scrHeight * .005),
                    height: Utils.scrHeight * .042,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff5872de)),
                    child: const Text("Apply",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                ),

                SizedBox(height: Utils.scrHeight * .01),
                // "Apply" Button
                // ElevatedButton(
                //   onPressed: () {},
                //   child: const Text('Apply'),
                // ),
              ],
            ),
          ),

          // BottomBar for change Job Post Status
          // _bottomBar(context),
        ],
      ),
    );
  }

//   Padding _bottomBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text('Change Status',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//               )),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             decoration: BoxDecoration(
//                 border:
//                 Border.all(width: 1, color: _getTextColor(selectedStatus)),
//                 borderRadius: BorderRadius.circular(10),
//                 color: _getContainerColor(selectedStatus)),
//             child: DropdownButton<JobPostStatus>(
//               underline: Container(),
//               value: selectedStatus,
//               onChanged: (newValue) async {
//                 setState(() {
//                   selectedStatus = newValue!;
//                 });
//
//                 await ProfileService.updateJobPostStatus(
//                     widget.jobPostModel.id, selectedStatus)
//                     .then((value) {
//                   Utils.showSnackBar(context,
//                       'Job Post Status ${selectedStatus.toString().split('.').last} Successfully');
//                 });
//               },
//               items: JobPostStatus.values.map((status) {
//                 return DropdownMenuItem<JobPostStatus>(
//                   value: status,
//                   child: Text(status.toString().split('.').last),
//                 );
//               }).toList(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Color _getContainerColor(JobPostStatus status) {
//     switch (status) {
//       case JobPostStatus.Active:
//         return Colors.green.shade100;
//       case JobPostStatus.Disabled:
//         return Colors.orange.shade100;
//       case JobPostStatus.Expired:
//         return Colors.red.shade100;
//     // Add more cases if needed
//       default:
//         return Colors.black; // Default color
//     }
//   }
//
//   Color _getTextColor(JobPostStatus status) {
//     switch (status) {
//       case JobPostStatus.Active:
//         return Colors.green;
//       case JobPostStatus.Disabled:
//         return Colors.orange;
//       case JobPostStatus.Expired:
//         return Colors.red;
//     // Add more cases if needed
//       default:
//         return Colors.black; // Default color
//     }
//   }
}