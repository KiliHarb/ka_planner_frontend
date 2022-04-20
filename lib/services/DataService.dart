import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:ka_planner/constants/ServerInfo.dart';
import 'package:ka_planner/objects/Text.dart';
import 'package:ka_planner/services/LoginService.dart';
import 'dart:convert';

class DataService {

  static String _availableTextIds = '';
  static List<Text> collectedTextObjects = [];

  static Future<void> collectLatestData() async {

    http.Response response;

    collectedTextObjects.clear();

    // Collect all available text ids
    try {
      response = await http.get(
        Uri.parse('${ServerInfo.url}text/allids?token=${LoginService.getToken()}')
      ).timeout(ServerInfo.globalTimeout);
    } catch (e) {
      // Check if token expired
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      return;
    }
    if (response.statusCode == 401) {
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      return;
    } else if (response.statusCode != 200) {
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      return;
    }
    _availableTextIds = response.body;

    // Collect all available text objects by sending the received text ids
    for (var i = 0; i < _availableTextIds.split(';').length-1; i++) {
      String currentId = _availableTextIds.split(';')[i];
      String jsonString = await getTextById(currentId);
      Map<String, dynamic> textAsJsonString = json.decode(jsonString);
      Text text = Text(
        id: textAsJsonString["id"].toString(), 
        name: textAsJsonString["name"].toString(), 
        content: textAsJsonString["content"].toString(), 
        dateOfCreation: textAsJsonString["dateOfCreation"].toString(), 
        dateOfEditing: textAsJsonString["editingDate"].toString()
      );
      collectedTextObjects.add(text);
    }

  }

  // Get Text Objext by String id from the Server
  static Future<String> getTextById(String id) async {
    http.Response response;

    try {
      response = await http.get(
        Uri.parse('${ServerInfo.url}text?token=${LoginService.getToken()}&id=$id')
      ).timeout(ServerInfo.globalTimeout);
    } catch (e) {
      throw Exception('Something went wrong!');
    }

    if (response.statusCode == 200) {
      return response.body;
    } else {
      log(response.body);
      throw Exception('Something went wrong!');
    }
  }

  // Returns true if a different user is editing this Text
  static Future<bool> isDifferentUserEditing({required String id}) async {
    http.Response response;
    String token = LoginService.getToken();
    try {
      response = await http.get(
        Uri.parse('${ServerInfo.url}text/editing?token=$token&id=$id')
      ).timeout(ServerInfo.globalTimeout);
    } catch (e) {
      // Check if token expired
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      return true;
    }
    if (response.statusCode == 401) {
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      return true;
    } else if (response.statusCode != 200) {
      LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
      return true;
    }

    if (token.split("@")[1].toLowerCase() == response.body.toLowerCase() || response.body == "") {
      return false;
    } else {
      return true;
    }
  }

}