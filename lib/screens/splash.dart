import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_online/model/auth_model.dart';
import 'package:flutter_online/screens/home.dart';
import 'package:flutter_online/screens/login.dart';
import 'package:flutter_online/screens/root_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  Timer startTime() {
    var _duration = const Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    AuthModel authModel = context.read<AuthModel>();
    bool isLoggedIn = await authModel.isLoggedIn();
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RootApp()),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/avatar.png",
              width: 200,
              height: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
