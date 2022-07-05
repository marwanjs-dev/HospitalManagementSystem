// database name
const dbName = "patient_care.db";

//Patient Table
const patientTable = "patient_record";
const idColumn = "id";
const emailColumn = "email";
const nameColumn = 'name';
const ageColumn = 'age';
const genderColumn = 'gender';
const phoneNumberColumn = 'phone_number';
const addressColumn = 'address';
const bloodTypeColumn = 'blood_type';
const weightColumn = 'weight';
const heightColumn = 'height';
const dateOfBirthColumn = 'date_of_birth';
const healthHistoryColumn = 'health_history';

const createPatientTable = '''
          CREATE TABLE IF NOT EXISTS "patient_record" (
          "name"	TEXT NOT NULL,
          "id"	INTEGER NOT NULL UNIQUE,
          "age"	INTEGER NOT NULL,
          "gender"	TEXT NOT NULL,
          "phone_number"	INTEGER NOT NULL,
          "address"	TEXT NOT NULL,
          "email"	TEXT NOT NULL,
          "blood_type"	TEXT NOT NULL,
          "weight"	INTEGER,
          "height"	INTEGER,
          "date_of_birth"	TEXT NOT NULL,
          "health_history"	INTEGER,
          PRIMARY KEY("id" AUTOINCREMENT)
        );
      ''';

//appointment Table
const appointmentPatientIDColumn = "patient_id";
const appointmentIDColumn = "appointment_id";
const appointmentDateColumn = "date";
const appointmentAttendanceColumn = "attendance";
const appointmentTable = "appointment";

const createAppointmentTable = '''
        CREATE TABLE IF NOT EXISTS "appointment" (
        "patient_id"	INTEGER NOT NULL,
        "appointment_id"	INTEGER NOT NULL UNIQUE,
        "date"	TEXT NOT NULL,
        "attendance"	INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY("patient_id") REFERENCES "patient_record"("id"),
        PRIMARY KEY("appointment_id" AUTOINCREMENT)
        );
      ''';

//diagnosis table
const diagnosisTable = "diagnosis";
const diagnosisIDColumn = 'id';
const diagnosisPatientIDColumn = 'patient_id';
const diagnosisDetailColumn = 'text';
const diagnosisDoctorNameColumn = 'doctor_name';
const diagnosisDateColumn = 'date';

const createDiagnosisTable = ''' 
 CREATE TABLE IF NOT EXISTS "diagnosis" (
	"id"	INTEGER NOT NULL UNIQUE,
	"patient_id"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL,
	"doctor_name"	TEXT NOT NULL,
	"date"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("patient_id") REFERENCES "patient_record"("id")
);
''';

// prescription table
const prescriptionTable = 'prescription';
const prescriptionIDColumn = 'id';
const prescriptionPatientIDColumn = 'patient_id';
const prescriptionDoctorNameColumn = 'doctor_name';
const prescriptionMedicineDetail = 'medicine_detail';
const prescriptionDateColumn = 'date';

const createPrescriptionTable = ''' 
  CREATE TABLE IF NOT EXISTS "diagnosis" (
	"id"	INTEGER NOT NULL UNIQUE,
	"patient_id"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL,
	"doctor_name"	TEXT NOT NULL,
	"date"	TEXT NOT NULL,
	PRIMARY KEY("id"),
	FOREIGN KEY("patient_id") REFERENCES "patient_record"("id")
);
''';

// const demanded = '''

// ALTER TABLE prescription 
// ADD COLUMN "date" TEXT NOT NULL DEFAULT 0;


// ''';
