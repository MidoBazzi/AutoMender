class Services {
    List<Service> services;

    Services({
        required this.services,
        
    });

}

class Service {
    int id;
    String name;
    String desc;
    int price;
    String timeReq;

    Service({
        required this.id,
        required this.name,
        required this.desc,
        required this.price,
        required this.timeReq,
    });



     factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: json['price'],
      timeReq: json['time_req'],
    );
  }

}
