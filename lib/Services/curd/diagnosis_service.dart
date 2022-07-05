// ignore_for_file: camel_case_types

import 'constants.dart';

class DataBaseDiagnosis {
  final int patientID;
  final int id;
  final String diagnosisDetail;
  final String doctorName;
  final String date;

  DataBaseDiagnosis(
      {required String this.doctorName,
      required String this.diagnosisDetail,
      required int this.id,
      required int this.patientID,
      required String this.date});

  DataBaseDiagnosis.fromRow(Map<String, Object?> map)
      : patientID = map[diagnosisPatientIDColumn] as int,
        id = map[diagnosisIDColumn] as int,
        diagnosisDetail = map[diagnosisDetailColumn] as String,
        doctorName = map[diagnosisDoctorNameColumn] as String,
        date = map[diagnosisDateColumn] as String;

  @override
  String toString() =>
      "Note, patientID= $patientID, id =$id, diagnosisDetails = $diagnosisDetail, doctorName = $doctorName";

  @override
  bool operator ==(covariant DataBaseDiagnosis other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
