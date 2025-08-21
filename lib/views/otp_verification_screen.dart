import 'package:cargo_pro_assignments/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'object_list_screen.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

  final authController = Get.find<AuthController>();
  final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter OTP')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final horizontalPadding = isWide ? 48.0 : 16.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 24),
            child: Center(
              child: SizedBox(
                width: isWide ? 500 : double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(() => authController.generatedOtp.value.isNotEmpty
                        ? Text(
                            'Demo OTP: ${authController.generatedOtp.value}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 16),
                    TextField(
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        labelText: 'OTP Code',
                        hintText: 'Enter 6-digit OTP',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    Obx(() => authController.errorMessage.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              authController.errorMessage.value,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : const SizedBox.shrink()),
                    ElevatedButton(
                      onPressed: () async {
                        await authController.verifyOtp(otpController.text.trim());
                        if (authController.isLoggedIn.value) {
                          Get.offAll(() => ObjectListScreen());
                        }
                      },
                      child: const Text('Verify OTP',
                      style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
