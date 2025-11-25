// abstract class BaseApiServices {
//   Future<dynamic> get(String url, {Map<String, dynamic>? queryParams, Map<String, String>? headers});
//   Future<dynamic> post(String url, {dynamic body, Map<String, String>? headers});
// }



import 'package:dio/dio.dart';

abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(String url, {Map<String, dynamic>? queryParameters});
  Future<dynamic> getPostApiResponse(String url, dynamic data, {Map<String, dynamic>? queryParameters});
  Future<dynamic> getPutApiResponse(String url, dynamic data, {Map<String, dynamic>? queryParameters});
  Future<dynamic> getPatchApiResponse(String url, dynamic data, {Map<String, dynamic>? queryParameters});
  Future<dynamic> getDeleteApiResponse(String url, {dynamic data, Map<String, dynamic>? queryParameters});
  Future<dynamic> getFormDataApiResponse(String url, FormData formData, {Map<String, dynamic>? queryParameters});
}