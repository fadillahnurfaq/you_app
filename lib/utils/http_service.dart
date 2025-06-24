import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../model/api_exception.dart';
import '../model/response_model.dart';
import '../service/local/local_service.dart';
import 'utils.dart';

enum MethodRequest { get, post, put, download }

class HttpService {
  static final Dio _dio = Dio()
    ..interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );

  static Future<Either<ApiException, dynamic>> request({
    String baseUrl = "",
    String endpoint = "",
    MethodRequest method = MethodRequest.get,
    bool allowAnonymous = false,
    dynamic data,
    bool isFormData = false,
    bool isFormUrlEncoded = false,
    String url = "",
    String savePath = "",
    String? token,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      dynamic responseData;

      final response = method == MethodRequest.get
          ? await _dio.get(
              "${baseUrl.isNotEmpty ? baseUrl : AppApi.url}/$endpoint",
              data: data,
              queryParameters: queryParameters,
              options: Options(
                headers:
                    headers ??
                    await _getHttpHeaders(
                      allowAnonymous: allowAnonymous,
                      token: token,
                      isFormData: isFormData,
                      isFormUrlEncoded: isFormUrlEncoded,
                    ),
              ),
            )
          : method == MethodRequest.download
          ? await _dio.download(url, savePath, queryParameters: queryParameters)
          : method == MethodRequest.put
          ? await _dio.put(
              "${baseUrl.isNotEmpty ? baseUrl : AppApi.url}/$endpoint",
              data: data,
              queryParameters: queryParameters,
              options: Options(
                headers:
                    headers ??
                    await _getHttpHeaders(
                      allowAnonymous: allowAnonymous,
                      token: token,
                      isFormData: isFormData,
                      isFormUrlEncoded: isFormUrlEncoded,
                    ),
              ),
            )
          : await _dio.post(
              "${baseUrl.isNotEmpty ? baseUrl : AppApi.url}/$endpoint",
              data: data,
              queryParameters: queryParameters,
              options: Options(
                headers:
                    headers ??
                    await _getHttpHeaders(
                      allowAnonymous: allowAnonymous,
                      token: token,
                      isFormData: isFormData,
                      isFormUrlEncoded: isFormUrlEncoded,
                    ),
              ),
            );
      if (method == MethodRequest.download) {
        responseData = response.data;
      } else {
        responseData = response.data;
      }

      return right(responseData);
    } on DioException catch (e) {
      return Left(await _fromDioError(e));
    }
  }

  static Future<Map<String, String>> _getHttpHeaders({
    final bool allowAnonymous = false,
    String? token,
    bool isFormData = false,
    bool isFormUrlEncoded = false,
  }) async {
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: isFormData
          ? 'multipart/form-data'
          : isFormUrlEncoded
          ? 'application/x-www-form-urlencoded'
          : "application/json",
    };
    token ??= await LocalService.getToken();
    if (!allowAnonymous) {
      headers['x-access-token'] = token;
    }
    return headers;
  }

  static Future<ApiException> _fromDioError(DioException e) async {
    if (e.error is SocketException) {
      return ApiException(
        statusCode: e.response?.statusCode,
        message: "You are not connected to a network.",
      );
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: "The connection to the server timed out.",
        );

      case DioExceptionType.sendTimeout:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: "The request to the server timed out.",
        );

      case DioExceptionType.receiveTimeout:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: "The response from the server timed out.",
        );

      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 404) {
          return ApiException(
            statusCode: e.response?.statusCode,
            message: "${e.response?.statusCode}. Data not found.",
          );
        }
        if ((e.response?.data is String &&
                (e.response?.data as String).contains("DOCTYPE")) ==
            true) {
          return ApiException(
            statusCode: e.response?.statusCode,
            message:
                "${e.response?.statusCode}. Internal server error, please try again later.",
          );
        }
        if (e.response?.data != null &&
            e.response?.data is Map<String, dynamic>) {
          final ResponseModel<dynamic> response = ResponseModel.fromJson(
            e.response?.data,
            (data) => [],
          );
          return ApiException(
            statusCode: e.response?.statusCode,
            message: response.message,
          );
        }
        return ApiException(
          statusCode: e.response?.statusCode,
          message:
              "${e.response?.statusCode != null ? "${e.response?.statusCode}. " : ""}Internal server error, please try again later.",
        );
      case DioExceptionType.cancel:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: "The server request was canceled.",
        );

      case DioExceptionType.unknown:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: "An unexpected error occurred, please try again later.",
        );

      case DioExceptionType.connectionError:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: "An unexpected error occurred, please try again later.",
        );

      default:
        return ApiException(
          statusCode: e.response?.statusCode,
          message: "An unexpected error occurred, please try again later.",
        );
    }
  }
}
