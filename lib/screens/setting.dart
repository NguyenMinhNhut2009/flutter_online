import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online/model/account_model.dart';
import 'package:flutter_online/screens/root_app.dart';
import 'package:flutter_online/utils/firestore_constant.dart';
import 'package:flutter_online/utils/user_chat.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController _controller = TextEditingController();
  TextEditingController? nickNameEditing;
  TextEditingController? aboutMeEditing;

  String id = '';
  String nickname = '';
  String aboutMe = '';
  String photoUrl = '';
  String phoneNumber = '';

  bool isLoading = false;
  File? avatar;
  late AccountModel accountModel;

  final FocusNode focusNodeNickName = FocusNode();
  final FocusNode focusNodeAboutMe = FocusNode();

  @override
  void initState() {
    super.initState();
    accountModel = context.read<AccountModel>();
    readLocal();
  }

  void readLocal() {
    setState(() {
      id = accountModel.getPrefs(FirestoreConstants.id) ?? "";
      nickname = accountModel.getPrefs(FirestoreConstants.nickname) ?? "";
      aboutMe = accountModel.getPrefs(FirestoreConstants.aboutMe) ?? "";
      photoUrl = accountModel.getPrefs(FirestoreConstants.photoUrl) ?? "";
      phoneNumber = accountModel.getPrefs(FirestoreConstants.phoneNumber) ?? "";
    });

    nickNameEditing = TextEditingController(text: nickname);
    aboutMeEditing = TextEditingController(text: aboutMe);
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile? pickedFile = await imagePicker
        // ignore: deprecated_member_use
        .getImage(source: ImageSource.gallery)
        .catchError((err) {
      Fluttertoast.showToast(msg: err.toString());
    });

    File? image;

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avatar = image;
        isLoading = true;
      });

      upLoadFile();
    }
  }

  Future upLoadFile() async {
    String fileName = id;
    UploadTask uploadTask = accountModel.uploadTask(avatar!, fileName);

    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();

      UserChat updateinfo = UserChat(
          aboutMe: aboutMe,
          id: id,
          nickname: nickname,
          phoneNumber: phoneNumber,
          photoUrl: photoUrl);
      accountModel
          .updateDetailFirestore(
              FirestoreConstants.pathUserCollection, id, updateinfo.toJson())
          .then((data) async {
        await accountModel.setPrefs(FirestoreConstants.photoUrl, photoUrl);

        setState(() {
          isLoading = false;
        });
      }).catchError((err) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: err.toString());
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void handleUpdate() {
    focusNodeAboutMe.unfocus();
    focusNodeNickName.unfocus();
    setState(() {
      isLoading = true;
    });

    UserChat update = UserChat(
        aboutMe: aboutMe,
        id: id,
        nickname: nickname,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl);

    accountModel
        .updateDetailFirestore(
            FirestoreConstants.pathUserCollection, id, update.toJson())
        .then((data) async {
      await accountModel.setPrefs(FirestoreConstants.nickname, nickname);
      await accountModel.setPrefs(FirestoreConstants.aboutMe, aboutMe);
      await accountModel.setPrefs(FirestoreConstants.phoneNumber, phoneNumber);
      await accountModel.setPrefs(FirestoreConstants.photoUrl, photoUrl);

      setState(() {
        isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RootApp()));
      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CupertinoButton(
                  // ignore: sort_child_properties_last
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: avatar == null
                        ? photoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(45),
                                child: Image.network(
                                  photoUrl,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.account_circle,
                                      size: 90,
                                      color: Colors.grey,
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.grey,
                                        value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null &&
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      )),
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.account_circle,
                                size: 90,
                                color: Colors.grey,
                              )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Image.file(
                              avatar!,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  onPressed: getImage),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      "Name",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(primaryColor: Colors.grey),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Write your nickName",
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: nickNameEditing,
                        onChanged: (value) {
                          nickname = value;
                        },
                        focusNode: focusNodeNickName,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "About Me",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(primaryColor: Colors.grey),
                      child: TextField(
                        style: TextStyle(color: Colors.grey),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: "Write something about yourself",
                          contentPadding: EdgeInsets.all(5),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: aboutMeEditing,
                        onChanged: (value) {
                          aboutMe = value;
                        },
                        focusNode: focusNodeAboutMe,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 50,
                        bottom: 50,
                      ),
                      child: TextButton(
                        onPressed: handleUpdate,
                        child: const Text(
                          "Update now",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.grey),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ]),
          ),
          Positioned(
              child: isLoading
                  ? Container(
                      color: Colors.black87,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : const SizedBox.shrink())
        ],
      ),
    );
  }
}
