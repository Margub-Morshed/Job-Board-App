import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../utils/utils.dart';

class RecommendedPost extends StatelessWidget {
  const RecommendedPost(
      {super.key,
      required this.jobTitle,
      required this.jobShortDec,
      required this.image,
      this.onTap});

  final String image;
  final String jobTitle;
  final String jobShortDec;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Utils.scrHeight * .25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Utils.scrHeight * .01),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Utils.scrHeight * .01),
                  topLeft: Radius.circular(Utils.scrHeight * .01),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child:
                      CachedNetworkImage(imageUrl: image, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: Utils.scrHeight * .015),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    jobTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    jobShortDec.length > 22
                        ? '${jobShortDec.substring(0, 22)}...' // Truncate the text if it exceeds 22 characters
                        : jobShortDec,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
