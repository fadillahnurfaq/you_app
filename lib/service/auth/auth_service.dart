import 'package:dartz/dartz.dart';
import 'package:you_app/model/user/user_model.dart';

import '../../model/api_exception.dart';
import '../../model/response_model.dart';
import '../../utils/utils.dart';

class AuthService {
  Future<Either<ApiException, String>> login({
    required final String emailOrUsername,
    required final String password,
  }) async {
    try {
      final isEmail = Validator.isEmail(emailOrUsername);
      final response = await HttpService.request(
        endpoint: "login",
        method: MethodRequest.post,
        data: {
          "email": isEmail ? emailOrUsername : "",
          "username": isEmail ? "" : emailOrUsername,
          "password": password,
        },
      );
      return response.fold((l) => Left(l), (r) {
        final String token = r["access_token"] ?? "";
        return token.isNotEmpty
            ? Right(token)
            : Left(ApiException(statusCode: 401, message: "Session not valid"));
      });
    } catch (e) {
      return Left(
        ApiException(
          statusCode: null,
          message:
              "An error occurred in the application, please try again later.",
        ),
      );
    }
  }

  Future<Either<ApiException, bool>> register({
    required final String email,
    required final String username,
    required final String password,
  }) async {
    try {
      final response = await HttpService.request(
        endpoint: "register",
        method: MethodRequest.post,
        data: {"email": email, "username": username, "password": password},
      );
      return response.fold((l) => Left(l), (r) => Right(true));
    } catch (e) {
      return Left(
        ApiException(
          statusCode: null,
          message:
              "An error occurred in the application, please try again later.",
        ),
      );
    }
  }

  Future<Either<ApiException, UserModel?>> getUserDetail() async {
    try {
      final response = await HttpService.request(endpoint: "getProfile");
      return await response.fold((l) => Left(l), (r) async {
        final userDetail = ResponseModel<UserModel?>.fromJson(
          r,
          (data) => UserModel.fromJson(data),
        );
        return Right(userDetail.data);
      });
    } catch (e) {
      return Left(
        ApiException(
          statusCode: null,
          message: "Terjadi kesalahan pada aplikasi, silahkan coba lagi nanti.",
        ),
      );
    }
  }
}
