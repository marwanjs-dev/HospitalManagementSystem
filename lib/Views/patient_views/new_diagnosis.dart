import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Containers/side_bar.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/diagnosis_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';

class NewDiagnosisView extends StatefulWidget {
  const NewDiagnosisView({Key? key}) : super(key: key);

  @override
  State<NewDiagnosisView> createState() => _NewDiagnosisViewState();
}

class _NewDiagnosisViewState extends State<NewDiagnosisView> {
  DataBaseDiagnosis? _diagnosis;
  late final PatientService _patient_service;
  late final TextEditingController _text_editing_controller,
      dateController,
      doctorNameController,
      detailController,
      diagnosisIDController;

  @override
  void initState() {
    _patient_service = PatientService();
    _text_editing_controller = TextEditingController();
    dateController = TextEditingController();
    doctorNameController = TextEditingController();
    detailController = TextEditingController();
    diagnosisIDController = TextEditingController();
    super.initState();
  }

  Future<DataBaseDiagnosis> createDiagnosis(
      {required String date,
      required String doctorName,
      required String detail,
      required int diagnosisId}) async {
    final _existingDiagnosis = _diagnosis;
    if (_existingDiagnosis != null) {
      return _existingDiagnosis;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final patient = await _patient_service.getUser(email: email);
    return await _patient_service.createDiagnosis(patient,
        Date: date,
        DoctorName: doctorName,
        Detail: detail,
        DiagnosisId: diagnosisId);
  }

  @override
  void dispose() {
    _text_editing_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.pink[700],
          title: const Text("Add NewDiagnosis"),
        ),
        body: Column(
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(hintText: "input date"),
            ),
            TextField(
              controller: doctorNameController,
              decoration: const InputDecoration(hintText: "input doctor name"),
            ),
            TextField(
              controller: detailController,
              decoration:
                  const InputDecoration(hintText: "input diagnosis details"),
            ),
            TextField(
              controller: diagnosisIDController,
              decoration: const InputDecoration(hintText: "input diagnosis id"),
            ),
            FutureBuilder(
              future: createDiagnosis(
                date: dateController.text,
                doctorName: doctorNameController.text,
                detail: detailController.text,
                diagnosisId: int.parse(diagnosisIDController.text),
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    _diagnosis = snapshot.data as DataBaseDiagnosis;
                    return const Text("success");
                  default:
                    return const CircularProgressIndicator();
                }
              },
            )
          ],
        ));
  }
}
