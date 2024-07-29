class Appointment {
  final int id;
  final String userName;
  final String date;
  final String startTime;
  final String endTime;
  final String serviceName;
  final String carModel;
  final int carYear;

  Appointment({
    required this.id,
    required this.userName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.serviceName,
    required this.carModel,
    required this.carYear,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      userName: json['user_name'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      serviceName: json['service_name'],
      carModel: json['car_model'],
      carYear: json['car_year'],
    );
  }
}
