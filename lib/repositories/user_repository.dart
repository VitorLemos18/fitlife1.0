import '../models/app_user.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserService _service;

  UserRepository(this._service);

  Future<AppUser> registerUser(AppUser user) async {
    return await _service.registerUser(user);
  }
}