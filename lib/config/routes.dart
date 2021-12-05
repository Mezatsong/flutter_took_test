
import 'package:flutter/material.dart';
import 'package:took_test/screens/create/create_screen.dart';
import 'package:took_test/screens/home/home_screen.dart';

abstract class AppRoutes {

  static const home = 'home';
  static const create = 'create';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    
    final routes = <String, WidgetBuilder> {
      home: (_) => const HomeScreen(),
      create: (_) => CreateScreen(openGallery: settings.arguments != null)      
    }; 

    assert(routes.containsKey(settings.name), 'Need to implement ${settings.name}');

    if (routes.containsKey(settings.name)) {
      WidgetBuilder builder = routes[settings.name]!;
      return MaterialPageRoute(builder: (ctx) => builder(ctx));
    }
  }
}
