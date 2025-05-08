import 'package:get/get.dart';
import '../models/user_model.dart';

import '../services/apimiddleware.dart';

class HomeScreenController extends GetxController {
  static HomeScreenController get instance => Get.find();

  var users = <User>[].obs;
  var user = Rxn<User>();
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      final data =
          await ApiMiddleware.get('https://reqres.in/api/users?page=1');
      final userResponse = UserResponse.fromJson(data);
      users.assignAll(userResponse.data);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchUserById(int id) async {
    try {
      isLoading(true);
      final data = await ApiMiddleware.get('https://reqres.in/api/users/$id');
      user.value = User.fromJson(data['data']);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }
}
