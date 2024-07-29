class Car2 {
  int id;
  String countryName;
  String carModelName;
  String brandName;
  String governorate;
  int currMialage;
  int nextMialage;
  int plateNum;
  String color;

  Car2({
    required this.id,
    required this.countryName,
    required this.carModelName,
    required this.brandName,
    required this.governorate,
    required this.currMialage,
    required this.nextMialage,
    required this.plateNum,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'country_name': countryName,
      'car_model_name': carModelName,
      'brand_name': brandName,
      'curr_mialage': currMialage,
      'next_mialage': nextMialage,
      'plate_num': plateNum,
      'color': color,
      'governorate': governorate,
    };
  }

  factory Car2.fromMap(Map<String, dynamic> map) {
    return Car2(
      id: map['id'] ?? 1,
      countryName: map['country_name'] ?? '',
      carModelName: map['car_model_name'] ?? '',
      brandName: map['brand_name'] ?? '',
      governorate: map['governorate'] ?? '',
      currMialage: map['curr_mialage'] ?? 0,
      nextMialage: map['next_mialage'] ?? 0,
      plateNum: map['plate_num'] ?? 0,
      color: map['color'] ?? '',
    );
  }
}
