// ignore_for_file: file_names

class Shop {
  String id;
  String email;
  String ownerName;
  String shopName;
  String location;
  String locationX;
  String locationY;
  String openTime;
  String closeTime;
  String schedule;
  String phoneNum;
  String picture;
  String capacity;

  Shop({
    required this.id,
    required this.email,
    required this.ownerName,
    required this.shopName,
    required this.location,
    required this.locationX,
    required this.locationY,
    required this.openTime,
    required this.closeTime,
    required this.schedule,
    required this.phoneNum,
    required this.picture,
    required this.capacity,
  });

  factory Shop.fromMap(Map<String, dynamic> map) {
    return Shop(
      id: map['id']?.toString() ?? '',
      email: map['email'] ?? '',
      ownerName: map['owner_name'] ?? '',
      shopName: map['shop_name'] ?? '',
      location: map['location'] ?? '',
      locationX: map['location_x']?.toString() ?? '',
      locationY: map['location_y']?.toString() ?? '',
      openTime: map['open_time']?.toString() ?? '',
      closeTime: map['close_time']?.toString() ?? '',
      schedule: map['schedule'] ?? '',
      phoneNum: map['phone_num'] ?? '',
      picture: map['picture'] ?? '',
      capacity: map['capacity']?.toString() ?? '',
    );
  }
}
