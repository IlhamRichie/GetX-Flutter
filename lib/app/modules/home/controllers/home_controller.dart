import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/api_services.dart';

class HomeController extends GetxController {
  var recipes = [].obs;
  var isLoading = false.obs;
  final ApiServices _recipeServices = ApiServices();
  final ApiServices authService = ApiServices();

  @override
  void onInit() {
    super.onInit();
    fetchRecipes();
  }

  void fetchRecipes() async {
    isLoading.value = true;
    try {
      var data = await _recipeServices.getAllRecipe();
      recipes.value = data;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch recipes: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void confirmLogout() {
    Get.defaultDialog(
      title: "Konfirmasi Logout",
      middleText: "Apakah Anda yakin ingin keluar?",
      textCancel: "Batal",
      textConfirm: "Logout",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await authService.logout();
        Get.offAllNamed('/login');
      },
    );
  }
}