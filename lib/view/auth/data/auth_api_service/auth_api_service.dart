
import 'package:neuro_math/core/http/api_end_points.dart';
import 'package:neuro_math/core/http/api_service.dart';
import 'package:neuro_math/core/injection/di.dart';
import 'package:neuro_math/view/auth/domain/entity/login_params.dart';
import 'package:neuro_math/view/auth/data/models/login_model/login_model.dart';

class AuthApiService {

  var apiService = getIt<ApiService>();

  // Future<LoginModel> login(LoginParams params) async {
  //
  //
  //   try{
  //     Response response = await getIt<DioOptions>().dio.post(
  //       ApiEndPoints.login,
  //       data: FormData.fromMap(params.toJson()),
  //     );
  //     var data = response.data['token'];
  //     return LoginModel.fromJson(data);
  //   }on DioException catch(e){
  //     if (e.type == DioExceptionType.connectionTimeout) {
  //       log('Connection timeout!');
  //     }
  //     return LoginModel.fromJson({});
  //   }
  // }

  Future<ApiResponse<LoginModel>> login(LoginParams params) async {
    return await apiService.request(
      path: ApiEndPoints.login,
      method: HttpMethod.post,
      fromJson: LoginModel.fromJson,
      requestBody: params.toJson(),
      isFormData: true,
      responseKey: 'token'
    );
  }
}
