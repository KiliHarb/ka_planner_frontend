import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ka_planner/constants/ServerInfo.dart';

class DevSettings extends StatefulWidget {
  const DevSettings({ Key? key }) : super(key: key);

  @override
  _DevSettingsState createState() => _DevSettingsState();
}

class _DevSettingsState extends State<DevSettings> {

  String _serverAddress = ServerInfo.url;
  final _serverAddressController = TextEditingController();
  Color _serverAddressColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _serverAddressController.text = ServerInfo.url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: ListView(
            children: [
              TextFormField(
                controller: _serverAddressController,
                decoration: loginTextInputDecoration('Current server address: ' + ServerInfo.url),
                style: const TextStyle(
                  color: Colors.white
                ),
                onEditingComplete: () {
                  ServerInfo.url = _serverAddressController.text;
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xff2222222),
    );
  }

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
      labelStyle: TextStyle(
        color: Colors.orange.shade500
      ),
      hintText: fieldName,
      hintStyle: const TextStyle(
        color: Colors.white30
      )
    );
  }
}