import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class TextLink extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextAlign textAlign;

  const TextLink({super.key, required this.text, this.onPressed, this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        textAlign: textAlign,
        style: const TextStyle(
          color: TextLinkTheme.color,
          fontSize: TextLinkTheme.fontSize,
          decoration: TextLinkTheme.decoration,
          decorationColor: TextLinkTheme.color,
        ),
      ),
    );
  }
}
