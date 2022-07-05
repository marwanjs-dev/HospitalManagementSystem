// To parse this JSON data, do
//
//     final patient = patientFromJson(jsonString);

import 'dart:convert';

List<PatientDataModel> patientFromJson(String str) =>
    List<PatientDataModel>.from(
        json.decode(str).map((x) => PatientDataModel.fromJson(x)));

String patientToJson(List<PatientDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PatientDataModel {
  PatientDataModel({
    required this.patientId,
    required this.email,
    required this.name,
    required this.age,
    required this.gender,
    required this.phoneNumber,
    required this.address,
    required this.bloodType,
    required this.weight,
    required this.height,
    required this.dateOfBirth,
    required this.healthHistory,
  });

  int patientId;
  String email;
  String name;
  int age;
  String gender;
  int phoneNumber;
  String address;
  String bloodType;
  int weight;
  int height;
  DateTime dateOfBirth;
  String healthHistory;

  factory PatientDataModel.fromJson(Map<String, dynamic> json) =>
      PatientDataModel(
        patientId: json["patientId"],
        email: json["email"],
        name: json["name"],
        age: json["age"],
        gender: json["gender"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        bloodType: json["bloodType"],
        weight: json["weight"],
        height: json["height"],
        dateOfBirth: DateTime.parse(json["dateOfBirth"]),
        healthHistory: json["healthHistory"],
      );

  Map<String, dynamic> toJson() => {
        "patientId": patientId,
        "email": email,
        "name": name,
        "age": age,
        "gender": gender,
        "phoneNumber": phoneNumber,
        "address": address,
        "bloodType": bloodType,
        "weight": weight,
        "height": height,
        "dateOfBirth":
            "${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}",
        "healthHistory": healthHistory,
      };
}
