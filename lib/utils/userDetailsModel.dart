class UserDetailsModel {
  String? displayName;
  String? email;
  String? photoUrl;

  UserDetailsModel({this.photoUrl, this.displayName, this.email});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    displayName = json["displayName"];
    email = json["email"];
    photoUrl = json["photoUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> mapData = new Map<String, dynamic>();

    mapData["displayName"] = this.displayName;
    mapData["email"] = this.email;
    mapData["photoUrl"] = this.photoUrl;
    return mapData;
  }
}
