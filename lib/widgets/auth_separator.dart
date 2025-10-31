import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class AuthSeparator extends StatelessWidget {
  final String text;

  const AuthSeparator({super.key, this.text = 'or'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppTheme.withOpacity(SeparatorTheme.lineColor, SeparatorTheme.lineOpacity),
            thickness: SeparatorTheme.thickness,
          ),
        ),
        Padding(
          padding: SeparatorTheme.textPadding,
          child: Text(
            text,
            style: TextStyle(
              color: AppTheme.withOpacity(SeparatorTheme.textColor, SeparatorTheme.textOpacity),
              fontSize: SeparatorTheme.fontSize,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppTheme.withOpacity(SeparatorTheme.lineColor, SeparatorTheme.lineOpacity),
            thickness: SeparatorTheme.thickness,
          ),
        ),
      ],
    );
  }
}
