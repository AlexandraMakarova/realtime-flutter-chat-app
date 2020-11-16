import 'package:http/http.dart' as http;

import './auth_service.dart';

import '../global/environment.dart';

import '../models/user.dart';
import '../models/users_response.dart';

class UsersService {
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get('${Environment.apiUrl}/users', headers: {
        'Content-Type': 'aplication/json',
        'x-token': await AuthService.getToken()
      });

      final usersResponse = usersResponseFromJson(response.body);

      return usersResponse.users;
    } catch (error) {
      return [];
    }
  }
}
