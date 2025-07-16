
// 🏷️ Label widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelTextWidget extends StatelessWidget {
  const LabelTextWidget({
    super.key,
    required this.labelStyle,
    required this.text,
  });

  final TextStyle labelStyle;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: 5.h),
    child: Text(text, style: labelStyle),
  );
}