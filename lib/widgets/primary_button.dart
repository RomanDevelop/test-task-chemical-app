import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? trailing;

  const PrimaryButton({super.key, required this.text, this.onPressed, this.isLoading = false, this.trailing});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: PrimaryButtonTheme.width,
      height: PrimaryButtonTheme.height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: PrimaryButtonTheme.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PrimaryButtonTheme.borderRadius)),
          elevation: PrimaryButtonTheme.elevation,
          padding: PrimaryButtonTheme.padding,
        ),
        child:
            isLoading
                ? SizedBox(
                  height: PrimaryButtonTheme.loadingIndicatorSize,
                  width: PrimaryButtonTheme.loadingIndicatorSize,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(PrimaryButtonTheme.loadingIndicatorColor),
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontFamily: PrimaryButtonTheme.fontFamily,
                        fontSize: PrimaryButtonTheme.fontSize,
                        fontWeight: PrimaryButtonTheme.fontWeight,
                        color: PrimaryButtonTheme.foregroundColor,
                        height: PrimaryButtonTheme.lineHeight,
                        letterSpacing: PrimaryButtonTheme.letterSpacing,
                      ),
                    ),
                    if (trailing != null) ...[const SizedBox(width: 8), trailing!],
                  ],
                ),
      ),
    );
  }
}
