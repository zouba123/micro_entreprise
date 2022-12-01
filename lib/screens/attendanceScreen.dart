// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/EmployeeSalaryModel.dart';
import 'package:accounting_app/models/EmployeeSalaryStructuresModel.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/attendanceModel.dart';
import 'package:accounting_app/models/attendanceSearchModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/attendanceAddScreen.dart';
import 'package:accounting_app/screens/attendanceDetailScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AttenDanceScreen extends BaseRoute {
  AttenDanceScreen({@required a, @required o}) : super(a: a, o: o, r: 'AttenDanceScreen');
  @override
  _AttenDanceScreenState createState() => _AttenDanceScreenState();
}

class _AttenDanceScreenState extends BaseRouteState {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Attendance> _attenDanceList = [];
  List<EmployeeSalary> _employeeSalary = [];
  List<EmployeeSalary> _employeeSalaryAll = [];
  int _startIndex = 0;
  ScrollController _scrollController = ScrollController();
  //String _searchByPaymentMode;
  // ExpenseSearch _expenseSearch =  ExpenseSearch();
  bool _isDataLoaded = false;
  bool _isLoaderHide = false;
  bool _isRecordPending = true;
  AttendanceSearch _attendanceSearch =  AttendanceSearch();
  int filterCount = 0;
  List<Account> _emplyList = [];
  _AttenDanceScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(global.appLocaleValues['tle_attendance'],style: Theme.of(context).appBarTheme.titleTextStyle,),
        actions: <Widget>[
          // BadgeIconButton(
          //     itemCount: filterCount, // required
          //     icon: Icon(MdiIcons.filter), // required
          //     badgeColor: Colors.green, // default: Colors.red
          //     badgeTextColor: Colors.white, // default: Colors.white
          //     hideZeroCount: true, // default: true
          //     onPressed: () async {
          //       await attendanceSearch();
          //     }),
          (_emplyList.length > 0)
              ? IconButton(
                  icon: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AttenDanceAddScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              employeeSalary: _employeeSalary,
                              screenId: 2,
                              //  attendanceList:  List<Attendance>(),
                            )));
                  },
                )
              : SizedBox()
        ],
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        key: _refreshKey,
        child: WillPopScope(
          onWillPop: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
            return null;
          },
          child: (_isDataLoaded)
              ? (_attenDanceList.length > 0)
                  ? Scrollbar(
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: _attenDanceList.length + 1,
                        controller: _scrollController,
                        itemBuilder: (context, index) {
                          if (_attenDanceList.length == index) {
                            return (!_isLoaderHide)
                                ? Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : SizedBox();
                          }
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                              title: Row(
                                children: <Widget>[
                                  Text(
                                    '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(_attenDanceList[index].attendanceDate.toString()))}',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Container(
                                    width: 70,
                                    padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Colors.green)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          global.appLocaleValues['lbl_present'],
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9, fontSize: 12),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          ' ${_attenDanceList[index].present.length}',
                                          style: TextStyle(color: Colors.green, height: 0.9, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 70,
                                    padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
                                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Colors.red)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          global.appLocaleValues['lbl_absent'],
                                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9, fontSize: 12),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          ' ${_attenDanceList[index].absent.length}',
                                          style: TextStyle(color: Colors.red, height: 0.9, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                List<Attendance> temp = [];
                                temp = _attenDanceList[index].present.toList();
                                temp += _attenDanceList[index].absent.toList();
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => AttenDanceDetailScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          attendanceList: temp,
                                        )));
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                              Text(global.appLocaleValues['lbl_edit']),
                                            ],
                                          ),
                                          onTap: () {
                                            List<Attendance> temp = [];
                                            temp = _attenDanceList[index].present.toList();
                                            temp += _attenDanceList[index].absent.toList();
                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(MaterialPageRoute(
                                                builder: (context) => AttenDanceAddScreen(
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                      attendanceList: temp,
                                                      employeeSalary: _employeeSalary,
                                                      screenId: 1,
                                                    )));
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                              Text(global.appLocaleValues['lbl_delete']),
                                            ],
                                          ),
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            await _deleteAttendance(_attenDanceList[index]);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.compare_arrows,
                          color: Colors.grey,
                          size: 180,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Text(
                            global.appLocaleValues['tle_attendance_empty'],
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ))
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_lazyLoading);
  }

  @override
  void initState() {
    super.initState();
    _getEmployeeSalary();
    _getData();
    _scrollController.addListener(_lazyLoading);
    _isDataLoaded = true;
  }

  Future _getEmployeeSalary() async {
    _emplyList.clear();
    _emplyList += await dbHelper.accountGetList(accountType: 'Worker');
    _emplyList += await dbHelper.accountGetList(accountType: 'Employee');
    for (int i = 0; i < _emplyList.length; i++) {
      _employeeSalary += await dbHelper.employeeSalaryGetList(accountId: [_emplyList[i].id], orderBy: 'DESC');
    }
    _employeeSalaryAll = await dbHelper.employeeSalaryAmountGetList();
    setState(() { });
  }

  Future _getData() async {
    try {
      if (_isRecordPending) {
        if (_attenDanceList.length != null && _attenDanceList.length > 0) {
          _startIndex = _attenDanceList.length;
        } else {
          _attenDanceList = [];
        }
        _attenDanceList += await dbHelper.attendanceGetList(
          startIndex: _startIndex,
          orderBy: 'DESC',
          fetchRecords: global.fetchRecords,
          attendanceDate: (_attendanceSearch != null) ? (_attendanceSearch.attendanceDate != null) ? _attendanceSearch.attendanceDate : null : null,
        );
        for (int i = _startIndex; i < _attenDanceList.length; i++) {
          String date = _attenDanceList[i].attendanceDate.toString().substring(0, 10);
          List<Attendance> temp = await dbHelper.attendanceWithoutGrpBtGetList(atdDate: date);

          _attenDanceList[i].present = temp.where((element) => element.isAbsent).toList();
          _attenDanceList[i].absent = temp.where((element) => !element.isAbsent).toList();
        }
        _startIndex += global.fetchRecords;
        setState(() {
          (_attenDanceList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
        });
      }
    } catch (e) {
      print('Exception - attendanceScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _deleteAttendance(Attendance attendance) async {
    try {
      AlertDialog _dialog =  AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_dlt_attendance'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: (global.appLanguage['name'] == 'English')
            ? Text('${global.appLocaleValues['txt_delete']} "${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(attendance.attendanceDate.toString()))}"?')
            : Text('"${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(attendance.attendanceDate.toString()))}" ${global.appLocaleValues['txt_delete']}?'),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_cancel']),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
              child: Text(global.appLocaleValues['btn_delete']),
              onPressed: () async {
                Navigator.of(context).pop();

                //
                String date = attendance.attendanceDate.toString().substring(0, 10);
                int totalabsent = 0;
                List<EmployeeSalaryStructures> employeeSalaryStructuresList = await dbHelper.employeeSalaryStructuresGetList(accountId: _employeeSalaryAll.map((e) => e.accountId).toList(), orderBy: 'DESC');
                List<Attendance> attenDanceList = await dbHelper.attendanceWithoutGrpBtGetList(accountId: _employeeSalaryAll.map((e) => e.accountId).toList());

                if (_employeeSalaryAll.length > 0) {
                  for (int i = 0; i < _employeeSalaryAll.length; i++) {
                    for (int j = 0; j < attenDanceList.length; j++) {
                      EmployeeSalaryStructures _obj = employeeSalaryStructuresList.firstWhere((element) => element.accountId == _employeeSalaryAll[i].accountId);
                      if (_obj.salaryType == 'Daily') {
                        if (DateFormat('yyyy-MM-dd hh:mm').format(_employeeSalaryAll[i].createdAt) == DateFormat('yyyy-MM-dd hh:mm').format(attendance.createdAt)) {
                          await dbHelper.employeeSalaryDelete(id: _employeeSalaryAll[i].id);
                        }
                      }
                      if (_employeeSalaryAll[i].accountId == attenDanceList[j].accountId && attenDanceList[j].isAbsent == false) {
                        totalabsent++;
                      }
                    }
                    EmployeeSalaryStructures _obj = employeeSalaryStructuresList.firstWhere((element) => element.accountId == _employeeSalaryAll[i].accountId);
                    if (_obj.salaryType != 'Daily') {
                      _employeeSalaryAll[i].salaryAmount = _obj.salary - (_obj.leaveCutAmount * totalabsent);
                      await dbHelper.employeeSalaryUpdate(_employeeSalaryAll[i]);
                    }
                  }
                }
                int _result = await dbHelper.attendDanceDelete(atdDate: date);
                if (_result > 0) {
                  await _refreshData(isSearchAction: true);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('${global.appLocaleValues['tle_attendance_dlt_success']}'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('${global.appLocaleValues['tle_attendance_dlt_fail']}'),
                  ));
                }
                //
              }),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context);
    } catch (e) {
      print('Exception - attendanceScreen.dart - _deleteAttendance(): ' + e.toString());
    }
  }

  Future _lazyLoading() async {
    try {
      int _dataLen = _attenDanceList.length;
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        await _getData();
        if (_dataLen == _attenDanceList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - expenseScreen.dart - _lazyloading(): ' + e.toString());
    }
  }

  Future _refreshData({bool isSearchAction}) async {
    try {
      _startIndex = 0;
      _attenDanceList.clear();
      if (isSearchAction == null) {
        // _attenDanceList = null;
      }
      // _isSearching = false;
      await _getData();
      _scrollController.position.jumpTo(1);
      _isLoaderHide = false;
      setState(() {});
    } catch (e) {
      print('Exception - expenseScreen.dart - _refreshdata(): ' + e.toString());
    }
  }

  Future attendanceSearch() async {
    try {
      Navigator.of(context)
          .push(AttendnaceFilter(
        _attendanceSearch,
      ))
          .then((value) async {
        if (value != null) {
          _attendanceSearch = value;
          if (_attendanceSearch.isSearch) {
            _attenDanceList.clear();
            if (_attendanceSearch.isSearch != null && _attendanceSearch.isSearch) {
              _isDataLoaded = false;
              setState(() {});
              await _refreshData(isSearchAction: true);
              _isDataLoaded = true;
              setState(() {});
            }
          }
        }
      });
    } catch (e) {
      print('Exception - expenseScreen.dart - expenseSearch(): ' + e.toString());
    }
  }
}

class AttendnaceFilter extends ModalRoute<AttendanceSearch> {
  AttendanceSearch attendanceSearch;
  AttendnaceFilter(this.attendanceSearch);

  @override
  Duration get transitionDuration => Duration(milliseconds: 2);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.3);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return EmployeeFilterForm(
        attendanceSearch: attendanceSearch,
        searchValue: (obj) {
          attendanceSearch = obj;
        });
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class EmployeeFilterForm extends StatefulWidget {
  final AttendanceSearch attendanceSearch;
  final ValueChanged<AttendanceSearch> searchValue;
  EmployeeFilterForm({this.attendanceSearch, this.searchValue});
  @override
  _EventFilterFormState createState() => _EventFilterFormState(attendanceSearch, searchValue);
}

class _EventFilterFormState extends State<EmployeeFilterForm> {
  AttendanceSearch attendanceSearch;
  final ValueChanged<AttendanceSearch> searchValue;

  _EventFilterFormState(this.attendanceSearch, this.searchValue);

  bool isText = false; //search text avalaibal or not.
  bool isReset = true;
  Account _searchByAccount;
  var _cDateRangeFrom = TextEditingController();
  var _fFromDate =  FocusNode();
  var _focusNode =  FocusNode();
  bool _dateFrom = false;
  String _dateRangeFrom2 = '';

  AttendanceSearch eSearch =  AttendanceSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    _fFromDate.addListener(_selectdateListener);

    if (attendanceSearch != null) {
      _dateRangeFrom2 = (attendanceSearch.attendanceDate != null) ? attendanceSearch.attendanceDate.toString() : '';
      _cDateRangeFrom.text = (attendanceSearch.attendanceDate != null) ? DateFormat('dd-MM-yyyy').format(attendanceSearch.attendanceDate) : null;
      setState(() {
        if (_searchByAccount != null) {
          isReset = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    assignValue();
  }

  @override
  void dispose() {
    super.dispose();
    _fFromDate.removeListener(_selectdateListener);
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          //   _date=picked;
          if (_dateFrom) {
            _cDateRangeFrom.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(picked.toString().substring(0, 10)));
            _dateRangeFrom2 = picked.toString().substring(0, 10);
          }
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - expenseSearchDialog.dart - _selectDate(): ' + e.toString());
    }
  }

  Future<Null> _selectdateListener() async {
    try {
      if (_fFromDate.hasFocus) {
        if (_fFromDate.hasFocus) {
          _dateFrom = true;
        } else {
          _dateFrom = false;
        }
        _selectDate(context); //open date picker
      }
    } catch (e) {
      print('Exception - expenseSearchDialog.dart - _selectdateListener(): ' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 56.0,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        MdiIcons.filter,
                        color: Colors.white,
                        size: 26.0,
                      ),
                      SizedBox(
                        width: 31.0,
                      ),
                      Text(
                        global.appLocaleValues['tle_search_attendance'],
                        style: TextStyle(color: Colors.white, fontFamily: 'WhitneyBold', fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                      onTap: () {
                        resetFilter();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            MdiIcons.restore,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Text(
                            '${global.appLocaleValues['btn_reset']}',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _cDateRangeFrom,
                        focusNode: _fFromDate,
                        readOnly: true,
                        maxLength: 5,
                        decoration: InputDecoration(hintText: global.appLocaleValues['lbl_attendance_Date'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: TextButton(
                   
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          MdiIcons.close,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text('${global.appLocaleValues['btn_cancel']}',
                            style: TextStyle(
                              color: Colors.white,
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  flex: 5,
                  child: TextButton(
                   
                    onPressed: () {
                      eSearch.isSearch = true;
                      eSearch.attendanceDate = (_dateRangeFrom2 != '') ? DateTime.parse(_dateRangeFrom2) : null;
                      searchValue(eSearch);
                      Navigator.pop(context, eSearch);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text(
                          '${global.appLocaleValues['btn_search']}',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> resetConfermation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${global.appLocaleValues['lbl_reset']}', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${global.appLocaleValues['txt_filter']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${global.appLocaleValues['btn_cancel']}'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${global.appLocaleValues['btn_ok']}'),
              onPressed: () {
                setState(() {
                  isReset = false;
                  eSearch.isSearch = true;
                  eSearch.attendanceDate = null;
                  Navigator.of(context).pop();
                  Navigator.pop(context, eSearch);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
