import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/view/common_widgets/job_seeker_drawer/job_seeker_drawer_screen.dart';
import 'package:job_board_app/view/filter/job_seeker_filter_screen.dart';
import 'package:job_board_app/view/home/new_widget/new_recent_job_post.dart';
import 'package:job_board_app/view/job_post_details/job_post_details_screen.dart';
import '../../../model/job_post_model.dart';
import '../../../services/job_post/job_post_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/utils.dart';
import '../../job_post_details/new_screen/new_job_post_details_screen.dart';
import '../widget/job_seeker/recommended_post.dart';


class NewJobSeekerHomeScreen extends StatefulWidget {
  const NewJobSeekerHomeScreen({Key? key}) : super(key: key);

  @override
  State<NewJobSeekerHomeScreen> createState() => _NewJobSeekerHomeScreenState();
}

class _NewJobSeekerHomeScreenState extends State<NewJobSeekerHomeScreen> {
  final JobService jobService = JobService();
  final TextEditingController _searchController = TextEditingController();
  final List<JobPostModel> _searchList = [];
  final ValueNotifier<bool> _searchNotifier = ValueNotifier<bool>(false);
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xff5872de),
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Stack(
        children: [
          const JobSeekerDrawerScreen(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(isDrawerOpen ? -50 : 0),
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isDrawerOpen
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: Scaffold(
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

                  return Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: Utils.scrHeight * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft:
                              Radius.circular(Utils.scrHeight * .028),bottomRight: Radius.circular(Utils.scrHeight * .028),),
                              color: const Color(0xff5872de),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20,top: 50),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      isDrawerOpen
                                          ? GestureDetector(
                                        child: Image.asset(
                                          'assets/icons/close_drawer.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            xOffset = 0;
                                            yOffset = 0;
                                            isDrawerOpen = false;
                                          });
                                        },
                                      )
                                          : GestureDetector(
                                        child: Image.asset(
                                          'assets/icons/drawer.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            xOffset = 320;
                                            yOffset = 80;
                                            isDrawerOpen = true;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Utils.scrHeight * .025,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          const Text('Welcome Back',style: TextStyle(
                                              fontSize: 12, fontWeight: FontWeight.w400,color: Colors.white)),
                                          Text('HI ${SessionManager.userModel!.username}!',style: TextStyle(
                                              fontSize: 24, fontWeight: FontWeight.w700,color: Colors.white)),
                                        ],
                                      ),
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: CachedNetworkImage(
                                            imageUrl: SessionManager.userModel!.userAvatar ??
                                                Utils.flutterDefaultImg,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Utils.scrHeight * .03),
                                  // Search Bar
                                  CustomSearchBar(
                                    searchController: _searchController,
                                    searchNotifier: _searchNotifier,
                                    jobPosts: jobPosts,
                                    searchList: _searchList,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // SizedBox(height: Utils.scrHeight * .01),
                              // // Search Bar
                              // CustomSearchBar(
                              //   searchController: _searchController,
                              //   searchNotifier: _searchNotifier,
                              //   jobPosts: jobPosts,
                              //   searchList: _searchList,
                              // ),
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
                                builder: (BuildContext context, bool value,
                                    Widget? child) {
                                  return _searchList.isNotEmpty
                                      ? SizedBox(
                                          height: Utils.scrHeight * .195,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: _searchList.length,
                                            itemBuilder: (context, index) {
                                              JobPostModel jobPost =
                                                  _searchList[index];
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
                                        )
                                      : _searchController.text.isNotEmpty
                                          ? const Text("No matching jobs found")
                                          : SizedBox(
                                              height: Utils.scrHeight * .195,
                                              child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: jobPosts.length,
                                                itemBuilder: (context, index) {
                                                  JobPostModel jobPost =
                                                      jobPosts[index];
                                                  return Padding(
                                                    padding: const EdgeInsets.only(
                                                        right: 8.0),
                                                    child: RecommendedPost(
                                                      image: jobPost.image ??
                                                          "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png",
                                                      jobTitle: jobPost.jobTitle,
                                                      jobShortDec:
                                                          jobPost.description,
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
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w700)),
                              // SizedBox(height: Utils.scrHeight * .02),
                              Expanded(
                                child: ValueListenableBuilder<bool>(
                                  valueListenable: _searchNotifier,
                                  builder: (context, _, __) {
                                    return _searchList.isNotEmpty
                                        ? ListView.builder(
                                            itemCount: _searchList.length,
                                            itemBuilder: (context, index) {
                                              JobPostModel jobPost =
                                                  _searchList[index];
                                              return NewRecentJobPost(
                                                jobPostModel: jobPost,
                                                onTap: () {
                                                  final tag =
                                                      "${jobPost.id}_hero_tag";
                                                  Utils.navigateTo(
                                                    context,
                                                    JobPostDetailsScreen(
                                                        jobPostModel: jobPost,
                                                        tag: tag),
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
                                                  return NewRecentJobPost(
                                                    jobPostModel: jobPost,
                                                    onTap: () {
                                                      final tag =
                                                          "${jobPost.id}_hero_tag";
                                                      Utils.navigateTo(
                                                        context,
                                                        NewJobPostDetailsScreen(
                                                            jobPostModel: jobPost,
                                                            tag: tag),
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
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
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
                hintText: 'Search Jobs...',
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        SizedBox(width: Utils.scrHeight * .02),

        // Filter Button
        GestureDetector(
          onTap: () {
            Utils.navigateTo(context, const JobSeekerFilterScreen());
          },
          child: Container(
            width: Utils.scrHeight * .050,
            height: Utils.scrHeight * .055,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Utils.scrHeight * .01),
                color: appThemeColor),
            child: SizedBox(
              height: Utils.scrHeight * .01,
              width: Utils.scrHeight * .01,
              child: const Icon(Icons.filter_list_alt, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
