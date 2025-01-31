import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

String idColumn = "idColumn";
String nameColumn = "nameColumn";
String phoneColumn = "phoneColumn";
String emailColumn = "emailColumn";
String imgColumn = "imgColumn";
String contactTable = "contactTable";

class ContactHelper{
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();
  Database _db;

  Future<Database> get db async{
    if(_db != null){
      return _db;
    }else{
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "contacts.db");
    return await openDatabase(path, version: 1, onCreate: (Database db, int newVersion) async{
      await db.execute("CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $emailColumn TEXT, $phoneColumn TEXT, $imgColumn TEXT)");
    
      
    },
    );
  }

  Future<List> getAllContacts() async{
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<Contact> getContact(int id) async{
     Database dbContact = await db;
     List<Map> maps = await dbContact.query(contactTable,
     columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
     where: "$idColumn = ?", whereArgs: [id]);
     if(maps.isNotEmpty){
      return Contact.fromMap(maps.first);
     }else{
      return null;
     }
  }

  Future<Contact> saveContact(Contact contact) async{
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<int> updateContact(Contact contact) async{
    Database dbContact = await db;
    return await dbContact.update(contactTable, contact.toMap(),
    where: "$idColumn = ?", whereArgs:[contact.id]);
  }

  Future<int> deleteContact(int id) async{
    Database dbContact = await db;
    return await dbContact.delete(contactTable,
    where: "$idColumn = ?", whereArgs:[id]);
  }
}

class Contact{
  Contact();

  int id;
  String name;
  String email;
  String phone;
  String img;


  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    email = map[emailColumn];
    phone = map[phoneColumn];
    img = map[imgColumn];
  } 

  Map toMap(){
    Map<String, dynamic> map = {
      nameColumn : name,
      emailColumn : email,
      phoneColumn : phone,
      imgColumn : img
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString(){
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}