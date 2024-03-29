import 'package:flutter/material.dart';
import 'package:job_board_app/view/filter/company_admin_filter_screen.dart';
import 'package:job_board_app/view/input/input_screen.dart';
import '../../model/job_post_model.dart';
import '../../services/job_post/job_post_service.dart';
import '../../services/session/session_services.dart';
import '../../utils/utils.dart';
import '../home/company_admin_home_screen.dart';
import '../home/widget/company_admin/admin_recent_job_post.dart';
import '../home/widget/job_seeker/recommended_post.dart';
import '../job_post_details/company_job_post_detail_screen.dart';
import '../show_applicant_list/company_admin_applicant_list_screen.dart';

class CompanyPostListScreen extends StatefulWidget {
  const CompanyPostListScreen({Key? key}) : super(key: key);

  @override
  State<CompanyPostListScreen> createState() => _CompanyPostListScreenState();
}

class _CompanyPostListScreenState extends State<CompanyPostListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<JobPostModel> _searchList = [];
  final ValueNotifier<bool> _searchNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: StreamBuilder<List<JobPostModel>>(
        stream:
            JobService.getJobPostsByCompanyId(SessionManager.companyModel!.id),
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

          List<JobPostModel> jobPosts = snapshot.data ?? [];

          // Use a common list to store displayed job posts
          List<JobPostModel> displayedJobPosts =
              _searchController.text.isNotEmpty
                  ? _searchList.isNotEmpty
                      ? _searchList
                      : []
                  : jobPosts;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                _searchBar(jobPosts, context),

                SizedBox(height: Utils.scrHeight * .02),

                // Recent Job Post Section
                _jobPostCard(displayedJobPosts),
              ],
            ),
          );
        },
      ),
    );
  }

  Expanded _jobPostCard(List<JobPostModel> displayedJobPosts) {
    return Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _searchNotifier,
                  builder: (context, _, __) {
                    return _searchList.isNotEmpty
                        ? ListView.builder(
                            itemCount: _searchList.length,
                            itemBuilder: (context, index) {
                              JobPostModel jobPost = _searchList[index];
                              return CompanyAdminRecentJobPost(
                                jobPostModel: jobPost,
                                  onTap: () {
                                    final tag = "${jobPost.id}_hero_tag";
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          CompanyJobPostDetailsScreen(
                                            jobPostModel: jobPost,
                                            tag: tag,
                                          ),
                                    ));
                                  }
                              );
                            },
                          )
                        : _searchController.text.isNotEmpty
                            ? const Text("No matching jobs found")
                            : ListView.builder(
                                itemCount: displayedJobPosts.length,
                                itemBuilder: (context, index) {
                                  JobPostModel jobPost =
                                      displayedJobPosts[index];
                                  return CompanyAdminRecentJobPost(
                                    jobPostModel: jobPost,
                                      onTap: () {
                                        final tag = "${jobPost.id}_hero_tag";
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              CompanyJobPostDetailsScreen(
                                                jobPostModel: jobPost,
                                                tag: tag,
                                              ),
                                        ));
                                      }
                                  );
                                },
                              );
                  },
                ),
              );
  }

  Row _searchBar(List<JobPostModel> jobPosts, BuildContext context) {
    return Row(
                children: [
                  Expanded(
                    child: Container(
                      height: Utils.scrHeight * .055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Builder(
                        builder: (BuildContext context) {
                          return TextField(
                            onChanged: (val) {
                              _searchList.clear();
                              _searchList.addAll(jobPosts
                                  .where((jobPost) =>
                                      jobPost.jobTitle
                                          .toLowerCase()
                                          .contains(val.toLowerCase()) ||
                                      jobPost.email
                                          .toLowerCase()
                                          .contains(val.toLowerCase()) ||
                                      jobPost.jobType
                                          .toLowerCase()
                                          .contains(val.toLowerCase()))
                                  .toList());
                              // Notify listeners without using setState
                              _searchNotifier.value = !_searchNotifier.value;
                            },
                            controller: _searchController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 2),
                              hintText: 'Search',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              prefixIcon: Icon(Icons.search),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: Utils.scrHeight * .02),
                  GestureDetector(
                    onTap: () {
                      Utils.navigateTo(context, const CompanyAdminFilterScreen());
                    },
                    child: Container(
                      width: Utils.scrHeight * .050,
                      height: Utils.scrHeight * .048,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Utils.scrHeight * .01),
                        color: const Color(0xff5872de),
                      ),
                      child: SizedBox(
                        height: Utils.scrHeight * .01,
                        width: Utils.scrHeight * .01,
                        child: const Icon(Icons.filter_list_alt,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      title: const Text('My Job Post'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(onPressed: (){
            Utils.navigateTo(context, const InputScreen());
          }, icon: const Icon(Icons.add, color: Color(0xff5872de),size: 30,)),
        )
      ],
      leading: IconButton(
        onPressed: () {
          Utils.navigateReplaceTo(context, const CompanyAdminHomeScreen());
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
