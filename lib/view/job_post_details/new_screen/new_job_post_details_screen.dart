import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/services/favorite/favorite_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/utils/constants.dart';
import 'package:job_board_app/view/home/job_seeker_home_screen.dart';
import '../../../services/application/application_service.dart';
import '../../../utils/utils.dart';
import '../../input/application_screen.dart';

class NewJobPostDetailsScreen extends StatefulWidget {
  final JobPostModel jobPostModel;
  final String tag;

  const NewJobPostDetailsScreen(
      {Key? key, required this.jobPostModel, required this.tag})
      : super(key: key);

  @override
  State<NewJobPostDetailsScreen> createState() =>
      _NewJobPostDetailsScreenState();
}

class _NewJobPostDetailsScreenState extends State<NewJobPostDetailsScreen> {
  late String selectedStatus;
  late String userId;
  late String jobId;
  late ValueNotifier<bool> isAlreadySelected;
  late bool hasUserApplied = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.jobPostModel.status;
    userId = SessionManager.userModel!.id;
    jobId = widget.jobPostModel.id;
    isAlreadySelected = ValueNotifier<bool>(false);

    _checkUserApplicationStatus();
    _fetchFavoriteStatus();
  }

  Future<void> _checkUserApplicationStatus() async {
    try {
      // Check if the user has already applied
      bool applied = await ApplicationService.hasUserApplied(userId, jobId);

      setState(() {
        hasUserApplied = applied;
      });
    } catch (e) {
      print('Error checking user application status: $e');
    }
  }

  Future<void> _fetchFavoriteStatus() async {
    bool isFavorite = await FavoriteService.checkIfFavorite(userId, jobId);

    if (mounted) {
      isAlreadySelected.value = isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color(0xffF6F6F6),
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xfff6f6f6),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(Utils.scrHeight * .05),
                            bottomRight:
                                Radius.circular(Utils.scrHeight * .05))),
                    height: Utils.scrHeight * .15,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: Utils.scrHeight * .02,
                        bottom: Utils.scrHeight * .05,
                        left: Utils.scrHeight * .02,
                        right: Utils.scrHeight * .02,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Utils.navigateReplaceTo(
                                  context, const JobSeekerHomeScreen());
                            },
                          ),
                          Container(child: favoriteIconButton()),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: Utils.scrHeight * .08,
                        left: Utils.scrHeight * .025,
                        right: Utils.scrHeight * .025,
                        bottom: Utils.scrHeight * .08),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: Utils.scrHeight * .25,
                        //   child: Hero(
                        //     tag: widget.tag,
                        //     transitionOnUserGestures: true,
                        //     child: ClipRRect(
                        //       borderRadius:
                        //       BorderRadius.circular(Utils.scrHeight * .02),
                        //       child: CachedNetworkImage(
                        //         imageUrl: widget.jobPostModel.image ??
                        //             Utils.flutterDefaultImg,
                        //         width: double.infinity,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: Utils.scrHeight * .02),

                        // Title & Add To Favorites
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.jobPostModel.jobTitle,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(height: Utils.scrHeight * .02),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.jobPostModel.createdBy,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: Utils.scrHeight * .02),

                        // Application Deadline
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: appThemeColor,
                            ),
                            Text(
                              widget.jobPostModel.address,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: Utils.scrHeight * .02),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DescriptionCard(
                              icon: Icons.monetization_on_outlined,
                              title: "Salary (Monthly)",
                              subTitle: widget.jobPostModel.salaryRange ??
                                  "Not specified",
                            ),
                            DescriptionCard(
                              icon: Icons.type_specimen,
                              title: "Job Type",
                              subTitle: widget.jobPostModel.jobType ??
                                  "Not specified",
                            ),
                          ],
                        ),
                        SizedBox(height: Utils.scrHeight * .02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DescriptionCard(
                              icon: Icons.join_right_sharp,
                              title: "Experience",
                              subTitle: widget.jobPostModel.experience ??
                                  'Not Required',
                            ),
                            DescriptionCard(
                              icon: Icons.location_on,
                              title: "Level",
                              subTitle: widget.jobPostModel.careerLevel ??
                                  "Not Needed",
                            ),
                          ],
                        ),

                        SizedBox(height: Utils.scrHeight * .02),

                        // Application Deadline
                        Text(
                          'Application Deadline: ${widget.jobPostModel.applicationDeadline}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),

                        // Row(
                        //   children: [
                        //     const Text('Salary Range:',
                        //         style: TextStyle(fontSize: 16)),
                        //     const SizedBox(width: 5),
                        //     Container(
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 5, horizontal: 10),
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(8),
                        //           color: Colors.white),
                        //       child: Text(
                        //           widget.jobPostModel.salaryRange ??
                        //               "Not specified",
                        //           style: const TextStyle(
                        //               fontSize: 14,
                        //               fontWeight: FontWeight.w700,
                        //               color: Colors.black)),
                        //     ),
                        //   ],
                        // ),

                        SizedBox(height: Utils.scrHeight * .02),

                        // Job Description
                        const Text(
                          "Description",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: Utils.scrHeight * .02),

                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white),
                          child: Text(
                            widget.jobPostModel.description,
                            style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                                height: 2.2),
                            textAlign: TextAlign.justify,
                          ),
                        ),

                        SizedBox(height: Utils.scrHeight * .025),

                        // Add more details as needed
                        GestureDetector(
                          onTap: () {
                            if (!hasUserApplied) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplicationScreen(
                                    jobPostModel: widget.jobPostModel,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: Utils.scrHeight * .02,
                              vertical: Utils.scrHeight * .005,
                            ),
                            height: Utils.scrHeight * .055,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(
                                  hasUserApplied ? 0xffbfd6ff : 0xff5872de),
                            ),
                            child: hasUserApplied
                                ? const Text(
                                    "Already Applied",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Apply Here",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Icon(Icons.arrow_forward,
                                          color: Colors.white)
                                    ],
                                  ),
                          ),
                        ),
                        SizedBox(height: Utils.scrHeight * .01),
                        SizedBox(
                          height: Utils.scrHeight * .07,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: Utils.scrHeight * .08,
                right: Utils.scrHeight * .15,
                left: Utils.scrHeight * .15,
                child: // Job Post Image
                    ClipOval(
                      child: CachedNetworkImage(
                          imageUrl: widget.jobPostModel.image ??
                              Utils.flutterDefaultImg,
                          fit: BoxFit.cover,
                          width: Utils.scrHeight * .14,
                          height: Utils.scrHeight * .16),
                    ),
              )
            ],
          )
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Job Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Utils.navigateReplaceTo(context, const JobSeekerHomeScreen());
          },
        ),
        actions: [
          favoriteIconButton(),
        ]);
  }

  Future<void> _toggleFavorite() async {
    // Check if the post is already in the user's favorites
    bool isAlreadyFavorite =
        await FavoriteService.checkIfFavorite(userId, jobId);

    // Toggle isSelected when the button is tapped
    isAlreadySelected.value = !isAlreadySelected.value;

    if (isAlreadySelected.value && !isAlreadyFavorite) {
      // If the post is not already in favorites, add it
      await FavoriteService.addToFavorites(userId, jobId);
      print("Added to Favorites");
    } else if (!isAlreadySelected.value && isAlreadyFavorite) {
      // If the post is already in favorites, remove it
      await FavoriteService.removeFromFavorites(userId, jobId);
      print("Removed from Favorites");
    }
  }

  Widget favoriteIconButton() {
    return ValueListenableBuilder(
      valueListenable: isAlreadySelected,
      builder: (context, value, child) {
        return Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              await _toggleFavorite();
            },
            child: Icon(
              isAlreadySelected.value
                  ? Icons.favorite
                  : Icons.favorite_border_outlined,
              color: isAlreadySelected.value
                  ? const Color(0xff5872de)
                  : Colors.black54,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    isAlreadySelected.dispose();
    super.dispose();
  }
}

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final IconData icon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Utils.scrHeight * .2,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 1),
          color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: appThemeColor,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black)),
              Text(subTitle,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: appThemeColor)),
            ],
          )
        ],
      ),
    );
  }
}
