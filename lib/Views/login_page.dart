import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/Controller/Auth_controller/firebase_auth_controller.dart';
import 'package:quick_notes/Utils/validtor/textformfield_validator.dart';
import 'package:quick_notes/widgets/custom_buttion.dart';
import 'package:quick_notes/widgets/custom_dialog_buttion.dart';
import 'package:quick_notes/widgets/custom_textformfield.dart';
import 'package:quick_notes/widgets/custom_social_buttion.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final firebaseAuthController = Get.put(FirebaseAuthController());

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: ClipOval(
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          "assets/icons/app_logo.png",
                          height: 180,
                          width: 180,
                        ),
                      ),
                    ),
                    Text(
                      "Sign in to your Account",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      "Enter your email and password to Sign in",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),

                    SizedBox(height: 25),
                    Text(
                      "Email",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.5),
                      child: CustomTextFormField(
                        hintText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: emailController,
                        validator: TextFormFieldValidator.validateEmailId,
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Password",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.5),
                      child: CustomTextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        isPassword: !isPasswordVisible,
                        validator: TextFormFieldValidator.validatePassword,
                        hintText: 'Password',
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },

                          tooltip:
                              isPasswordVisible
                                  ? "Hide Password"
                                  : "Show Password",
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 28,
                          ),
                        ),
                        controller: passwordController,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  rememberMe = newValue ?? false;
                                });
                              },
                            ),
                            Text(
                              "Remember me",
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                            ),
                          ],
                        ),

                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.passwordResetPage);
                          },
                          child: Text(
                            "Forgot Password ?",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () =>
                          firebaseAuthController.isLogInLoading.value
                              ? const Center(child: CircularProgressIndicator())
                              : CustomButton(
                                title: 'Login',

                                onTap: () async {
                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    try {
                                      UserCredential? userCredential =
                                          await firebaseAuthController
                                              .loginWithEmailPassword(
                                                emailController.text.trim(),
                                                passwordController.text.trim(),
                                              );
                                      if (!mounted) return;

                                      if (userCredential != null) {
                                        // Login successful
                                        Get.offAllNamed(
                                          AppRoutes.customBottomNavBar,
                                        );
                                      }
                                    } catch (e) {
                                      if (!mounted) return;
                                      Get.snackbar(
                                        "Login Failed",
                                        "Invalid email or password",
                                      );
                                      return;
                                    }
                                  }
                                },
                              ),
                    ),

                    SizedBox(height: 15),
                    Center(
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRoutes.signupPage);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Sign up",
                                style: Theme.of(
                                  context,
                                ).textTheme.labelLarge?.copyWith(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 2,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "OR",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Theme.of(context).dividerColor,
                            thickness: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () =>
                          firebaseAuthController.isGoogleLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : CustomSocialButtion(
                                tittleText: 'Continue with Google',
                                imagePath: 'assets/icons/google.png',
                                onTap: () async {
                                  if (firebaseAuthController
                                      .isGoogleLoading
                                      .value) {
                                    return;
                                  }
                                  try {
                                    firebaseAuthController
                                        .isGoogleLoading
                                        .value = true;
                                    final result =
                                        await firebaseAuthController
                                            .googleLogin();

                                    if (!mounted) return;
                                    if (result == null) {
                                      Get.snackbar(
                                        "Login Cancelled",
                                        "Google Sign-In Closed",
                                      );
                                      return;
                                    }
                                    final displayName =
                                        result.user?.displayName ?? "User";
                                    Get.snackbar("Hello", " $displayName");
                                  } on FirebaseAuthException catch (e) {
                                    Get.snackbar(
                                      "Login Failed",
                                      e.message ?? "FireBase Error",
                                    );
                                  } catch (e) {
                                    Get.snackbar(
                                      "Login Failed",
                                      "Something went wrong $e",
                                    );
                                  } finally {
                                    firebaseAuthController
                                        .isGoogleLoading
                                        .value = false;
                                  }
                                },
                              ),
                    ),
                    SizedBox(height: 25),
                    CustomSocialButtion(
                      tittleText: 'Continue with Apple',
                      imagePath: 'assets/icons/apple.png',
                      onTap: () {
                        showCustomDialog(
                          icon: Icons.add_alert,
                          title: 'Not Avaliable',
                          message: 'Apple login not avaliable at this time',
                        );
                      },
                    ),

                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
