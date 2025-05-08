import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:techtask/models/user_model.dart';
import 'package:techtask/utils/shrimmer_effect.dart';

import '../controller /home_screen_controller.dart';

class UserDetailsScreen extends StatelessWidget {
  final int userId;

  // Use find instead of put to retrieve the existing controller instance
  final HomeScreenController controller = Get.find<HomeScreenController>();

  UserDetailsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Fetch user data when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchUserById(userId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return UserDetailsShimmer();
        }

        final User? user = controller.user.value;
        if (user == null) {
          return const Center(
            child: Text(
              "User data not available",
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Hero(
                  tag: 'user-avatar-${user.id}',
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(user.avatar),
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.email, 'Email', user.email),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                            Icons.numbers, 'User ID', user.id.toString()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh Data'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => controller.fetchUserById(userId),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
