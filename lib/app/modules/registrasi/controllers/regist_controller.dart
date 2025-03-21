import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_services.dart';

class RegisterController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final ApiServices authService = ApiServices();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> register(String name, String email, String password) async {
    isLoading.value = true;

    try {
      bool success = await authService.register(Get.context!, name, email, password);

      if (success) {
        Get.snackbar("Success", "Registrasi berhasil! Silakan login.");
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Error", "Registrasi gagal, coba lagi nanti");
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}