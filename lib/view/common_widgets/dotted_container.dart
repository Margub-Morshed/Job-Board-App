
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/application/application_service.dart';
import '../../utils/utils.dart';


class DottedContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final String? fileName;

  const DottedContainer({Key? key, this.onTap, this.fileName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
            onTap: onTap,
            child: DottedBorder(
              color: const Color(0xFF5A5C5F),
              // Dotted line color
              strokeWidth: 2.5,
              // Dotted line width
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              // Dotted line border radius
              dashPattern: const [4, 0, 4],
              // Responsible for [- - - - - -]
              child: Container(
                padding: EdgeInsets.all(Utils.scrHeight * .016),
                // Padding for the red container
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF7F7), // Dotted Border Inner Color
                  borderRadius:
                  BorderRadius.circular(Utils.scrHeight * .012), // Inner Radius
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.file_present,
                        size: Utils.scrHeight * .024),
                    SizedBox(width: Utils.scrHeight * .012),
                    Text( fileName == null ? "Add CV/Resume" : _truncateImageName(fileName),
                      style: const TextStyle( fontSize: 16),
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<dynamic> _buildShowDialog(BuildContext context) {
    return showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Permission Required'),
                    content: const Text(
                      'Please grant access to the camera and storage in settings to proceed.',
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          openAppSettings(); // Open app settings
                        },
                        child: const Text('Open Settings'),
                      ),
                    ],
                  ),
                );
  }

  String _truncateImageName(String? imageName) {
    if (imageName == null || imageName.isEmpty) {
      return "";
    }

    const maxLength = 18; // Change this to your desired maximum length

    if (imageName.length <= maxLength) {
      return imageName;
    }

    final extensionIndex = imageName.lastIndexOf('.');
    final nameBeforeExtension = imageName.substring(0, extensionIndex);
    final extension = imageName.substring(extensionIndex);

    final prefixLength = (maxLength - extension.length) ~/ 2;
    final suffixLength = maxLength - extension.length - prefixLength;

    final truncatedName =
        '${nameBeforeExtension.substring(0, prefixLength)}...'
        '${nameBeforeExtension.substring(nameBeforeExtension.length - suffixLength)}$extension';

    return truncatedName;
  }
}