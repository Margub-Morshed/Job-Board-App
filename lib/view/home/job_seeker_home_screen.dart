import 'package:flutter/material.dart';
import 'package:job_board_app/view/common_widgets/job_seeker_drawer/job_seeker_custom_drawer.dart';
import 'package:job_board_app/view/job_post_details/job_post_details_screen.dart';
import '../../model/job_post_model.dart';
import '../../services/job_post/job_post_service.dart';
import '../../utils/utils.dart';
import 'widget/job_seeker/recent_job_post.dart';
import 'widget/job_seeker/recommended_post.dart';

class JobSeekerHomeScreen extends StatefulWidget {
  const JobSeekerHomeScreen({Key? key}) : super(key: key);

  @override
  State<JobSeekerHomeScreen> createState() => _JobSeekerHomeScreenState();
}

class _JobSeekerHomeScreenState extends State<JobSeekerHomeScreen> {
  final JobService jobService = JobService();
  final TextEditingController _searchController = TextEditingController();
  List<JobPostModel> _searchList = [];
  final ValueNotifier<bool> _searchNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
      drawer: const JobSeekerCustomDrawer(),
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
                CustomSearchBar(
                  searchController: _searchController,
                  searchNotifier: _searchNotifier,
                  jobPosts: jobPosts,
                  searchList: _searchList,
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Recommended Post For User
                const Text("Recommended For You",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: Utils.scrHeight * .02),

                // Recommended For You Part
                ValueListenableBuilder<bool>(
                  valueListenable: _searchNotifier,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return _searchList.isNotEmpty
                        ? SizedBox(
                            height: Utils.scrHeight * .195,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _searchList.length,
                              itemBuilder: (context, index) {
                                JobPostModel jobPost = _searchList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: RecommendedPost(
                                    image: jobPost.image ??
                                        "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png",
                                    jobTitle: jobPost.jobTitle,
                                    jobShortDec: jobPost.description,
                                    onTap: () {
                                      final tag =
                                          "${jobPost.id}_hero_tag_recommended";
                                      Utils.navigateTo(
                                        context,
                                        JobPostDetailsScreen(
                                          jobPostModel: jobPost,
                                          tag: tag,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          )
                        : _searchController.text.isNotEmpty
                            ? const Text("No matching jobs found")
                            : SizedBox(
                                height: Utils.scrHeight * .195,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: jobPosts.length,
                                  itemBuilder: (context, index) {
                                    JobPostModel jobPost = jobPosts[index];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: RecommendedPost(
                                        image: jobPost.image ??
                                            "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png",
                                        jobTitle: jobPost.jobTitle,
                                        jobShortDec: jobPost.description,
                                        onTap: () {
                                          final tag =
                                              "${jobPost.id}_hero_tag_recommended";
                                          Utils.navigateTo(
                                            context,
                                            JobPostDetailsScreen(
                                              jobPostModel: jobPost,
                                              tag: tag,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                  },
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Recent Post For User
                const Text("Recently Posted",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: Utils.scrHeight * .02),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _searchNotifier,
                    builder: (context, _, __) {
                      return _searchList.isNotEmpty
                          ? ListView.builder(
                              itemCount: _searchList.length,
                              itemBuilder: (context, index) {
                                JobPostModel jobPost = _searchList[index];
                                return RecentJobPost(
                                  jobPostModel: jobPost,
                                  onTap: () {
                                    final tag = "${jobPost.id}_hero_tag";
                                    Utils.navigateTo(
                                      context,
                                      JobPostDetailsScreen(
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
                                    return RecentJobPost(
                                      jobPostModel: jobPost,
                                      onTap: () {
                                        final tag = "${jobPost.id}_hero_tag";
                                        Utils.navigateTo(
                                          context,
                                          JobPostDetailsScreen(
                                              jobPostModel: jobPost, tag: tag),
                                        );
                                      },
                                    );
                                  },
                                );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    Key? key,
    required this.searchController,
    required this.searchNotifier,
    required this.jobPosts,
    required this.searchList,
  }) : super(key: key);

  final TextEditingController searchController;
  final ValueNotifier<bool> searchNotifier;
  final List<JobPostModel> jobPosts;
  final List<JobPostModel> searchList;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: Utils.scrHeight * .055,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: TextField(
              controller: searchController,
              onChanged: (val) {
                searchList.clear();
                searchList.addAll(jobPosts
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
                searchNotifier.value = !searchNotifier.value;
              },
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 4),
                labelText: 'Search Jobs...',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        SizedBox(width: Utils.scrHeight * .02),
        GestureDetector(
          onTap: () {
            // Add your onTap functionality
          },
          child: Container(
            width: Utils.scrHeight * .050,
            height: Utils.scrHeight * .055,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Utils.scrHeight * .01),
                color: const Color(0xff5872de)),
            child: SizedBox(
              height: Utils.scrHeight * .01,
              width: Utils.scrHeight * .01,
              child: const Icon(Icons.filter_list_alt, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
