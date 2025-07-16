import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/widgets/custom_buttion.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/splash_image.png",
                height: 276,
                width: 299,
              ),

              Text(
                "Enjoy Your Time",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 48,
                width: 259,
                child: Text(
                  textAlign: TextAlign.center,
                  "when you are confused about managing your task come to us",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.1),
              CustomButton(
                margin: EdgeInsets.symmetric(horizontal: 25),
                title: "Login",
                gradientColors: [
                  Color(0xFF00B4DB),
                  Color.fromARGB(255, 127, 195, 218),
                ],
                onTap: () {
                  Get.toNamed(AppRoutes.loginPage);
                },
              ),
              SizedBox(height: 25),
              CustomButton(
                margin: EdgeInsets.symmetric(horizontal: 25),
                title: "Sign Up",
                gradientColors: [
                  Color(0xFF00C9FF),
                  Color.fromARGB(255, 130, 159, 207),
                ],
                onTap: () {
                  Get.toNamed(AppRoutes.signupPage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
