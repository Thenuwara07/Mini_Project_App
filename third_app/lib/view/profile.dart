import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:third_app/view/recoverydata.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();  // Navigate back when pressed
          },
        ),
      ),
      body: user == null
          ? const Center(
              child: Text(
                'No user logged in!',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      user.displayName ?? 'Pramukha',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.email ?? 'No Email',
                      style: const TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ProfileDetailTile(label: 'Email', value: user.email ?? 'No Email'),
                    ProfileDetailTile(label: 'Name', value: user.displayName ?? 'Pramukha'),
                    const SizedBox(height: 20),  // Moved the SizedBox here
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width * .5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecoveryData(),
                            ),
                          );
                        },
                        child: const Text(
                          'Add Personal Data',
                          style: TextStyle(color: Colors.purple, fontSize: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProfileDetailTile extends StatelessWidget {
  final String label;
  final String value;

  const ProfileDetailTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
