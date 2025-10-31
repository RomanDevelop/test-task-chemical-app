import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

enum SocialProvider { google, apple, facebook }

class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;

  const SocialLoginButton({super.key, required this.provider, this.onPressed});

  @override
  Widget build(BuildContext context) {
    String imagePath;
    switch (provider) {
      case SocialProvider.google:
        imagePath = 'assets/icons/google.png';
        break;
      case SocialProvider.apple:
        imagePath = 'assets/icons/apple.png';
        break;
      case SocialProvider.facebook:
        imagePath = 'assets/icons/facebook.png';
        break;
    }

    final icon = Image.asset(
      imagePath,
      width: SocialButtonTheme.iconSize,
      height: SocialButtonTheme.iconSize,
      fit: BoxFit.contain,
    );

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(SocialButtonTheme.borderRadius),
      child: Container(
        width: SocialButtonTheme.size,
        height: SocialButtonTheme.size,
        decoration: BoxDecoration(
          color: SocialButtonTheme.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.withOpacity(SocialButtonTheme.shadowColor, SocialButtonTheme.shadowOpacity),
              blurRadius: SocialButtonTheme.shadowBlurRadius,
              offset: SocialButtonTheme.shadowOffset,
            ),
          ],
        ),
        child: Center(child: icon),
      ),
    );
  }
}
