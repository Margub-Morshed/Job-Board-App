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
  }

  @override
  Widget build(BuildContext context) {
    final tag = "${widget.jobPostModel.id}_hero_tag";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
        child: SizedBox(
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
                    // Left Side Image Part
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12)),
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
                    const SizedBox(width: 16),

                    // Right Side Information Part
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.jobPostModel.jobTitle,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          SizedBox(height: Utils.scrHeight * .003),
                          SizedBox(
                            width: 220,
                            child: Text(
                              'Job Type: ${widget.jobPostModel.jobType}',
                              style: const TextStyle(
                                  color: Colors.black38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: Utils.scrHeight * .003),
                          Text(
                            'Deadline: ${widget.jobPostModel.applicationDeadline}',
                            style: const TextStyle(
                                color: Colors.black38,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
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
