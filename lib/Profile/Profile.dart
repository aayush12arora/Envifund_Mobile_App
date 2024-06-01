import 'package:envifund_moblie_application/UserProjects/userProjects.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../UserInvestMents/userInvestments.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
loading= false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  loading
        ? Center(
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: const CircularProgressIndicator(color: Colors.black),
      ),
    )
        :Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile picture
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user!.photoURL!), // Replace with actual image URL
            ),
            const SizedBox(height: 20),
            // Name
             Text(
              user!.displayName?? "Name",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Email
             Text(
              user?.email ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Divider
            const Divider(),
            const SizedBox(height: 20),
            // Options
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('My Investments'),
              onTap: () {
                // Navigate to My Investments page
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserInvestmentsPage(email: user?.email ?? '',)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('My Projects'),
              onTap: () {
                // Navigate to My Projects page
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProjects(email: user?.email ?? '',)));
              },
            ),
          ],
        ),
      ),
    );
  }
}
