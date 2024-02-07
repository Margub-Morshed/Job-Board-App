import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../common_widgets/super_admin_drawer/super_admin_drawer_screen.dart';
import '../company_list/company_list_screen.dart';
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
    'Category': {
      'title': 'Category',
      'image': 'assets/icons/menu.png',
    },
    'Skill': {
      'title': 'Skill',
      'image': 'assets/icons/skill.png',
    },
    'City': {
      'title': 'City',
      'image': 'assets/icons/city.png',
    },
    'Settings': {
      'title': 'Settings',
      'image': 'assets/icons/setting.png',
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
            duration: Duration(milliseconds: 200),
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
                    child: Image.asset(
                      'assets/icons/close_drawer.png',
                      height: 16,
                      width: 16,
                    ),
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
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: Utils.scrHeight * .02,
                    vertical: Utils.scrHeight * .02,
                  ),
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
                          } else {
                            null;
                          }
                        });
                  },
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
