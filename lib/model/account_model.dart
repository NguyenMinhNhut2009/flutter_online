import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountModel {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  AccountModel(
      {required this.prefs,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  String? getPrefs(String key) {
    return prefs.getString(key);
  }

  Future<bool> setPrefs(String key, String value) async {
    return await prefs.setString(key, value);
  }

  UploadTask uploadTask(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDetailFirestore(
      String collectionPath, String path, Map<String, String> DataneedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(path)
        .update(DataneedUpdate);
  }
}
