import 'package:flutter/material.dart';
import 'package:job_board_app/view/company_post_list/company_post_list_screen.dart';
import '../../utils/utils.dart';
import '../common_widgets/drawer/custom_drawer.dart';
import '../company_list/company_list_screen.dart';
import '../input/input_screen.dart';

class CompanyAdminHomeScreen extends StatelessWidget {
  const CompanyAdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      'Settings': {
        'title': 'Settings',
        'image': 'assets/icons/setting.png',
      },
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),
      drawer: const CustomDrawer(),
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
                onTap: (){
                  if(index == 0){
                    Utils.navigateTo(context, const CompanyPostListScreen());
                  }else if(index == 1){
                    Utils.navigateTo(context, const InputScreen());
                  }else{
                    null;
                  }
                });
          },
        ),
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
