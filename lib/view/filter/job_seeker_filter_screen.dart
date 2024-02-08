import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import '../../model/job_post_model.dart';
import '../../services/favorite/favorite_service.dart';
import '../../services/session/session_services.dart';
import '../../utils/utils.dart';
import '../job_post_details/job_post_details_screen.dart';

class JobSeekerFilterScreen extends StatefulWidget {
  const JobSeekerFilterScreen({super.key});

  @override
  State<JobSeekerFilterScreen> createState() => _JobSeekerFilterScreenState();
}

class _JobSeekerFilterScreenState extends State<JobSeekerFilterScreen> {
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
      backgroundColor: Colors.white,
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
                          final hero_tag = "${jobPost.id}_hero_tag";
                          // return CompanyCard(jobPostModel: jobPost);
                          return JobPostFilter(
                            jobPostModel: jobPost,
                            onTap: () {
                              Utils.navigateTo(context,
                                  JobPostDetailsScreen(jobPostModel: jobPost, tag: hero_tag));
                            },
                          );
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
    final heroTag = "${jobPostModel.id}_hero_tag";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Utils.navigateTo(
            context,
            JobPostDetailsScreen(jobPostModel: jobPostModel, tag: heroTag),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  child: Hero(
                    tag: heroTag,
                    transitionOnUserGestures: true,
                    child: CachedNetworkImage(
                      imageUrl: jobPostModel.image ?? Utils.flutterDefaultImg,
                      fit: BoxFit.cover, // Cover the entire space
                      width: 100, // Set explicit width
                    ),
                  ),
                ),
                title: Text(
                  jobPostModel.jobTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: ProfileDetails(
                  email: jobPostModel.email,
                  teamSize: 20,
                  address: jobPostModel.address,
                ),
                trailing: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.arrow_forward_ios),
                ),
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
    return // Left Side Image Part
        ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
      child: Hero(
        tag: tag,
        transitionOnUserGestures: true,
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? Utils.flutterDefaultImg,
          width: 120,
          height: double.infinity,
          fit: BoxFit.cover,
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

class JobPostFilter extends StatefulWidget {
  const JobPostFilter({super.key, required this.jobPostModel, this.onTap});

  final VoidCallback? onTap;

  final JobPostModel jobPostModel;

  @override
  State<JobPostFilter> createState() => _JobPostFilterState();
}

class _JobPostFilterState extends State<JobPostFilter> {
  late ValueNotifier<bool> isAlreadySelected;

  @override
  void initState() {
    super.initState();
    isAlreadySelected = ValueNotifier<bool>(false);
    _fetchFavoriteStatus();
  }

  Future<void> _fetchFavoriteStatus() async {
    bool isFavorite = await FavoriteService.checkIfFavorite(
        SessionManager.userModel!.id, widget.jobPostModel.id);

    if (mounted) {
      setState(() {
        isAlreadySelected.value = isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tag = "${widget.jobPostModel.id}_hero_tag";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
            spreadRadius: -8,
            offset: const Offset(-6, 4),
          ),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onTap,
        child: Stack(
          children: [
            SizedBox(
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        // Left Side Image Part
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          child: Hero(
                            tag: tag,
                            transitionOnUserGestures: true,
                            child: CachedNetworkImage(
                              imageUrl: widget.jobPostModel.image ??
                                  Utils.flutterDefaultImg,
                              width: 120,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Side Information Part
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.jobPostModel.jobTitle,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: Utils.scrHeight * .003),
                              SizedBox(
                                width: 220,
                                child: Text(
                                  'Job Type: ${widget.jobPostModel.jobType}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              SizedBox(height: Utils.scrHeight * .003),
                              Text(
                                'Deadline: ${widget.jobPostModel.applicationDeadline}',
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: Utils.scrHeight * 0.02,
              right: Utils.scrHeight * 0.02,
              child: ValueListenableBuilder(
                  valueListenable: isAlreadySelected,
                  builder: (context, value, child) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () async {
                        await _toggleFavorite();
                      },
                      child: Icon(
                        isAlreadySelected.value
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color: isAlreadySelected.value
                            ? const Color(0xff5872de)
                            : Colors.black54,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _toggleFavorite() async {
    // Check if the post is already in the user's favorites
    bool isAlreadyFavorite = await FavoriteService.checkIfFavorite(
        SessionManager.userModel!.id, widget.jobPostModel.id);

    // Toggle isSelected when the button is tapped
    isAlreadySelected.value = !isAlreadySelected.value;

    if (isAlreadySelected.value && !isAlreadyFavorite) {
      // If the post is not already in favorites, add it
      await FavoriteService.addToFavorites(
          SessionManager.userModel!.id, widget.jobPostModel.id);
      print("Added to Favorites");
    } else if (!isAlreadySelected.value && isAlreadyFavorite) {
      // If the post is already in favorites, remove it
      await FavoriteService.removeFromFavorites(
          SessionManager.userModel!.id, widget.jobPostModel.id);
      print("Removed from Favorites");
    }
  }

  @override
  void dispose() {
    isAlreadySelected.dispose();
    super.dispose();
  }
}
