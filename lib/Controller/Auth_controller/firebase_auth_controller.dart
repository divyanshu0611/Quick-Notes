import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/widgets/custom_dialog_buttion.dart';

class FirebaseAuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ✅ Reactive verification ID to persist value even after navigation
  RxString verificationId = ''.obs;

  RxBool isLogInLoading = false.obs;
  RxBool isSignupLoading = false.obs;
  RxBool isGoogleLoading = false.obs;

  // ✅ Email/password login
  Future<UserCredential?> loginWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      isLogInLoading.value = true;
      final userLogin = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // // ✅ Save login session
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', true);
      return userLogin;
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
      return null;
    } finally {
      isLogInLoading.value = false;
    }
  }

  // ✅ Email/password registration
  Future<UserCredential?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      isSignupLoading.value = true;
      final userRegister = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userRegister;
    } catch (e) {
      Get.snackbar("Registration Failed", e.toString());
      return null;
    } finally {
      isSignupLoading.value = false;
    }
  }

  // ✅ Firebase logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }
      // // ✅ Clear login session
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', false);
      Get.snackbar(
        "Logout Successful",
        "You have been logged out successfully.",
      );
      Get.offAllNamed(AppRoutes.loginPage);
    } catch (e) {
      Get.snackbar("Logout Failed", e.toString());
    }
  }

  // ✅ Send password reset email
  Future<void> sendRestPasswordEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showCustomDialog(
        title: "Email Sent",
        message:
            "We've sent a password reset link to your email. Please check your inbox.",
        icon: Icons.email_outlined,
        buttonText: "OK",
        onConfirm: () {
          Get.offAllNamed(AppRoutes.loginPage);
        },
      );
    } catch (e) {
      Get.snackbar("Reset Password Failed", e.toString());
    }
  }

  // ✅ Send OTP to phone number
  Future<void> sendOtpToPhone(String phoneNumber) async {
    try {
      verificationId.value = ''; // Clear previous ID
      int? resendToken;

      await _auth.verifyPhoneNumber(
        phoneNumber: "+91$phoneNumber",
        timeout: const Duration(seconds: 60),
        forceResendingToken: resendToken,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Optional: Handle auto-verification
        },
        verificationFailed: (FirebaseAuthException e) {
          Get.snackbar("OTP Error", e.message ?? "Verification failed");
        },
        codeSent: (String verId, int? resendToken) {
          verificationId.value = verId; // ✅ Store verificationId
          resendToken = resendToken;

          // // Small delay to ensure navigation works smoothly
          // Future.delayed(const Duration(milliseconds: 200), () {
          //   Get.toNamed(AppRoutes.otpScreen);
          // });
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId.value = verId; // ✅ Store even if timeout
        },
      );
    } catch (e) {
      Get.snackbar("Send OTP Failed", e.toString());
    }
  }

  // ✅ Verify the OTP code
  Future<bool> verifyOtpCode(String smsCode) async {
    try {
      if (verificationId.value.isEmpty) {
        Get.snackbar(
          "Error",
          "Verification ID not found. Please request OTP again.",
        );
        return false;
      }

      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );

      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar("Error", "No user is signed in.");
        return false;
      }

      // Already verified
      if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty) {
        return true;
      }

      // ✅ Link phone number
      await user.linkWithCredential(credential);

      verificationId.value = ''; // Clear after success

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage = "OTP verification failed.";
      if (e.code == 'invalid-verification-code') {
        errorMessage = "Invalid OTP. Please try again.";
      } else if (e.code == 'credential-already-in-use') {
        errorMessage =
            "This phone number is already linked to another account.";
      } else if (e.code == 'provider-already-linked') {
        errorMessage = "Phone number is already linked.";
      }
      Get.snackbar("Verification Error", errorMessage);
      return false;
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
      return false;
    }
  }

  // ✅ Google login/signup
  Future<UserCredential?> googleLogin() => signInWithGoogle();
  Future<UserCredential?> googleSignup() => signInWithGoogle();

  Future<UserCredential?> signInWithGoogle({bool forceLogout = true}) async {
    try {
      isGoogleLoading.value = true;

      if (forceLogout) {
        await _googleSignIn.signOut(); // Force logout previous session
      }

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      // // ✅ Save login state
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setBool('isLoggedIn', true);

      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      if (isNewUser) {
        Get.offAllNamed(AppRoutes.userOnBoardScreen);
      } else {
        Get.offAllNamed(AppRoutes.customBottomNavBar);
      }

      return userCredential;
    } catch (e) {
      Get.snackbar("Google Sign-In Error", "$e");
      return null;
    } finally {
      isGoogleLoading.value = false;
    }
  }
}
