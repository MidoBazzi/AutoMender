// ignore_for_file: camel_case_types

import 'dart:io';

class placelocation {
  final double latitude;
  final double longitude;
  final String address;

  const placelocation(
      {required this.latitude, required this.longitude, required this.address});
}

class place {
  final String id;
  final String title;
  final File image;
  final placelocation location;

  place(
      {required this.location,
      required this.id,
      required this.title,
      required this.image});
}
