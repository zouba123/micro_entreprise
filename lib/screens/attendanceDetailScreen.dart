// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment
import 'package:accounting_app/models/attendanceModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:accounting_app/screens/attendanceScreen.dart';

class AttenDanceDetailScreen extends BaseRoute {
  final List<Attendance> attendanceList;
  AttenDanceDetailScreen({@required a, @required o, this.attendanceList}) : super(a: a, o: o, r: 'AttenDanceAddScreen');
  @override
  _AttenDanceDetailState createState() => _AttenDanceDetailState(this.attendanceList);
}

class _AttenDanceDetailState extends BaseRouteState {
  int screenId;
  bool _isDataLoaded = false;
  TextEditingController _cstartDate =  TextEditingController();
  final _fstartDate =  FocusNode();

  var _key = GlobalKey<FormState>();
  List<Attendance> attendanceList = [];
  int _selected = 1;
  _AttenDanceDetailState(this.attendanceList) : super();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(PageTransition(
            type: PageTransitionType.leftToRight,
            child: AttenDanceScreen(
              a: widget.analytics,
              o: widget.observer,
            )));
        return null;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(global.appLocaleValues['tle_attendance_detail']),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 5, top: 10),
                          child: Row(children: <Widget>[
                            Flexible(
                              child: TextFormField(
                                controller: _cstartDate,
                                focusNode: _fstartDate,
                                readOnly: true,
                                // onTap: () async {
                                //   await _selectattendanceDate(context);
                                // },
                                decoration: InputDecoration(labelText: '${global.appLocaleValues['lbl_attendance_Date']}', border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                                validator: (v) {
                                  if (v.isEmpty) {
                                    return global.appLocaleValues['txt_attendance_err_req'];
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ])),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${global.appLocaleValues['lbl_select_sel_type']} ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: RadioListTile(
                                  title: Text('${global.appLocaleValues['lbl_present']}'),
                                  value: 1,
                                  groupValue: _selected,
                                  onChanged: (int val) {
                                    // setState(() {
                                    //   _selected = val;
                                    // });
                                  }),
                            ),
                            Expanded(
                              child: RadioListTile(
                                  title: Text('${global.appLocaleValues['lbl_absent']}'),
                                  value: 0,
                                  groupValue: _selected,
                                  onChanged: (int val) {
                                    // setState(() {
                                    //   _selected = val;
                                    // });
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '${global.appLocaleValues['lbl_emp_err_req']} ',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                      ),
                      (_isDataLoaded)
                          ? (attendanceList.length > 0)
                              ? Column(
                                  children: <Widget>[
                                    ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: attendanceList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            color: attendanceList[index].isAbsent == true ? (_selected == 0) ? Colors.red[50] : Colors.green[50] : (_selected == 1) ? Colors.red[50] : Colors.green[50],
                                            child: ListTile(
                                                title: Text("${attendanceList[index].name}"),
                                                subtitle: (attendanceList[index].accountType == ',Employee,Worker,')
                                                    ? Text(
                                                        'Employee and Worker',
                                                      )
                                                    : Text(
                                                        '${(attendanceList[index].accountType)}',
                                                      ),
                                                // leading: CircleAvatar(
                                                //   child: Text('${snapshot.data[index]['symbol']}'),
                                                // ),
                                                trailing: attendanceList[index].isAbsent
                                                    ? Icon(
                                                        Icons.check,
                                                        color: (_selected == 0) ? Colors.red : Colors.green,
                                                        size: 30,
                                                      )
                                                    : SizedBox(),
                                                onTap: () {
                                                  // attendanceList[index].isAbsent = !attendanceList[index].isAbsent;
                                                  // setState(() {});
                                                }),
                                          );

                                          // CheckboxListTile(
                                          //     title: Text(
                                          //       '${attendanceList[index].name}',
                                          //       // '${br.generateAccountName(_paymentList[index].account)}',
                                          //       style: TextStyle(fontSize: 14),
                                          //       overflow: TextOverflow.ellipsis,
                                          //     ),
                                          //     value: attendanceList[index].isAbsent,
                                          //     onChanged: (value) {
                                          //       attendanceList[index].isAbsent = value;
                                          //       setState(() {});
                                          //     });
                                        }),
                                  ],
                                )
                              : Container(
                                  margin: const EdgeInsets.only(top: 50),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.1,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20, bottom: 10),
                                        child: Icon(
                                          Icons.credit_card,
                                          color: Colors.grey,
                                          size: 50,
                                        ),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          global.appLocaleValues['tle_recent_salary_setup_empty_msg'],
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                )
                          : Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Center(
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                    ]))
              ]),
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _intitget();
  }

  Future _intitget() async {
    // if (attendanceList == null) {
    //   attendanceList = [];
    //   _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
    //   _startDate = DateTime.now().toString().substring(0, 10);
    //   await _getData();
    // } else {
    await _fillData();
    //}
  }

  // Future _getData() async {
  //   try {
  //     List<Account> _emplyList = [];
  //   //  List<Account> _workList = [];
  //     _emplyList += await dbHelper.employeeGetList(accountType: 'Worker');
  //     _emplyList += await dbHelper.employeeGetList(accountType: 'Employee');
  //    // _workList = await dbHelper.employeeGetList(accountType: 'Worker');
  //     _empList = _emplyList.toList();
  //    // _empList += _workList.toList();
  //     _empList.forEach((element) {
  //       DateTime date = DateTime.parse(_startDate);
  //       Attendance attendance =  Attendance(element.id, element.accountType, br.generateAccountName(element), date);
  //       attendanceList.add(attendance);
  //     });
  //     setState(() {
  //       _isDataLoaded = true;
  //     });
  //   } catch (e) {
  //     print('Exception - addattendanceScreen.dart - _getCustomers(): ' + e.toString());
  //   }
  // }

  Future _fillData() async // display details during update expense
  {
    try {
      attendanceList.forEach((element) {
        //element.attendanceDate = element.attendanceDate;
        _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(element.attendanceDate);
        _selected = element.selectionType;
        if (_selected == 0) {
          if (element.isAbsent) {
            element.isAbsent = false;
          } else {
            element.isAbsent = true;
          }
        }
        // element.selectionType = element.selectionType;
        element.accountType = element.account.accountType;
        element.name = br.generateAccountName(element.account);
        setState(() {
          _isDataLoaded = true;
        });
      });
    } catch (e) {
      print('Exception - addattendanceScreen.dart - _fillData(): ' + e.toString());
    }
  }

  // Future _onSubmit() async {
  //   try {
  //     for (int i = 0; i < attendanceList.length; i++) {
  //       attendanceList[i].attendanceDate = DateTime.parse(_startDate);
  //       attendanceList[i].selectionType = _selected;
  //       if (_selected == 0) {
  //         if (attendanceList[i].isAbsent) {
  //           attendanceList[i].isAbsent = false;
  //         } else {
  //           attendanceList[i].isAbsent = true;
  //         }
  //       }
  //       if (attendanceList[i].id == null) {
  //         await dbHelper.attendanceInsert(attendanceList[i]);
  //       } else {
  //         await dbHelper.attendanceUpdate(attendanceList[i]);
  //       }
  //     }
  //     Navigator.of(context).push(MaterialPageRoute(
  //         builder: (context) => AttenDanceScreen(
  //               a: widget.analytics,
  //               o: widget.observer,

  //               //attendanceList: temp,
  //             )));
  //   } catch (e) {
  //     print('Exception - addattendanceScreen.dart - _onSubmit(): ' + e.toString());
  //   }
  // }

  // Future<String> _selectattendanceDate(BuildContext context) async {
  //   try {
  //     final DateTime picked = await showDatePicker(
  //       context: context,
  //       helpText: '${global.appLocaleValues['lbl_date_from']}',
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1940),
  //       lastDate: DateTime.now(),
  //     );
  //     if (picked != null && picked != DateTime(2000)) {
  //       setState(() {
  //         _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
  //         _startDate = picked.toString().substring(0, 10);
  //       });
  //     }
  //   } catch (e) {
  //     print('Exception - attendanceAddScreen.dart - _selectattendanceDate(): ' + e.toString());
  //   }
  //   return _startDate;
  // }
}
