// ignore_for_file: non_constant_identifier_names

class Appointments {
  String CarId;
  String date;
  String startTime;
  String ShopId;
  String serviceId;

  Appointments({
    required this.CarId,
    this.date = '',
    this.startTime = '',
    this.ShopId = '',
    this.serviceId = '',
  });
}
