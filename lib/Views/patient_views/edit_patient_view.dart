import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hospitalmanagementsystem/Constants/routes.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/database_user.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';

class EditPatient extends StatefulWidget {
  const EditPatient({Key? key}) : super(key: key);

  @override
  State<EditPatient> createState() => _EditPatientState();
}

class _EditPatientState extends State<EditPatient> {
  late final _height = MediaQuery.of(context).size.height;
  late final PatientService _patient_service;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final TextEditingController emailController,
      nameController,
      addressController,
      bloodTypeController,
      ageController,
      medicalHistoryController,
      phoneNumberController,
      dateOfBirthController,
      heightController,
      weightController,
      genderController;

  void initState() {
    _patient_service = PatientService();
    super.initState();
  }

  Future<DataBaseUser> GetPatient() async {
    DataBaseUser patient = await _patient_service.getUser(email: userEmail);
    return patient;
  }

  Future<void> updatePatient({
    required String PatientEmail,
    required String PatientName,
    required int PatientAge,
    required String PatientGender,
    required int PatientPhoneNumber,
    required String PatientAddress,
    required String PatientDateOfBirth,
    required String PatientBloodType,
    required int PatientHeight,
    required int PatientWeight,
    required String PatientHealthHistory,
  }) async {
    _patient_service.updateUser(
      patientEmail: PatientEmail,
      patientName: PatientName,
      patientAge: PatientAge,
      patientGender: PatientGender,
      patientPhoneNumber: PatientPhoneNumber,
      patientAddress: PatientAddress,
      patientDateOfBirth: PatientDateOfBirth,
      patientBloodType: PatientBloodType,
      patientHeight: PatientHeight,
      patientHealthHistory: PatientHealthHistory,
      patientWeight: PatientWeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[700],
        title: const Text("edit patient"),
        leading: Row(children: [
          BackButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  patientRecordRoute, (route) => false);
            },
          )
        ]),
      ),
      body: FutureBuilder(
          future: GetPatient(),
          builder: (context, AsyncSnapshot<DataBaseUser> snapshot) {
            if (snapshot.hasData) {
              emailController =
                  TextEditingController(text: snapshot.data!.email);
              nameController = TextEditingController(text: snapshot.data!.name);
              addressController =
                  TextEditingController(text: snapshot.data!.address);
              bloodTypeController =
                  TextEditingController(text: snapshot.data!.bloodType);
              ageController =
                  TextEditingController(text: snapshot.data!.age.toString());
              medicalHistoryController =
                  TextEditingController(text: snapshot.data!.healthHistory);
              phoneNumberController = TextEditingController(
                  text: snapshot.data!.phoneNumber.toString());
              dateOfBirthController = TextEditingController(
                  text: snapshot.data!.dateOfBirth.toString());
              heightController =
                  TextEditingController(text: snapshot.data!.height.toString());
              weightController =
                  TextEditingController(text: snapshot.data!.weight.toString());
              genderController =
                  TextEditingController(text: snapshot.data!.gender);

              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(controller: emailController),
                    TextField(controller: nameController),
                    TextField(controller: addressController),
                    TextField(controller: bloodTypeController),
                    TextField(controller: ageController),
                    TextField(controller: medicalHistoryController),
                    TextField(controller: phoneNumberController),
                    TextField(controller: dateOfBirthController),
                    TextField(controller: heightController),
                    TextField(controller: weightController),
                    TextField(controller: genderController),
                    TextButton(
                        onPressed: () async {
                          await updatePatient(
                              PatientEmail: emailController.text,
                              PatientName: nameController.text,
                              PatientAge: int.parse(ageController.text),
                              PatientGender: genderController.text,
                              PatientPhoneNumber:
                                  int.parse(phoneNumberController.text),
                              PatientAddress: addressController.text,
                              PatientDateOfBirth: dateOfBirthController.text,
                              PatientWeight: int.parse(weightController.text),
                              PatientHeight: int.parse(heightController.text),
                              PatientBloodType: bloodTypeController.text,
                              PatientHealthHistory:
                                  medicalHistoryController.text);
                        },
                        child: const Text("Edit")),
                  ]);
            } else {
              return const Text("no patient is recorded");
            }
          }),
    );
  }
}
