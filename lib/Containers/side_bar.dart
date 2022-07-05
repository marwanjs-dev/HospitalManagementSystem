import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Constants/routes.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(homeRoute, (route) => false)
            },
          ),
          ListTile(
            leading: const Icon(Icons.data_object),
            title: const Text('Patient Record'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(patientRecordRoute, (route) => false)
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_information),
            title: const Text('Prescription'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(prescriptionRoute, (route) => false)
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_center),
            title: const Text('Diagnosis'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(diagnosisRoute, (route) => false)
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(chatRoute, (route) => false)
            },
          ),
          ListTile(
            leading: const Icon(Icons.meeting_room),
            title: const Text('Appointment'),
            onTap: () => {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(appointmentRoute, (route) => false)
            },
          ),
        ],
      ),
    );
  }
}
