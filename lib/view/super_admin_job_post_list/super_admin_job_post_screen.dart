import 'package:flutter/material.dart';
import '../../model/job_post_model.dart';
import '../../services/job_post/job_post_service.dart';
import '../../utils/utils.dart';
import '../filter/company_admin_filter_screen.dart';
import '../home/widget/company_admin/admin_recent_job_post.dart';
import '../job_post_details/super_admin_job_post_details_screen.dart';

class SuperAdminJobPostScreen extends StatefulWidget {
  const SuperAdminJobPostScreen({Key? key}) : super(key: key);

  @override
  State<SuperAdminJobPostScreen> createState() => _SuperAdminJobPostScreenState();
}

class _SuperAdminJobPostScreenState extends State<SuperAdminJobPostScreen> {
  final JobService jobService = JobService();
  final TextEditingController _searchController = TextEditingController();
  final List<JobPostModel> _searchList = [];
  final ValueNotifier<bool> _searchNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Text('Jobs')),
      body: StreamBuilder<List<JobPostModel>>(
        stream: jobService.getPostsStream(),
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
                CustomSearchBar(searchList: _searchList, jobPosts: jobPosts, searchNotifier: _searchNotifier, searchController: _searchController),
                SizedBox(height: Utils.scrHeight * .02),


                // Recent Post For User
                const Text("All Jobs Post",
                    style:
                    TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: Utils.scrHeight * .02),
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
                            Utils.navigateTo(
                              context,
                              SuperAdminJobPostDetailsScreen(
                                  jobPostModel: jobPost, tag: tag),
                            );
                          },
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
                            Utils.navigateTo(
                              context,
                              SuperAdminJobPostDetailsScreen(
                                  jobPostModel: jobPost, tag: tag),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required List<JobPostModel> searchList,
    required this.jobPosts,
    required ValueNotifier<bool> searchNotifier,
    required TextEditingController searchController,
  }) : _searchList = searchList, _searchNotifier = searchNotifier, _searchController = searchController;

  final List<JobPostModel> _searchList;
  final List<JobPostModel> jobPosts;
  final ValueNotifier<bool> _searchNotifier;
  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
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
}


