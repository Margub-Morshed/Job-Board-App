import 'package:flutter/material.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/favorites/job_seeker_favorites.dart';
import 'package:job_board_app/view/show_applicant_list/job_seeker_applied_jobs_screen.dart';

import 'job_seeker_bottom_user_info.dart';
import 'job_seeker_custom_list_tile.dart';
import 'job_seeker_header.dart';

class JobSeekerCustomDrawer extends StatefulWidget {
  const JobSeekerCustomDrawer({Key? key}) : super(key: key);

  @override
  State<JobSeekerCustomDrawer> createState() => _JobSeekerCustomDrawerState();
}

class _JobSeekerCustomDrawerState extends State<JobSeekerCustomDrawer> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: _isCollapsed ? 300 : 70,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(20, 20, 20, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              JobSeekerCustomDrawerHeader(isCollapsed: _isCollapsed),
              const Divider(color: Colors.grey),
              JobSeekerCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.home_outlined,
                title: 'Home',
                infoCount: 0,
              ),
              JobSeekerCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.calendar_today,
                title: 'Jobs',
                infoCount: 6,
                onTap: () {
                  Utils.navigateTo(context, const JobSeekerAppliedJobsScreen());
                },
              ),
              JobSeekerCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.favorite_border_outlined,
                title: 'Favorites',
                infoCount: 0,
                onTap: () {
                  Utils.navigateTo(context, const JobSeekerFavorites());
                },
                doHaveMoreOptions: Icons.arrow_forward_ios,
              ),
              JobSeekerCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.message_rounded,
                title: 'Messages',
                infoCount: 8,
              ),
              const Divider(color: Colors.grey),
              const Spacer(),
              JobSeekerCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.notifications,
                title: 'Notifications',
                infoCount: 2,
              ),
              JobSeekerCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.settings,
                title: 'Settings',
                infoCount: 0,
              ),
              const SizedBox(height: 10),
              JobSeekerBottomUserInfo(isCollapsed: _isCollapsed),
              Align(
                alignment: _isCollapsed
                    ? Alignment.bottomRight
                    : Alignment.bottomCenter,
                child: IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _isCollapsed
                        ? Icons.arrow_back_ios
                        : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
