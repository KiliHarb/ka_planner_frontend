import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ka_planner/main.dart';
import 'package:ka_planner/services/DataService.dart';
import 'package:ka_planner/services/EditingService.dart';

import '../navigation/RoutePaths.dart';

class EditingScreen extends StatefulWidget {
  const EditingScreen({ Key? key }) : super(key: key);

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {

  final _controller = TextEditingController();
  final _controllerContent = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List _collectedTextObjects = DataService.collectedTextObjects;
    String _currentTextNameTemp = "Loading...";
    String _currentTextContentTemp = "Loading...";
    for (var i = 0; i < _collectedTextObjects.length; i++) {
      if (_collectedTextObjects[i].id == EditingService.selectedText) {
        _currentTextNameTemp = _collectedTextObjects[i].name;
        _currentTextContentTemp = _collectedTextObjects[i].content;
      }
    }
    setState(() {
      _controller.text = _currentTextNameTemp;
      _controllerContent.text = _currentTextContentTemp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                if (!await EditingService.submitChanges(title: _controller.text, content: _controllerContent.text, id: EditingService.selectedText)) {
                  Routes.sailor.pop();
                  Routes.sailor.navigate(RoutePaths().Home);
                  return;
                }
                Routes.sailor.pop();
                Routes.sailor.navigate(RoutePaths().Home);
              },
            ),
            const SizedBox(width: 10,),
            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: TextFormField(
                controller: _controller,
                cursorColor: Colors.white,
                style: GoogleFonts.jost(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
            )
          ],
        ),
        backgroundColor: Color(0xff333333),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          controller: _controllerContent,
          maxLines: null,
          cursorColor: Colors.white,
          style: GoogleFonts.jost(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
          ),
        ),
      ),
      backgroundColor: const Color(0xff111111),
    );
  }
}