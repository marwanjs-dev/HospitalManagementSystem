import 'constants.dart';

class DataBaseUser {
  final int id;
  final String email;
  final String name;
  final int age;
  final String gender;
  final int phoneNumber;
  final String address;
  final String? bloodType;
  final int? weight;
  final int? height;
  final String dateOfBirth;
  final String? healthHistory;

  const DataBaseUser({
    required this.bloodType,
    required this.weight,
    required this.height,
    required this.healthHistory,
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.dateOfBirth,
    required this.id,
    required this.email,
  });

  DataBaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        name = map[nameColumn] as String,
        age = map[ageColumn] as int,
        gender = map[genderColumn] as String,
        phoneNumber = map[phoneNumberColumn] as int,
        address = map[addressColumn] as String,
        dateOfBirth = map[dateOfBirthColumn] as String,
        bloodType = map[bloodTypeColumn] as String,
        weight = map[weightColumn] as int,
        height = map[heightColumn] as int,
        healthHistory = map[healthHistoryColumn] as String;

  String toString() => 'Person, ID = ${id} email = $email';

  @override
  bool operator ==(covariant DataBaseUser other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
