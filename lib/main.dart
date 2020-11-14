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
        accentColor: Colors.purple[400],
        backgroundColor: Colors.grey[100],
      ),
      initialRoute: 'login',
      routes: appRoutes,
    );
  }
}
