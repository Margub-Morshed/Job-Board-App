import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/services/profile/profile_service.dart';
import '../../model/company_model.dart';
import '../../utils/utils.dart';

class CompanyDetailsScreen extends StatefulWidget {
  final CompanyModel company;
  final String tag;

  const CompanyDetailsScreen({super.key, required this.company, required this.tag});

  @override
  State<CompanyDetailsScreen> createState() => _CompanyDetailsScreenState();
}

class _CompanyDetailsScreenState extends State<CompanyDetailsScreen> {
  late CompanyStatus selectedStatus;

  @override
  void initState() {
    selectedStatus = widget.company.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Company Details")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company All details
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: Utils.scrHeight * .02,
                vertical: Utils.scrHeight * .02,
              ),
              children: [
                // Company Image
                Hero(
                  tag: widget.tag,
                  transitionOnUserGestures: true,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(Utils.scrHeight * .02),
                      child: CachedNetworkImage(
                        imageUrl: widget.company.logoImage!,
                        width: double.infinity,
                        // height: Utils.scrHeight * .180,
                        fit: BoxFit.cover,
                      )),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Company name and Status show
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.company.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: _getTextColor(selectedStatus)),
                          borderRadius: BorderRadius.circular(10),
                          color: _getContainerColor(selectedStatus)),
                      child: Text(selectedStatus.toString().split('.').last),
                    )
                  ],
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Company Team Size
                Row(
                  children: [
                    SizedBox(
                        height: Utils.scrHeight * .04,
                        width: Utils.scrHeight * .04,
                        child: Image.asset('assets/icons/team.png')),
                    SizedBox(width: Utils.scrHeight * .02),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Utils.scrHeight * .01,
                        vertical: Utils.scrHeight * .01,
                      ),
                      height: Utils.scrHeight * .04,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Utils.scrHeight * .005),
                          color: Colors.blue.shade100),
                      child: Text(
                        '${widget.company.teamSize}',
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // Company Address Email Number
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.grey,
                    ),
                    SizedBox(width: Utils.scrHeight * .02),
                    Text(
                      widget.company.address,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: Utils.scrHeight * .01),
                Text(
                  'Email: ${widget.company.email}',
                  style: const TextStyle(color: Colors.black),
                ),
                SizedBox(height: Utils.scrHeight * .01),
                Text(
                  'Mobile: ${widget.company.phone}',
                  style: const TextStyle(color: Colors.black),
                ),
                SizedBox(height: Utils.scrHeight * .01),

                // Divider
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                SizedBox(height: Utils.scrHeight * .01),

                //Company Description
                const Text("Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: Utils.scrHeight * .01),
                const Text(
                    "Aston Hotel, Alice Springs NT 0870, Australia is a modern hotel. elegant 5 star hotel overlooking the sea. perfect for a romantic, charming  Read More. . .",
                    style: TextStyle(
                      fontSize: 14,
                    )),
              ],
            ),
          ),

          // BottomBar for change Company Status
          _bottomBar(context),
        ],
      ),
    );
  }

  Padding _bottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Change Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                border:
                    Border.all(width: 1, color: _getTextColor(selectedStatus)),
                borderRadius: BorderRadius.circular(10),
                color: _getContainerColor(selectedStatus)),
            child: DropdownButton<CompanyStatus>(
              underline: Container(),
              value: selectedStatus,
              onChanged: (newValue) async {
                setState(() {
                  selectedStatus = newValue!;
                });

                await ProfileService.updateCompanyStatus(
                        widget.company.id, selectedStatus)
                    .then((value) {
                  Utils.showSnackBar(context,
                      'Company Status ${selectedStatus.toString().split('.').last} Successfully');
                });
              },
              items: CompanyStatus.values.map((status) {
                return DropdownMenuItem<CompanyStatus>(
                  value: status,
                  child: Text(status.toString().split('.').last),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  Color _getContainerColor(CompanyStatus status) {
    switch (status) {
      case CompanyStatus.Active:
        return Colors.green.shade100;
      case CompanyStatus.Disabled:
        return Colors.orange.shade100;
      case CompanyStatus.Suspended:
        return Colors.red.shade100;
      // Add more cases if needed
      default:
        return Colors.black; // Default color
    }
  }

  Color _getTextColor(CompanyStatus status) {
    switch (status) {
      case CompanyStatus.Active:
        return Colors.green;
      case CompanyStatus.Disabled:
        return Colors.orange;
      case CompanyStatus.Suspended:
        return Colors.red;
      // Add more cases if needed
      default:
        return Colors.black; // Default color
    }
  }
}