// ignore_for_file: file_names

import 'dart:convert';
import 'package:automender/BackendUrl.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app_routes.dart';

class ExpertController extends GetxController {
  RxBool stop = false.obs;
  RxString currentAnswer = ''.obs;
  RxString currentQuestion = ''.obs;

  Future<void> startExpert() async {
    await http.get(Uri.parse(Expert.ExpertUrl));
    final initialResponse = await fetchExpertResponse();
    if (initialResponse != null) {
      currentQuestion.value = initialResponse['message'].first;
      currentAnswer.value = '';
      stop.value = initialResponse['Stop'];
    }
  }

  Future<void> sendAnswer(String answer) async {
    currentAnswer.value = answer;
    final response = await fetchExpertResponse(answer);
    if (response != null) {
      stop.value = response['Stop'];
      if (stop.value) {
        Get.offAllNamed(AppRoutes.exp_last, arguments: response);
      } else {
        currentQuestion.value = response['message'].first;
      }
    }
  }

  Future<Map<String, dynamic>?> fetchExpertResponse([String? answer]) async {
    final url = answer != null
        ? '${Expert.ExpertUrl}temp=$answer'
        : '${Expert.ExpertUrl}temp=';
    final httpResponse = await http.get(Uri.parse(url));

    if (httpResponse.statusCode == 200) {
      final responseJson = json.decode(httpResponse.body);
      return responseJson;
    } else {
      return null;
    }
  }
}
