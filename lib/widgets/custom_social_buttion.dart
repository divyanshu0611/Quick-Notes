import 'package:flutter/material.dart';

class CustomSocialButtion extends StatelessWidget {
  const CustomSocialButtion({
    super.key,
    required this.tittleText,
    required this.imagePath,
    required this.onTap,
  });

  final String tittleText;
  final String imagePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.symmetric(horizontal: 50),
          height: 45,
          // width: 250,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath, width: 30, height: 30),
              SizedBox(width: 5),
              Text(
                tittleText,

                style: TextStyle(fontSize: 18, fontFamily: "Poppins"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
