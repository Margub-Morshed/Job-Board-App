import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/view/company_list/company_list_screen.dart';
import 'package:job_board_app/view/home/super_admin_home_screen.dart';
import 'package:job_board_app/view/super_admin_job_post_list/super_admin_job_post_screen.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/login_session/login_session.dart';
import '../../../services/session/session_services.dart';
import '../../../utils/utils.dart';
import '../../login/login_screen.dart';
import '../../profile/super_admin_profile_screen.dart';
import '../../show_all_applications/super_admin_all_application_list_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff5872de),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 50),
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
                      imageUrl: SessionManager.superAdminModel!.userAvatar!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  SessionManager.superAdminModel!.name,
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
                    Utils.navigateTo(context, const SuperAdminHomeScreen());
                  },
                  text: 'Home',
                  icon: Icons.home,
                ),
                const SizedBox(
                  height: 20,
                ),
                 NewRow(
                  onTap: (){
                    Utils.navigateTo(context, SuperAdminProfileScreen(role: "Super Admin", superAdminModel: SessionManager.superAdminModel,));
                  },
                  text: 'Profile',
                  icon: Icons.person_outline,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: (){
                    Utils.navigateTo(context, const CompanyListScreen());
                  },
                  text: 'Company List',
                  icon: Icons.bookmark_border,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: (){
                    Utils.navigateTo(context, const SuperAdminJobPostScreen());
                  },
                  text: 'All Job Post',
                  icon: Icons.post_add,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: (){
                    Utils.navigateTo(context, const SuperAdminAllApplicationScreen());                  },
                  text: 'All Applications',
                  icon: Icons.document_scanner,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            InkWell(
              onTap: (){
                AuthService.signOut().then((value) {
                  LoginSession.clearSessionData();
                  Utils.navigateReplaceTo(context, const LoginScreen());
                  Utils.showSnackBar(context, 'Successfully Log OUt');
                });
              },
              child: const Row(
                children: <Widget>[
                  Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
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
    required this.text, this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
