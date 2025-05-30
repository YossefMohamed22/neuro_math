
import 'package:neuro_math/core/http/api_service.dart';
import 'package:neuro_math/view/auth/data/auth_api_service/auth_api_service.dart';
import 'package:neuro_math/view/auth/domain/entity/login_params.dart';
import 'package:neuro_math/view/auth/data/models/login_model/login_model.dart';

class AuthRepositories {
   final AuthApiService authApiService;

  AuthRepositories({required this.authApiService});

  Future<ApiResponse<LoginModel>> login(LoginParams params)async{
    return authApiService.login(params);
  }

}