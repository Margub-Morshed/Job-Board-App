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
        backgroundColor: Colors.white,
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
                // return const Text('No favorite job posts found.');
              } else {
                List<JobPostModel> favoriteJobPosts = snapshot.data!;

                return ListView.builder(
                  itemCount: favoriteJobPosts.length,
                  itemBuilder: (context, index) {
                    JobPostModel jobPost = favoriteJobPosts[index];
                    return CompanyCard(jobPostModel: jobPost);
                  },
                );
              }
            },
          ),
        ));
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
