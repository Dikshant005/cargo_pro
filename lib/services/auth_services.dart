import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Send OTP to phone number (mobile & web)
  Future<void> sendOTP({
    required String phoneNumber,
    required Function(ConfirmationResult)? webConfirmationCallback,
    required Function(PhoneAuthCredential) autoVerifiedCallback,
    required Function(FirebaseAuthException) failedCallback,
    required Function(String, int?) codeSentCallback,
    required Function(String) codeAutoRetrievalTimeoutCallback,
  }) async {
    if (webConfirmationCallback != null) {
      // Web: use signInWithPhoneNumber returns a ConfirmationResult
      try {
        final confirmationResult = await _auth.signInWithPhoneNumber(phoneNumber);
        webConfirmationCallback(confirmationResult);
      } catch (e) {
        failedCallback(FirebaseAuthException(code: 'error', message: e.toString()));
      }
      return;
    }

    // Mobile: use verifyPhoneNumber
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: autoVerifiedCallback,
      verificationFailed: failedCallback,
      codeSent: codeSentCallback,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeoutCallback,
      timeout: Duration(seconds: 60),
    );
  }

  /// Verify OTP code entered by the user
  Future<UserCredential> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _auth.signInWithCredential(credential);
  }

  /// Logout user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Observe auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
