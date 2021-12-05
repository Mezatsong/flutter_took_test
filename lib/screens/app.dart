import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:took_test/bloc/post/post_cubit.dart';
import 'package:took_test/config/routes.dart';
import 'package:took_test/repository/post_repository.dart';
import 'package:took_test/service/database_service.dart';

class TookTestApp extends StatelessWidget {

  const TookTestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostCubit(PostRepository(DatabaseService.db)),
      child: MaterialApp(
        title: 'Took test',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: AppRoutes.onGenerateRoute,
        initialRoute: AppRoutes.home,
      )
    );
  }
  
}