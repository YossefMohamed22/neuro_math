
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:neuro_math/core/http/api_end_points.dart';
import 'package:neuro_math/core/http/dio_headers.dart';
import 'package:neuro_math/core/injection/di.dart';

@lazySingleton
class DioOptions{

  late final Dio dio;

  void init(){
    dio = Dio(
        baseOptions
    )..interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
        responseHeader: true,
        logPrint: (data) => log(data.toString(),
        ))
    );
  }

  BaseOptions get baseOptions => BaseOptions(
    baseUrl: ApiEndPoints.baseUrl,
    // connectTimeout: Duration(minutes: 1),
    // receiveTimeout: Duration(minutes: 1),
    // sendTimeout: Duration(minutes: 1),
    connectTimeout: null,
    receiveTimeout: null,
    sendTimeout: null,
    headers: getIt.get<DioHeaders>().getHeaders(),
  );


  // void call()async{
//   var response = await dio.request(
//     '',
//     options: Options(
//       method: 'POST',
//       headers: getIt.get<DioHeaders>().getHeaders(),
//     ),
//     data: data,
//   );
// }

}