import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/regist_controller.dart';

class RegisterView extends StatelessWidget {
  final RegisterController registerController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Warna background yang lembut
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            color: Colors.black87, // Warna teks yang soft
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Hilangkan shadow
        iconTheme: const IconThemeData(color: Colors.black87), // Warna ikon
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: registerController.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40), // Spacing di atas form
                TextFormField(
                  controller: registerController.nameController,
                  decoration: InputDecoration(
                    labelText: "Nama Lengkap",
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Nama lengkap tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16), // Spacing antara field
                TextFormField(
                  controller: registerController.emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Email tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16), // Spacing antara field
                TextFormField(
                  controller: registerController.passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Password tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16), // Spacing antara field
                TextFormField(
                  controller: registerController.confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Password",
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    } else if (value != registerController.passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24), // Spacing sebelum tombol
                Obx(() => registerController.isLoading.value
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (registerController.formKey.currentState!.validate()) {
                            registerController.register(
                              registerController.nameController.text,
                              registerController.emailController.text,
                              registerController.passwordController.text,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600], // Warna tombol
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2, // Shadow halus
                        ),
                        child: const Text(
                          "Daftar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      )),
                const SizedBox(height: 16), // Spacing setelah tombol
                TextButton(
                  onPressed: () => Get.toNamed('/login'),
                  child: Text(
                    "Sudah punya akun? Login",
                    style: TextStyle(
                      color: Colors.blue[600], // Warna teks yang soft
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}