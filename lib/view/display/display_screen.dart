import 'package:flutter/material.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import '../../model/job_post_model.dart';

class DisplayScreen extends StatefulWidget {
  const DisplayScreen({
    Key? key,
    required String jobTitle,
    required String description,
  }) : super(key: key);

  @override
  DisplayScreenState createState() => DisplayScreenState();
}

class DisplayScreenState extends State<DisplayScreen> {
  final JobService jobService = JobService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Display Screen'),
      ),
      body: StreamBuilder<List<JobPostModel>>(
        stream: jobService.getPostsStream(),
        // Use the stream method that listens to updates
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<JobPostModel> jobPosts = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: jobPosts.map((jobPost) {
                return Column(
                  children: [
                    // Job Post Card
                    Card(
                      child: ListTile(
                        title: Text('Job Title: ${jobPost.jobTitle}'),
                        subtitle: Text('Description: ${jobPost.description}'),
                        ),
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
