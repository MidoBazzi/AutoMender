

import 'package:automender_shops/crud/statusrequest.dart';

handlingData(response) {
  if (response is StatusRequest) {
    return response; 
  } else {
    return StatusRequest.success;
  }
}