import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';

class RecommendedPost extends StatelessWidget {
  const RecommendedPost({
    super.key,
    required this.jobTitle,
    required this.jobShortDec,
    required this.image,
    this.onTap
  });

  final String image;
  final String jobTitle;
  final String jobShortDec;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Utils.scrHeight * .22,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Utils.scrHeight * .01),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(Utils.scrHeight * .01),
                  topLeft: Radius.circular(Utils.scrHeight * .01),
                ),
                child: SizedBox(
                    height: Utils.scrHeight * .099,
                    width: Utils.scrHeight * .187,
                    child: CachedNetworkImage(
                        imageUrl: image, fit: BoxFit.contain))),
            // SizedBox(height: Utils.scrHeight * .01),
            Column(
              children: [
                Text(jobTitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
                Text(jobShortDec,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center)
              ],
            )
          ],
        ),
      ),
    );
  }
}
