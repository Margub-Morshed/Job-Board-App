

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';


import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import '../../model/job_post_model.dart';

class JobPostChart extends StatelessWidget {
  JobPostChart({Key? key});

  @override
  Widget build(BuildContext context) {
    final JobService jobService = JobService();


    final leftTitle = {
    0: '0',
    20: '10',
    40: '20',
    60: '20',
    80: '40',
    100: '50'
  };
    final Map<String, String> bottomTitle = {
      '00': 'Jan',
      '10': 'Feb',
      '20': 'Mar',
      '30': 'Apr',
      '40': 'May',
      '50': 'Jun',
      '60': 'Jul',
      '70': 'Aug',
      '80': 'Sep',
      '90': 'Oct',
      '100': 'Nov',
      '110': 'Dec',
    };

    return StreamBuilder<List<JobPostModel>>(
      stream: jobService.getPostsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final List<JobPostModel> jobPosts = snapshot.data ?? [];
        final List<FlSpot> spots = _calculateSpots(jobPosts);

        return CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Application",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              AspectRatio(
                aspectRatio: 9 / 4,
                child: LineChart(
                  LineChartData(
                    lineTouchData: const LineTouchData(
                      handleBuiltInTouches: true,
                    ),
                    gridData: const FlGridData(show: false),
                    titlesData: FlTitlesData(

                      bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: ( value,  meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 10,
                          child: Text(
                              bottomTitle[value.toInt().toString().padLeft(2, '0')] ?? '',
                              style: TextStyle(
                                  fontSize:  9,
                                  color: Colors.grey[400])),
                        );
                      },
                    ),
                  ),
                      // bottomTitles: AxisTitles(
                      //   sideTitles: SideTitles(
                      //     showTitles: true,
                      //     reservedSize: 32,
                      //     interval: 1,
                      //     getTitlesWidget: (value, meta) {
                      //       return Text(bottomTitle[value.toInt().toString().padLeft(2, '0')] ?? '');
                      //     },
                      //   )
                      // ),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles:  AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta){
                            return Text(leftTitle[value.toInt()] ?? '');
                          }

                        )
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        isCurved: true,
                        curveSmoothness: 0,
                        color: Theme.of(context).primaryColor,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              Colors.transparent
                            ],
                          ),
                          show: true,
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.5),
                        ),
                        dotData: FlDotData(show: false),
                        spots: spots,
                      )
                    ],
                    minX: 0,
                    maxX: 120,
                    maxY: 105,
                    minY: -5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<FlSpot> _calculateSpots(List<JobPostModel> jobPosts) {
    final Map<int, int> postCounts = Map<int, int>.fromIterable(
      List<int>.generate(12, (index) => index + 1),
      key: (index) => index,
      value: (_) => 0,
    );

    jobPosts.forEach((jobPost) {
      final String createdAtString = jobPost.createdAt!;
      final DateTime createdAt = _parseDateString(createdAtString);
      postCounts[createdAt.month] = postCounts[createdAt.month]! + 1;
    });

    return postCounts.entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
        .toList();
  }

  DateTime _parseDateString(String dateString) {
    // Parse dateString manually
    // Example date string format: "9-Feb-2024, 5:27 PM"
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

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  const CustomCard({Key? key, this.color, this.padding, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.white,
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}





// class JobPostChart extends StatelessWidget {
//   JobPostChart({super.key});
//
//   final List<FlSpot> spots = const [
//     // FlSpot(0, 6),
//     // FlSpot(10, 10),
//     // FlSpot(20, 60),
//     FlSpot(1.68, 21.04),
//     FlSpot(2.84, 26.23),
//     FlSpot(5.19, 19.82),
//     FlSpot(6.01, 24.49),
//     FlSpot(7.81, 19.82),
//     FlSpot(9.49, 23.50),
//     FlSpot(12.26, 19.57),
//     FlSpot(15.63, 20.90),
//     FlSpot(20.39, 39.20),
//     FlSpot(23.69, 75.62),
//     FlSpot(25.69, 75.62),
//   ];
//
//   final leftTitle = {
//     0: '0',
//     20: '2K',
//     40: '4K',
//     60: '6K',
//     80: '8K',
//     100: '10K'
//   };
//   final bottomTitle = {
//     0: 'Jan',
//     10: 'Feb',
//     20: 'Mar',
//     30: 'Apr',
//     40: 'May',
//     50: 'Jun',
//     60: 'Jul',
//     70: 'Aug',
//     80: 'Sep',
//     90: 'Oct',
//     100: 'Nov',
//     110: 'Dec',
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomCard(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Application Submitted",
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           AspectRatio(
//             aspectRatio: 9 / 4 ,
//             child: LineChart(
//               LineChartData(
//                 lineTouchData: const LineTouchData(
//                   handleBuiltInTouches: true,
//                 ),
//                 gridData: const FlGridData(show: false),
//                 titlesData: FlTitlesData(
//                   bottomTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       showTitles: true,
//                       reservedSize: 32,
//                       interval: 1,
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         return bottomTitle[value.toInt()] != null
//                             ? SideTitleWidget(
//                           axisSide: meta.axisSide,
//                           space: 10,
//                           child: Text(
//                               bottomTitle[value.toInt()].toString(),
//                               style: TextStyle(
//                                   fontSize:  9,
//                                   color: Colors.grey[400])),
//                         )
//                             : const SizedBox();
//                       },
//                     ),
//                   ),
//                   rightTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   topTitles: const AxisTitles(
//                     sideTitles: SideTitles(showTitles: false),
//                   ),
//                   leftTitles: AxisTitles(
//                     sideTitles: SideTitles(
//                       getTitlesWidget: (double value, TitleMeta meta) {
//                         return leftTitle[value.toInt()] != null
//                             ? Text(leftTitle[value.toInt()].toString(),
//                             style: const TextStyle(
//                                 fontSize: 9,
//                                 color: Colors.grey))
//                             : const SizedBox();
//                       },
//                       showTitles: true,
//                       interval: 1,
//                       reservedSize: 40,
//                     ),
//                   ),
//                 ),
//                 borderData: FlBorderData(show: false),
//                 lineBarsData: [
//                   LineChartBarData(
//                       isCurved: true,
//                       curveSmoothness: 0,
//                       color: Theme.of(context).primaryColor,
//                       barWidth: 2.5,
//                       isStrokeCapRound: true,
//                       belowBarData: BarAreaData(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Theme.of(context).primaryColor.withOpacity(0.5),
//                             Colors.transparent
//                           ],
//                         ),
//                         show: true,
//                         color: Theme.of(context).primaryColor.withOpacity(0.5),
//                       ),
//                       dotData: FlDotData(show: false),
//                       spots: spots
//                   )
//                 ],
//                 minX: 0,
//                 maxX: 120,
//                 maxY: 105,
//                 minY: -5,
//               ),
//               // swapAnimationDuration: const Duration(milliseconds: 250),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


//
// class CustomCard extends StatelessWidget {
//   final Widget child;
//   final Color? color;
//   final EdgeInsetsGeometry? padding;
//
//   const CustomCard({super.key, this.color,this.padding, required this.child});
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: const BoxDecoration(
//           borderRadius: BorderRadius.all(
//             Radius.circular(8.0),
//           ),
//           color: Colors.white,
//         ),
//         child: Padding(
//           padding:padding?? const EdgeInsets.all(12.0),
//           child: child,
//         ));
//   }
// }
