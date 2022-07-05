import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Containers/side_bar.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_provider.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/prescription_service.dart';

class PrescriptionView extends StatefulWidget {
  const PrescriptionView({Key? key}) : super(key: key);

  @override
  State<PrescriptionView> createState() => _PrescriptionViewState();
}

class _PrescriptionViewState extends State<PrescriptionView> {
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
            backgroundColor: Colors.pink[700],
            title: const Text("Prescription")),
        body: FutureBuilder(
            future: _patient_service.getUser(email: userEmail),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return FutureBuilder(
                      future: _patient_service.getLatestPrescription(),
                      builder: (context,
                          AsyncSnapshot<DataBasePrescription> snapshot) {
                        print(snapshot.data);
                        if (snapshot.hasData) {
                          final prescription =
                              snapshot.data as DataBasePrescription;
                          return Column(
                            children: [
                              Text("date : ${prescription.date}"),
                              Text("doctor name : ${prescription.doctorName}"),
                              Text("prescription id : ${prescription.id}"),
                              Text(
                                  "prescription details : ${prescription.medicineDetail}"),
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      });
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
