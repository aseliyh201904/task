import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task/api/api_settings.dart';
import 'package:task/model/branch.dart';

class ApiBranchController {
  Future<List<Branch>> readBranch({String? query}) async {
    var url = Uri.parse(ApiSettings.branchUrl);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List;
      List<Branch> branch =
          jsonResponse.map((e) => Branch.fromJson(e)).toList();
      if (query != null) {
        branch = branch
            .where((element) => element.branchName
                .toLowerCase()
                .contains((query.toLowerCase())))
            .toList();
      }
      return branch;
    }
    return [];
  }
}
