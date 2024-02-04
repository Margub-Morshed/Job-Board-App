import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class JobSeekerCustomDrawerHeader extends StatelessWidget {
  final bool isCollapsed;

  const JobSeekerCustomDrawerHeader({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 60,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CachedNetworkImage(
              imageUrl:
                  "https://static.vecteezy.com/system/resources/previews/021/096/523/original/3d-icon-job-search-png.png",
              height: 40),
          if (isCollapsed) const SizedBox(width: 10),
          if (isCollapsed)
            const Expanded(
              flex: 3,
              child: Text(
                'Job Board',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
              ),
            ),
          if (isCollapsed) const Spacer(),
          if (isCollapsed)
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
