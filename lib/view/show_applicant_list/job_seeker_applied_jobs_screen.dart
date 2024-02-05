import 'package:flutter/material.dart';
import 'package:job_board_app/services/application/application_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
import '../../model/application_model.dart';
import '../../utils/utils.dart';

class JobSeekerAppliedJobsScreen extends StatelessWidget {
  const JobSeekerAppliedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = SessionManager.userModel!.id;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Applied Jobs List'),
        ),
        body: Center(
            child: StreamBuilder<List<ApplicationModel>>(
          stream: ApplicationService.getApplicationsForUser(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // or a loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Utils.noDataFound();
            } else {
              List<ApplicationModel> userApplications = snapshot.data!;
              return ListView.builder(
                itemCount: userApplications.length,
                itemBuilder: (context, index) {
                  ApplicationModel application = userApplications[index];
                  return ListTile(
                    title: Text(application.jobPost),
                    subtitle: Text(application.status),
                  );
                },
              );
            }
          },
        )));
  }
}
