import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_board_app/model/company_model.dart';

import 'package:flutter/material.dart';
import 'package:job_board_app/utils/utils.dart';

import '../common_widgets/drawer/custom_drawer.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company List'),
      ),
      drawer: const CustomDrawer(),
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

          List<CompanyModel> companies = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return CompanyModel.fromMap(data);
          }).toList();

          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              CompanyModel company = companies[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(company.id),
                  subtitle: Text(company.email),
                  // You can add more fields as needed
                  // onTap: () {
                  //   // Handle onTap if needed
                  // },
                ),
              );
            },
          );
        },
      ),
    );
  }
}



