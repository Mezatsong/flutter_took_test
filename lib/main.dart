import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:took_test/screens/app.dart';
import 'package:took_test/service/database_service.dart';

void main() async {
  EquatableConfig.stringify = true;
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initializeDB();
  runApp(const TookTestApp());
}
