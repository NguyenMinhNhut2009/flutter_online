import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_online/utils/firestore_constant.dart';


class UserChat {
  String id;
  String aboutMe;
  String nickname;
  String photoUrl;
  String phoneNumber;

  UserChat(
      {required this.aboutMe,
      required this.id,
      required this.nickname,
      required this.phoneNumber,
      required this.photoUrl});

  Map<String, String> toJson() {
    return {
      FirestoreConstants.nickname: nickname,
      FirestoreConstants.aboutMe: aboutMe,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.phoneNumber: phoneNumber
    };
  }

  factory UserChat.fromDocument(DocumentSnapshot doc) {
    String nickname = "";
    String aboutMe = "";
    String photoUrl = "";
    String phoneNumber = "";

    try {
      aboutMe = doc.get(FirestoreConstants.aboutMe);
    } catch (e) {}
    try {
      nickname = doc.get(FirestoreConstants.nickname);
    } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      phoneNumber = doc.get(FirestoreConstants.phoneNumber);
    } catch (e) {}

    return UserChat(
      aboutMe: aboutMe,
      id: doc.id,
      nickname: nickname,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl,
    );
  }
}
