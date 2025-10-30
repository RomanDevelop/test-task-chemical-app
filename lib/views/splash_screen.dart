import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../constants/ui_constants.dart';

class SplashScreen extends StatefulWidget {
  final Widget next;
  const SplashScreen({super.key, required this.next});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(UIConstants.splashDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => widget.next));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(UIConstants.splashLottiePath, width: 240, height: 240, fit: BoxFit.contain, repeat: true),
      ),
    );
  }
}
