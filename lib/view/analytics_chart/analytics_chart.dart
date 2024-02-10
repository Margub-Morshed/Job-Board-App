import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/job_post/job_post_service.dart';
import 'package:job_board_app/utils/utils.dart';
import '../../model/job_post_model.dart';


class JobPostChart extends StatelessWidget {
  JobPostChart({Key? key});

  @override
  Widget build(BuildContext context) {
    final JobService jobService = JobService();

    final leftTitle = {
      00: '0',
      20: '10',
      40: '20',
      60: '30',
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
          return SizedBox(
            height: Utils.scrHeight * .2,
            width: Utils.scrHeight * .2,
              child: Center(child: const CircularProgressIndicator()));
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
                "Post Created LinerChart",
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
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 10,
                              child: Text(
                                  bottomTitle[value
                                          .toInt()
                                          .toString()
                                          .padLeft(2, '0')] ??
                                      '',
                                  style: TextStyle(
                                      fontSize: 9, color: Colors.grey[400])),
                            );
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text(leftTitle[value.toInt()] ?? '');
                              })),
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
                              Theme.of(context).primaryColor.withOpacity(0.5),
                              Colors.transparent
                            ],
                          ),
                          show: true,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
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
    final List<String> parts =
        dateString.split(', '); // Split by ', ' to separate date and time
    final List<String> dateParts =
        parts[0].split('-'); // Split date part by '-'
    final int day = int.parse(dateParts[0]);
    final int month = _parseMonth(dateParts[1]); // Parse month abbreviation
    final int year = int.parse(dateParts[2]);
    final List<String> timeParts =
        parts[1].split(':'); // Split time part by ':'
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

