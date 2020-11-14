import 'package:flutter/material.dart';

import '../pages/chat_page.dart';
import '../pages/loading_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/users_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => UsersPage(),
  'chat': (_) => ChatPage(),
  'register': (_) => RegisterPage(),
  'login': (_) => LoginPage(),
  'loading': (_) => LoadingPage(),
};
