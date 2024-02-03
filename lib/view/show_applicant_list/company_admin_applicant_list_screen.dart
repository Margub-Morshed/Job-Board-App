import 'package:flutter/material.dart';
import 'package:job_board_app/model/application_model.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/services/application/application_service.dart';

import '../../utils/utils.dart';

class ShowApplicantList extends StatefulWidget {
  const ShowApplicantList({super.key, required this.jobPostModel});
  final JobPostModel jobPostModel;

  @override
  State<ShowApplicantList> createState() => _ShowApplicantListState();
}

class _ShowApplicantListState extends State<ShowApplicantList> {
  final ApplicationService applicationService = ApplicationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application List'),
      ),
      body: StreamBuilder<List<ApplicationModel>>(
        stream: applicationService.getApplicationsByPostId(widget.jobPostModel.id),
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

          List<ApplicationModel> applications = snapshot.data ?? [];
          // Use a common list to store displayed job posts
          // List<ApplicantModel> displayedJobPosts = _searchController.text.isNotEmpty? _searchList : jobPosts;


          return Padding(
            padding:  EdgeInsets.symmetric(horizontal: Utils.scrHeight * .01),
            child: applications.isNotEmpty ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar

                // Row(
                //   children: [
                //     Expanded(
                //       child: Container(
                //         height: Utils.scrHeight * .055,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10), color: Colors.white),
                //         child: Builder(
                //             builder: (BuildContext context) {
                //               return TextField(
                //
                //                 onChanged: (val) {
                //                   setState(() {
                //                     // _isSearching = val.isNotEmpty;
                //                     _searchList.clear();
                //
                //                     _searchList.addAll(jobPosts.where((jobPost) =>
                //                     jobPost.jobTitle.toLowerCase().contains(val.toLowerCase()) ||
                //                         jobPost.email.toLowerCase().contains(val.toLowerCase()) ||
                //                         jobPost.jobType.toLowerCase().contains(val.toLowerCase())).toList());
                //                   });
                //                 },
                //                 controller: _searchController,
                //                 decoration: const InputDecoration(
                //                     contentPadding: EdgeInsets.symmetric(vertical: 2),
                //                     label: Text('Search'),
                //                     enabledBorder:
                //                     OutlineInputBorder(borderSide: BorderSide.none),
                //                     focusedBorder:
                //                     OutlineInputBorder(borderSide: BorderSide.none),
                //                     prefixIcon: Icon(Icons.search)),
                //               );
                //             }
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: Utils.scrHeight * .02),
                //     GestureDetector(
                //       child: Container(
                //         width: Utils.scrHeight * .050,
                //         height: Utils.scrHeight * .048,
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(Utils.scrHeight * .01),
                //             color: const Color(0xff5872de)),
                //         child: SizedBox(
                //             height: Utils.scrHeight * .01,
                //             width: Utils.scrHeight * .01,
                //             child: const Icon(Icons.filter_list_alt, color: Colors.white)),
                //       ),
                //     )
                //   ],
                // ),

                SizedBox(height: Utils.scrHeight * .02),
                Expanded(
                  child: ListView.builder(
                    itemCount: applications.length,
                    itemBuilder: (context, index) {
                      ApplicationModel application = applications[index];
                      return Card(
                        child: ListTile(
                          title: Text(application.id),
                          subtitle: Text(widget.jobPostModel.jobTitle),
                          trailing: Text(
                              application.status
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ) : const Center(child: Text('No Application Found'),),
          );
        },
      )







    );
  }
}
