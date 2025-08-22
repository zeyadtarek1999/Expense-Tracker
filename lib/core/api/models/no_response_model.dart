import '../entities/no_response_entity.dart';

class NoResponseModel extends NoResponseEntity {
  NoResponseModel({required super.message});

  factory NoResponseModel.fromJson(Map<String, dynamic> json) => NoResponseModel(
        message: json['message'],
      );
}
