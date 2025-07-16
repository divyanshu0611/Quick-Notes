// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/Controller/Auth_controller/firebase_auth_controller.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';
import 'package:quick_notes/Controller/Profile_Image_Controller/image_picker_controller.dart';
import 'package:quick_notes/Utils/Firebase_Storage/firebase_storage_helper.dart';
import 'package:quick_notes/Utils/validtor/textformfield_validator.dart';
import 'package:quick_notes/widgets/custom_buttion.dart';
import 'package:quick_notes/widgets/custom_textformfield.dart';
import 'package:quick_notes/widgets/OnBoard/dob_input_formater.dart';

class UserOnboardDetails extends StatefulWidget {
  const UserOnboardDetails({super.key});

  @override
  State<UserOnboardDetails> createState() => _UserOnboardDetailsState();
}

class _UserOnboardDetailsState extends State<UserOnboardDetails> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final positionController = TextEditingController();
  final dobController = TextEditingController();
  final otpController = TextEditingController();

  final FirebaseAuthController firebaseAuthController =
      FirebaseAuthController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RxBool isSubmitting = false.obs;
  final RxBool showOtpField = false.obs;
  final RxBool isPhoneVerified = false.obs;

  late ImagePickerController _pickerController;

  @override
  void initState() {
    super.initState();
    _pickerController = Get.put(ImagePickerController());
  }

  @override
  void dispose() {
    Get.delete<ImagePickerController>();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    otpController.dispose();
    dobController.dispose();
    positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Setup",
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 20),

                          Center(
                            child: Obx(() {
                              final hasImage =
                                  _pickerController.imagePath.isNotEmpty &&
                                  File(
                                    _pickerController.imagePath.value,
                                  ).existsSync();
                              return InkWell(
                                onTap:
                                    () => _pickerController.getProfileImage(),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage:
                                      hasImage
                                          ? FileImage(
                                            File(
                                              _pickerController.imagePath.value,
                                            ),
                                          )
                                          : null,
                                  backgroundColor: Colors.grey[300],
                                  child:
                                      !hasImage
                                          ? const Icon(
                                            Icons.person,
                                            size: 70,
                                            color: Colors.white,
                                          )
                                          : null,
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 25),

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomTextWidget(
                                      tittle: 'First Name',
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextFormField(
                                      controller: firstNameController,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      hintText: 'First Name',
                                      validator:
                                          TextFormFieldValidator
                                              .validateFirstName,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CustomTextWidget(tittle: 'Last Name'),
                                    const SizedBox(height: 5),
                                    CustomTextFormField(
                                      controller: lastNameController,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      hintText: 'Last Name',
                                      validator:
                                          TextFormFieldValidator
                                              .validateLastName,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          const CustomTextWidget(tittle: 'DOB'),
                          const SizedBox(height: 5),
                          CustomTextFormField(
                            controller: dobController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            hintText: 'DD/MM/YYYY',
                            inputFormatter: [DOBInputFormatter()],
                            icon: const Icon(Icons.calendar_month_outlined),
                          ),
                          const SizedBox(height: 25),

                          const CustomTextWidget(tittle: 'Phone Number'),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextFormField(
                                  controller: phoneNumberController,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  hintText: 'Phone Number',
                                  validator:
                                      TextFormFieldValidator
                                          .validatePhoneNumber,
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () async {
                                  final phone =
                                      phoneNumberController.text.trim();
                                  if (phone.length == 10) {
                                    await firebaseAuthController.sendOtpToPhone(
                                      phone,
                                    );
                                    showOtpField.value = true;
                                    Get.snackbar(
                                      "OTP Sent",
                                      "Check your SMS inbox",
                                    );
                                  } else {
                                    Get.snackbar(
                                      "Invalid",
                                      "Enter valid phone number",
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text(
                                  "Send OTP",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Obx(
                            () =>
                                showOtpField.value
                                    ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 25),
                                        const CustomTextWidget(
                                          tittle: 'OTP Verification',
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextFormField(
                                                controller: otpController,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.done,
                                                hintText: 'Enter OTP',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.length != 6) {
                                                    return "Enter 6-digit OTP";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            ElevatedButton(
                                              onPressed: () async {
                                                final otp =
                                                    otpController.text.trim();
                                                if (otp.length == 6) {
                                                  final verified =
                                                      await firebaseAuthController
                                                          .verifyOtpCode(otp);
                                                  if (verified) {
                                                    isPhoneVerified.value =
                                                        true;
                                                    showOtpField.value = false;
                                                    Get.snackbar(
                                                      "Verified",
                                                      "Phone number verified",
                                                    );
                                                  } else {
                                                    Get.snackbar(
                                                      "Failed",
                                                      "Invalid OTP",
                                                    );
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 8,
                                                    ),
                                                backgroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                              child: const Text(
                                                "Verify",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                    : const SizedBox(),
                          ),

                          const SizedBox(height: 25),

                          const CustomTextWidget(tittle: 'Position'),
                          const SizedBox(height: 5),
                          CustomTextFormField(
                            controller: positionController,
                            keyboardType: TextInputType.text,
                            hintText: 'Position',
                            textInputAction: TextInputAction.done,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? "Required"
                                        : null,
                          ),
                          const SizedBox(height: 25),

                          Obx(() {
                            return Visibility(
                              visible: isPhoneVerified.value,
                              child: CustomButton(
                                title:
                                    isSubmitting.value
                                        ? "Submitting..."
                                        : "Submit",
                                onTap: () async {
                                  if (isSubmitting.value) return;

                                  if (formKey.currentState?.validate() ??
                                      false) {
                                    isSubmitting.value = true;

                                    try {
                                      String? imageUrl;

                                      // ✅ Show loading spinner
                                      Get.dialog(
                                        const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        barrierDismissible: false,
                                      );

                                      // ✅ Upload image using helper
                                      final imagePath =
                                          _pickerController.imagePath.value;
                                      if (imagePath.isNotEmpty &&
                                          File(imagePath).existsSync()) {
                                        final imageFile = File(imagePath);
                                        imageUrl =
                                            await FirebaseStorageHelper.uploadProfileImage(
                                              imageFile,
                                            );
                                      }

                                      // ✅ Prepare Firestore user profile data
                                      final userProfile = {
                                        "firstName":
                                            firstNameController.text
                                                .trim()
                                                .capitalizeFirst,
                                        "lastName":
                                            lastNameController.text
                                                .trim()
                                                .capitalizeFirst,
                                        "dob": dobController.text.trim(),
                                        "phone":
                                            phoneNumberController.text.trim(),
                                        "position":
                                            positionController.text.trim(),
                                        "isPhoneVerified": true,
                                        if (imageUrl != null)
                                          "profileImageUrl": imageUrl,
                                      };

                                      final success = await DataBaseMethods()
                                          .createUser(userProfile);

                                      if (!mounted) return;

                                      // ✅ Close spinner dialog
                                      if (Get.isDialogOpen ?? false) Get.back();

                                      if (success) {
                                        // ✅ Better feedback UI
                                        Get.snackbar(
                                          "🎉 Welcome ${firstNameController.text.trim().capitalizeFirst}!",
                                          "Your profile has been successfully created!",

                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.TOP,
                                        );
                                        Get.offAllNamed(
                                          AppRoutes.customBottomNavBar,
                                        );
                                      } else {
                                        Get.snackbar(
                                          "❌ Error",
                                          "Failed to save profile",
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }
                                    } catch (e) {
                                      if (Get.isDialogOpen ?? false) Get.back();
                                      Get.snackbar(
                                        "⚠️ Error",
                                        "Something went wrong: ${e.toString()}",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        snackPosition: SnackPosition.BOTTOM,
                                      );
                                    } finally {
                                      isSubmitting.value = false;
                                    }
                                  }
                                },
                              ),
                            );
                          }),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomTextWidget extends StatelessWidget {
  const CustomTextWidget({super.key, required this.tittle});
  final String tittle;

  @override
  Widget build(BuildContext context) {
    return Text(
      tittle,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
