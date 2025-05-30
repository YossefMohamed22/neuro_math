import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:neuro_math/core/http/api_end_points.dart';
import 'package:neuro_math/core/http/dio_headers.dart';
import 'package:neuro_math/core/http/dio_options.dart';
import 'package:neuro_math/core/injection/di.dart';

@lazySingleton
class ApiService {
  ApiService(){
    getIt<DioOptions>().init();
  }

  Future<ApiResponse<T>> request<T>({
    required String path,
    required HttpMethod method,
    required T Function(Map<String, dynamic>) fromJson,
    String? responseKey,
    bool isFormData = true,
    Map<String,dynamic>? requestBody,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
     Dio dio = getIt<DioOptions>().dio;
    try {
      final response = await dio.request(
        ApiEndPoints.baseUrl + path,
        data: isFormData ? FormData.fromMap(requestBody ?? {}) : requestBody ?? {},
        queryParameters: queryParameters,
        options: Options(
          method: method.name,
          headers:getIt<DioHeaders>().getHeaders(),
        ),
      );

      return ApiResponse.success(
        responseKey !=null ? response.data[responseKey] : fromJson(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return ApiResponse.error(
        message: e.response?.data?['message']?.toString() ?? e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(
        message: e.toString(),
      );
    }
  }
}



enum HttpMethod { get, post, put, patch, delete }

class ApiResponse<T> {
  final T? data;
  final String? message;
  final int? statusCode;
  final bool success;

  ApiResponse._({
    this.data,
    this.message,
    this.statusCode,
    required this.success,
  });

  factory ApiResponse.success(T data, {int? statusCode}) {
    return ApiResponse._(
      data: data,
      success: true,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({String? message, int? statusCode}) {
    return ApiResponse._(
      message: message,
      success: false,
      statusCode: statusCode,
    );
  }
}