import 'package:flutter/material.dart';
import 'package:flutter_online/screens/home.dart';
import 'package:flutter_online/screens/root_app.dart';
import 'package:flutter_online/utils/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: " Sign in cancel");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      default:
        break;
    }
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          bool isSuccess = await authProvider.handleSignIn();
          if (isSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RootApp()),
            );
          }
        },
        child: Center(
          child: Image.asset(
            "assets/icons/ic_google.png",
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }
}