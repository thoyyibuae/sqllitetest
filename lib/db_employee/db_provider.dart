import 'dart:io';
import 'dart:math';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:whiterabittest/model/employee_list_model.dart';

class DBProvider {
  static Database? _database;
  static DBProvider db = DBProvider._();

  DBProvider._();

  // Insert employee on database
  createEmployee(EmployeeListModel? newEmployee) async {
    final db = await database;

    var result = await db!.rawQuery(
      'SELECT EXISTS(SELECT 1 FROM Employee WHERE id="${newEmployee!.id}")',
    );
    int? exists = Sqflite.firstIntValue(result);

    if (exists != 1) {
      await db.insert(
        'Employee',
        newEmployee.toMap2(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      newEmployee.address!.employee_id = newEmployee.id;
      await db.insert(
        'Address',
        newEmployee.address!.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      if (newEmployee.company != null) {
        newEmployee.company!.employee_id = newEmployee.id;
        await db.insert(
          'Company',
          newEmployee.company!.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
  }

// get All employees
  Future<List<EmployeeListModel>> getAllEmployees() async {
    final db = await database;

    // Query the table for all The Employee.

    final List<Map<String, dynamic>> maps = await db!.rawQuery(''
        'select e.*,c.name as cname,a.street as street  from employee e inner join company c inner join address a where  a.employee_id=e.id and e.id=c.employee_id;'
        '');

    // Convert the List<Map<String, dynamic> into a List<EmployeeListModel>.
    return List.generate(maps.length, (i) {
      maps.forEach((element) {
        print(element);
      });
      var add = Address(
          city: maps[i]['city'],
          employee_id: maps[i]['employee_id'],
          street: maps[i]['street'],
          suite: maps[i]['suite'],
          zipcode: maps[i]['zipcode']);

      var company = Company(
        employee_id: maps[i]['employee_id'],
        cname: maps[i]['cname'],
        bs: maps[i]['bs'],
        catchPhrase: maps[i]['catchPhrase'],
      );

      return EmployeeListModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        username: maps[i]['username'],
        email: maps[i]['email'],
        address: add,
        profileImage: maps[i]['profile_image'],
        phone: maps[i]['phone'],
        website: maps[i]['website'],
        company: company,
      );
    });
  }

// seacrh employee by keyword is email or name
  Future<List<EmployeeListModel>> getAllEmployeesBySearch(
      String keyword) async {
    final db = await database;

    //Search Query the table for all The Employee.
    final List<Map<String, dynamic>> maps = await db!.rawQuery(
      ''
      'select e.*,c.name as cname,a.street as street   from employee e inner join company c inner join address a where  a.employee_id=e.id and e.id=c.employee_id and (e.name like "%${keyword}%" or e.email like "%${keyword}%");'
      '',
    );

    // Convert the List<Map<String, dynamic> into a List<EmployeeListModel>.
    return List.generate(maps.length, (i) {
      var add = Address(
          city: maps[i]['city'],
          employee_id: maps[i]['employee_id'],
          street: maps[i]['street'],
          suite: maps[i]['suite'],
          zipcode: maps[i]['zipcode']);

      var company = new Company(
        employee_id: maps[i]['employee_id'],
        cname: maps[i]['cname'],
        bs: maps[i]['bs'],
        catchPhrase: maps[i]['catchPhrase'],
      );

      return EmployeeListModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        username: maps[i]['username'],
        email: maps[i]['email'],
        address: add,
        profileImage: maps[i]['profile_image'],
        phone: maps[i]['phone'],
        website: maps[i]['website'],
        company: company,
      );
    });
  }

//to check db is exsit or not
  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) {
      return _database;
    } else {
      // If database don't exists, create one
      _database = await initDB();

      return _database;
    }
  }

  // Create the database and the Employee table
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'employees.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Employee (id INTEGER PRIMARY KEY, name TEXT,username TEXT, email TEXT, phone TEXT, profile_image TEXT,website TEXT )');

      await db.execute(
          'CREATE TABLE IF NOT EXISTS Address (id INTEGER PRIMARY KEY,employee_id INTEGER, street TEXT, suite TEXT,city TEXT, zipcode TEXT,FOREIGN KEY(employee_id) REFERENCES Employee(id))');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Company (id INTEGER PRIMARY KEY,employee_id INTEGER, name TEXT, bs TEXT,catchPhrase TEXT, FOREIGN KEY(employee_id) REFERENCES Employee(id))');
    });
  }
}
