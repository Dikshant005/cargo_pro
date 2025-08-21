import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class AuthController extends GetxController {
  final String validPhoneNumber = '+1234567890';

  var isCodeSent = false.obs;
  var isLoggedIn = false.obs;
  var errorMessage = ''.obs;
  var generatedOtp = ''.obs;

  static const _loginKey = 'is_logged_in';

  @override
  void onInit() {
    super.onInit();
    _loadLoginState();
  }

  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool(_loginKey) ?? false;
  }

  Future<void> _saveLoginState(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, loggedIn);
  }

  void sendOtp(String phone) {
    if (phone == validPhoneNumber) {
      generatedOtp.value = _generateOtp();
      isCodeSent.value = true;
      errorMessage.value = '';
      print('Generated OTP: ${generatedOtp.value}'); // For demo only
    } else {
      errorMessage.value = 'Invalid phone number';
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (otp == generatedOtp.value) {
      await _saveLoginState(true);
      isLoggedIn.value = true;
      errorMessage.value = '';
    } else {
      errorMessage.value = 'Invalid OTP code';
    }
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    isCodeSent.value = false;
    errorMessage.value = '';
    generatedOtp.value = '';
    await _saveLoginState(false);
  }

  String _generateOtp() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString(); // 6-digit OTP
  }
}
