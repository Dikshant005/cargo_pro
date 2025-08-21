import 'package:cargo_pro_assignments/controllers/auth_controllers.dart';
import 'package:cargo_pro_assignments/views/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneInputScreen extends StatelessWidget {
  PhoneInputScreen({super.key});

  final authController = Get.find<AuthController>();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
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
                    Text(
                      'Please enter your phone number',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+1234567890',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(() => authController.errorMessage.value.isNotEmpty
                        ? Text(
                            authController.errorMessage.value,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox.shrink()),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        authController.sendOtp(phoneController.text.trim());
                        if (authController.isCodeSent.value) {
                          Get.to(() => OtpScreen());
                        }
                      },
                      child: const Text('Send OTP',
                      style: TextStyle(color: Colors.white),),
                    ),
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
