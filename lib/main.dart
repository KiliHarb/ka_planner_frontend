import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ka_planner/navigation/RoutePaths.dart';
import 'package:ka_planner/views/devsettings_view.dart';
import 'package:ka_planner/views/editing_view.dart';
import 'package:ka_planner/views/home_view.dart';
import 'package:ka_planner/views/login_view.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:sailor/sailor.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// === MAIN ===
void main() async {

  // Black Nav Bar
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  await GetStorage.init();

  Routes.createRoutes();

  runApp(MyApp());

}

// === HOME APP ===
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KA PLANNER',
      navigatorKey: Routes.sailor.navigatorKey,
      onGenerateRoute: Routes.sailor.generator(),
      home: const LoginView(),
      navigatorObservers: [
        SailorLoggingObserver(),
        Routes.sailor.navigationStackObserver,
      ],
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) =>
            const LoginView(),
        );
      },
    );
  }
}

class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    sailor.addRoutes([
      SailorRoute(
        name: RoutePaths().Home,
        builder: (context, args, params) {return const HomeScreen();}
      ),
      SailorRoute(
        name: RoutePaths().Login,
        builder: (context, args, params) {return const LoginView();}
      ),
      SailorRoute(
        name: RoutePaths().DevSettings,
        builder: (context, args, params) {return const DevSettings();}
      ),
      SailorRoute(
        name: RoutePaths().Editing,
        builder: (context, args, params) {return const EditingScreen();}
      )
    ]);
  }
}