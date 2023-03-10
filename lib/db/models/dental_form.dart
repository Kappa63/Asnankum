final String dental_forms_table = 'dental_forms';

class DentalFormFields {
  static final List<String> vals = [id, creationDT,
                                    patientID, firstName, lastName, age, sex,
                                    allergies, desc,
                                    imgPath,
                                    status, appointmentDT, dentistID, dentistName];

  static final String id = "_id";
  static final String creationDT = "creationDT";

  static final String patientID = "patientID";
  static final String firstName = "firstName";
  static final String lastName = "lastName";
  static final String age = "age";
  static final String sex = "sex";

  static final String allergies = "allergies";
  static final String desc = "desc";

  static final String imgPath = "imgPath";

  static final String status = "status";
  static final String appointmentDT = "appointmentDT";
  static final String dentistID = "dentistID";
  static final String dentistName = "dentistName";
}

class DentalForm {
  final int? id;
  final DateTime creationDT;

  final int patientID;
  final String firstName;
  final String lastName;
  final int age;
  final String sex;

  final String? allergies;
  final String desc;

  final String? imgPath;

  final bool status;
  final DateTime? appointmentDT;
  final int? dentistID;
  final String? dentistName; 


  const DentalForm ({
    this.id,
    required this.creationDT,

    required this.patientID,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.sex,

    required this.allergies,
    required this.desc,

    required this.imgPath,

    required this.status,
    required this.appointmentDT,
    required this.dentistID,
    required this.dentistName,
  });

  DentalForm replicate({
    int? id,
    DateTime? creationDT,

    int? patientID,
    String? firstName,
    String? lastName,
    int? age,
    String? sex,

    String? allergies,
    String? desc,

    String? imgPath,

    bool? status,
    DateTime? appointmentDT,
    int? dentistID,
    String? dentistName,
  }) => DentalForm(id: id?? this.id,
                   creationDT: creationDT?? this.creationDT,

                   patientID: patientID?? this.patientID,
                   firstName: firstName?? this.firstName,
                   lastName: lastName?? this.lastName,
                   age: age?? this.age,
                   sex: sex?? this.sex,

                   allergies: allergies?? this.allergies,
                   desc: desc?? this.desc,

                   imgPath: imgPath?? this.imgPath,

                   status: status?? this.status,
                   appointmentDT: appointmentDT==null?this.appointmentDT:(appointmentDT==DateTime.fromMicrosecondsSinceEpoch(9254)?null:appointmentDT),
                   dentistID: dentistID==null?this.dentistID:(dentistID==-785?null:dentistID),
                   dentistName: dentistName==null?this.dentistName:(dentistName=="dbs78s"?null:dentistName),);
             

  static DentalForm Deserialize(Map<String, Object?> dt) => DentalForm(
    id: dt[DentalFormFields.id] as int?,
    creationDT: DateTime.parse(dt[DentalFormFields.creationDT] as String),

    patientID: dt[DentalFormFields.patientID] as int,
    firstName: dt[DentalFormFields.firstName] as String,
    lastName: dt[DentalFormFields.lastName] as String,
    age: dt[DentalFormFields.age] as int,
    sex: dt[DentalFormFields.sex] as String,

    allergies: dt[DentalFormFields.allergies]!=null?dt[DentalFormFields.allergies] as String:null,
    desc: dt[DentalFormFields.desc] as String,

    imgPath: dt[DentalFormFields.imgPath]!=null?dt[DentalFormFields.imgPath] as String:null,

    status: dt[DentalFormFields.status] == 1,
    appointmentDT: dt[DentalFormFields.appointmentDT]!=null?DateTime.parse(dt[DentalFormFields.appointmentDT] as String):null,
    dentistID: dt[DentalFormFields.dentistID]!=null?dt[DentalFormFields.dentistID] as int:null,
    dentistName: dt[DentalFormFields.dentistName]!=null?dt[DentalFormFields.dentistName] as String:null,
  );

  Map<String, Object?> Serialize() => {    
    DentalFormFields.id: id,
    DentalFormFields.creationDT: creationDT.toIso8601String(),

    DentalFormFields.patientID: patientID,
    DentalFormFields.firstName: firstName,
    DentalFormFields.lastName: lastName,
    DentalFormFields.age: age,
    DentalFormFields.sex: sex,

    DentalFormFields.allergies: allergies,
    DentalFormFields.desc: desc,

    DentalFormFields.imgPath: imgPath,

    DentalFormFields.status: status?1:0,
    DentalFormFields.appointmentDT: appointmentDT?.toIso8601String(),
    DentalFormFields.dentistID: dentistID,
    DentalFormFields.dentistName: dentistName,
  };
}