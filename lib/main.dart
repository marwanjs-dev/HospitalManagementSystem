import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Constants/routes.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Views/Login/login_screen.dart';
import 'package:hospitalmanagementsystem/Views/Signup/signup_screen.dart';
import 'package:hospitalmanagementsystem/Views/Welcome/welcome_screen.dart';
import 'package:hospitalmanagementsystem/Views/patient_views/appointment_view.dart';
import 'package:hospitalmanagementsystem/Views/patient_views/chat_view.dart';
import 'package:hospitalmanagementsystem/Views/patient_views/diagnosis_view.dart';
import 'package:hospitalmanagementsystem/Views/home_page.dart';
import 'package:hospitalmanagementsystem/Views/Login/login_view.dart';
import 'package:hospitalmanagementsystem/Views/patient_views/edit_patient_view.dart';
import 'package:hospitalmanagementsystem/Views/patient_views/new_diagnosis.dart';
import 'package:hospitalmanagementsystem/Views/patient_views/patient_record_view.dart';
import 'package:hospitalmanagementsystem/Views/patient_views/prescription_view.dart';
import 'package:hospitalmanagementsystem/Views/Signup/register_view.dart';
import 'package:hospitalmanagementsystem/Views/verify_email_view.dart';

// const chatRoute = '/chat/';
// const prescriptionRoute = '/prescription/';
// const diagnosisRoute = '/diagnosis/';
// const appointmentRoute = '/appointment/';
// const patientRecordRoute = '/patient_record/';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'My App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const WelcomeScreen(),
    routes: {
      loginRoute: (context) => const LoginScreen(),
      registerRoute: (context) => const SignUpScreen(),
      homeRoute: (context) => const HomePage2(),
      VerifyEmailRoute: (context) => const VerifyEmailView(),
      chatRoute: (context) => const ChatView(),
      prescriptionRoute: (context) => const PrescriptionView(),
      diagnosisRoute: (context) => const DiagnosisView(),
      appointmentRoute: (context) => const AppointmentView(),
      patientRecordRoute: (context) => const PatientRecord(),
      editPatientRoute: (context) => const EditPatient(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                return const LoginView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
