// ignore_for_file: camel_case_types
import 'constants.dart';

class DataBaseAppointment {
  final int patientID;
  final int id;
  final String date;
  final int attendance;

  DataBaseAppointment(
      {required int this.attendance,
      required String this.date,
      required int this.id,
      required int this.patientID});

  DataBaseAppointment.fromRow(Map<String, Object?> map)
      : patientID = map[appointmentPatientIDColumn] as int,
        id = map[appointmentIDColumn] as int,
        date = map[appointmentDateColumn] as String,
        attendance = map[appointmentAttendanceColumn] as int;
  // isSyncedWithCloud =
  //     (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      "Note, patientID= $patientID, id =$id, date = $date, attendance = $attendance";

  @override
  bool operator ==(covariant DataBaseAppointment other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
