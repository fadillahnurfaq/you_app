class ResponseModel<T> {
  final String message;
  final T? data;

  ResponseModel({required this.message, this.data});

  Map<String, dynamic> toJson(Function(T) dataToJson) {
    return <String, dynamic>{
      'message': message,
      'data': data != null ? dataToJson(data as T) : null,
    };
  }

  factory ResponseModel.fromJson(
    Map<String, dynamic> map,
    Function(dynamic) dataFromJson,
  ) {
    return ResponseModel(
      message:
          map['message'] ??
          (map['error'] is List
              ? (map['error'] as List).join(",")
              : map['error']) ??
          (map['errors'] is List
              ? (map['errors'] as List).join(",")
              : map['errors'] is String
              ? map['errors']
              : "") ??
          "",
      data: map['data'] != null && map['data'].isNotEmpty
          ? dataFromJson(map['data'])
          : null,
    );
  }
}
