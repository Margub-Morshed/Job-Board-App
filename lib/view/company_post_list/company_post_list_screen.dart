import 'package:flutter/material.dart';
import 'package:job_board_app/view/job_post_details/company_job_post_detail_screen.dart';
import 'package:job_board_app/view/show_applicant_list/company_admin_applicant_list_screen.dart';
import '../../model/job_post_model.dart';
import '../../services/job_post/job_post_service.dart';
import '../../utils/utils.dart';
import '../home/widget/job_seeker/recent_job_post.dart';
import '../home/widget/job_seeker/recommended_post.dart';
import '../job_post_details/job_post_details_screen.dart';

class CompanyPostListScreen extends StatefulWidget {
  const CompanyPostListScreen({Key? key}) : super(key: key);

  @override
  State<CompanyPostListScreen> createState() => _CompanyPostListScreenState();
}

class _CompanyPostListScreenState extends State<CompanyPostListScreen> {
  final JobService jobService = JobService();

  final TextEditingController _searchController = TextEditingController();

  // for storing searched items
  final List<JobPostModel> _searchList = [];

  // for storing search status
  bool _isSearching = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
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
          List<JobPostModel> displayedJobPosts = _searchController.text.isNotEmpty? _searchList : jobPosts;


          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                // CustomSearchBar(searchController: _searchController),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: Utils.scrHeight * .055,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10), color: Colors.white),
                        child: Builder(
                            builder: (BuildContext context) {
                              return TextField(

                                onChanged: (val) {
                                  setState(() {
                                    // _isSearching = val.isNotEmpty;
                                    _searchList.clear();

                                    _searchList.addAll(jobPosts.where((jobPost) =>
                                    jobPost.jobTitle.toLowerCase().contains(val.toLowerCase()) ||
                                        jobPost.email.toLowerCase().contains(val.toLowerCase()) ||
                                        jobPost.jobType.toLowerCase().contains(val.toLowerCase())).toList());
                                  });
                                },
                                controller: _searchController,
                                decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 2),
                                    label: Text('Search'),
                                    enabledBorder:
                                    OutlineInputBorder(borderSide: BorderSide.none),
                                    focusedBorder:
                                    OutlineInputBorder(borderSide: BorderSide.none),
                                    prefixIcon: Icon(Icons.search)),
                              );
                            }
                        ),
                      ),
                    ),
                    SizedBox(width: Utils.scrHeight * .02),
                    GestureDetector(
                      child: Container(
                        width: Utils.scrHeight * .050,
                        height: Utils.scrHeight * .048,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Utils.scrHeight * .01),
                            color: const Color(0xff5872de)),
                        child: SizedBox(
                            height: Utils.scrHeight * .01,
                            width: Utils.scrHeight * .01,
                            child: const Icon(Icons.filter_list_alt, color: Colors.white)),
                      ),
                    )
                  ],
                ),
                SizedBox(height: Utils.scrHeight * .02),
                // Recommended Post For User
                const Text("Recommended For You",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: Utils.scrHeight * .02),
                SizedBox(
                  height: Utils.scrHeight * .195,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: displayedJobPosts.length,
                    itemBuilder: (context, index) {
                      JobPostModel jobPost =  displayedJobPosts[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: RecommendedPost(
                          image: jobPost.image ??
                              "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png",
                          jobTitle: jobPost.jobTitle,
                          jobShortDec: jobPost.description,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Recent Post For User
                const Text("Recently Posted",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: Utils.scrHeight * .02),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedJobPosts.length,
                    itemBuilder: (context, index) {
                      JobPostModel jobPost = displayedJobPosts[index];
                      return GestureDetector(

                        onTap: () {
                          final tag = "${jobPost.id}_hero_tag";
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CompanyJobPostDetailsScreen(jobPostModel: jobPost, tag: tag),
                          ));
                        },
                        child: RecentJobPost(jobPostModel: jobPost,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ShowApplicantList(jobPostModel: jobPost,),
                            ));
                          },
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}




