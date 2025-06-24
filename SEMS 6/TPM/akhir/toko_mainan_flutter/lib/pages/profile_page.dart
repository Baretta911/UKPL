import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_mainan_flutter/services/auth_service.dart';
import 'package:toko_mainan_flutter/pages/login_page.dart';
import 'package:toko_mainan_flutter/pages/order_history_page.dart'; // Import OrderHistoryPage
import 'package:toko_mainan_flutter/pages/edit_profile_page.dart'; // Import EditProfilePage

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use watch to rebuild when authService notifies listeners (e.g., after profile update)
    final authService = Provider.of<AuthService>(context);
    final user = authService.currentUser; // Accessing the corrected getter

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Not logged in. Please log in again.')) // Updated message
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'User Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('ID: ${user.id}'), // Displaying user ID for confirmation
                  Text('Name: ${user.name}'),
                  Text('Email: ${user.email}'),
                  Text('Role: ${user.role}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderHistoryPage()),
                      );
                    },
                    child: const Text('View Order History'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                      ).then((_) {
                        // This block executes when EditProfilePage is popped.
                        // No explicit refresh needed here if AuthService.refreshCurrentUser()
                        // was called and notified listeners, and ProfilePage is listening.
                      });
                    },
                    child: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}
