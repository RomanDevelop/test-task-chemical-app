import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double? height;
  final bool showText;

  const AppLogo({super.key, this.height, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icons/icon_logo.png',
          height: height ?? 30,
          fit: BoxFit.contain,
          semanticLabel: 'Aquaticus Icon',
        ),
      ],
    );
  }
}
