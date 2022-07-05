import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Containers/side_bar.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/appointment_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';
import 'package:intl/intl.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({Key? key}) : super(key: key);

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  var _currencies = [
    "10",
    "11"
        "12",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8"
  ];
  DataBaseAppointment? _appointment;
  late final PatientService _patient_service;
  late final TextEditingController _textController;
  TextEditingController dateinput = TextEditingController();
  String _currentSelectedValue = '';

  @override
  void initState() {
    dateinput.text = "";
    _patient_service = PatientService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DataBaseAppointment> createNewAppointment(
      {required String date}) async {
    final _existingAppointment = _appointment;
    if (_existingAppointment != null) {
      return _existingAppointment;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final patient = await _patient_service.getUser(email: email);
    return await _patient_service.createAppointment(patient,
        Date: date); //needs refactoring
  }

  void _deleteAppointment() {
    final appointment = _appointment;
    if (_textController.text.isEmpty && appointment != null) {
      _patient_service.deleteAppointment(id: appointment.id);
    }
  }

  @override
  void dispose() {
    _deleteAppointment();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.pink[700],
        title: const Text("Appointment"),
      ),
      body: ListView(children: [
        Column(
          children: [
            TextField(
                controller: dateinput,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today), labelText: "Enter Date"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101));
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(pickedDate.toString());
                    setState(() {
                      dateinput.text = formattedDate;
                    });
                    print(dateinput.text.toString());
                  } else {
                    print("Date is not selected");
                  }
                }),
            TextField(
              decoration: InputDecoration(hintText: "input time"),
            ),
            TextButton(
                onPressed: () async {
                  await createNewAppointment(date: dateinput.text.toString());
                },
                child: const Text("reserve appointment"))
          ],
        )
      ]),
    );
  }
}
