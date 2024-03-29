import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/view/home/company_admin_home_screen.dart';
import 'package:job_board_app/view/input/input_screen.dart';
import 'package:job_board_app/view/job_post_list/company_post_list_screen.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/session/session_services.dart';
import '../../../utils/utils.dart';
import '../../login/login_screen.dart';
import '../../profile/company_admin_profile_screen.dart';
import '../../show_all_applications/company_admin_all_application_screen.dart';

class CompanyAdminDrawerScreen extends StatefulWidget {
  const CompanyAdminDrawerScreen({super.key});

  @override
  State<CompanyAdminDrawerScreen> createState() => _CompanyAdminDrawerScreenState();
}

class _CompanyAdminDrawerScreenState extends State<CompanyAdminDrawerScreen> {
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
                      imageUrl: SessionManager.companyModel!.logoImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  SessionManager.companyModel!.name,
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
                    Utils.navigateTo(context, const CompanyAdminHomeScreen());
                  },
                  text: 'Home',
                  icon: Icons.home,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: (){
                    Utils.navigateTo(context, CompanyAdminProfileScreen(role: "Company Admin",companyModel: SessionManager.companyModel,));
                  },
                  text: 'Profile',
                  icon: Icons.person_outline,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: (){
                    Utils.navigateTo(context, const InputScreen());
                  },
                  text: 'Create Job Post',
                  icon: Icons.add,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: () {
                    Utils.navigateTo(context, const CompanyPostListScreen());
                  },
                  text: 'My Jobs',
                  icon: Icons.bookmark_border,
                ),
                const SizedBox(
                  height: 20,
                ),
                NewRow(
                  onTap: () {
                    Utils.navigateTo(context, const CompanyAdminAllApplicationScreen());                  },
                  text: 'ALl Applications',
                  icon: Icons.document_scanner_outlined,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            InkWell(
              onTap: (){
                AuthService.signOut().then((value) {
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
            style: const TextStyle(color: Colors.white,fontSize: 16),
          )
        ],
      ),
    );
  }
}
