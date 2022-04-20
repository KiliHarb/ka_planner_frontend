import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ka_planner/services/DataService.dart';
import 'package:ka_planner/views/login_view.dart';
import 'package:ka_planner/widgets/TextW.dart';
import '../services/LoginService.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {

  Widget _loadingPlaceholder = SizedBox();

  List<Widget> _textWidgets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    refresh();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // If the user leaves the app and then opens it again (When he does not close it)
    if (state == AppLifecycleState.resumed) {
      // Sends a request to the server -> Checks if the stored token is still valid
      await LoginService().onTokeExpired(isHomePage: true, isLoginPage: false);
    }
  }

  Future<void> refresh() async {
    setState(() {
      _loadingPlaceholder = loadingWidget();
    });
    await DataService.collectLatestData();
    final List<Widget> _textWidgetsNew = [];
    for (var i = 0; i < DataService.collectedTextObjects.length; i++) {
      _textWidgetsNew.add(TextW(
        id: DataService.collectedTextObjects.elementAt(i).id, 
        name: DataService.collectedTextObjects.elementAt(i).name, 
        content: DataService.collectedTextObjects.elementAt(i).content, 
        dateOfCreation: DataService.collectedTextObjects.elementAt(i).dateOfCreation, 
        editingDate: DataService.collectedTextObjects.elementAt(i).dateOfEditing
      ));
    }
    _textWidgetsNew.add(const SizedBox(height: 20));
    setState(() {
      _textWidgets = [];
    });
    await Future.delayed(const Duration(milliseconds: 10), (){});
    setState(() {
      _textWidgets = _textWidgetsNew;
    });
    setState(() {
      _loadingPlaceholder = SizedBox();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.black,
              onRefresh: () => refresh(),
              child: ListView(
                children: _textWidgets,
              )
            ),
          ),
          _loadingPlaceholder
        ],
      ),
      backgroundColor: Color(0xff111111),
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

