import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/session/session_services.dart';
import '../../utils/utils.dart';
import '../analytics_chart/analytics_chart.dart';
import '../analytics_chart/bar_graph_card.dart';
import '../common_widgets/super_admin_drawer/super_admin_drawer_screen.dart';
import '../company_list/company_list_screen.dart';
import '../profile/super_admin_profile_screen.dart';
import '../show_all_applications/super_admin_all_application_list_screen.dart';
import '../super_admin_job_post_list/super_admin_job_post_screen.dart';

class SuperAdminHomeScreen extends StatefulWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  State<SuperAdminHomeScreen> createState() => _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState extends State<SuperAdminHomeScreen> {
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;
  Map<String, Map<String, String>> dashboardMap = {
    'Company List': {
      'title': 'Company List',
      'image': 'assets/icons/building.png',
    },
    'Job Post': {
      'title': 'Job Post',
      'image': 'assets/icons/post.png',
    },
    'Profile': {
      'title': 'profile',
      'image': 'assets/icons/team.png',
    },
    'Applications': {
      'title': 'Applications',
      'image': 'assets/icons/cv.png',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(isDrawerOpen ? -50 : 0),
            duration: const Duration(milliseconds: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isDrawerOpen
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Admin Dashboard"),
                leading: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: isDrawerOpen
                      ? GestureDetector(
                          child: Image.asset('assets/icons/close_drawer.png',
                              height: 16, width: 16),
                          onTap: () {
                            setState(() {
                              xOffset = 0;
                              yOffset = 0;
                              isDrawerOpen = false;
                            });
                          },
                        )
                      : GestureDetector(
                          child: Image.asset(
                            'assets/icons/drawer.png',
                            height: 16,
                            width: 16,
                          ),
                          onTap: () {
                            setState(() {
                              xOffset = 320;
                              yOffset = 80;
                              isDrawerOpen = true;
                            });
                          },
                        ),
                ),
              ),
              // drawer:  DrawerScreen(),
              body: Center(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: Utils.scrHeight * .02,
                    vertical: Utils.scrHeight * .02,
                  ),
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Welcome Back',style:
                            TextStyle(fontSize: Utils.scrHeight * .018, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              '${SessionManager.superAdminModel!.name} 👋',
                              style:
                              TextStyle(fontSize: Utils.scrHeight * .03, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              DateFormat('dd MMM, yyyy, hh:mm a').format(DateTime.now()),
                              style:
                              TextStyle(fontSize: Utils.scrHeight * .016, fontWeight: FontWeight.w400),

                            ),
                          ],
                        ),
                        SizedBox(width: Utils.scrHeight * .08,),
                        Container(
                          width: Utils.scrHeight * .1,
                          height: Utils.scrHeight * .1,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(Utils.scrHeight * .05),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Utils.scrHeight * .05),
                            child: CachedNetworkImage(
                              imageUrl: SessionManager.superAdminModel!.userAvatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Utils.scrHeight * .02),
                    Padding(
                        padding: EdgeInsets.only(top: Utils.scrHeight * .02),
                        child: BarGraphCard()),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Utils.scrHeight * .02,
                      ),
                      child: JobPostChart(),
                    ),
                    SizedBox(
                      height: Utils.scrHeight * .44,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Utils.scrHeight * .02,
                          mainAxisSpacing: Utils.scrHeight * .02,
                        ),
                        itemCount: dashboardMap.length,
                        itemBuilder: (context, index) {
                          String title = dashboardMap.keys.elementAt(index);
                          Map<String, String> data = dashboardMap[title] ?? {};
                          String imageUrl = data['image'] ?? '';
                          return AdminDashboardCard(
                              title: title,
                              imageUrl: imageUrl,
                              onTap: () {
                                if (index == 0) {
                                  Utils.navigateTo(
                                      context, const CompanyListScreen());
                                } else if (index == 1) {
                                  Utils.navigateTo(
                                      context, const SuperAdminJobPostScreen());
                                } else if (index == 2) {
                                  Utils.navigateTo(
                                      context,
                                      SuperAdminProfileScreen(
                                        role: "Super Admin",
                                        superAdminModel:
                                            SessionManager.superAdminModel,
                                      ));
                                } else if (index == 3) {
                                  Utils.navigateTo(context,
                                      const SuperAdminAllApplicationScreen());
                                } else {
                                  null;
                                }
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDashboardCard extends StatelessWidget {
  const AdminDashboardCard({
    super.key,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(Utils.scrHeight * .010),
      onTap: onTap,
      child: Card(
        elevation: 0.3,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Utils.scrHeight * .010),
              color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: Utils.scrHeight * 0.06,
                  width: Utils.scrHeight * 0.06,
                  child: Image.asset(imageUrl, fit: BoxFit.cover)),
              SizedBox(height: Utils.scrHeight * 0.02),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
