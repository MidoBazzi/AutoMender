// ignore_for_file: file_names

class User {
  Data data;
  String message;

  User({
    required this.data,
    required this.message,
  });
}

class Data {
  String name;
  String email;
  String phoneNum;
  int id;

  Data({
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.id,
  });
}
