import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/model/job_post_model.dart';
import 'package:job_board_app/view/company_post_list/company_post_list_screen.dart';
import 'package:job_board_app/view/job_post_details/job_post_details_screen.dart';

import '../../../../utils/utils.dart';
import '../../../show_applicant_list/company_admin_applicant_list_screen.dart';

class RecentJobPost extends StatelessWidget {
  const RecentJobPost({super.key, required this.jobPostModel, this.onTap});

  final VoidCallback? onTap;
  final JobPostModel jobPostModel;

  @override
  Widget build(BuildContext context) {
    final tag = "${jobPostModel.id}_hero_tag";
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          width: 335,
          height: Utils.scrHeight * .1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Row(
            children: [
              Hero(
                tag: tag,
                transitionOnUserGestures: true,
                child: CachedNetworkImage(
                    imageUrl: jobPostModel.image ?? Utils.flutterDefaultImg,
                    width: 93,
                    height: 94),
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(jobPostModel.jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  Text(jobPostModel.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
