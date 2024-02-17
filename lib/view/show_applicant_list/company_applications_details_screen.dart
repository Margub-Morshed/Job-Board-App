
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_board_app/model/application_model.dart';
import 'package:job_board_app/model/user_model.dart';
import 'package:job_board_app/services/application/application_service.dart';
import 'package:job_board_app/services/session/session_services.dart';
import 'package:job_board_app/view/pdf_viewer/pdf_viewer_screen.dart';
import 'package:path_provider/path_provider.dart';
import '../../model/company_model.dart';
import '../../utils/utils.dart';
import 'package:dio/dio.dart';


class CompanyApplicationDetailsScreen extends StatefulWidget {
  final String tag;
  final ApplicationModel applicationModel;
  final UserModel userModel;

  const CompanyApplicationDetailsScreen(
      {super.key,
      required this.tag,
      required this.applicationModel,
      required this.userModel});

  @override
  State<CompanyApplicationDetailsScreen> createState() =>
      _CompanyApplicationDetailsScreenState();
}

class _CompanyApplicationDetailsScreenState
    extends State<CompanyApplicationDetailsScreen> {
  late String selectedStatus;
  CompanyModel? company = SessionManager.companyModel;
  Dio dio = Dio();

  @override
  void initState() {
    selectedStatus = widget.applicationModel.status;
    super.initState();
  }

  DateTime millisecondsToUtc(int millisecondsSinceEpoch) {
    // Convert milliseconds to microseconds
    int microsecondsSinceEpoch = millisecondsSinceEpoch * 1000;
    // Create DateTime object with UTC timezone
    DateTime utcDateTime = DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch,
        isUtc: false);
    return utcDateTime;
  }

  @override
  Widget build(BuildContext context) {
    print('createdAt ${widget.applicationModel.createdAt}');

    int milliseconds = int.parse(widget.applicationModel.createdAt);
    print('milliseconds $milliseconds');
    DateTime utcTime = millisecondsToUtc(milliseconds);
    print("UTC Time: ${DateFormat('dd-MMM-yyyy, HH:mm a').format(utcTime)}");

    return Scaffold(
      appBar: AppBar(title: const Text("Application Details")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company All details
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Utils.scrHeight * .02,
                  vertical: Utils.scrHeight * .02),
              children: [
                // User Image
                Hero(
                  tag: widget.tag,
                  transitionOnUserGestures: true,
                  child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(Utils.scrHeight * .02),
                      child: widget.userModel.userAvatar!.isNotEmpty ? CachedNetworkImage(
                          imageUrl: widget.userModel.userAvatar!,
                          width: double.infinity,
                          height: Utils.scrHeight * .180,
                          fit: BoxFit.cover) : CachedNetworkImage(
                          imageUrl: Utils.flutterDefaultImg,
                          width: double.infinity,
                          height: Utils.scrHeight * .180,
                          fit: BoxFit.cover)),
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // User info
                const Text('Applicant Information',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: Utils.scrHeight * .02),
                const Divider(color: Colors.grey, thickness: 1),
                SizedBox(height: Utils.scrHeight * .02),

                // Company name and Status show
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Name:- ${widget.userModel.name}',
                        style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: _getTextColor(selectedStatus)),
                          borderRadius: BorderRadius.circular(10),
                          color: _getContainerColor(selectedStatus)),
                      child: Text(selectedStatus),
                    )
                  ],
                ),
                SizedBox(height: Utils.scrHeight * .02),

                // User Address Email Number
                Text('Email: ${widget.userModel.email}',
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 16)),
                SizedBox(height: Utils.scrHeight * .02),
                Text('Phone Number: ${widget.userModel.phoneNumber}',
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 16)),
                SizedBox(height: Utils.scrHeight * .02),
                Text(
                    'Applied on: ${DateFormat('dd-MMM-yyyy hh:mm a').format(utcTime)}',
                    style: const TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(height: Utils.scrHeight * .02),

                // Divider
                const Divider(color: Colors.grey, thickness: 1),
                SizedBox(height: Utils.scrHeight * .02),

                //Company Description
                const Text("Massage",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )),
                SizedBox(height: Utils.scrHeight * .02),
                _massageContainer(),
                SizedBox(height: Utils.scrHeight * .02),
                _CVButton(context)
              ],
            ),
          ),

          // BottomBar for change Company Status
          _bottomBar(context),
        ],
      ),
    );
  }

  Row _CVButton(BuildContext context) {
    return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(widget.applicationModel.cv.isEmpty){
                        Utils.showSnackBar(context, 'CV Not Found');
                      }else{
                      Utils.navigateTo(context, PdfViewerScreen(pdfUrl: widget.applicationModel.cv, userName : widget.userModel.name));
                      }
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xff5872de)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Utils.scrHeight * .005,
                          horizontal: Utils.scrHeight * .01),
                      child: Text(
                        'View Cv',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Utils.scrHeight * .020,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      if(widget.applicationModel.cv.isEmpty){
                        Utils.showSnackBar(context, 'CV Not Found');
                      }else{
                        startDownloading();
                      }
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Color(0xff5872de)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Utils.scrHeight * .005,
                          horizontal: Utils.scrHeight * .01),
                      child: Text(
                        'DownLoad Cv',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Utils.scrHeight * .020,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              );
  }

  void startDownloading() async {
     String url = widget.applicationModel.cv;
     String fileName = "CV_${widget.userModel.username}_${widget.applicationModel.id}.pdf";

    String path = await _getFilePath(fileName);

    print('path $path');

    await dio.download(
      url,
      path,
      // onReceiveProgress: (recivedBytes, totalBytes) {
      //   setState(() {
      //     progress = (recivedBytes / totalBytes).clamp(0.0, 1.0);
      //   });
      //   print(progress);
      // }
      // ,
      deleteOnError: true,
    ).then((_) async {
      // Save the image to the gallery
      // final result = await ImageGallerySaver.saveFile(path);
      // print('Image saved to gallery: $result');
      Utils.showSnackBar(context, 'Downloaded Successfully');
      // Close the dialog
      // Navigator.pop(context);
    });
  }


  Future<String> _getFilePath(String filename) async {
    final dir = await getExternalStorageDirectory();
    print('directory : $dir');
    return "${dir!.path}/$filename";

  }

  Container _massageContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Text(
        widget.applicationModel.message,
        style:
            const TextStyle(fontSize: 15, color: Colors.black54, height: 2.2),
        textAlign: TextAlign.justify,
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
            child: DropdownButton<String>(
              underline: Container(),
              value: selectedStatus,
              onChanged: (newValue) async {
                setState(() {
                  selectedStatus = newValue!;
                });

                await ApplicationService.updateApplicationStatus(
                        widget.applicationModel.id, selectedStatus)
                    .then((value) {
                  Utils.showSnackBar(context, 'Applicant are $selectedStatus');
                });
              },
              items: status.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  List<String> status = ['Pending', 'Short Listed', 'Rejected'];

  Color _getContainerColor(String status) {
    switch (status) {
      case 'Short Listed':
        return Colors.green.shade100;
      case 'Pending':
        return Colors.orange.shade100;
      case 'Rejected':
        return Colors.red.shade100;
      default:
        return Colors.black; // Default color
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Short Listed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.black; // Default color
    }
  }
}
