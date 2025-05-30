
import 'package:injectable/injectable.dart';
import 'package:neuro_math/core/http/general_states.dart';

@lazySingleton
class DioHeaders {
   Map<String,dynamic>  getHeaders(){
     String? token = GeneralStates.instance.get("token");
    return {
    'Content-Type': 'application/json',
    // 'Accept': 'application/json',
    if(token != null) "Authorization":"Bearer$token"
    };
  }

}