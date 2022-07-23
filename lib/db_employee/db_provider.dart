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

    await db!.insert(
      'Employee',
      newEmployee!.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await db.insert(
      'Address',
      newEmployee.address!.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await db.insert(
      'Company',
      newEmployee.company!.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// get All employees
  Future<List<EmployeeListModel>> getAllEmployees() async {
    final db = await database;

    // Query the table for all The Employee.
    final List<Map<String, dynamic>> maps = await db!.query('Employee');

    // Convert the List<Map<String, dynamic> into a List<EmployeeListModel>.
    return List.generate(maps.length, (i) {
      return EmployeeListModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        username: maps[i]['username'],
        email: maps[i]['email'],
        address: maps[i]['address'],
        profileImage: maps[i]['profile_image'],
        phone: maps[i]['phone'],
        website: maps[i]['website'],
        company: maps[i]['company'],
      );
    });
  }

  //get employees address
  Future<List<Address>> getAllEmployeesAddress() async {
    final db = await database;

    // Query the table for all The Employees
    final List<Map<String, dynamic>> maps = await db!.query('Address');

    // Convert the List<Map<String, dynamic> into a List<EmployeeListModel>.
    return List.generate(maps.length, (i) {
      return Address(
        street: maps[i]['street'],
        suite: maps[i]['suite'],
        city: maps[i]['city'],
        zipcode: maps[i]['zipcode'],
      );
    });
  }

  //get employees company
  Future<List<Company>> getAllEmployeesCompany() async {
    final db = await database;

    // Query the table for all The Employees
    final List<Map<String, dynamic>> maps = await db!.query('Company');

    // Convert the List<Map<String, dynamic> into a List<EmployeeListModel>.
    return List.generate(maps.length, (i) {
      return Company(
          name: maps[i]['name'],
          catchPhrase: maps[i]['catchPhrase'],
          bs: maps[i]['bs']);
    });
  }

  // search employee
  Future<List<EmployeeListModel>> searchQuery(String? keyword) async {
    // get a reference to the database
    Database? db = await database;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db!.query('Employee',
        columns: [
          'name',
          'id',
          'username',
          'email',
          'phone',
          'profile_image',
          'website'
        ],
        whereArgs: ['$keyword'],
        where: 'name = ?');

    maps.forEach(print);
    // Convert the List<Map<String, dynamic> into a List<EmployeeListModel>.
    return List.generate(maps.length, (i) {
      return EmployeeListModel(
        id: maps[i]['id'],
        name: maps[i]['name'],
        username: maps[i]['username'],
        email: maps[i]['email'],
        address: maps[i]['address'],
        profileImage: maps[i]['profile_image'],
        phone: maps[i]['phone'],
        website: maps[i]['website'],
        company: maps[i]['company'],
      );
    });
  }

  Future<Database?> get database async {
    // If database exists, return database
    if (_database != null) {
      print("db exist");
      return _database;
    } else {
      // If database don't exists, create one
      _database = await initDB();
      print("db  not exist");
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
          'CREATE TABLE IF NOT EXISTS Employee (id INTEGER PRIMARY KEY, name TEXT,username TEXT, email TEXT, phone TEXT, profile_image TEXT,website TEXT , address BLOB, company BLOB)');

      await db.execute(
          'CREATE TABLE IF NOT EXISTS Address (id INTEGER PRIMARY KEY,employee_id INTEGER, street TEXT, suite TEXT,city TEXT, zipcode TEXT,FOREIGN KEY(employee_id) REFERENCES Employee(id))');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Company (id INTEGER PRIMARY KEY,employee_id INTEGER, name TEXT, bs TEXT,catchPhrase TEXT, FOREIGN KEY(employee_id) REFERENCES Employee(id))');
    });
  }
}
