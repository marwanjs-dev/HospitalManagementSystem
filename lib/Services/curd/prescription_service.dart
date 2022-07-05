import 'constants.dart';

class DataBasePrescription {
  final int patientID;
  final int id;
  final String medicineDetail;
  final String doctorName;
  final String date;

  DataBasePrescription(
      {required String this.doctorName,
      required String this.medicineDetail,
      required int this.id,
      required int this.patientID,
      required String this.date});

  DataBasePrescription.fromRow(Map<String, Object?> map)
      : patientID = map[prescriptionPatientIDColumn] as int,
        id = map[prescriptionIDColumn] as int,
        medicineDetail = map[prescriptionMedicineDetail] as String,
        doctorName = map[prescriptionDoctorNameColumn] as String,
        date = map[prescriptionDateColumn] as String;

  @override
  String toString() =>
      "Note, patientID= $patientID, id =$id, medicineDetail = $medicineDetail, doctorName = $doctorName, date = $date ";

  @override
  bool operator ==(covariant DataBasePrescription other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
