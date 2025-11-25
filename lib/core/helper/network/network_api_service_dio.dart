import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rider_pay_driver/share_pref/user_provider.dart';
import 'base_api_service.dart';
import 'api_exception.dart';

class NetworkApiServicesDio extends BaseApiServices {
  final Ref _ref;
  late Dio _dio;

  NetworkApiServicesDio(this._ref) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  /// Common headers with token
  Map<String, String> _getHeadersWithToken() {
    final user = _ref.read(userProvider);
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    if (user != null && user.token.isNotEmpty) {
      headers['Authorization'] = 'Bearer ${user.token}';
    }
    return headers;
  }

  @override
  Future<dynamic> getGetApiResponse(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(url, queryParameters: queryParameters, options: Options(headers: _getHeadersWithToken()));
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getPostApiResponse(String url, dynamic data, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(url, data: data, queryParameters: queryParameters, options: Options(headers: _getHeadersWithToken()));
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getPutApiResponse(String url, dynamic data, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(url, data: data, queryParameters: queryParameters, options: Options(headers: _getHeadersWithToken()));
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getPatchApiResponse(String url, dynamic data, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.patch(url, data: data, queryParameters: queryParameters, options: Options(headers: _getHeadersWithToken()));
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getDeleteApiResponse(String url, {data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(url, data: data, queryParameters: queryParameters, options: Options(headers: _getHeadersWithToken()));
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> getFormDataApiResponse(String url, FormData formData, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(url, data: formData, queryParameters: queryParameters, options: Options(headers: _getHeadersWithToken()));
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  dynamic _returnResponse(Response response) {
    // if (kDebugMode) {
    //   debugPrint('Status: ${response.statusCode}, Data: ${response.data}');
    // }
    final statusCode = response.statusCode ?? 500;
    switch (statusCode) {
      case 200:
      case 201:
      case 202:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        _ref.read(userProvider.notifier).clearUser();
        throw UnauthorisedException("Unauthorised: ${response.data}");
      case 404:
        throw NotFoundException("Not found: ${response.data}");
      case 500:
        throw FetchDataException("Server Error: ${response.data}");
      default:
        throw FetchDataException("Unexpected Error [$statusCode]: ${response.data}");
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return FetchDataException("Connection timeout");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      return FetchDataException("Receive timeout");
    } else if (e.type == DioExceptionType.badResponse) {
      return FetchDataException("Bad response: ${e.response?.data}");
    } else if (e.type == DioExceptionType.cancel) {
      return FetchDataException("Request cancelled");
    }
    return FetchDataException("Unexpected error: ${e.message}");
  }
}
