// ignore_for_file: file_names

class User {
  String name;
  String email;
  String phoneNum;

  User({
    required this.name,
    required this.email,
    required this.phoneNum,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNum: map['phone_num'] ?? '',
    );
  }
}
