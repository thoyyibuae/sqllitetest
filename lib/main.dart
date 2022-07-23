import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whiterabittest/model/employee_list_model.dart';
import 'package:whiterabittest/pages/employee_list_page.dart';

import 'db_employee/db_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.initDB();
  var response = await http
      .get(Uri.parse("http://www.mocky.io/v2/5d565297300000680030a986"));
  final r = json.decode(response.body);
  List<EmployeeListModel> rs = [];

  r.forEach((element) {
    rs.add(EmployeeListModel.fromJson(element ?? ""));
  });

  rs.forEach((element) {

    DBProvider.db.createEmployee(element);


  });


  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const EmployeesListPageView(),
    );
  }
}

