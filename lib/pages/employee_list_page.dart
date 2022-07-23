import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whiterabittest/pages/employee_detail_page.dart';

import '../db_employee/db_provider.dart';
import '../model/employee_list_model.dart';

class EmployeesListPageView extends StatefulWidget {
  const EmployeesListPageView({Key? key}) : super(key: key);

  @override
  State<EmployeesListPageView> createState() => _EmployeesListPageViewState();
}

class _EmployeesListPageViewState extends State<EmployeesListPageView> {
  List<EmployeeListModel> employeesDetails = [];
  List<Address> addressDetails = [];
  List<Company> companyDetails = [];
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    getEmployees();

    super.initState();
  }

  getEmployees() async {
    await DBProvider.db.getAllEmployees().then((value) {
      setState(() {
        employeesDetails.addAll(value);
      });
    });
    await DBProvider.db.getAllEmployeesAddress().then((address) {
      addressDetails.addAll(address);
    });
    await DBProvider.db.getAllEmployeesCompany().then((company) {
      companyDetails.addAll(company);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Employee List"),
          ),
          body: Container(
            padding: EdgeInsets.only(right: 20, left: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(right: 20, left: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  margin: EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 9,
                        child: TextField(
                          controller: _searchController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search by Name",
                            hintStyle: TextStyle(color: Colors.grey),
                            isDense: true,
                          ),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 0, right: 0),
                          child: Center(
                            child: InkWell(
                              onTap: () async {

                                if (_searchController.text
                                    .trim()
                                    .length > 0) {
                                  await DBProvider.db
                                      .searchQuery(_searchController.text)
                                      .then((value) {

                                    if(value.length <=0){

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Result Not Found!'),
                                      ));
                                    }

                                        value.forEach((element) {
                                      final index = employeesDetails
                                          .indexWhere((e) =>
                                      e.id == element.id);

                                      if (index != -1) {
                                        setState(() {
                                          addressDetails = [];
                                          companyDetails = [];

                                          employeesDetails = [];

                                          employeesDetails.addAll(value);
                                        });
                                        print(
                                            "Index $index: ${employeesDetails[index]}");
                                        employeesDetails.addAll(value);
                                      } else {
                                        print("Not found");
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Result Not Found!'),
                                        ));
                                      }
                                    });
                                  });
                                } else {
                                  setState(() {
                                    employeesDetails = [];
                                    getEmployees();
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Result Not Found!'),
                                  ));
                                }
                              },
                              child: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                onPressed: () async {

                                  if (_searchController.text
                                      .trim()
                                      .isNotEmpty) {
                                    await DBProvider.db
                                        .searchQuery(_searchController.text)
                                        .then((value) {

                                      if(value.length <=0){

                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Result Not Found!'),
                                        ));
                                      }
                                      value.forEach((element) {
                                        final index = employeesDetails
                                            .indexWhere((e) =>
                                        e.id == element.id);

                                        if (index != -1) {
                                          setState(() {
                                            addressDetails = [];
                                            companyDetails = [];

                                            employeesDetails = [];
                                            employeesDetails.addAll(value);
                                          });
                                          print(
                                              "Index $index: ${employeesDetails[index]}");
                                        } else {
                                          // final _snackBarContent = SnackBar(content: Text("Result Not Found"));
                                          // ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                                          //     .showSnackBar(_snackBarContent);
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('Result Not Found!'),
                                          ));
                                          print("Not found");
                                        }
                                      });
                                    });
                                  } else {
                                    setState(() {
                                      employeesDetails = [];
                                      getEmployees();
                                    });
                                    // final _snackBarContent = SnackBar(content: Text("Result Not Found"));
                                    // ScaffoldMessenger.of(_scaffoldKey.currentState!.context)
                                    //     .showSnackBar(_snackBarContent);
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text('Result Not Found!'),
                                    ));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemCount: employeesDetails.length,
                      itemBuilder: (context, int index) {
                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute
                              (builder: (context)=> EmployeeDetailPage(
                              companyDetails:companyDetails.length >0 ?
                              companyDetails[index]:null,

                              address: addressDetails.length > 0 ?
                              addressDetails[index]:null,
                              details:
                              employeesDetails[index],
                            )));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            // height: 100,
                            child: Card(
                              shadowColor: Colors.blueAccent,
                              elevation: 5,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 30,
                                  ),

                                  // SizedBox(
                                  //   width:
                                  //   MediaQuery.of(context).size.width /
                                  //       30,
                                  // ),

                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        // mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    employeesDetails[index]
                                                        .profileImage ??
                                                        ""),
                                                radius:
                                                35.0, // no matter how big it is, it won't overflow
                                              ),
                                              SizedBox(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width /
                                                    25,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  companyDetails.length > 0 ?
                                                  Text(
                                                      "Name : ${employeesDetails[index]
                                                          .name ?? ""}\n"
                                                          "Company : ${companyDetails[index]
                                                          .name ?? ""}"
                                                  ):

                                                  Text(
                                                      "Name : ${employeesDetails[index]
                                                          .name ?? ""}\n"

                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
