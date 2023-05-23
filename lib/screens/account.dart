import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_online/model/account_model.dart';
import 'package:flutter_online/model/auth_model.dart';
import 'package:flutter_online/screens/login.dart';
import 'package:flutter_online/screens/setting.dart';
import 'package:flutter_online/theme/color.dart';
import 'package:flutter_online/utils/data.dart';
import 'package:flutter_online/utils/firestore_constant.dart';
import 'package:flutter_online/widget/custom_image.dart';
import 'package:flutter_online/widget/setting_box.dart';
import 'package:flutter_online/widget/setting_item.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late AccountModel accountModel;
  String nickname = "";
  String photoUrl = "";
  @override
  void initState() {
    super.initState();
    accountModel = context.read<AccountModel>();
    nickname = accountModel.getPrefs(FirestoreConstants.nickname) ?? "";
    photoUrl = accountModel.getPrefs(FirestoreConstants.photoUrl) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    AuthModel authModel = Provider.of<AuthModel>(context);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            backgroundColor: appBgColor,
            pinned: true,
            snap: true,
            floating: true,
            title: getHeader()),
        SliverToBoxAdapter(
          child: getBody(authModel),
        )
      ],
    );
  }

  getHeader() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Account",
            style: TextStyle(
                color: textColor, fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget getBody(AuthModel authModel) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Column(
            children: [
              CachedNetworkImage(
                width: 70,
                height: 70,
                imageUrl: photoUrl,
                placeholder: (context, url) => BlankImageWidget(),
                errorWidget: (context, url, error) => BlankImageWidget(),
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                nickname,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: SettingBox(
                  title: "12 courses",
                  icon: "assets/icons/work.svg",
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SettingBox(
                  title: "55 hours",
                  icon: "assets/icons/time.svg",
                )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: SettingBox(
                  title: "4.8",
                  icon: "assets/icons/star.svg",
                )),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Setting",
                leadingIcon: "assets/icons/setting.svg",
                bgIconColor: blue,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SettingScreen()));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Payment",
                leadingIcon: "assets/icons/wallet.svg",
                bgIconColor: green,
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Bookmark",
                leadingIcon: "assets/icons/bookmark.svg",
                bgIconColor: primary,
                onTap: () {},
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Notification",
                leadingIcon: "assets/icons/bell.svg",
                bgIconColor: purple,
                onTap: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(left: 45),
                child: Divider(
                  height: 0,
                  color: Colors.grey.withOpacity(0.8),
                ),
              ),
              SettingItem(
                title: "Privacy",
                leadingIcon: "assets/icons/shield.svg",
                bgIconColor: orange,
                onTap: () {},
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: cardColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Column(children: [
              SettingItem(
                title: "Log Out",
                leadingIcon: "assets/icons/logout.svg",
                bgIconColor: darker,
                onTap: () async {
                  authModel.handleSignOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => LoginScreen()));
                },
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
