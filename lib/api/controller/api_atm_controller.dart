import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:task/api/api_settings.dart';
import 'package:task/model/atms.dart';

class ApiATMsController {
  Future<List<ATMs>> readATMS({String? query}) async {
    var url = Uri.parse(ApiSettings.atmUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      List<ATMs> atms = jsonResponse.map((e) => ATMs.fromJson(e)).toList();
      if (query != null) {
        atms = atms
            .where((element) =>
                element.atmName.toLowerCase().contains((query.toLowerCase())))
            .toList();
      }
      return atms;
    }
    return [];
  }
}
