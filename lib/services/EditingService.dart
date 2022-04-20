import 'dart:developer';

import 'package:ka_planner/objects/Text.dart';

import '../constants/ServerInfo.dart';
import 'LoginService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditingService {
  static String selectedText = "0";

  Future<void> edit({required String id}) async {
    
  }

  static Future<bool> setNewEditingUser({required String id}) async {
    // Get current username
    String token = await LoginService.getToken();
    String username =  token.split("@")[1];

    http.Response response;

    try {
      response = await http.post(
        Uri.parse('${ServerInfo.url}text/editing?token=$token&id=$id')
      ).timeout(ServerInfo.globalTimeout);
    } catch (e) {
      // Check if token expired
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      throw Exception('An error occured!');
    }
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 403) {
      return false;
    } else if (response.statusCode == 401) {
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      throw Exception('Error 401');
    } else if (response.statusCode != 200) {
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      throw Exception('Error ${response.statusCode.toString()}');
    } else {
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      throw Exception('An error occured!');
    }
  }

  static Future<bool> submitChanges({required String title, required String content, required String id}) async {

    String token = await LoginService.getToken();

    Text prepText = Text(
      name: title,
      content: content,
      id: id,
      dateOfCreation: "",
      dateOfEditing: "",
    );

    String prepJsonString = jsonEncode(prepText.toJson());

    http.Response response;

    try {
      response = await http.put(
        Uri.parse('${ServerInfo.url}text?token=$token&content=$prepJsonString')
      ).timeout(ServerInfo.globalTimeout);
    } catch (e) {
      // Check if token expired
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      throw Exception('An error occured!');
    }
    if (response.statusCode == 200) {
      log(response.body);
      return true;
    } else if (response.statusCode == 403) {
      return false;
    } else if (response.statusCode == 401) {
      LoginService().onTokeExpired(isHomePage: false, isLoginPage: false);
      throw Exception('Error 401');
    } else if (response.statusCode != 200) {
      LoginService().onTokeExpired(isHomePage: false, isLoginPage: false);
      throw Exception('Error ${response.statusCode.toString()}');
    } else {
      LoginService().onTokeExpired(isHomePage: false, isLoginPage: false);
      throw Exception('An error occured!');
    }
  }
}