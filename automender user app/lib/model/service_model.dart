class Service {
  String id;
  String name;
  String desc;
  String price;
  String timeReq;

  Service({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.timeReq,
  });

  factory Service.fromMap(Map<String, dynamic> map) {
    return Service(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      desc: map['desc'] ?? '',
      price: map['price']?.toString() ?? '',
      timeReq: map['time_req'] ?? '',
    );
  }
}
