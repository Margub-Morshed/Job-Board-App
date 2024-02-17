import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_board_app/view/company_details/company_details_screen.dart';
import '../../model/company_model.dart';
import '../../utils/utils.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Company List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: Utils.companyAdminsRef.snapshots(),
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

          List<CompanyModel> companies =
              snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return CompanyModel.fromMap(data);
          }).toList();

          // return Container();

          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              CompanyModel company = companies[index];
              return CompanyCard(company: company);
            },
          );
        },
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  const CompanyCard({Key? key, required this.company}) : super(key: key);

  final CompanyModel company;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Card Elevation
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
            spreadRadius: -2,
            offset: const Offset(-10, 4),
          ),
        ],
      ),
      child: InkWell(
        // Card Outer Border Radius
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Utils.navigateTo(
              context,
              CompanyDetailsScreen(
                  company: company, tag: "${company.id}_hero_tag"));
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: ProfileImage(
                        imageUrl: company.logoImage,
                        imageName: "${company.id}_hero_tag",
                      ),
                    ),

                    const SizedBox(width: 10),
                    // Right Side Information
                    Expanded(
                      flex: 6, // Adjust flex as needed
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            company.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ), // Add some spacing
                          ProfileDetails(
                            email: company.email,
                            teamSize: company.teamSize,
                            address: company.address,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({Key? key, required this.imageUrl, this.imageName})
      : super(key: key);

  final String? imageUrl;
  final String? imageName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      height: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Hero(
          transitionOnUserGestures: true,
          tag: imageName.toString(),
          child: (imageUrl!.isNotEmpty || imageUrl != '') ? CachedNetworkImage(
            imageUrl: imageUrl ?? Utils.flutterDefaultImg,
            fit: BoxFit.fill,
            height: double.infinity,
          ) : CachedNetworkImage(
            imageUrl: Utils.flutterDefaultImg,
            fit: BoxFit.fill,
            height: double.infinity,
          ),
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
        Text('Team Size: $teamSize',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text('Address: $address',
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
