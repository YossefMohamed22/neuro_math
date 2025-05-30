
import 'package:neuro_math/core/bloc/universal_bloc.dart';
import 'package:neuro_math/core/http/general_states.dart';
import 'package:neuro_math/view/auth/data/auth_api_service/auth_api_service.dart';
import 'package:neuro_math/view/auth/domain/entity/login_params.dart';
import 'package:neuro_math/view/auth/domain/repositories/auth_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginLogic {
  late final AuthApiService authApiService;
  late final AuthRepositories authRepositories;

  LoginLogic(){
    authApiService =  AuthApiService();
    authRepositories = AuthRepositories(authApiService: authApiService);
  }

  UniversalCubit<bool> showLoadingCubit = UniversalCubit<bool>();

  Future<void> onPressLogin()async{
    authRepositories.login(params).then((value) async{
      if(value.data != null){
        final SharedPreferences preferences = await SharedPreferences.getInstance();
        var token = await preferences.setString('token', value.data?.token??"");
        GeneralStates.instance.set("token", token);
      }
    },);
  }


  LoginParams get params => LoginParams(
      email: "mo.hashim678@gmail.com",
      password: "123456789ASD"
  );

}