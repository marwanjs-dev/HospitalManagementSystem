import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Constants/routes.dart';
import 'package:hospitalmanagementsystem/Containers/side_bar.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/database_user.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';

class PatientRecord extends StatefulWidget {
  const PatientRecord({Key? key}) : super(key: key);

  @override
  State<PatientRecord> createState() => _PatientRecordState();
}

class _PatientRecordState extends State<PatientRecord> {
  late final _height = MediaQuery.of(context).size.height;
  late final PatientService _patient_service;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  void initState() {
    _patient_service = PatientService();
    super.initState();
  }

  Future<DataBaseUser> GetPatient() async {
    DataBaseUser patient = await _patient_service.getUser(email: userEmail);
    return patient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.pink[700],
          title: const Text("Patient Record"),
        ),
        body: FutureBuilder(
            future: GetPatient(),
            builder: (context, AsyncSnapshot<DataBaseUser> snapshot) {
              if (snapshot.hasData) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("id: ${snapshot.data?.id}"),
                      SizedBox(height: 0.05 * _height),
                      Text("name: ${snapshot.data?.name}"),
                      SizedBox(height: 0.05 * _height),
                      Text("address: ${snapshot.data?.address}"),
                      SizedBox(height: 0.05 * _height),
                      Text("phone number: ${snapshot.data?.phoneNumber}"),
                      SizedBox(height: 0.05 * _height),
                      Text("age: ${snapshot.data?.age}"),
                      SizedBox(height: 0.05 * _height),
                      Text("blood type: ${snapshot.data?.bloodType}"),
                      SizedBox(height: 0.05 * _height),
                      Text("date of birth: ${snapshot.data?.dateOfBirth}"),
                      SizedBox(height: 0.05 * _height),
                      Text("gender: ${snapshot.data?.gender}"),
                      SizedBox(height: 0.05 * _height),
                      Text("health history: ${snapshot.data?.healthHistory}"),
                      SizedBox(height: 0.05 * _height),
                      Text("height: ${snapshot.data?.height}"),
                      SizedBox(height: 0.05 * _height),
                      Text("weight: ${snapshot.data?.weight}"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                editPatientRoute, (route) => false);
                          },
                          child: Text("Edit")),
                    ]);
              } else {
                return const Text("no patient is recorded");
              }
            }));
  }
}
