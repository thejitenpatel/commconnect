import 'package:hive_flutter/hive_flutter.dart';

part 'register_detail_model.g.dart';

@HiveType(typeId: 0)
class RegisterDetailModel {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String middleName;

  @HiveField(2)
  final String surname;

  @HiveField(3)
  final String mobileNumber;

  @HiveField(4)
  final String password;

  RegisterDetailModel({
    required this.firstName,
    required this.middleName,
    required this.surname,
    required this.mobileNumber,
    required this.password,
  });
}

