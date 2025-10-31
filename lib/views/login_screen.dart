import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../models/auth_models.dart';
import '../constants/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_input_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/text_link.dart';
import '../widgets/social_login_button.dart';
import '../widgets/auth_separator.dart';
import 'lsi_calculator_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    final success = await authNotifier.login(_emailController.text.trim(), _passwordController.text);

    if (success && mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LSICalculatorScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.status == AuthStatus.initial;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/background.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: LoginScreenTheme.logoTopPadding),
                child: Center(child: AppLogo(height: LoginScreenTheme.logoHeight)),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: LoginScreenTheme.horizontalPadding,
                    right: LoginScreenTheme.horizontalPadding,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: LoginScreenTheme.topSpacingBeforeTitle),
                        Text(
                          'Login',
                          style: const TextStyle(
                            color: LoginScreenTheme.titleColor,
                            fontSize: LoginScreenTheme.titleFontSize,
                            fontWeight: LoginScreenTheme.titleFontWeight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: LoginScreenTheme.spacingAfterTitle),
                        AuthCard(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AuthInputField(
                                  controller: _emailController,
                                  label: 'Email*',
                                  validator: _validateEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  enabled: !isLoading,
                                  prefixIcon: const Icon(Icons.email),
                                ),
                                SizedBox(height: LoginScreenTheme.spacingBetweenInputs),
                                AuthInputField(
                                  controller: _passwordController,
                                  label: 'Password*',
                                  validator: _validatePassword,
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  textInputAction: TextInputAction.done,
                                  enabled: !isLoading,
                                  prefixIcon: const Icon(Icons.lock),
                                  onFieldSubmitted: (_) => _submit(),
                                ),
                                SizedBox(height: LoginScreenTheme.spacingBeforeForgotPassword),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextLink(
                                    text: 'Forgot Password?',
                                    onPressed: isLoading ? null : () {},
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                SizedBox(height: LoginScreenTheme.spacingBeforeSignInButton),
                                Center(
                                  child: PrimaryButton(
                                    text: 'Sign In',
                                    onPressed: isLoading ? null : _submit,
                                    isLoading: isLoading,
                                    trailing: const Icon(Icons.arrow_forward, color: AppTheme.black),
                                  ),
                                ),
                                SizedBox(height: 8),
                                const AuthSeparator(),
                                SizedBox(height: 8),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: LoginScreenTheme.horizontalPadding),
                                  child: SizedBox(
                                    width: SocialButtonTheme.groupWidth,
                                    height: SocialButtonTheme.groupHeight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SocialLoginButton(
                                          provider: SocialProvider.google,
                                          onPressed: isLoading ? null : () {},
                                        ),
                                        SizedBox(width: SocialButtonTheme.spacing),
                                        SocialLoginButton(
                                          provider: SocialProvider.apple,
                                          onPressed: isLoading ? null : () {},
                                        ),
                                        SizedBox(width: SocialButtonTheme.spacing),
                                        SocialLoginButton(
                                          provider: SocialProvider.facebook,
                                          onPressed: isLoading ? null : () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text.rich(
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: TextStyle(color: AppTheme.white, fontSize: TextLinkTheme.fontSize),
                                    children: [
                                      WidgetSpan(
                                        child: TextLink(text: 'Register here', onPressed: isLoading ? null : () {}),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 8),
                                Center(
                                  child: TextLink(text: 'Terms and Conditions', onPressed: isLoading ? null : () {}),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (authState.error != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: ErrorDisplayTheme.padding,
                            decoration: BoxDecoration(
                              color: AppTheme.withOpacity(
                                ErrorDisplayTheme.backgroundColor,
                                ErrorDisplayTheme.backgroundOpacity,
                              ),
                              borderRadius: BorderRadius.circular(ErrorDisplayTheme.borderRadius),
                              border: Border.all(color: ErrorDisplayTheme.borderColor, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: ErrorDisplayTheme.iconColor,
                                  size: ErrorDisplayTheme.iconSize,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authState.error!,
                                    style: const TextStyle(
                                      color: ErrorDisplayTheme.textColor,
                                      fontSize: ErrorDisplayTheme.fontSize,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
