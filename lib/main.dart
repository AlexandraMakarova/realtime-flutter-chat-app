import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realtime_chat_app/services/auth_service.dart';

import './routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Realtime Chat App',
        theme: ThemeData(
          primaryColor: Colors.blue[600],
          primaryColorLight: Color(0xff4D9EF6),
          buttonColor: Colors.blue[400],
          backgroundColor: Colors.grey[100],
          fontFamily: "Quicksand",
        ),
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
