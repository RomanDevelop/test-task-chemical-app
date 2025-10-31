import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class AuthCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AuthCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AuthCardTheme.width,
      constraints: BoxConstraints(maxHeight: AuthCardTheme.height, minHeight: 0),
      decoration: BoxDecoration(
        color: AuthCardTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AuthCardTheme.borderRadius),
        border: Border.all(
          color: AppTheme.withOpacity(AuthCardTheme.borderColor, AuthCardTheme.borderOpacity),
          width: 1,
        ),
      ),
      padding: padding ?? AuthCardTheme.defaultPadding,
      child: child,
    );
  }
}
