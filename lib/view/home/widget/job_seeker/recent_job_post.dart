
import 'package:flutter/material.dart';

import '../../../../utils/utils.dart';

class RecentJobPost extends StatelessWidget {
  const RecentJobPost(
      {super.key,
        required this.jobTitle,
        required this.jobShortDec,
        required this.image});

  final String image;
  final String jobTitle;
  final String jobShortDec;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 335,
        height: Utils.scrHeight * .1,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(
          children: [
            Image.network(image, width: 93, height: 94),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
    );
  }
}