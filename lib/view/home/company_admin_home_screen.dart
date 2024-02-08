import 'package:flutter/material.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/view/common_widgets/company_admin_drawer/company_admin_custom_drawer.dart';
import 'package:job_board_app/view/common_widgets/company_admin_drawer/company_admin_drawer_screen.dart';
import 'package:svg_flutter/svg.dart';
import '../../services/auth/auth_service.dart';
import '../../utils/utils.dart';
import '../common_widgets/drawer/custom_drawer.dart';
import '../input/input_screen.dart';
import '../job_post_list/company_post_list_screen.dart';
import '../login/login_screen.dart';

class CompanyAdminHomeScreen extends StatefulWidget {
  const CompanyAdminHomeScreen({super.key});

  @override
  State<CompanyAdminHomeScreen> createState() => _CompanyAdminHomeScreenState();
}

class _CompanyAdminHomeScreenState extends State<CompanyAdminHomeScreen> {
  Map<String, Map<String, String>> dashboardMap = {
    'Job Post List': {
      'title': 'Job Post List',
      'image': 'assets/icons/post.png',
    },
    'Add Jop Post': {
      'title': 'Add Jop Post',
      'image': 'assets/icons/add.png',
    },
    'Company Profile': {
      'title': 'Add Jop Post',
      'image': 'assets/icons/team.png',
    },
  };
  double xOffset = 0;
  double yOffset = 0;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CompanyAdminDrawerScreen(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 0.85 : 1.00)
              ..rotateZ(isDrawerOpen ? -50 : 0),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isDrawerOpen
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Company Admin Dashboard"),
                leading: (SessionManager.companyModel!.status
                            .toString()
                            .split('.')
                            .last ==
                        'Active')
                    ? Container(
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
                      )
                    : null,
              ),
              body: (SessionManager.companyModel!.status
                          .toString()
                          .split('.')
                          .last ==
                      'Active')
                  ? Center(
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
                                      context, const CompanyPostListScreen());
                                } else if (index == 1) {
                                  Utils.navigateTo(
                                      context, const InputScreen());
                                } else {
                                  null;
                                }
                              });
                        },
                      ),
                    )
                  : (SessionManager.companyModel!.status
                              .toString()
                              .split('.')
                              .last ==
                          'Disabled')
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Please Wait For Admin Approval.\n       Its may take few times',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () =>
                                    AuthService.signOut().then((value) {
                                  Utils.navigateReplaceTo(
                                      context, const LoginScreen());
                                  Utils.showSnackBar(
                                      context, 'Successfully Log OUt');
                                }),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Utils.scrHeight * .02,
                                      horizontal: Utils.scrHeight * .025),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: Utils.scrHeight * .022,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                  'https://cdn.pixabay.com/photo/2020/04/01/06/08/temporarily-4990035_1280.png'),
                              const Text(
                                'You Company is Temporarily Suspended.\n',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    AuthService.signOut().then((value) {
                                  Utils.navigateReplaceTo(
                                      context, const LoginScreen());
                                  Utils.showSnackBar(
                                      context, 'Successfully Log OUt');
                                }),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Utils.scrHeight * .02,
                                      horizontal: Utils.scrHeight * .025),
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: Utils.scrHeight * .022,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
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
              // const Text("150+ Jobs",
              //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ),
    );
  }
}
