import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/services/session/session_services.dart';
import '../../../../services/favorite/favorite_service.dart';
import '../../../../utils/utils.dart';

class CompanyAdminRecentJobPost extends StatefulWidget {
  const CompanyAdminRecentJobPost(
      {super.key, required this.jobPostModel, this.onTap});

  final VoidCallback? onTap;
  final JobPostModel jobPostModel;

  @override
  State<CompanyAdminRecentJobPost> createState() =>
      _CompanyAdminRecentJobPostState();
}

class _CompanyAdminRecentJobPostState extends State<CompanyAdminRecentJobPost> {
  late ValueNotifier<bool> isAlreadySelected;

  @override
  void initState() {
    super.initState();
    isAlreadySelected = ValueNotifier<bool>(false);
    _fetchFavoriteStatus();
  }

  Future<void> _fetchFavoriteStatus() async {
    bool isFavorite = await FavoriteService.checkIfFavorite(
        SessionManager.userModel!.id, widget.jobPostModel.id);

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
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 10,
              spreadRadius: -8,
              offset: const Offset(-6, 4)),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Row(
                  children: [
                    // Left Side Image Part
                    Hero(
                        tag: tag,
                        transitionOnUserGestures: true,
                        child: CachedNetworkImage(
                            imageUrl: widget.jobPostModel.image ??
                                Utils.flutterDefaultImg,
                            width: 93,
                            height: 94)),
                    const SizedBox(width: 20),

                    // Right Side Information Part
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.jobPostModel.jobTitle,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        SizedBox(
                            width: 220,
                            child: Text(
                                'Job Type: ${widget.jobPostModel.jobType}',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500))),
                        Text(
                            'Deadline: ${widget.jobPostModel.applicationDeadline}',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    // Check if the post is already in the user's favorites
    bool isAlreadyFavorite = await FavoriteService.checkIfFavorite(
        SessionManager.userModel!.id, widget.jobPostModel.id);

    // Toggle isSelected when the button is tapped
    isAlreadySelected.value = !isAlreadySelected.value;

    if (isAlreadySelected.value && !isAlreadyFavorite) {
      // If the post is not already in favorites, add it
      await FavoriteService.addToFavorites(
          SessionManager.userModel!.id, widget.jobPostModel.id);
      print("Added to Favorites");
    } else if (!isAlreadySelected.value && isAlreadyFavorite) {
      // If the post is already in favorites, remove it
      await FavoriteService.removeFromFavorites(
          SessionManager.userModel!.id, widget.jobPostModel.id);
      print("Removed from Favorites");
    }
  }

  @override
  void dispose() {
    isAlreadySelected.dispose();
    super.dispose();
  }
}
