import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/auth/auth_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/login/login_screen.dart';

class BottomUserInfo extends StatelessWidget {
  final bool isCollapsed;

  const BottomUserInfo({
    Key? key,
    required this.isCollapsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isCollapsed ? 70 : 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isCollapsed
          ? Center(
              child: Row(
                children: [
                  // Image
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://media.licdn.com/dms/image/C5603AQFkDYayhf-m9Q/profile-displayphoto-shrink_800_800/0/1629643501179?e=2147483647&v=beta&t=7C59AWh2hjsmK8wEWgJP3oyezyacxcvnPMB6E1xtOog',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              'Morshed',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),

                        // Role
                        Expanded(
                          child: Text(
                            'JOB SEEKER',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Log Out
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          AuthService.signOut().then((value) {
                            Utils.navigateReplaceTo(context, const LoginScreen());
                            Utils.showSnackBar(context, 'Successfully Log OUt');
                          });
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Image
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://media.licdn.com/dms/image/C5603AQFkDYayhf-m9Q/profile-displayphoto-shrink_800_800/0/1629643501179?e=2147483647&v=beta&t=7C59AWh2hjsmK8wEWgJP3oyezyacxcvnPMB6E1xtOog',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Log Out
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.logout, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
    );
  }
}
