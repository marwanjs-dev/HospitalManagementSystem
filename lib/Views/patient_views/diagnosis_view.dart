import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Containers/diagnosis_card.dart';
import 'package:hospitalmanagementsystem/Containers/side_bar.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_provider.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/diagnosis_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';

class DiagnosisView extends StatefulWidget {
  const DiagnosisView({Key? key}) : super(key: key);

  @override
  State<DiagnosisView> createState() => _DiagnosisViewState();
}

class _DiagnosisViewState extends State<DiagnosisView> {
  late final PatientService _patient_service;
  late final TextEditingController _textController;

  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _patient_service = PatientService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const NavDrawer(),
        appBar: AppBar(
            backgroundColor: Colors.pink[700], title: const Text("Diagnosis")),
        body: FutureBuilder(
            future: _patient_service.getUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StreamBuilder(
                    stream: _patient_service.allDiagnosis,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          if (snapshot.hasData) {
                            final allDiagnosis =
                                snapshot.data as List<DataBaseDiagnosis>;
                            return ListView.builder(
                              itemCount: allDiagnosis.length,
                              itemBuilder: (context, index) {
                                final diagnosis = allDiagnosis[index];
                                return ListTile(
                                  title: Text(
                                      " date: ${diagnosis.date}, \n diagnosis details: ${diagnosis.diagnosisDetail}, \n doctor ${diagnosis.doctorName}, \n diagnosis id: ${diagnosis.id}"),
                                );
                              },
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        default:
                          return const CircularProgressIndicator();
                      }
                    },
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
