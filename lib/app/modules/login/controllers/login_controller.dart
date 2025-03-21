import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/providers/api_services.dart';

class LoginController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final ApiServices authService = ApiServices();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  SharedPreferences? prefs; // Gunakan nullable untuk menghindari late initialization

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance(); // Inisialisasi langsung di onInit
    checkLoginStatus();
  }

  Future<void> login(String email, String password) async {
    if (prefs == null) {
      print("SharedPreferences belum diinisialisasi");
      return;
    }

    isLoading.value = true;

    try {
      print("[LOGIN CONTROLLER] Attempting login for: $email");

      bool success = await authService.login(Get.context!, email, password);

      if (success) {
        final String? token = prefs!.getString('access_token'); // Gunakan prefs! karena sudah diinisialisasi

        if (token != null) {
          print("[LOGIN CONTROLLER] Login successful, token saved: $token");
          isAuthenticated.value = true;
          Get.offAllNamed('/home');
        } else {
          print("[LOGIN CONTROLLER] Login failed, token not found");
          Get.snackbar("Error", "Login gagal, token tidak ditemukan");
        }
      } else {
        print("[LOGIN CONTROLLER] Login failed, invalid credentials");
        Get.snackbar("Error", "Login gagal, periksa kembali email & password");
      }
    } catch (e) {
      print("[LOGIN CONTROLLER ERROR] ${e.toString()}");
      Get.snackbar("Error", "Terjadi kesalahan: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkLoginStatus() async {
    if (prefs == null) {
      print("SharedPreferences belum diinisialisasi");
      return;
    }

    final String? token = prefs!.getString('access_token');

    if (token != null) {
      print("[LOGIN CONTROLLER] User is already authenticated");
      isAuthenticated.value = true;
      Get.offAllNamed('/home');
    } else {
      print("[LOGIN CONTROLLER] No valid token found, redirecting to login");
      isAuthenticated.value = false;
    }
  }

  Future<void> logout() async {
    if (prefs == null) {
      print("SharedPreferences belum diinisialisasi");
      return;
    }

    await prefs!.remove('access_token');
    await prefs!.remove('refresh_token');
    print("[LOGOUT] User logged out, token removed.");

    isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }
}