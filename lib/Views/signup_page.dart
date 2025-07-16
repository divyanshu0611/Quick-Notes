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

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final firebaseAuthController = Get.put(FirebaseAuthController());
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
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
                key: formkey,
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
                      "Sign up",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      "Create an account to continue!",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),

                    SizedBox(height: 25),
                    Text(
                      "Email",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.5),
                      child: CustomTextFormField(
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Email',
                        controller: emailController,
                        textInputAction: TextInputAction.next,
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
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.5),
                      child: CustomTextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: !isPasswordVisible,
                        hintText: 'Password',
                        controller: passwordController,
                        textInputAction: TextInputAction.done,
                        validator: TextFormFieldValidator.validatePassword,
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Obx(
                      () =>
                          firebaseAuthController.isSignupLoading.value
                              ? Center(child: CircularProgressIndicator())
                              : CustomButton(
                                title: 'Sign up',
                                onTap: () async {
                                  if (formkey.currentState?.validate() ??
                                      false) {
                                    UserCredential? userCredential =
                                        await firebaseAuthController
                                            .registerWithEmailAndPassword(
                                              emailController.text.trim(),
                                              passwordController.text.trim(),
                                            );
                                    if (!mounted) return;

                                    if (userCredential != null) {
                                      Get.offNamed(AppRoutes.userOnBoardScreen);
                                    } else {
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
                          Get.toNamed(AppRoutes.loginPage);
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Login",
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
                                        "Sign-Up Cancelled",
                                        "Google Sign-Up Closed",
                                      );
                                      return;
                                    }
                                    final displayName =
                                        result.user?.displayName ?? "User";
                                    Get.snackbar("Welcome", " $displayName");
                                  } on FirebaseAuthException catch (e) {
                                    if (!mounted) return;
                                    Get.snackbar(
                                      "Sign-Up Failed",
                                      e.message ?? "FireBase Error",
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    Get.snackbar(
                                      "Sign-Up Failed",
                                      "Something went wrong $e",
                                    );
                                  } finally {
                                    if (mounted) {
                                      firebaseAuthController
                                          .isGoogleLoading
                                          .value = false;
                                    }
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
