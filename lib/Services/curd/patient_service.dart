// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hospitalmanagementsystem/Services/curd/diagnosis_service.dart';
import 'package:hospitalmanagementsystem/Services/curd/prescription_service.dart';
import "package:sqflite/sqflite.dart";
import "package:path_provider/path_provider.dart";
import 'package:path/path.dart' show join;

import 'appointment_service.dart';
import 'constants.dart';
import 'database_user.dart';
import 'exeptions.dart';

class PatientService {
  Database? _db;

  List<DataBaseDiagnosis> _diagnosis = [];

  static final PatientService _shared = PatientService._sharedInstance();

  PatientService._sharedInstance() {
    _diagnosisStreamController =
        StreamController<List<DataBaseDiagnosis>>.broadcast(onListen: () {
      _diagnosisStreamController.sink.add(_diagnosis);
    });
  }
  factory PatientService() => _shared;

  late final StreamController<List<DataBaseDiagnosis>>
      _diagnosisStreamController;

  Stream<List<DataBaseDiagnosis>> get allDiagnosis =>
      _diagnosisStreamController.stream;

  Future<DataBaseUser> getOrCreateUser({required String email}) async {
    try {
      final patient = await getUser(email: email);
      return patient;
    } on CouldNotFindUser {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheDiagnosis() async {
    final allDiagnosis = await getAllDiagnosis();
    _diagnosis = allDiagnosis.toList();
    _diagnosisStreamController.add(_diagnosis);
  }

  Future<DataBasePrescription> createPrescription(DataBaseUser Patient,
      {required int PrescriptionId,
      required String MedicineDetail,
      required String DoctorName,
      required String Date}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbPatient = await getUser(email: Patient.email);
    if (dbPatient != Patient) {
      throw CouldNotFindUser();
    }

    final diagnosisID = await db.insert(prescriptionTable, {
      prescriptionIDColumn: PrescriptionId,
      prescriptionPatientIDColumn: Patient.id,
      prescriptionMedicineDetail: MedicineDetail,
      prescriptionDoctorNameColumn: DoctorName,
      prescriptionDateColumn: Date
    });
    final prescription = DataBasePrescription(
        doctorName: DoctorName,
        patientID: Patient.id,
        id: PrescriptionId,
        date: Date,
        medicineDetail: MedicineDetail);

    return prescription;
  }

  Future<DataBaseDiagnosis> createDiagnosis(DataBaseUser Patient,
      {required int DiagnosisId,
      required String Detail,
      required String DoctorName,
      required String Date}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbPatient = await getUser(email: Patient.email);
    if (dbPatient != Patient) {
      throw CouldNotFindUser();
    }

    final diagnosisID = await db.insert(diagnosisTable, {
      diagnosisIDColumn: DiagnosisId,
      diagnosisPatientIDColumn: Patient.id,
      diagnosisDetailColumn: Detail,
      diagnosisDoctorNameColumn: DoctorName,
      diagnosisDateColumn: Date
    });
    final diagnosis = DataBaseDiagnosis(
        doctorName: DoctorName,
        patientID: Patient.id,
        id: DiagnosisId,
        date: Date,
        diagnosisDetail: Detail);

    _diagnosis.add(diagnosis);
    _diagnosisStreamController.add(_diagnosis);

    return diagnosis;
  }

  Future<DataBaseUser> updateUser(
      {required String patientEmail,
      required String patientName,
      required int patientAge,
      required String patientGender,
      required int patientPhoneNumber,
      required String patientAddress,
      String? patientBloodType,
      int? patientWeight,
      int? patientHeight,
      required String patientDateOfBirth,
      String? patientHealthHistory}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final updateCount = await db.update(patientTable, {
      emailColumn: patientEmail.toLowerCase(),
      nameColumn: patientName.toLowerCase(),
      ageColumn: patientAge,
      genderColumn: patientGender.toLowerCase(),
      phoneNumberColumn: patientPhoneNumber,
      addressColumn: patientAddress.toLowerCase(),
      bloodTypeColumn: patientBloodType?.toLowerCase(),
      weightColumn: patientWeight,
      heightColumn: patientHeight,
      dateOfBirthColumn: patientDateOfBirth,
      healthHistoryColumn: patientHealthHistory?.toLowerCase()
    });

    if (updateCount == 0) {
      throw CouldNotUpdatePatient();
    } else {
      return await getUser(email: patientEmail);
    }
  }

  Future<DataBasePrescription> getLatestPrescription() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final latestPrescription =
        await db.query(prescriptionTable, orderBy: prescriptionDateColumn);

    return DataBasePrescription.fromRow(latestPrescription.last);
  }

  Future<Iterable<DataBaseDiagnosis>> getAllDiagnosis() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final diagnosis =
        await db.query(diagnosisTable, orderBy: diagnosisDateColumn);

    return diagnosis
        .map((diagnosisRow) => DataBaseDiagnosis.fromRow(diagnosisRow));
  }

  Future<DataBaseAppointment> getAppointment({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final appointments = await db
        .query(appointmentTable, limit: 1, where: 'id = ?', whereArgs: [id]);

    if (appointments.isEmpty) {
      throw CouldNotFindAppointment();
    } else {
      return DataBaseAppointment.fromRow(appointments.first);
    }
  }

  Future<void> deleteAppointment({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      appointmentTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (deletedCount == 0) {
      throw CouldNotDeleteAppointment();
    }
  }

  Future<DataBaseAppointment> createAppointment(DataBaseUser patient,
      {required String Date}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final dbPatient = await getUser(email: patient.email);
    if (dbPatient != patient) {
      throw CouldNotFindUser();
    }

    final appointmentID = await db.insert(appointmentTable, {
      appointmentPatientIDColumn: patient.id,
      appointmentDateColumn: Date,
      appointmentAttendanceColumn: 0
    });
    final appointment = DataBaseAppointment(
        patientID: patient.id, id: appointmentID, date: Date, attendance: 0);

    return appointment;
  }

  Future<DataBaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      patientTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DataBaseUser.fromRow(results.first);
    }
  }

  Future<DataBaseUser> createPatient(
      {required String patientEmail,
      required String patientName,
      required int patientAge,
      required String patientGender,
      required int patientPhoneNumber,
      required String patientAddress,
      String? patientBloodType,
      int? patientWeight,
      int? patientHeight,
      required String patientDateOfBirth,
      String? patientHealthHistory}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      patientTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [patientEmail.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw userAlreadyExists();
    }

    final patientID = await db.insert(patientTable, {
      emailColumn: patientEmail.toLowerCase(),
      nameColumn: patientName.toLowerCase(),
      ageColumn: patientAge,
      genderColumn: patientGender.toLowerCase(),
      phoneNumberColumn: patientPhoneNumber,
      addressColumn: patientAddress.toLowerCase(),
      bloodTypeColumn: patientBloodType?.toLowerCase(),
      weightColumn: patientWeight,
      heightColumn: patientHeight,
      dateOfBirthColumn: patientDateOfBirth,
      healthHistoryColumn: patientHealthHistory?.toLowerCase()
    });

    return DataBaseUser(
        bloodType: patientBloodType,
        weight: patientWeight,
        height: patientHeight,
        healthHistory: patientHealthHistory,
        name: patientName,
        age: patientAge,
        gender: patientGender,
        phoneNumber: patientPhoneNumber,
        address: patientAddress,
        dateOfBirth: patientDateOfBirth,
        id: patientID,
        email: patientEmail);
  }

  Future<void> deletePatient({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      patientTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) {
      throw couldNotDeletePatientException();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw databaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;

    if (db == null) {
      throw databaseIsNotOpenException();
    } else {
      await db.close();
    }
  }

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      print("nothing");
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dPath = join(docsPath.path, dbName);
      final db = await openDatabase(dPath);
      _db = db;

      await db.execute(createPatientTable);

      await db.execute(createAppointmentTable);

      await db.execute(createDiagnosisTable);

      await db.execute(createPrescriptionTable);

      await _cacheDiagnosis();
    } on MissingPlatformDirectoryException {
      throw unableToGetDocumentDirectoryException();
    }
  }
}
