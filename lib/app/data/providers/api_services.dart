import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://recipe.incube.id/api',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Fungsi untuk login
  Future<bool> login(BuildContext context, String email, String password) async {
    try {
      print("[LOGIN] Sending request with email: $email");
      final response = await _dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      print("[LOGIN] Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Ambil token dari response JSON yang benar
        String? token = response.data['data']['token'];

        if (token != null && token.isNotEmpty) {
          await prefs.setString('access_token', token);
          print("[LOGIN] Token berhasil disimpan: $token");
          return true;
        } else {
          print("[LOGIN ERROR] Token tidak ditemukan di response!");
          Get.snackbar("Error", "Login gagal: Token tidak ditemukan.");
          return false;
        }
      } else {
        Get.snackbar("Error", response.data['message'] ?? 'Login gagal!');
        return false;
      }
    } on DioException catch (e) {
      print("[LOGIN ERROR] ${e.message} | Response: ${e.response?.data}");
      Get.snackbar("Error", "Terjadi kesalahan saat login: ${e.message}");
      return false;
    }
  }

  // Fungsi untuk register
  Future<bool> register(
      BuildContext context, String name, String email, String password) async {
    try {
      print("[REGISTER] Sending request with name: $name, email: $email");
      final response = await _dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
        options: Options(
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      print("[REGISTER] Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response.data['access_token']);
        await prefs.setString('refresh_token', response.data['refresh_token']);
        return true;
      } else {
        Get.snackbar("Error", response.data['message'] ?? 'Registrasi gagal!');
        return false;
      }
    } on DioException catch (e) {
      print("[REGISTER ERROR] ${e.message} | Response: ${e.response?.data}");
      Get.snackbar("Error", "Terjadi kesalahan saat registrasi: ${e.message}");
      return false;
    }
  }

  // Fungsi untuk mendapatkan token akses
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Fungsi untuk memperbarui token
  Future<String?> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('refresh_token');

    if (token == null) {
      return "Tidak ada refresh token tersedia";
    }

    try {
      final response = await _dio.post(
        "/refresh-token/",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("[REFRESH TOKEN] Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        await prefs.setString('access_token', response.data['access_token']);
        return "Token berhasil diperbarui";
      } else {
        return "Gagal memperbarui token";
      }
    } on DioException catch (e) {
      print("[REFRESH TOKEN ERROR] ${e.response?.data}");
      return "Error: ${e.response?.data['message']}";
    }
  }

  // Fungsi logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    print("[LOGOUT] Token removed, user logged out.");
  }

  // Fungsi untuk mendapatkan semua resep
  Future<List> getAllRecipe() async {
    final token = await getToken();
    if (token == null) {
      print("Error: No token found");
      return [];
    }

    try {
      final response = await _dio.get(
        '/recipes',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("[GET ALL RECIPES] Full Response: ${response.data}");

      // ✅ Ambil `data['data']` yang berisi list resep
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        var extractedData =
            response.data['data']['data']; // 🔥 Ubah ke `data['data']`

        if (extractedData is List) {
          print("[DEBUG] Loaded ${extractedData.length} recipes");
          return extractedData;
        } else {
          print("Error: `data['data']` is not a List - ${response.data}");
          return [];
        }
      } else {
        print("Error: Invalid response format - ${response.data}");
        return [];
      }
    } catch (e) {
      print("Error fetching recipes: $e");
      return [];
    }
  }

  // Fungsi untuk mendapatkan resep berdasarkan ID
  Future<Map<String, dynamic>?> getRecipeById(int id) async {
    final token = await getToken();
    if (token == null) {
      print("Error: No token found");
      return null;
    }

    try {
      final response = await _dio.get(
        '/recipes/$id', // 🔥 API endpoint sesuai ID resep
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      print("[GET RECIPE] Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        var extractedData = response.data['data']; // 🔥 Ambil data yang benar
        return extractedData;
      } else {
        print("Error: Failed to fetch recipe details");
        return null;
      }
    } catch (e) {
      print("Error fetching recipe details: $e");
      return null;
    }
  }

  // Fungsi untuk menangani error Dio
  void _handleDioError(DioException e) {
    print("[DIO ERROR] ${e.message} | Response: ${e.response?.data}");
  }
}