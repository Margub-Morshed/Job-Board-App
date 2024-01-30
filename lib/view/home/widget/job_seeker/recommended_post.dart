
import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';

class RecommendedPost extends StatelessWidget {
  const RecommendedPost({
    super.key,
    required this.jobTitle,
    required this.jobShortDec,
    required this.image,
  });

  final String image;
  final String jobTitle;
  final String jobShortDec;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Utils.scrHeight * .01),
          color: Colors.white),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(Utils.scrHeight * .01),
                topLeft: Radius.circular(Utils.scrHeight * .01),
              ),
              child: SizedBox(
                  height: Utils.scrHeight * .099,
                  width: Utils.scrHeight * .187,
                  child: Image.network(image, fit: BoxFit.cover))),
          SizedBox(height: Utils.scrHeight * .01),
          Column(
            children: [
              Text(jobTitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
              Text(jobShortDec,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ))
            ],
          )
        ],
      ),
    );
  }
}