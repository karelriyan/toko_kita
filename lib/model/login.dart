class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login(this.code, this.status, this.token, this.userID, this.userEmail);

  factory Login.fromJson(Map<String, dynamic> obj) {
    if (obj['code'] == 200) {
      return Login(
        obj['code'],
        obj['status'],
        obj['data']['token'],
        int.parse(obj['data']['user']['id']),
        obj['data']['user']['email'],
      );
    } else {
      return Login(obj['code'], obj['status'], null, null, null);
    }
  }
}
