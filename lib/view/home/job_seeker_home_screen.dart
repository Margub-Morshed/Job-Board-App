import 'package:flutter/material.dart';
import '../../model/job_post_model.dart';
import '../../services/job_post/job_post_service.dart';
import '../../utils/utils.dart';
import '../common_widgets/drawer/custom_drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
      drawer: const CustomDrawer(),
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

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                CustomSearchBar(searchController: _searchController),
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
                    itemCount: jobPosts.length,
                    itemBuilder: (context, index) {
                      JobPostModel jobPost = jobPosts[index];
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                SizedBox(height: Utils.scrHeight * .02),
                Expanded(
                  child: ListView.builder(
                    itemCount: jobPosts.length,
                    itemBuilder: (context, index) {
                      JobPostModel jobPost = jobPosts[index];
                      return RecentJobPost(jobPostModel: jobPost);
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

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required TextEditingController searchController,
  }) : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: Utils.scrHeight * .048,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                  label: Text('Search'),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
        ),
        SizedBox(width: Utils.scrHeight * .02),
        GestureDetector(
          onTap: () {},
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
    );
  }
}
