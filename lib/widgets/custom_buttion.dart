import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.gradientColors,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.radius,
    this.icon,
    this.iconSpacing,
    this.border,
    this.shadow = true,
    this.padding,
    this.margin,
  });

  final String title;
  final VoidCallback onTap;

  // 🛠️ Customizations
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? textColor;
  final double? radius;
  final Widget? icon;
  final double? iconSpacing;
  final BoxBorder? border;
  final bool shadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: height ?? 50,
        width: width ?? double.infinity,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                gradientColors ?? const [Color(0xff0093E9), Color(0xff80D0C7)],
          ),
          borderRadius: BorderRadius.circular(radius ?? 8),
          border: border,
          boxShadow:
              shadow
                  ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon!,
              if (icon != null)
                SizedBox(
                  width: iconSpacing ?? 8,
                ), // spacing between icon and text
              Text(
                title,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: fontSize ?? 26,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  fontFamily: "Poppins",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
