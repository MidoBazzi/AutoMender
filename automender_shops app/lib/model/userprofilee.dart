class UserProfile {
  String email;
  String ownerName;
  String shopName;
  String location;
  String locationX;
  String locationY;
  int openTime;
  int closeTime;
  String schedule;
  String phoneNum;
  String picture;
  int capacity;

  UserProfile({
    required this.email,
    required this.ownerName,
    required this.shopName,
    required this.location,
    required this.locationX,
    required this.locationY,
    required this.openTime,
    required this.closeTime,
    required this.schedule,
  required  this.phoneNum,
  required  this.picture,
   required this.capacity,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      
      email: json['email'],
      ownerName: json['owner_name'],
      shopName: json['shop_name'],
      location: json['location'],
      locationX: json['location_x'],
      locationY: json['location_y'],
      openTime: json['open_time'],
      closeTime: json['close_time'],
      schedule: json['schedule'],
      phoneNum: json['phone_num'],
      picture: json['picture'],
      capacity: json['capacity'],
    );
  }
}
