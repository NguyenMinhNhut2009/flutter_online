import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_online/model/auth_model.dart';
import 'package:flutter_online/screens/home.dart';
import 'package:flutter_online/screens/root_app.dart';
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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  late String email;
  late String password;
  bool _showPassword = true;
  bool _isVaild = false;
  final bool _isEmailValid = false;
  bool _isPassValid = false;
  GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  void _checkEmailPassword() {
    setState(() {
      _isVaild = _isEmailValid && _isPassValid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController;
    passController;
  }

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context);

    switch (authModel.status) {
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                'assets/icons/chat_app.jpg',
                width: 200,
                height: 200,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  style: const TextStyle(
                      // fontSize: AppSizes.textFontSize,
                      fontWeight: FontWeight.w400,
                      // letterSpacing: 6,
                      fontFamily: 'Helvetica'),
                  controller: emailController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập email';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    errorStyle: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w200),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xffEEEEEE))),
                    // focusedBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.all(Radius.circular(10)),
                    //     borderSide: BorderSide(color: AppColors.primaryColor)),
                    focusColor: Colors.white,
                    hintText: 'Vui lòng nhập email',
                    hintStyle: TextStyle(
                      // fontSize: AppSizes.hintTextFontSize,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Helvetica',
                      color: Color(0xff9B9B9B),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      email = text;
                    });
                  },
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, fontFamily: 'Helvetica'),
                  controller: passController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    } else if (value.length < 8) {
                      return "Không được ít hơn 8 ký tự";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 16),
                    errorStyle: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.w200),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Color(0xffEEEEEE))),
                    focusColor: Colors.white,
                    hintText: 'Vui lòng nhập mật khẩu',
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          });
                        },
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20,
                          color: Colors.grey,
                        )),
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Color(0xff9B9B9B),
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {
                      password = text;
                      _isPassValid = password.isNotEmpty;
                      _checkEmailPassword();
                    });
                  },
                  obscureText: _showPassword,
                  keyboardType: TextInputType.text,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 0,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email, password: password);
                      print(credential);
                      if (credential != null) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => RootApp()));
                      }
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        Fluttertoast.showToast(
                            msg: 'No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        Fluttertoast.showToast(
                            msg: 'Wrong password provided for that user.');
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    // primary: AppColors.primaryColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Đăng Nhập',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Đăng nhập nhanh với:"),
              SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: GestureDetector(
                  onTap: () async {
                    bool isSuccess = await authModel.handleSignIn();
                    if (isSuccess) {
                      print(isSuccess);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RootApp()),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/ic_google.png",
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text("Login with Google"),
                    ],
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
