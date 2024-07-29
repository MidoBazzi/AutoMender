import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:automender_shops/crud/checkinternet.dart';
import 'package:automender_shops/crud/statusrequest.dart';
import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final AuthController authController = Get.find<AuthController>();

class Crud {
  Future<Either<StatusRequest, Map>> getData(String linkurl, Map data) async {
      try {
      if (await checkInternet()) {
    var  response = await http.get(Uri.parse(linkurl), headers: 
       {"Accept":"application/json",
      "Authorization" :'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgwMDAvYXBpL2F1dGhfc2hvcC9sb2dpbiIsImlhdCI6MTcwNTU5MTk2NCwiZXhwIjoxNzA2MTk2NzY0LCJuYmYiOjE3MDU1OTE5NjQsImp0aSI6IlUzV0t0NXVvdmVSdkdkbUQiLCJzdWIiOiI0MCIsInBydiI6IjMyZGMwZmExMjZhOWMzNzVkNjJmMTIyZDgzOGMyZjQ4YTJkMGYwMDIifQ.8OnKVj_UWzPr8Z-oABT7xhIPXexvl8Ba6iTd_h4nOwU'
      }
      
    );
  
        if (response.statusCode == 200) {
          Map responsebody = jsonDecode(response.body);
          return Right(responsebody);
        } else {
          return const Left(StatusRequest.serverfailure);
        }
      } else {
        return const Left(StatusRequest.offlinefailure);
      }
    } catch (_) {
      return const Left(StatusRequest.serverExeption);
    }
  }
}