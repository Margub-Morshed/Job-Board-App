import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import 'analytics_chart.dart';
import '../../model/job_post_model.dart';


class BarGraphCard extends StatelessWidget {
  BarGraphCard({super.key});

  @override
  Widget build(BuildContext context) {
    final JobService jobService = JobService();
    final lable = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Set',
      'Oct',
      'Nov',
      'Dec'
    ];
    return StreamBuilder<List<JobPostModel>>(
      stream: jobService.getPostsStream(), // Stream of job posts data
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator while fetching data
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}'); // Show error if any
        }
        final List<JobPostModel> jobPosts =
            snapshot.data ?? []; // Extract job posts from snapshot
        return GridView.builder(
          itemCount: 1,
          // Since there is only one set of data
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12.0,
              childAspectRatio: 16 / 9),
          itemBuilder: (context, i) {
            return CustomCard(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Post Created",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Expanded(
                      child: BarChart(
                        swapAnimationDuration:
                            const Duration(milliseconds: 150),
                        BarChartData(
                          barGroups: _chartGroups(jobPosts: jobPosts),
                          borderData: FlBorderData(border: const Border()),
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    value.toInt() < lable.length ? lable[value.toInt()] : '',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500),
                                  ),
                                );
                              },
                            )),
                            leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }

  List<BarChartGroupData> _chartGroups({required List<JobPostModel> jobPosts}) {
    List<int> postCounts = List.filled(12, 0);
    jobPosts.forEach((jobPost) {
      final String createdAtString = jobPost.createdAt!; // Assuming createdAt is of type String
      final DateTime createdAt = _parseDateString(createdAtString);
      final int month = createdAt.month;
      postCounts[month - 1]++;
    });
    return List.generate(12, (index) {
      print(index);
      print('post count: ${postCounts.length}');
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            width: 12,
            color: const Color(0xff5872de),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(3.0),
              topRight: Radius.circular(3.0),
            ),
            toY: postCounts[index].toDouble(),
          )
        ],
      );
    });
  }

  DateTime _parseDateString(String dateString) {
    // Example date string format: "30-Jan-2024, 4:14 PM"
    final List<String> parts = dateString.split(', '); // Split by ', ' to separate date and time
    final List<String> dateParts = parts[0].split('-'); // Split date part by '-'
    final int day = int.parse(dateParts[0]);
    final int month = _parseMonth(dateParts[1]); // Parse month abbreviation
    final int year = int.parse(dateParts[2]);
    final List<String> timeParts = parts[1].split(':'); // Split time part by ':'
    int hour = int.parse(timeParts[0]);
    if (parts[1].contains('PM')) {
      hour += 12; // Convert to 24-hour format if PM
    }
    final int minute = int.parse(timeParts[1].split(' ')[0]); // Extract minutes
    return DateTime(year, month, day, hour, minute);
  }

  int _parseMonth(String monthAbbr) {
    // Map month abbreviation to month number
    final Map<String, int> monthMap = {
      'Jan': DateTime.january,
      'Feb': DateTime.february,
      'Mar': DateTime.march,
      'Apr': DateTime.april,
      'May': DateTime.may,
      'Jun': DateTime.june,
      'Jul': DateTime.july,
      'Aug': DateTime.august,
      'Sep': DateTime.september,
      'Oct': DateTime.october,
      'Nov': DateTime.november,
      'Dec': DateTime.december,
    };
    return monthMap[monthAbbr]!;
  }

}

// class BarGraphCard extends StatelessWidget {
//   BarGraphCard({super.key});
//
//   final List<BarGraphModel> data = [
//     BarGraphModel(
//         lable: "Post Created 2024",
//         // color: const Color(0xFFFEB95A),
//         color: const Color(0xff5872de),
//         graph: [
//           GraphModel(x: 0, y: 3),
//           GraphModel(x: 1, y: 10),
//           GraphModel(x: 2, y: 0),
//           GraphModel(x: 3, y: 0),
//           GraphModel(x: 4, y: 0),
//           GraphModel(x: 5, y: 0),
//           GraphModel(x: 6, y: 0),
//           GraphModel(x: 7, y: 0),
//           GraphModel(x: 8, y: 0),
//           GraphModel(x: 9, y: 0),
//           GraphModel(x: 10, y: 0),
//           GraphModel(x: 11, y: 0),
//         ]),
//   ];
//
//   final lable = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Set', 'Oct', 'Nov', 'Dec'];
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: data.length,
//       shrinkWrap: true,
//       physics: const ScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12.0,
//           childAspectRatio: 16 / 9),
//       itemBuilder: (context, i) {
//         return CustomCard(
//             padding: const EdgeInsets.all(5),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     data[i].lable,
//                     style: const TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//                 Expanded(
//                   child: BarChart(
//                     swapAnimationDuration: const Duration(milliseconds: 150),
//                     BarChartData(
//                       barGroups: _chartGroups(
//                           points: data[i].graph, color: data[i].color),
//                       borderData: FlBorderData(border: const Border()),
//                       gridData: const FlGridData(show: false),
//                       titlesData: FlTitlesData(
//                         bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                           showTitles: true,
//                           getTitlesWidget: (value, meta) {
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 5),
//                               child: Text(
//                                 lable[value.toInt()],
//                                 style: const TextStyle(
//                                     fontSize: 11,
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             );
//                           },
//                         )),
//                         leftTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                         topTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                         rightTitles: const AxisTitles(
//                             sideTitles: SideTitles(showTitles: false)),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ));
//       },
//     );
//   }
//
//   List<BarChartGroupData> _chartGroups(
//       {required List<GraphModel> points, required Color color}) {
//     return points
//         .map((point) => BarChartGroupData(x: point.x.toInt(), barRods: [
//               BarChartRodData(
//                 toY: point.y,
//                 width: 12,
//                 color: color.withOpacity(point.y.toInt() > 4 ? 1 : 0.4),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(3.0),
//                   topRight: Radius.circular(3.0),
//                 ),
//               )
//             ]))
//         .toList();
//   }
// }
