import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import 'package:job_board_app/view/show_applicant_list/company_admin_applicant_list_screen.dart';

import '../../model/job_post_model.dart';
import '../../utils/utils.dart';
import '../job_post_details/company_job_post_detail_screen.dart';
import '../job_post_details/job_post_details_screen.dart';

class CompanyAdminFilterScreen extends StatefulWidget {
  const CompanyAdminFilterScreen({super.key});

  @override
  State<CompanyAdminFilterScreen> createState() =>
      _CompanyAdminFilterScreenState();
}

class _CompanyAdminFilterScreenState extends State<CompanyAdminFilterScreen> {
  final JobService jobService = JobService();

  final List<String> filterJobTypeOptions = [
    "Select One",
    "Full Time",
    "Part Time",
    "On Site",
    "Remote"
  ];

  final List<String> filterSalaryOptions = [
    "Select One",
    "Less than 10,000",
    "10,000 - 20,000",
    "20,000 - 30,000",
    "30,000 - 50,000",
    "50,000 - 80,000",
    "80,000 - 100,000",
    "More than 100,000",
  ];

  String selectedJobTypeFilter = "Select One";
  String selectedSalaryFilter = "Select One";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Filter List'),
      ),
      body: Center(
        child: StreamBuilder<List<JobPostModel>>(
          stream: jobService.getPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Utils.noDataFound();
            } else {
              List<JobPostModel> jobPosts = snapshot.data ?? [];

              // Apply filters based on selected options
              List<JobPostModel> filteredJobPosts = applyFilters(jobPosts);

              return Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Job Type Drop Down
                        Expanded(
                          flex: 5,
                          child: CustomDropDown(
                            selectedFilter: selectedJobTypeFilter,
                            filterOptions: filterJobTypeOptions,
                            onFilterChanged: (newFilter) {
                              setState(() {
                                selectedJobTypeFilter = newFilter;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Salary Drop Down
                        Expanded(
                          flex: 6,
                          child: CustomDropDown(
                            selectedFilter: selectedSalaryFilter,
                            filterOptions: filterSalaryOptions,
                            onFilterChanged: (newFilter) {
                              setState(() {
                                selectedSalaryFilter = newFilter;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Job Posts
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredJobPosts.length,
                        itemBuilder: (context, index) {
                          JobPostModel jobPost = filteredJobPosts[index];
                          return CompanyCard(jobPostModel: jobPost);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  List<JobPostModel> applyFilters(List<JobPostModel> jobPosts) {
    // If both filters are "Select One," show all job posts
    if (selectedJobTypeFilter == "Select One" &&
        selectedSalaryFilter == "Select One") {
      return jobPosts;
    }

    // Apply filters based on selected options
    List<JobPostModel> filteredJobPosts = jobPosts.where((jobPost) {
      bool jobTypeFilter = selectedJobTypeFilter == "Select One" ||
          jobPost.jobType == selectedJobTypeFilter;

      bool salaryFilter = selectedSalaryFilter == "Select One" ||
          filterSalary(jobPost.salaryRange ?? "");

      return jobTypeFilter && salaryFilter;
    }).toList();

    return filteredJobPosts;
  }

  bool filterSalary(String salary) {
    // Remove non-numeric characters from the salary string
    String numericSalary = salary.replaceAll(RegExp(r'[^\d-]'), '');

    // Split the numeric part based on '-' if it's a range
    List<String> salaryParts = numericSalary.split('-');

    try {
      if (salaryParts.length == 1) {
        // For cases like "19,500"
        int jobSalary = int.parse(salaryParts[0]);
        return compareSalary(jobSalary);
      } else if (salaryParts.length == 2) {
        // For cases like "15,000 - 35,000"
        int minSalary = int.parse(salaryParts[0]);
        int maxSalary = int.parse(salaryParts[1]);
        return compareSalaryRange(minSalary, maxSalary);
      } else {
        // Invalid format, handle accordingly
        return false;
      }
    } catch (e) {
      // Handle the case where parsing fails
      print("Error parsing salary: $e");
      return false;
    }
  }

  bool compareSalary(int jobSalary) {
    switch (selectedSalaryFilter) {
      case "Less than 10,000":
        return jobSalary < 10000;
      case "10,000 - 20,000":
        return jobSalary >= 10000 && jobSalary <= 20000;
      case "20,000 - 30,000":
        return jobSalary >= 20000 && jobSalary <= 30000;
      case "30,000 - 50,000":
        return jobSalary >= 30000 && jobSalary <= 50000;
      case "50,000 - 80,000":
        return jobSalary >= 50000 && jobSalary <= 80000;
      case "80,000 - 100,000":
        return jobSalary >= 80000 && jobSalary <= 100000;
      case "More than 100,000":
        return jobSalary > 100000;
      default:
        return false;
    }
  }

  bool compareSalaryRange(int minSalary, int maxSalary) {
    switch (selectedSalaryFilter) {
      case "Less than 10,000":
        return maxSalary < 10000;
      case "10,000 - 20,000":
        return minSalary >= 10000 && maxSalary <= 20000;
      case "20,000 - 30,000":
        return minSalary >= 20000 && maxSalary <= 30000;
      case "30,000 - 50,000":
        return minSalary >= 30000 && maxSalary <= 50000;
      case "50,000 - 80,000":
        return minSalary >= 50000 && maxSalary <= 80000;
      case "80,000 - 100,000":
        return minSalary >= 80000 && maxSalary <= 100000;
      case "More than 100,000":
        return minSalary > 100000;
      default:
        return false;
    }
  }
}

class CompanyCard extends StatelessWidget {
  const CompanyCard({Key? key, required this.jobPostModel}) : super(key: key);

  final JobPostModel jobPostModel;

  @override
  Widget build(BuildContext context) {
    final hero_tag = "${jobPostModel.id}_hero_tag";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 5,
            spreadRadius: -8,
            offset: const Offset(-10, 4),
          ),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  ShowApplicantList(jobPostModel: jobPostModel)));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                // Left Side Image
                leading: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  // Right Side Padding
                  child: JobProfileImage(
                      imageUrl: jobPostModel.image,
                      imageName: "${jobPostModel.id}_hero_tag",
                      tag: hero_tag),
                ),

                // Right Side Information
                title: Text(jobPostModel.jobTitle,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: ProfileDetails(
                    email: jobPostModel.email,
                    teamSize: 20,
                    address: jobPostModel.address),
                trailing: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.arrow_forward_ios)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JobProfileImage extends StatelessWidget {
  const JobProfileImage({
    Key? key,
    required this.imageUrl,
    this.imageName,
    required this.tag,
  }) : super(key: key);

  final String? imageUrl;
  final String? imageName;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      transitionOnUserGestures: true,
      tag: tag,
      child: SizedBox(
        width: 100,
        height: 100, // Set explicit dimensions
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.2),
                blurRadius: 10,
                spreadRadius: -2,
                offset: const Offset(-10, 4),
              ),
            ],
          ),
          child: CachedNetworkImage(
              imageUrl: imageUrl ??
                  "https://t4.ftcdn.net/jpg/03/28/54/21/360_F_328542178_YotgB5sGePl9SzsChnn66W4xVMCvC3hb.jpg",
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails(
      {Key? key,
      required this.email,
      required this.teamSize,
      required this.address})
      : super(key: key);

  final String email;
  final int teamSize;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text('Address: $address',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

@immutable
class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    Key? key,
    required this.selectedFilter,
    required this.filterOptions,
    required this.onFilterChanged,
  }) : super(key: key);

  String selectedFilter;
  final List<String> filterOptions;
  final ValueChanged<String> onFilterChanged;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        value: widget.selectedFilter,
        onChanged: (String? newValue) {
          if (newValue != null) {
            widget.onFilterChanged(newValue);
          }
        },
        items: widget.filterOptions.map((String role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role, style: const TextStyle(fontSize: 16)),
          );
        }).toList(),
        isExpanded: true,
        icon: const Icon(Icons.arrow_drop_down),
        iconSize: 36,
        underline: const SizedBox(), // Remove the default underline
      ),
    );
  }
}
