import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ka_planner/main.dart';
import 'package:ka_planner/navigation/RoutePaths.dart';
import 'package:ka_planner/services/LoginService.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _loadingPlaceholder = SizedBox();

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      LoginService().onTokeExpired(isLoginPage: true, isHomePage: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _usernameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          decoration: loginTextInputDecoration('Username'),
                          cursorColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: loginTextInputDecoration('Password'),
                          cursorColor: Colors.white,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: 100,
                    width: 2,
                    decoration: const BoxDecoration(
                      color: Colors.white38
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // Settings
                      SizedBox(
                        width: 80,
                        height: 60,
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white38,
                            size: 40,
                          ),
                          onPressed: () {
                            Routes.sailor.navigate(RoutePaths().DevSettings);
                          },
                        ),
                      ),

                      // Login
                      SizedBox(
                        width: 80,
                        height: 60,
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          icon: const Icon(
                            Icons.keyboard_arrow_right_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loadingPlaceholder = loadingWidget();
                              });
                              // Validate Login Data -> Send Request to Server
                              LoginService().validateLogin(_usernameController.text, _passwordController.text);
                            }
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          _loadingPlaceholder,
        ],
      ),
      backgroundColor: const Color(0xff111111)
    );
  }

  // Input Decoration for the username and password input field
  InputDecoration loginTextInputDecoration(String fieldName) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.white,
          width: 2
        )
      ),
      filled: true,
      fillColor: const Color(0xff333333),
      labelText: fieldName,
      labelStyle: const TextStyle(
        color: Colors.white
      ),
      hintText: fieldName,
      hintStyle: const TextStyle(
        color: Colors.white30
      )
    );
  }

  Widget loadingWidget() {
    return FractionallySizedBox(
      child: Container(
        child: const Center(
          child: SpinKitThreeBounce(
            color: Colors.white,
          ),
        ),
        decoration: const BoxDecoration(
          color: Color(0x88000000)
        ),
      ),
    );
  }

}
