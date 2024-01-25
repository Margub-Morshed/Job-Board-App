import 'package:flutter/material.dart';

import '../../model/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            UserAttributeCard(label: 'ID', value: user.id),
            UserAttributeCard(label: 'Username', value: user.username),
            UserAttributeCard(label: 'Name', value: user.name ?? 'N/A'),
            UserAttributeCard(label: 'Email', value: user.email),
            UserAttributeCard(
                label: 'Phone Number', value: user.phoneNumber ?? 'N/A'),
            UserAttributeCard(
                label: 'User Avatar', value: user.userAvatar ?? 'N/A'),
            UserAttributeCard(
                label: 'Cover Image', value: user.coverImage ?? 'N/A'),
            UserAttributeCard(label: 'Password', value: user.password),
            UserAttributeCard(label: 'Role', value: user.role),
          ],
        ),
      ),
    );
  }
}

class UserAttributeCard extends StatelessWidget {
  final String label;
  final String value;

  const UserAttributeCard(
      {super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
