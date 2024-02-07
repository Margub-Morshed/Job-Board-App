import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/view/job_post_details/job_post_details_screen.dart';

import '../../model/job_post_model.dart';
import '../../services/favorite/favorite_service.dart';
import '../../utils/utils.dart';

class JobSeekerFavorites extends StatelessWidget {
  const JobSeekerFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    final String userId = SessionManager.userModel!.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite List'),
      ),
      body: Center(
        child: StreamBuilder<List<JobPostModel>>(
          stream: FavoriteService.getFavoriteJobPostsStream(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Utils.noDataFound();
            } else {
              List<JobPostModel> favoriteJobPosts = snapshot.data!;
              return ListView.builder(
                itemCount: favoriteJobPosts.length,
                itemBuilder: (context, index) {
                  JobPostModel jobPost = favoriteJobPosts[index];
                  final heroTag = "${jobPost.id}_hero_tag";
                  return JobPostFavorite(
                    key: ValueKey(jobPost.id), // Add ValueKey for each job post
                    jobPostModel: jobPost,
                    onTap: () {
                      Utils.navigateTo(
                        context,
                        JobPostDetailsScreen(
                          jobPostModel: jobPost,
                          tag: heroTag,
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class JobPostFavorite extends StatefulWidget {
  const JobPostFavorite({
    Key? key,
    required this.jobPostModel,
    this.onTap,
  }) : super(key: key);

  final VoidCallback? onTap;
  final JobPostModel jobPostModel;

  @override
  State<JobPostFavorite> createState() => _JobPostFavoriteState();
}

class _JobPostFavoriteState extends State<JobPostFavorite> {
  late ValueNotifier<bool> isAlreadySelected;

  @override
  void initState() {
    super.initState();
    isAlreadySelected = ValueNotifier<bool>(false);
    _fetchFavoriteStatus();
  }

  Future<void> _fetchFavoriteStatus() async {
    bool isFavorite = await FavoriteService.checkIfFavorite(
      SessionManager.userModel!.id,
      widget.jobPostModel.id,
    );

    if (mounted) {
      setState(() {
        isAlreadySelected.value = isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tag = "${widget.jobPostModel.id}_hero_tag";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
            spreadRadius: -8,
            offset: const Offset(-6, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Stack(
          children: [
            SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          child: Hero(
                            tag: tag,
                            transitionOnUserGestures: true,
                            child: CachedNetworkImage(
                              imageUrl: widget.jobPostModel.image ??
                                  Utils.flutterDefaultImg,
                              width: 120,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.jobPostModel.jobTitle,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: Utils.scrHeight * .003),
                              Text(
                                'Job Type: ${widget.jobPostModel.jobType}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: Utils.scrHeight * .003),
                              SizedBox(
                                width: 180,
                                child: Text(
                                  'Deadline: ${widget.jobPostModel.applicationDeadline}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Utils.scrHeight * 0.01,
              right: Utils.scrHeight * 0.01,
              child: ValueListenableBuilder(
                valueListenable: isAlreadySelected,
                builder: (context, value, child) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      await _toggleFavorite();
                    },

                    child: Icon(
                      isAlreadySelected.value
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color:
                      isAlreadySelected.value ? Colors.blue : Colors.black54,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    bool isAlreadyFavorite = await FavoriteService.checkIfFavorite(
      SessionManager.userModel!.id,
      widget.jobPostModel.id,
    );

    isAlreadySelected.value = !isAlreadySelected.value;

    if (isAlreadySelected.value && !isAlreadyFavorite) {
      await FavoriteService.addToFavorites(
        SessionManager.userModel!.id,
        widget.jobPostModel.id,
      );
      print("Added to Favorites");
    } else if (!isAlreadySelected.value && isAlreadyFavorite) {
      await FavoriteService.removeFromFavorites(
        SessionManager.userModel!.id,
        widget.jobPostModel.id,
      );
      print("Removed from Favorites");
    }
  }

  @override
  void dispose() {
    isAlreadySelected.dispose();
    super.dispose();
  }
}

class CompanyCard extends StatelessWidget {
  const CompanyCard({Key? key, required this.jobPostModel}) : super(key: key);

  final JobPostModel jobPostModel;

  @override
  Widget build(BuildContext context) {
    final hero_tag = "${jobPostModel.id}_hero_tag";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
            spreadRadius: -2,
            offset: const Offset(-10, 4),
          ),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Utils.navigateTo(context,
              JobPostDetailsScreen(jobPostModel: jobPostModel, tag: hero_tag));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                // Left Side Image
                leading: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  // Right Side Padding
                  child: JobProfileImage(
                      imageUrl: jobPostModel.image,
                      imageName: "${jobPostModel.id}_hero_tag",
                      tag: hero_tag),
                ),

                // Right Side Information
                title: Text(jobPostModel.jobTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: ProfileDetails(
                    email: jobPostModel.email,
                    teamSize: 20,
                    address: jobPostModel.address),
                trailing: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JobProfileImage extends StatelessWidget {
  const JobProfileImage(
      {Key? key, required this.imageUrl, this.imageName, required this.tag})
      : super(key: key);

  final String? imageUrl;
  final String? imageName;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: tag,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 10,
              spreadRadius: -2,
              offset: const Offset(-10, 4),
            ),
          ],
        ),
        child: CachedNetworkImage(
            imageUrl: imageUrl ??
                "https://cdn-images-1.medium.com/v2/resize:fit:1200/1*5-aoK8IBmXve5whBQM90GA.png",
            fit: BoxFit.cover),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails(
      {Key? key,
        required this.email,
        required this.teamSize,
        required this.address})
      : super(key: key);

  final String email;
  final int teamSize;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text('Address: $address',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
