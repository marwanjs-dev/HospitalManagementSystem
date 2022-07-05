// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hospitalmanagementsystem/Constants/routes.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_exceptions.dart';
import 'package:hospitalmanagementsystem/Services/auth/auth_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/database_user.dart';
import 'package:hospitalmanagementsystem/Services/curd/patient_service.dart';
import 'package:hospitalmanagementsystem/utilities/show_error_dialog.dart';
import 'dart:developer' as devtools show log;

import '../../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final PatientService _patientService;
  late final TextEditingController _email;
  //late means that the variable will have a value later in the code but for now it is null
  late final TextEditingController _password;

  late final TextEditingController patientEmailController,
      patientNameController,
      patientAgeController,
      patientGenderController,
      patientPhoneNumberController,
      patientAddressController,
      patientBloodTypeController,
      patientWeightController,
      patientHeightController,
      patientDateOfBirthController,
      patientHealthHistoryController;

  @override
  void initState() {
    _patientService = PatientService();
    _email = TextEditingController();
    _password = TextEditingController();
    patientEmailController = TextEditingController();
    patientNameController = TextEditingController();
    patientAgeController = TextEditingController();
    patientGenderController = TextEditingController();
    patientPhoneNumberController = TextEditingController();
    patientAddressController = TextEditingController();
    patientBloodTypeController = TextEditingController();
    patientWeightController = TextEditingController();
    patientHeightController = TextEditingController();
    patientDateOfBirthController = TextEditingController();
    patientHealthHistoryController = TextEditingController();
    super.initState();
  }

  Future<DataBaseUser> createNewPatient(
      {required String PatientEmail,
      required String PatientName,
      required int PatientAge,
      required String PatientGender,
      required int PatientPhoneNumber,
      required String PatientAddress,
      String? PatientBloodType,
      int? PatientWeight,
      int? PatientHeight,
      required String PatientDateOfBirth,
      String? PatientHealthHistory}) async {
    return await _patientService.createPatient(
      patientEmail: PatientEmail,
      patientName: PatientName,
      patientAge: PatientAge,
      patientGender: PatientGender,
      patientPhoneNumber: PatientPhoneNumber,
      patientAddress: PatientAddress,
      patientBloodType: PatientBloodType,
      patientWeight: PatientWeight,
      patientHeight: PatientHeight,
      patientDateOfBirth: PatientDateOfBirth,
      patientHealthHistory: PatientHealthHistory,
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[700],
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BackButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginRoute, (route) => false);
              },
            )
          ],
        ),
        title: const Text("Register page"),
      ),
      body: ListView(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email address",
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          TextField(
            controller: patientNameController,
            decoration: const InputDecoration(hintText: "input patient name"),
          ),
          TextField(
            controller: patientAgeController,
            decoration: const InputDecoration(hintText: "input age"),
          ),
          TextField(
            controller: patientGenderController,
            decoration: const InputDecoration(hintText: "input gender"),
          ),
          TextField(
            controller: patientPhoneNumberController,
            decoration: const InputDecoration(hintText: "input phoneNumber"),
          ),
          TextField(
            controller: patientAddressController,
            decoration: const InputDecoration(hintText: "input address"),
          ),
          TextField(
            controller: patientBloodTypeController,
            decoration: const InputDecoration(hintText: "input blood type"),
          ),
          TextField(
            controller: patientWeightController,
            decoration: const InputDecoration(hintText: "input weight"),
          ),
          TextField(
            controller: patientHeightController,
            decoration: const InputDecoration(hintText: "input height"),
          ),
          TextField(
            controller: patientDateOfBirthController,
            decoration: const InputDecoration(hintText: "input DOB"),
          ),
          TextField(
            controller: patientHealthHistoryController,
            decoration: const InputDecoration(hintText: "input health history"),
          ),
          TextButton(
              onPressed: () async {
                await createNewPatient(
                    PatientEmail: _email.text,
                    PatientName: patientNameController.text,
                    PatientAge: int.parse(patientAgeController.text),
                    PatientGender: patientGenderController.text,
                    PatientPhoneNumber:
                        int.parse(patientPhoneNumberController.text),
                    PatientAddress: patientAddressController.text,
                    PatientDateOfBirth: patientDateOfBirthController.text,
                    PatientBloodType: patientBloodTypeController.text,
                    PatientWeight: int.parse(patientWeightController.text),
                    PatientHeight: int.parse(patientHeightController.text),
                    PatientHealthHistory: patientHealthHistoryController.text);

                await AuthService.firebase().initialize();

                final email = _email.text;
                final password = _password.text;
                try {
                  final userCredential =
                      await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  await AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(VerifyEmailRoute);
                } on WeakPasswordAuthException {
                  showErrorDialog(context, "weak password");
                } on EmailAlreadyInUseAuthException {
                  showErrorDialog(context, "email already in use");
                } on InvalidEmailAuthException {
                  showErrorDialog(context, "invalid email");
                } on GenericAuthException {
                  showErrorDialog(context, "Failed to Register");
                }
              },
              child: const Text("Register")),
        ],
      ),
    );
  }
}
