import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whiterabittest/model/employee_list_model.dart';

class EmployeeDetailPage extends StatefulWidget {
   EmployeeDetailPage({this.details,this.address,this.companyDetails});

  final EmployeeListModel? details ;
  final Company? companyDetails ;
  final Address?
   address;
  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
 TextStyle textStyle= TextStyle(
  fontSize: 16
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title:
        const Text("Employee Detail Page"),
        centerTitle: true,),
      body: ListView(
        children: [
          Container(
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




                  Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center,
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        // mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    widget.details
                                    !.profileImage ??
                                        ""),
                                radius:
                                100.0, // no matter how big it is, it won't overflow
                              ),

                            ],
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("UserName : ${widget.details!.username
                                    ?? ""}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue
                                  ),
                                ),
                                SizedBox(height: 40,),
                                Text("Email : ${widget.details!.email
                                    ?? ""}"
                                    ,style: textStyle,
                                ),
                                widget.companyDetails !=null ?
                                Text(
                                    "Name : ${widget.details
                                    !.name ?? ""}\n"
                                        "Company : ${widget.companyDetails
                                    !.name ?? ""}"
                                  ,style: textStyle,
                                ):

                                Text(
                                    "Name : ${widget.details
                                    !.name ?? ""}\n"
                                  ,style: textStyle,
                                ),




                                widget.address !=null ?
                                Text("Address : ${widget.address!.street
                                    ?? ""}"
                                  ,style: textStyle,
                                ):

                                Text(
                                    " "

                                ),
                                Text("Phone : ${widget.details!.phone
                                    ?? " No Number"}"
                                  ,style: textStyle,
                                ),
                                Text("Website : ${widget.details!.website
                                    ?? ""}\n"
                                  ,style: textStyle,
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
