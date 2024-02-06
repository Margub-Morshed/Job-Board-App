import 'package:flutter/material.dart';
import 'package:job_board_app/utils/utils.dart';
import 'package:job_board_app/view/show_applicant_list/company_admin_applicant_list_screen.dart';

import 'company_admin_bottom_user_info.dart';
import 'company_admin_custom_list_tile.dart';
import 'company_admin_header.dart';

class CompanyAdminCustomDrawer extends StatefulWidget {
  const CompanyAdminCustomDrawer({Key? key}) : super(key: key);

  @override
  State<CompanyAdminCustomDrawer> createState() => _CompanyAdminCustomDrawerState();
}

class _CompanyAdminCustomDrawerState extends State<CompanyAdminCustomDrawer> {
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
              CompanyAdminCustomDrawerHeader(isCollapsed: _isCollapsed),
              const Divider(color: Colors.grey),
              CompanyAdminCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.home_outlined,
                title: 'Home',
                infoCount: 0,
              ),
              // CompanyAdminCustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.calendar_today,
              //   title: 'Applications',
              //   infoCount: 6,
              // ),
              // CompanyAdminCustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.pin_drop,
              //   title: 'Destinations',
              //   infoCount: 0,
              //   doHaveMoreOptions: Icons.arrow_forward_ios,
              // ),
              CompanyAdminCustomListTile(
                isCollapsed: _isCollapsed,
                icon: Icons.message_rounded,
                title: 'Messages',
                infoCount: 8,
              ),
              const Divider(color: Colors.grey),
              const Spacer(),
              // CompanyAdminCustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.notifications,
              //   title: 'Notifications',
              //   infoCount: 2,
              // ),
              // CompanyAdminCustomListTile(
              //   isCollapsed: _isCollapsed,
              //   icon: Icons.settings,
              //   title: 'Settings',
              //   infoCount: 0,
              // ),
              const SizedBox(height: 10),
              CompanyAdminBottomUserInfo(isCollapsed: _isCollapsed),
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
