import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/Controller/Auth_controller/firebase_auth_controller.dart';
import 'package:quick_notes/widgets/custom_buttion.dart';
import 'package:quick_notes/widgets/custom_textformfield.dart';
import 'package:quick_notes/Utils/validtor/textformfield_validator.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  FirebaseAuthController firebaseAuthController = FirebaseAuthController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed(AppRoutes.loginPage);
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reset Password",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 28,
                ),
              ),
              Text(
                "Enter the email linked to your account, and we'll send instructions on that email, to reset your password.",
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
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                hintText: 'Email',
                controller: emailController,
                validator: TextFormFieldValidator.validateEmailId,
              ),
              SizedBox(height: Get.height * 0.08),
              CustomButton(
                title: "Send Instruction",
                onTap: () {
                  Get.offAllNamed(AppRoutes.loginPage);
                  if (formKey.currentState!.validate()) {
                    firebaseAuthController.sendRestPasswordEmail(
                      emailController.text.trim(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
