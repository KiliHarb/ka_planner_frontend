import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ka_planner/constants/ServerInfo.dart';
import 'package:ka_planner/navigation/RoutePaths.dart';

import '../main.dart';

class LoginService {

  // Custom Snackbar
  static SnackBar snackBar({required String content, int colorValue = 0}) {
    
    Color color = Colors.grey.shade800;

    switch (colorValue) {
      case 0:
        color = Colors.grey.shade800;
        break;
      case 1: 
        color = Colors.green.shade900;
        break;
      case 2:
        color = Colors.yellow.shade900;
        break;
      case 3:
        color = Colors.red.shade900;
        break;
      default:
        color = Colors.grey.shade800;
    }

    return SnackBar(
      content: Text(
        content
      ),
      backgroundColor: color
    );
  }

  Future validateLogin(String username, String password) async {

    http.Response response;

    BuildContext context = Routes.sailor.navigatorKey.currentContext!;
    
    await Future.delayed(const Duration(milliseconds: 500), (){});

    // Send username and password
    try {
      response = await http.post(
        Uri.parse('${ServerInfo.url}login/login?username=$username&password=$password')
      ).timeout(ServerInfo.globalTimeout);
    } catch (e) {
      Routes.sailor.pop();
      Routes.sailor.navigate(RoutePaths().Login);
      ScaffoldMessenger.of(context).showSnackBar(snackBar(content: 'Something went wrong! Check your internet connection!', colorValue: 3));
      throw Exception('Something went wrong!');
    }

    // Response Handling
    if (response.statusCode == 200) { // OK

      // Writes the received token on the disk
      GetStorage().write('token', response.body);

      Routes.sailor.pop();
      Routes.sailor.navigate(RoutePaths().Home);

      ScaffoldMessenger.of(context).showSnackBar(snackBar(content: 'Logged in as ${username.toLowerCase()}!', colorValue: 1));

    } else if (response.statusCode == 401) { // Invalid

      // Invalid username or password
      Routes.sailor.pop();
      Routes.sailor.navigate(RoutePaths().Login);
      ScaffoldMessenger.of(context).showSnackBar(snackBar(content: 'Username or password wrong!', colorValue: 3));

    } else {

      // Internal error
      Routes.sailor.pop();
      Routes.sailor.navigate(RoutePaths().Login);
      ScaffoldMessenger.of(context).showSnackBar(snackBar(content: 'Invalid login!', colorValue: 3));

    }
  }

  // Sends the token to the server - returns 'true' if the token is valid
  static Future<bool> loginWithToken() async {

    BuildContext context = Routes.sailor.navigatorKey.currentContext!;

    http.Response response;

    // Reads the token from the disk
    String? token = GetStorage().read('token');

    if (token != null) {

      try {

        // Send Token
        response = await http.get(
          Uri.parse('${ServerInfo.url}login/token?token=$token')
        ).timeout(ServerInfo.globalTimeout);

      } catch (e) {

        // Error
        ScaffoldMessenger.of(context).showSnackBar(snackBar(content: 'Cannot connect to the server!', colorValue: 3));
        throw Exception('Something went wrong!');

      }
      
    } else {
      return false;
    }

    // Status Code Response Handling
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 401) {
      return false;
    } else {
      return false;
    }

  }

  Future<void> onTokeExpired({bool isHomePage = true, bool isLoginPage = false}) async {

    BuildContext context = Routes.sailor.navigatorKey.currentContext!;

    if (await LoginService.loginWithToken()) {

      // Login token detected
      ScaffoldMessenger.of(context).showSnackBar(snackBar(content: 'Valid login token detected!', colorValue: 1));
      if (!isHomePage) {
        Routes.sailor.pop();
        Routes.sailor.navigate(RoutePaths().Home);
      }

    } else {

      // No login token detected
      ScaffoldMessenger.of(context).showSnackBar(snackBar(content: 'No valid login token detected!', colorValue: 2));
      if (!isLoginPage) {
        Routes.sailor.pop();
        Routes.sailor.navigate(RoutePaths().Login);
      }

    }
  }

  static String getToken() {
    String? token = GetStorage().read('token');
    if (token != null) {
      return token;
    } else {
      throw Exception('The token read is null!');
    }
  }

}