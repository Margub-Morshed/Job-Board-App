import 'dart:ui';
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
    final hero_tag = "${company.id}_hero_tag";

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
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),

                // Left Side Image
                leading: Padding(
                  padding: const EdgeInsets.only(right: 6.0),
                  // Right Side Padding
                  child: ProfileImage(
                      imageUrl: company.logoImage,
                      imageName: "${company.id}_hero_tag"),
                ),

                // Right Side Information
                title: Text(company.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: ProfileDetails(
                    email: company.email,
                    teamSize: company.teamSize,
                    address: company.address),
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
    return Hero(
      transitionOnUserGestures: true,
      tag: imageName.toString(),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.2),
              blurRadius: 10,
              spreadRadius: -2,
              offset: const Offset(-10, 4),
            ),
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl ?? ''),
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
