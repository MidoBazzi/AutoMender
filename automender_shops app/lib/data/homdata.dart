
// ignore_for_file: camel_case_types

import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/crud/crud.dart';

class home {
  Crud crud;

  home(this.crud);
  String? token;
 
  getData() async {
    var response = await crud.getData('${GlobalConfig.backendUrl}/auth_shop/register' ,{});
   return response.fold((l) => l, (r) => r);
  }
}