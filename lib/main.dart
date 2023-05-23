import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online/model/account_model.dart';
import 'package:flutter_online/model/auth_model.dart';
import 'package:flutter_online/screens/login.dart';
import 'package:flutter_online/screens/splash.dart';
import 'package:flutter_online/theme/color.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({required this.prefs});

  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthModel(
                firebaseAuth: FirebaseAuth.instance,
                firebaseFirestore: firebaseFirestore,
                googleSignIn: GoogleSignIn(),
                prefs: prefs)),
        Provider<AccountModel>(
            create: (_) => AccountModel(
                prefs: prefs,
                firebaseFirestore: firebaseFirestore,
                firebaseStorage: firebaseStorage))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Online Course App',
        theme: ThemeData(
          primaryColor: primary,
        ),
        home: const Splashscreen(),
      ),
    );
  }
}
