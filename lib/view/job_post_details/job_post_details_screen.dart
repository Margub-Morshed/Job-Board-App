import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/services/favorite/favorite_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
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
  late String userId;
  late String jobId;
  late ValueNotifier<bool> isAlreadySelected;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.jobPostModel.status;
    userId = SessionManager.userModel!.id;
    jobId = widget.jobPostModel.id;
    isAlreadySelected = ValueNotifier<bool>(false);

    _fetchFavoriteStatus();
  }

  Future<void> _fetchFavoriteStatus() async {
    bool isFavorite =
    await FavoriteService.checkIfFavorite(userId, jobId);

    if (mounted) {
      setState(() {
        isAlreadySelected.value = isFavorite;
      });
    }
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
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Title & Add To Favorites
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Job Title and Company
                    Text(
                      widget.jobPostModel.jobTitle,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    ValueListenableBuilder(
                      valueListenable: isAlreadySelected,
                      builder: (context, value, child) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            await _toggleFavorite();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 16),
                            decoration: BoxDecoration(
                              color: isAlreadySelected.value
                                  ? Colors.blue
                                  : Colors.white30,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              isAlreadySelected.value
                                  ? "Added To Favorites"
                                  : "Add To Favorites",
                              style: TextStyle(
                                color: isAlreadySelected.value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }
                    ),
                  ],
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

                SizedBox(height: Utils.scrHeight * .025),

                // Add more details as needed
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicationScreen(
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
                    child: const Text("Apply",
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

  Future<void> _toggleFavorite() async {
    // Check if the post is already in the user's favorites
    bool isAlreadyFavorite = await FavoriteService.checkIfFavorite(userId, jobId);

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

  @override
  void dispose() {
    isAlreadySelected.dispose();
    super.dispose();
  }
}

