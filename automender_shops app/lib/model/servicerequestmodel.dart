// ignore_for_file: non_constant_identifier_names

class ServiceRequest {
  String name;
  String desc;
  String price;
  String time_req;

  ServiceRequest({
    required this.name,
    required this.desc,
    required this.price,
    required this.time_req,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,  
      'desc': desc,  
      'price': price,       
      'time_req': time_req, 
    };
  }
}
