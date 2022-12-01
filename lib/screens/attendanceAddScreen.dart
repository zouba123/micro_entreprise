// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment
import 'package:accounting_app/models/EmployeeSalaryModel.dart';
import 'package:accounting_app/models/EmployeeSalaryStructuresModel.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/attendanceModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/screens/attendanceScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:intl/intl.dart';

class AttenDanceAddScreen extends BaseRoute {
  final List<Attendance> attendanceList;
  final List<EmployeeSalary> employeeSalary;
  final int screenId;
  AttenDanceAddScreen({@required a, @required o, this.attendanceList, this.employeeSalary, this.screenId}) : super(a: a, o: o, r: 'AttenDanceAddScreen');
  @override
  _AttenDanceAddScreenState createState() => _AttenDanceAddScreenState(this.attendanceList, this.employeeSalary, this.screenId);
}

class _AttenDanceAddScreenState extends BaseRouteState {
  List<Account> _empList = [];
  List<EmployeeSalary> employeeSalary = [];
  int screenId;
  bool _isDataLoaded = false;
  TextEditingController _cstartDate = TextEditingController();
  final _fstartDate = FocusNode();
  String _startDate;
  String _oldStartDate; // use during update operation
  DateTime _salaryStartdate;
  DateTime _salaryEndDate;
  DateTime _attendanceDate;
  String status;
  var _key = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Attendance> attendanceList;
  List<EmployeeSalary> empSalary = [];
  List<Account> _emplyList = [];

  int _selected = 1;
  _AttenDanceAddScreenState(this.attendanceList, this.employeeSalary, this.screenId) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: screenId == 1 ? Text(global.appLocaleValues['tle_attendance_update']) : Text(global.appLocaleValues['tle_attendance_add']),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await _onSubmit();
            },
            child: Text(global.appLocaleValues['btn_save'], style: TextStyle(color: Colors.white, fontSize: 18)),
          )
        ],
      ),
      body: (_isDataLoaded)
          ? SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Text(global.appLocaleValues['lbl_attendance_Date'], style: Theme.of(context).primaryTextTheme.headline3),
                        Padding(
                            padding: EdgeInsets.only(bottom: 5, top: 0),
                            child: Row(children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: _cstartDate,
                                  focusNode: _fstartDate,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectattendanceDate(context);
                                  },
                                  decoration: InputDecoration( border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.calendar_today)),
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
                                      setState(() {
                                        _selected = val;
                                      });
                                    }),
                              ),
                              Expanded(
                                child: RadioListTile(
                                    title: Text('${global.appLocaleValues['lbl_absent']}'),
                                    value: 0,
                                    groupValue: _selected,
                                    onChanged: (int val) {
                                      setState(() {
                                        _selected = val;
                                      });
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
                                              color: attendanceList[index].isAbsent == true
                                                  ? (_selected == 0)
                                                      ? Colors.red[50]
                                                      : Colors.green[50]
                                                  : Colors.white,
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
                                                    attendanceList[index].isAbsent = !attendanceList[index].isAbsent;
                                                    setState(() {});
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
                                            Icons.people,
                                            color: Colors.grey,
                                            size: 50,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Text(
                                            global.appLocaleValues['tle_emp_empty_msg'],
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
            )
          : Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
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
    if (attendanceList == null) {
      _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
      _startDate = DateTime.now().toString().substring(0, 10);
      _attendanceDate = DateTime.parse(_startDate);
      await _getData();
    } else {
      await _fillData();
    }
  }

  Future _getData() async {
    try {
      // _emplyList += await dbHelper.accountGetList(accountType: 'Worker');
      // _emplyList += await dbHelper.accountGetList(accountType: 'Employee');
      attendanceList = [];
      await _getEmployee();
      await _getWorker();
      _empList += _emplyList.toList();

      for (int i = 0; i < _empList.length; i++) {
        DateTime date = DateTime.parse(_startDate);
        Attendance attendance = Attendance(_empList[i].id, _empList[i].accountType, br.generateAccountName(_empList[i]), date);
        attendanceList.add(attendance);
      }
      if (employeeSalary.length > 0) {
        for (int i = 0; i < employeeSalary.length; i++) {
          List<EmployeeSalaryStructures> employeeSalaryStructuresList = [];
          employeeSalaryStructuresList = await dbHelper.employeeSalaryStructuresGetLastRecord(accountId: [employeeSalary[i].accountId], orderBy: 'DESC');
          for (int j = 0; j < employeeSalaryStructuresList.length; j++) {
            if (employeeSalary[i].accountId == employeeSalaryStructuresList[j].accountId) {
              employeeSalary[i].leaveCutAmount = employeeSalaryStructuresList[j].leaveCutAmount;
              if (employeeSalaryStructuresList[j].salaryType == 'Daily') {
                employeeSalary[i].startDate.add(Duration(days: 1));
                employeeSalary[i].endDate.add(Duration(days: 1));
                employeeSalary[i].id = null;
              } else if (employeeSalaryStructuresList[j].salaryType == 'Weekly') {
                if (DateFormat('yyyy-MM-dd').format(employeeSalary[i].endDate) == DateFormat('yyyy-MM-dd').format(_attendanceDate)) {
                  employeeSalary[i].startDate = employeeSalary[i].endDate.add(Duration(days: 1));
                  employeeSalary[i].endDate = employeeSalary[i].startDate.add(Duration(days: 6));
                  employeeSalary[i].id = null;
                }
              } else if (employeeSalaryStructuresList[j].salaryType == 'Monthly') {
                if (DateFormat('yyyy-MM-dd').format(employeeSalary[i].endDate) == DateFormat('yyyy-MM-dd').format(_attendanceDate)) {
                  employeeSalary[i].startDate = employeeSalary[i].endDate.add(Duration(days: 1));
                  employeeSalary[i].endDate = employeeSalary[i].startDate.add(Duration(days: 30));
                  employeeSalary[i].id = null;
                }
              }
            }
            empSalary = employeeSalary.toList();
          }
        }
      } else {
        for (int j = 0; j < _empList.length; j++) {
          List<EmployeeSalaryStructures> employeeSalaryStructuresList = [];
          employeeSalaryStructuresList = await dbHelper.employeeSalaryStructuresGetLastRecord(accountId: [_empList[j].id], orderBy: 'DESC');
          if (employeeSalaryStructuresList.length > 0) {
            for (int k = 0; k < employeeSalaryStructuresList.length; k++) {
              if (employeeSalaryStructuresList[k].salaryType == 'Daily') {
                _salaryStartdate = employeeSalaryStructuresList[k].startDate;
                _salaryEndDate = employeeSalaryStructuresList[k].startDate;
              } else if (employeeSalaryStructuresList[k].salaryType == 'Weekly') {
                _salaryStartdate = employeeSalaryStructuresList[k].startDate;
                _salaryEndDate = employeeSalaryStructuresList[k].startDate.add(Duration(days: 6));
              } else if (employeeSalaryStructuresList[k].salaryType == 'Monthly') {
                _salaryStartdate = employeeSalaryStructuresList[k].startDate;
                _salaryEndDate = employeeSalaryStructuresList[k].startDate.add(Duration(days: 30));
              }
              if (_salaryEndDate != null) {
                if (_salaryEndDate.isBefore(_attendanceDate)) {
                  status = 'Due';
                } else if (DateFormat('yyyy-MM-dd').format(_salaryEndDate) == DateFormat('yyyy-MM-dd').format(_salaryEndDate)) {
                  status = 'Pending';
                }
              }
              EmployeeSalary employeeSalaries = EmployeeSalary(employeeSalaryStructuresList[k].accountId, employeeSalaryStructuresList[k].id, employeeSalaryStructuresList[k].salary, _salaryStartdate, _salaryEndDate, status, employeeSalaryStructuresList[k].leaveCutAmount);
              empSalary.add(employeeSalaries);
            }
          }
        }
      }

      setState(() {
        _isDataLoaded = true;
      });
    } catch (e) {
      print('Exception - addattendanceScreen.dart - _getCustomers(): ' + e.toString());
    }
  }

  Future _fillData() async // display details during update expense
  {
    try {
      attendanceList.forEach((element) {
        //element.attendanceDate = element.attendanceDate;
        _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(element.attendanceDate);
        _startDate = element.attendanceDate.toString();
        _oldStartDate = _startDate;
        _attendanceDate = element.attendanceDate;
        _selected = element.selectionType;
        if (_selected == 0) {
          if (element.isAbsent) {
            element.isAbsent = false;
          } else {
            element.isAbsent = true;
          }
        } else {}
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

  Future _getEmployee() async {
    _emplyList += await dbHelper.accountGetList(accountType: 'Employee');
  }

  Future _getWorker() async {
    _emplyList += await dbHelper.accountGetList(accountType: 'Worker');
  }

  Future _onSubmit() async {
    try {
      int _result;
      int _isChecked = attendanceList.where((element) => element.isAbsent).length;
      if (_isChecked > 0) {
        if (screenId != 1) // if add operation
        {
          _result = await dbHelper.attendanceExist(_startDate);
        } else {
          _result = (_startDate != _oldStartDate) ? await dbHelper.attendanceExist(_startDate) : 0;
        }
        if (_result == 0) {
          // if no attendance taken of that date
          showLoader(global.appLocaleValues['txt_wait']);
          setState(() {});
          for (int i = 0; i < empSalary.length; i++) {
            if (empSalary[i].endDate != null) {
              if (empSalary[i].endDate.isBefore(_attendanceDate)) {
                empSalary[i].status = 'Due';
              } else if (DateFormat('yyyy-MM-dd').format(empSalary[i].endDate) == DateFormat('yyyy-MM-dd').format(empSalary[i].endDate)) {
                empSalary[i].status = 'Pending';
              }
            }
          }
          for (int i = 0; i < attendanceList.length; i++) {
            attendanceList[i].attendanceDate = DateTime.parse(_startDate);
            attendanceList[i].selectionType = _selected;
            if (_selected == 0) {
              if (attendanceList[i].isAbsent) {
                attendanceList[i].isAbsent = false;
                for (int j = 0; j < empSalary.length; j++) {
                  if (attendanceList[i].accountId == empSalary[j].accountId) {
                    empSalary[j].salaryAmount -= empSalary[j].leaveCutAmount;
                  }
                }
              } else {
                attendanceList[i].isAbsent = true;
              }
            } else {
              if (attendanceList[i].isAbsent == false) {
                for (int j = 0; j < empSalary.length; j++) {
                  if (attendanceList[i].accountId == empSalary[j].accountId) {
                    empSalary[j].salaryAmount -= empSalary[j].leaveCutAmount;
                  }
                }
              }
            }
            for (int i = 0; i < empSalary.length; i++) {
              if (attendanceList[i].isAbsent == true) {
                List<EmployeeSalaryStructures> employeeSalaryStructuresList = [];
                employeeSalaryStructuresList = await dbHelper.employeeSalaryStructuresGetLastRecord(accountId: [empSalary[i].accountId], orderBy: 'DESC');
                for (int j = 0; j < employeeSalaryStructuresList.length; j++) {
                  if (empSalary[i].accountId == employeeSalaryStructuresList[j].accountId) {
                    empSalary[i].leaveCutAmount = employeeSalaryStructuresList[j].leaveCutAmount;
                    if (employeeSalaryStructuresList[j].salaryType == 'Daily') {
                      if (empSalary[i].salaryAmount == 0.0) {
                        empSalary[i].salaryAmount = (employeeSalaryStructuresList[j].salary * 1);
                      }
                    }
                  }
                  if (empSalary[i].accountId == employeeSalaryStructuresList[j].accountId) {
                    empSalary[i].leaveCutAmount = employeeSalaryStructuresList[j].leaveCutAmount;
                    if (employeeSalaryStructuresList[j].salaryType == 'Monthly') {
                      if (empSalary[i].salaryAmount == 0.0) {
                        empSalary[i].salaryAmount = (employeeSalaryStructuresList[j].salary * -1);
                      }
                    }
                  }
                  if (empSalary[i].accountId == employeeSalaryStructuresList[j].accountId) {
                    empSalary[i].leaveCutAmount = employeeSalaryStructuresList[j].leaveCutAmount;
                    if (employeeSalaryStructuresList[j].salaryType == 'Weekly') {
                      if (empSalary[i].salaryAmount == 0.0) {
                        empSalary[i].salaryAmount = (employeeSalaryStructuresList[j].salary * -1);
                      }
                    }
                  }
                }
              }
            }
            if (attendanceList[i].id == null) {
              await dbHelper.attendanceInsert(attendanceList[i]);
              //await dbHelper.employeeSalaryInsert(empSalary[i]);
            } else {
              await dbHelper.attendanceUpdate(attendanceList[i]);
            }
          }
          for (int i = 0; i < empSalary.length; i++) {
            if (empSalary[i].id == null) {
              await dbHelper.employeeSalaryInsert(empSalary[i]);
            } else {
              await dbHelper.employeeSalaryUpdate(empSalary[i]);
            }
          }
          hideLoader();
          setState(() {});
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AttenDanceScreen(
                    a: widget.analytics,
                    o: widget.observer,

                    //attendanceList: temp,
                  )));
        } else {
          if (screenId != 1) // if add operation
          {
            AlertDialog _dialog = AlertDialog(
              shape: nativeTheme().dialogTheme.shape,
              title: Text(
                global.appLocaleValues['lbl_warning'],
                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
              ),
              content: (global.appLanguage['name'] == 'English')
                  ? Text('${global.appLocaleValues['txt_attendance_exist']} "${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(_startDate))}". ${global.appLocaleValues['txt_attendance_exist2']}?', textAlign: TextAlign.justify)
                  : Text('"${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(_startDate))}" ${global.appLocaleValues['txt_attendance_exist']}. ${global.appLocaleValues['txt_attendance_exist2']}?', textAlign: TextAlign.justify),
              actions: <Widget>[
                TextButton(
                  // textColor: Theme.of(context).primaryColor,
                  child: Text(global.appLocaleValues['btn_no']),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AttenDanceScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              //attendanceList: temp,
                            )));
                  },
                ),
                TextButton(
                  child: Text(global.appLocaleValues['btn_yes'], style: TextStyle(color: Theme.of(context).primaryColor)),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.of(context, rootNavigator: true).pop();
                    List<Attendance> temp = await dbHelper.attendanceWithoutGrpBtGetList(atdDate: _startDate);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AttenDanceAddScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              attendanceList: temp,
                              employeeSalary: employeeSalary,
                              screenId: 1,
                            )));
                  },
                ),
              ],
            );
            showDialog(builder: (context) => _dialog, context: context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['axt_attendance_vld'])));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['axt_attendance_vld2'])));
      }
    } catch (e) {
      print('Exception - addattendanceScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future<String> _selectattendanceDate(BuildContext context) async {
    try {
      final DateTime picked = await showDatePicker(
        context: context,
        helpText: '${global.appLocaleValues['lbl_date_from']}',
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          _cstartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _startDate = picked.toString().substring(0, 10);
          _attendanceDate = picked;
        });
      }
    } catch (e) {
      print('Exception - attendanceAddScreen.dart - _selectattendanceDate(): ' + e.toString());
    }
    return _startDate;
  }
}
