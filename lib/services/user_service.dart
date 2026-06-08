import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/app_user.dart';

class UserService {
  final Dio _dio = ApiClient().dio;

  Future<AppUser> registerUser(AppUser user) async {
    try {
      final response = await _dio.post(
        ApiConstants.users,
        data: user.toJson(),
      );

      return AppUser.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data.toString() ?? e.message ?? 'Erro ao cadastrar usuário';
      throw Exception(message);
    }
  }
}