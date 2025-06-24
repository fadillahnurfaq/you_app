import 'package:dartz/dartz.dart';

import '../../model/api_exception.dart';
import '../../utils/utils.dart';

class ProfileService {
  Future<Either<ApiException, bool>> create({
    required final String name,
    required final String birthDay,
    required final int height,
    required final int weight,
    required final List<String> interests,
  }) async {
    try {
      final response = await HttpService.request(
        endpoint: "createProfile",
        method: MethodRequest.post,
        data: {
          "name": name,
          "birthday": birthDay,
          "height": height,
          "weight": weight,
          "interests": interests,
        },
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

  Future<Either<ApiException, bool>> update({
    required final String name,
    required final String birthDay,
    required final int height,
    required final int weight,
    required final List<String> interests,
  }) async {
    try {
      final response = await HttpService.request(
        endpoint: "updateProfile",
        method: MethodRequest.put,
        data: {
          "name": name,
          "birthday": birthDay,
          "height": height,
          "weight": weight,
          "interests": interests,
        },
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
}
