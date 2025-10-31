import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryGreen = Color(0xFF65E647);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF0000);

  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}

class AuthCardTheme {
  AuthCardTheme._();

  static const Color backgroundColor = AppTheme.black;
  static const Color borderColor = AppTheme.primaryGreen;
  static const double borderOpacity = 0.3;
  static const double borderRadius = 24.0;
  static const EdgeInsets defaultPadding = EdgeInsets.all(24);
  static const double width = 343.0;
  static const double height = 394.0;
}

class InputFieldTheme {
  InputFieldTheme._();

  static const Color textColor = AppTheme.white;
  static const Color labelColor = AppTheme.white;
  static const double labelOpacity = 0.7;
  static const Color iconColor = AppTheme.white;
  static const double iconOpacity = 0.7;
  static const Color fillColor = Color(0xFF666666);
  static const Color enabledBorderColor = Color(0xFF666666);
  static const double enabledBorderOpacity = 1.0;
  static const double borderWidth = 1.0;
  static const Color focusedBorderColor = AppTheme.primaryGreen;
  static const double focusedBorderWidth = 1.0;
  static const Color errorBorderColor = AppTheme.red;
  static const double errorBorderWidth = 1.0;
  static const Color errorTextColor = AppTheme.red;
  static const double borderRadius = 90.0;
  static const double width = 303.0;
  static const double height = 45.0;
  static const EdgeInsets contentPadding = EdgeInsets.only(top: 16, right: 30, bottom: 16, left: 20);
  static const double spacingBetweenFields = 10.0;
}

class PrimaryButtonTheme {
  PrimaryButtonTheme._();

  static const Color backgroundColor = AppTheme.primaryGreen;
  static const Color foregroundColor = AppTheme.black;
  static const Color loadingIndicatorColor = AppTheme.white;
  static const double borderRadius = 70.0;
  static const double width = 126.0;
  static const double height = 45.0;
  static const double loadingIndicatorSize = 24.0;
  static const double fontSize = 16.0;
  static const FontWeight fontWeight = FontWeight.w700;
  static const String fontFamily = 'Space Mono';
  static const double lineHeight = 1.0;
  static const double letterSpacing = 0.0;
  static const double elevation = 0.0;
  static const EdgeInsets padding = EdgeInsets.only(top: 16, right: 20, bottom: 16, left: 20);
}

class TextLinkTheme {
  TextLinkTheme._();

  static const Color color = AppTheme.primaryGreen;
  static const double fontSize = 14.0;
  static const TextDecoration decoration = TextDecoration.underline;
}

class SeparatorTheme {
  SeparatorTheme._();

  static const Color lineColor = AppTheme.white;
  static const double lineOpacity = 0.3;
  static const Color textColor = AppTheme.white;
  static const double textOpacity = 0.7;
  static const double fontSize = 14.0;
  static const double thickness = 1.0;
  static const EdgeInsets textPadding = EdgeInsets.symmetric(horizontal: 16);
}

class SocialButtonTheme {
  SocialButtonTheme._();

  static const Color backgroundColor = Color.fromARGB(255, 28, 26, 26);
  static const Color shadowColor = AppTheme.black;
  static const double shadowOpacity = 0.1;
  static const double shadowBlurRadius = 8.0;
  static const Offset shadowOffset = Offset(0, 2);
  static const double size = 40.0;
  static const double iconSize = 24.0;
  static const double borderRadius = 50.0;
  static const double groupWidth = 140.0;
  static const double groupHeight = 40.0;
  static const double spacing = 10.0;
}

class LoginScreenTheme {
  LoginScreenTheme._();

  static const Color titleColor = AppTheme.white;
  static const double titleFontSize = 32.0;
  static const FontWeight titleFontWeight = FontWeight.bold;
  static const double logoTopPadding = 0.0;
  static const double logoHeight = 30.0;
  static const double horizontalPadding = 25.0;
  static const double topSpacingBeforeTitle = 130.0;
  static const double spacingAfterTitle = 8.0;
  static const double spacingBetweenInputs = 10.0;
  static const double spacingBeforeForgotPassword = 16.0;
  static const double spacingBeforeSignInButton = 24.0;
  static const double signInButtonTop = 439.0;
  static const double signInButtonLeft = 134.0;
  static const double spacingAfterCard = 24.0;
  static const double spacingAfterSeparator = 24.0;
  static const double spacingBeforeRegisterText = 32.0;
  static const double spacingBeforeTerms = 16.0;
  static const double socialButtonSpacing = 10.0;
  static const double socialButtonsGroupTop = 532.0;
  static const double socialButtonsGroupLeft = 127.0;
}

class ErrorDisplayTheme {
  ErrorDisplayTheme._();

  static const Color backgroundColor = AppTheme.red;
  static const double backgroundOpacity = 0.2;
  static const Color borderColor = AppTheme.red;
  static const Color textColor = AppTheme.red;
  static const Color iconColor = AppTheme.red;
  static const double iconSize = 20.0;
  static const double fontSize = 14.0;
  static const double borderRadius = 12.0;
  static const EdgeInsets padding = EdgeInsets.all(12);
}
