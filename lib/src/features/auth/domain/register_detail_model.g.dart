// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_detail_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegisterDetailModelAdapter extends TypeAdapter<RegisterDetailModel> {
  @override
  final int typeId = 0;

  @override
  RegisterDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegisterDetailModel(
      firstName: fields[0] as String,
      middleName: fields[1] as String,
      surname: fields[2] as String,
      mobileNumber: fields[3] as String,
      password: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RegisterDetailModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.middleName)
      ..writeByte(2)
      ..write(obj.surname)
      ..writeByte(3)
      ..write(obj.mobileNumber)
      ..writeByte(4)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
