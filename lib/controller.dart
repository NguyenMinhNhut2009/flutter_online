// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:online/utils/userDetailsModel.dart';

// class ControllerLogin with ChangeNotifier {
//   var ggSigin = GoogleSignIn();
//   GoogleSignInAccount? googleSignInAccount;
//   UserDetailsModel? userDetailsModel;

//   allowUserLogin() async {
//     this.googleSignInAccount = await ggSigin.signIn();

//     this.userDetailsModel = await UserDetailsModel(
//         displayName: this.googleSignInAccount!.displayName,
//         email: this.googleSignInAccount!.email,
//         photoUrl: googleSignInAccount!.photoUrl);
//   }

//   notifyListeners();
// }
