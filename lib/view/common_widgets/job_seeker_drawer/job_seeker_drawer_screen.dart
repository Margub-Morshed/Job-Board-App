import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/view/home/job_seeker_home_screen.dart';
import 'package:job_board_app/view/profile/profile_screen.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/session/session_services.dart';
import '../../../utils/utils.dart';
import '../../favorites/job_seeker_favorites.dart';
import '../../login/login_screen.dart';
import '../../show_applicant_list/job_seeker_applied_jobs_screen.dart';

class JobSeekerDrawerScreen extends StatefulWidget {
  const JobSeekerDrawerScreen({super.key});

  @override
  State<JobSeekerDrawerScreen> createState() => _JobSeekerDrawerScreenState();
}

class _JobSeekerDrawerScreenState extends State<JobSeekerDrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5872de),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: CachedNetworkImage(
                      imageUrl: SessionManager.userModel!.userAvatar ??
                          Utils.flutterDefaultImg,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  SessionManager.userModel!.name!,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                NewRow(
                  onTap: (){
                    Utils.navigateTo(context, JobSeekerHomeScreen());
                  },
                  text: 'Home',
                  icon: Icons.home,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: () {
                    Utils.navigateTo(
                        context,
                        ProfileScreen(
                            role: "Job Seeker",
                            userModel: SessionManager.userModel));
                  },
                  text: 'Profile',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
                NewRow(
                  onTap: () {
                    Utils.navigateTo(
                        context, const JobSeekerAppliedJobsScreen());
                  },
                  text: 'Jobs',
                  icon: Icons.bookmark_border,
                ),
                const SizedBox(height: 20),
                NewRow(
                  onTap: () {
                    Utils.navigateTo(context, const JobSeekerFavorites());
                  },
                  text: 'Favorites',
                  icon: Icons.favorite_border,
                ),
                const SizedBox(height: 20),
              ],
            ),
            InkWell(
              onTap: () {
                AuthService.signOut().then((value) {
                  Utils.navigateReplaceTo(context, const LoginScreen());
                  Utils.showSnackBar(context, 'Successfully Log OUt');
                });
              },
              child: const Row(
                children: <Widget>[
                  Icon(Icons.cancel, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    'Log out',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class NewRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  const NewRow({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
