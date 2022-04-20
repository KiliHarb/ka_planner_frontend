import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ka_planner/main.dart';
import 'package:ka_planner/navigation/RoutePaths.dart';
import 'package:ka_planner/services/DataService.dart';
import 'package:ka_planner/services/EditingService.dart';

class TextW extends StatefulWidget {
  final String id;
  final String name;
  final String content;
  final String dateOfCreation;
  final String editingDate; 
  const TextW({ Key? key, required this.id, required this.name, required this.content, required this.dateOfCreation, required this.editingDate }) : super(key: key);

  @override
  _TextWState createState() => _TextWState();
}

class _TextWState extends State<TextW> {

  Color _editingDateBackgroundColor = const Color(0xff333333);
  Color _2ndEditingDateBackgroundColor = const Color(0xff888888);
  Widget _editingLoadingIcon = Container();

  Widget _loadingPlaceholder = SizedBox();

  @override
  void initState() {
    super.initState();
    canEdit();
  }

  // Checks wheather someone is already editing this text or not 
  Future<bool> canEdit() async {
    // Loading Icon
    setState(() {
      _loadingPlaceholder = loadingWidget();
    });
    bool isDifferentUserEditing = await DataService.isDifferentUserEditing(id: widget.id);
    if (isDifferentUserEditing) {
      setState(() {
        _editingDateBackgroundColor = Colors.orange.shade700;
        _2ndEditingDateBackgroundColor = Colors.black;
        _editingLoadingIcon = Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: const SpinKitThreeBounce(
            color: Colors.black,
            size: 15,
          ),
        );
      });
      // Loading Icon
      setState(() {
        _loadingPlaceholder = SizedBox();
      });
      return false;
    } else {
      setState(() {
        _editingDateBackgroundColor = const Color(0xff333333);
        _2ndEditingDateBackgroundColor = const Color(0xff888888);
      });
      // Loading Icon
      setState(() {
        _loadingPlaceholder = SizedBox();
      });
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Can edit this text? False: Reaload, True: load editing screen
        bool canEditBool = await canEdit();
        if (!canEditBool) {
          Routes.sailor.pop();
          Routes.sailor.navigate(RoutePaths().Home);
          return;
        }
        // Loading Icon
        setState(() {
          _loadingPlaceholder = loadingWidget();
        });
        // Reload all data
        await DataService.collectLatestData();
        // Check if selected text still exist
        bool _doesStillExist = false;
        for (var i = 0; i < DataService.collectedTextObjects.length; i++) {
          if (DataService.collectedTextObjects[i].id == widget.id) {
            _doesStillExist = true;
          }
        }
        if (!_doesStillExist) {
          Routes.sailor.pop();
          Routes.sailor.navigate(RoutePaths().Home);
          return;
        }
        // Request editing
        try {
          if (!await EditingService.setNewEditingUser(id: widget.id)) {
            Routes.sailor.pop();
            Routes.sailor.navigate(RoutePaths().Home);
            return;
          }
        } catch (e) {
          Routes.sailor.pop();
          Routes.sailor.navigate(RoutePaths().Home);
          return;
        }
        // Navigate to editing page
        EditingService.selectedText = widget.id;
        Routes.sailor.pop();
        Routes.sailor.navigate(RoutePaths().Editing);

      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                widget.name,
                style: GoogleFonts.jost(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                color: const Color(0xff333333)
              ),
            ),
    
            const SizedBox(
              height: 10,
            ),
    
            // Content
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                widget.content,
                style: GoogleFonts.jost(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 16
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(10),
                color: const Color(0xff333333)
              ),
            ),
    
            const SizedBox(
              height: 10,
            ),
            
            Row(
              children: [
                _loadingPlaceholder, SizedBox(width: 5),
    
                // Date of Creation
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    widget.dateOfCreation,
                    style: GoogleFonts.jost(
                      color: const Color(0xff888888),
                      fontWeight: FontWeight.normal,
                      fontSize: 12
                    )
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    color: const Color(0xff333333)
                  ),
                ),
    
                const SizedBox(
                  width: 5,
                ),
    
                // Date of Editing
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: _2ndEditingDateBackgroundColor,
                        size: 15,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.editingDate,
                        style: GoogleFonts.jost(
                          color: _2ndEditingDateBackgroundColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 12
                        )
                      ),
                      _editingLoadingIcon
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(10),
                    color: _editingDateBackgroundColor
                  ),
                ),
              ],
            )
          ],
        ),
        decoration: BoxDecoration(
          color: const Color(0xff222222),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  static Widget loadingWidget() {
    return FractionallySizedBox(
      child: Container(
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}