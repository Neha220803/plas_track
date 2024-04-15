// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Incentives Received',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          ListTile(
            title: Text('Recycling Bonus'),
            subtitle: Text('Received on August 15, 2023'),
            trailing: Text('+Rs 5.00'),
          ),
          ListTile(
            title: Text('Recycling Bonus'),
            subtitle: Text('Received on August 10, 2023'),
            trailing: Text('+Rs. 2.50'),
          ),
        ],
      ),
    );
  }
}
