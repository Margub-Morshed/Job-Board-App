import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/job_post_model.dart';

import '../../../../utils/utils.dart';

class RecentJobPost extends StatelessWidget {
  const RecentJobPost({super.key, required this.jobPostModel, this.onTap});

  final VoidCallback? onTap;

  final JobPostModel jobPostModel;

  @override
  Widget build(BuildContext context) {
    final tag = "${jobPostModel.id}_hero_tag";
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
            offset: const Offset(-6, 4),
          ),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
                          imageUrl:
                              jobPostModel.image ?? Utils.flutterDefaultImg,
                          width: 93,
                          height: 94),
                    ),
                    const SizedBox(width: 20),

                    // Right Side Information Part
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(jobPostModel.jobTitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(
                          width: 220,
                          child: Text(
                            jobPostModel.description,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                        )
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
}
