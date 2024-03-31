class MyUser {
  String uid;
  String email;
  String name;
  String password;

  MyUser(
      {required this.uid,
      required this.email,
      required this.name,
      required this.password});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  factory MyUser.fromMap(Map<String, dynamic> map) {
    return MyUser(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      password: map['password'] ?? '',
    );
  }
}
