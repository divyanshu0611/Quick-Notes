import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:quick_notes/Controller/Auth_controller/firebase_auth_controller.dart';
import 'package:quick_notes/widgets/custom_buttion.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final otpController = TextEditingController();
  FirebaseAuthController firebaseAuthController = FirebaseAuthController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter OTP Code",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
            Text(
              "We've sent a 6-digit code to your\nPhone Number: +91 XXXXX 12345",

              style: Theme.of(context).textTheme.labelLarge,
            ),

            SizedBox(height: 25),
            Center(
              child: Pinput(
                controller: otpController,
                onCompleted: (pin) {},
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 50,
                  textStyle: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 22),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(
                      color:
                          (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: InkWell(
                onTap: () {},
                child: RichText(
                  text: TextSpan(
                    text: "Don't receive code? ",
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Resend Code",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 45),
            CustomButton(
              title: "Continue",
              onTap: () {
                final otp = otpController.text.trim();
                if (otp.length != 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Please enter a valid 6-digit code."),
                    ),
                  );
                  return;
                }
                firebaseAuthController.verifyOtpCode(otp);
              },
            ),
          ],
        ),
      ),
    );
  }
}
