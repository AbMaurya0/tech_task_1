import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:techtask/screens/user_detail_screen.dart';

import '../controller /home_screen_controller.dart';
import '../utils/shrimmer_effect.dart'; // Import the shimmer widgets

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          // Use the shimmer effect instead of CircularProgressIndicator
          return const UserListShimmer();
        }

        if (controller.users.isEmpty) {
          return const Center(
            child: Text('No users found', style: TextStyle(fontSize: 16)),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchUsers,
          child: ListView.builder(
            itemCount: controller.users.length,
            itemBuilder: (context, index) {
              final user = controller.users[index];
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8),
                    leading: Hero(
                      tag: 'user-avatar-${user.id}',
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                        radius: 25,
                      ),
                    ),
                    title: Text(
                      '${user.firstName} ${user.lastName}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(user.email),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.to(() => UserDetailsScreen(userId: user.id));
                    },
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchUsers,
        child: const Icon(Icons.refresh),
        tooltip: 'Refresh Users',
      ),
    );
  }
}
