import 'package:flutter/material.dart';
import './routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realtime Chat App',
      theme: ThemeData(
        primaryColor: Colors.blue[600],
        primaryColorLight: Color(0xff4D9EF6),
        buttonColor: Colors.blue[400],
        backgroundColor: Colors.grey[100],
        fontFamily: "Quicksand",
      ),
      initialRoute: 'chat',
      routes: appRoutes,
    );
  }
}
