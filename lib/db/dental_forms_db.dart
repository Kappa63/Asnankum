import 'package:dental_care/db/models/dental_form.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer';

class DentalFormsDB {
  static final DentalFormsDB db_I = DentalFormsDB._init();

  static Database? _db;

  DentalFormsDB._init();

  Future<Database> get db async {
    if(_db != null) return _db!;

    _db = await _initDB("dentalForms.db");
    return _db!;
  }

  Future<Database> _initDB(String f_name) async {
    final db_path = await getDatabasesPath();
    final file_path = join(db_path, f_name); 
    log(file_path);
    return await openDatabase(file_path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db_, int v) async {
    log("creating...");
    await db_.execute('''CREATE TABLE $dental_forms_table (
                            ${DentalFormFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
                            ${DentalFormFields.creationDT} TEXT NOT NULL,

                            ${DentalFormFields.patientID} INTEGER NOT NULL,
                            ${DentalFormFields.firstName} TEXT NOT NULL,
                            ${DentalFormFields.lastName} TEXT NOT NULL,
                            ${DentalFormFields.age} INTEGER NOT NULL,
                            ${DentalFormFields.sex} TEXT NOT NULL,

                            ${DentalFormFields.allergies} TEXT,
                            ${DentalFormFields.desc} TEXT NOT NULL,

                            ${DentalFormFields.imgPath} TEXT NOT NULL,

                            ${DentalFormFields.status} BOOLEAN NOT NULL,
                            ${DentalFormFields.appointmentDT} TEXT,
                            ${DentalFormFields.dentistID} INTEGER,
                            ${DentalFormFields.dentistName} TEXT
                         )''');
  }

  Future<DentalForm> insert(DentalForm form) async {
    final db_ = await db_I.db;

    final id = await db_.insert(dental_forms_table, form.Serialize());

    return form.replicate(id: id);
  }

  Future<DentalForm> getForm_byID(int id) async {
    final db_ = await db_I.db;

    final form = await db_.query(dental_forms_table, columns: DentalFormFields.vals, 
                                where: "${DentalFormFields.id} = ?", whereArgs: [id]);

    if(form.isEmpty)
      throw Exception("Id $id not Found");
      
    return DentalForm.Deserialize(form.first);
  }

  Future<List<DentalForm>?> getForm_byDrID(int? dID) async {
    final db_ = await db_I.db;

    final forms = await db_.query(dental_forms_table, columns: DentalFormFields.vals, 
                                where: "${DentalFormFields.dentistID} = ?", whereArgs: [dID]);    
    
    return forms.isEmpty?null:forms.map((e) => DentalForm.Deserialize(e)).toList();
  }

  Future<List<DentalForm>?> getForm_byPatientID(int? pID) async {
    final db_ = await db_I.db;

    final forms = await db_.query(dental_forms_table, columns: DentalFormFields.vals, 
                                where: "${DentalFormFields.patientID} = ?", whereArgs: [pID]);    
    
    return forms.isEmpty?null:forms.map((e) => DentalForm.Deserialize(e)).toList();
  }

  Future<int> update(DentalForm form) async {
    final db_ = await db_I.db;

    return db_.update(dental_forms_table, form.Serialize(), 
                      where: "${DentalFormFields.id} = ?", whereArgs: [form.id]);
  }

  Future<int> delete(int id) async {
    final db_ = await db_I.db;

    return await db_.delete(dental_forms_table, where: "${DentalFormFields.id} = ?", whereArgs: [id]);
  }

  Future close() async {
    final db_ = await db_I.db;

    db_.close;
  }
}