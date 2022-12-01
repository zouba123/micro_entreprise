// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/businessModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
// import 'package:accounting_app/screens/StockSoldStatementScreen.dart';
import 'package:accounting_app/screens/accountStatementScreen.dart';
// import 'package:accounting_app/screens/businessStatementScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/employeeSalaryStatementScreen.dart';
import 'package:accounting_app/screens/employeeStatementScreen.dart';
import 'package:accounting_app/screens/purchaseScreen.dart';
import 'package:accounting_app/screens/salesScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchReportScreen extends BaseRoute {
  final int returnScreenId;
  final Account account;
  final int accountStatementScreenId;
  final int recordNo;
  SearchReportScreen({@required a, @required o, @required this.returnScreenId, this.account, this.accountStatementScreenId, this.recordNo}) : super(a: a, o: o, r: 'SearchReport');
  @override
  _SearchReportScreenScreenState createState() => _SearchReportScreenScreenState(this.returnScreenId, this.account, this.accountStatementScreenId, this.recordNo);
}

class _SearchReportScreenScreenState extends BaseRouteState {
  final Account account;
  final int returnScreenId;
  final int accountStatementScreenId;
  int recordNo;
  _SearchReportScreenScreenState(this.returnScreenId, this.account, this.accountStatementScreenId, this.recordNo) : super();
  var _cDateRangeTo = TextEditingController();
  var _cDateRangeFrom = TextEditingController();
  var _fFromDateFocusNode =  FocusNode();
  var _fToDateFocusNode =  FocusNode();
  bool _dateFrom = false;
  String _dateRangeFrom2 = '', _dateRangeTo2 = '';
  var _focusNode =  FocusNode();
  int _selected;
  String _dates;
  String _timePeriod = '';
  String _dateRange = '';
  List<Payment> paymentList = [];
  DateTime customStart;
  DateTime customEnd;

  DateTime paymentFirstDate;

  DateTime today = DateTime.now();
  DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
  DateTime thisWeek = DateTime.now();
  DateTime lastWeekMonday = DateTime.now().subtract( Duration(days: ((DateTime.now().weekday + 6) % 7))).subtract(Duration(days: 7));
  DateTime lastWeekSunday = DateTime.now().subtract( Duration(days: ((DateTime.now().weekday + 6) % 7))).subtract(Duration(days: 7)).add( Duration(days: 6));
  DateTime last7day = DateTime.now().subtract(Duration(days: 7));
  DateTime thisMonthFirstDay =  DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime thisMonthLastDay =  DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
  DateTime lastMonthFirstDay =  DateTime(DateTime.now().year, DateTime.now().month - 1, 1);
  DateTime lastMonthLastDay =  DateTime(DateTime.now().year, DateTime.now().month, 0);
  DateTime last30day = DateTime.now().subtract(Duration(days: 30));
  DateTime currentWeekMonday = DateTime.now().subtract( Duration(days: ((DateTime.now().weekday + 6) % 7)));
  DateTime thisYearCurrentDay =  DateTime.now();
  DateTime thisYearFirstDay =  DateTime(DateTime.now().year, 1, 1);
  DateTime lastYearFirstDay =  DateTime(DateTime.now().year - 1, 1, 1);
  DateTime lastYearLastDay =  DateTime(DateTime.now().year - 1, 12, 31);
  List<int> _valueList = [];
  List<FinancialYear> _financialYearList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(global.appLocaleValues['lbl_search_report'], style: Theme.of(context).appBarTheme.titleTextStyle,),
        actions: <Widget>[
          MaterialButton(
              child: Text(
                global.appLocaleValues['btn_search'],
                style: Theme.of(context).primaryTextTheme.headline2,
              ),
              onPressed: () {
                if (_selected == null) {
                  _timePeriod = 'All Time';
                }
                if (returnScreenId == 1) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>  AccountStatementScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            search: _dates,
                            account: account,
                            timePeriod: _timePeriod,
                            dateRange: _dateRange,
                            screenId: accountStatementScreenId,
                            recordNo: recordNo,
                          )));
                } else if (returnScreenId == 2) {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (BuildContext context) =>  BusinessStatementScreen(
                  //           a: widget.analytics,
                  //           o: widget.observer,
                  //           search: _dates,
                  //           timePeriod: _timePeriod,
                  //           dateRange: _dateRange,
                  //           recordNo: recordNo,
                  //         )));
                } else if (returnScreenId == 3) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>  SalesScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            search: _dates,
                            timePeriod: _timePeriod,
                            dateRange: _dateRange,
                          )));
                } else if (returnScreenId == 4) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>  PurchaseScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            search: _dates,
                            timePeriod: _timePeriod,
                            dateRange: _dateRange,
                          )));
                } else if (returnScreenId == 5) {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (BuildContext context) =>  StockSoldStatementScreen(
                  //           a: widget.analytics,
                  //           o: widget.observer,
                  //           timePeriod: _timePeriod,
                  //           dateRange: _dateRange,
                  //           search: _dates,
                  //         )));
                } else if (returnScreenId == 6) {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (BuildContext context) =>  ExpenseStatementScreen(
                  //           a: widget.analytics,
                  //           o: widget.observer,
                  //           search: _dates,
                  //           timePeriod: _timePeriod,
                  //           dateRange: _dateRange,
                  //           selected: _selected,
                  //         )));
                } else if (returnScreenId == 7) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) =>  EmployeeSalaryStatementScreen(a: widget.analytics, o: widget.observer, search: _dates, timePeriod: _timePeriod, dateRange: _dateRange)));
                } else if (returnScreenId == 8) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) =>  EmployeeStatementScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            search: _dates,
                            timePeriod: _timePeriod,
                            dateRange: _dateRange,
                            screenId: 0,
                            account: account,
                          )));
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DashboardScreen(
                            a: widget.analytics,
                            o: widget.observer,
                          )));
                }
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(global.appLocaleValues['lbl_day'], style: Theme.of(context).primaryTextTheme.headline1,),
                    ),
                    // Padding(padding: EdgeInsets.only(top: 5)),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(today)}'),
                            value: 0,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_today']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'Today';
                              recordNo = 0;
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(yesterday)}'),
                            value: 1,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_yesterday']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'YesterDay';
                              recordNo = 0;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(global.appLocaleValues['lbl_week'], style: Theme.of(context).primaryTextTheme.headline1),
                    ),
                    // Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('MMMd').format(currentWeekMonday)} - ${DateFormat('MMMd').format(today)}'),
                            value: 2,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_this_week']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'This Week';
                              recordNo = 0;
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('MMMd').format(lastWeekMonday)} - ${DateFormat('MMMd').format(lastWeekSunday)}'),
                            value: 3,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_last_week']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'Last Week';
                              recordNo = 0;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('MMMd').format(last7day)} - ${DateFormat('MMMd').format(today)}'),
                            value: 4,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_last_7days']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'Last 7 Days';
                              recordNo = 0;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(global.appLocaleValues['lbl_month']),
                    ),
                    // Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('MMM').format(today)}'),
                            value: 5,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_this_month']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'This Month';
                              recordNo = 1;
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('MMM').format(lastMonthFirstDay)}'),
                            value: 6,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_last_month']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'Last Month';
                              recordNo = 1;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('MMMd').format(last30day)} - ${DateFormat('MMMd').format(today)}'),
                            value: 7,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_last_30days']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'Last 30 Days';
                              recordNo = 6;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(global.appLocaleValues['lbl_year']),
                    ),
                    // Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('yyyy').format(thisYearFirstDay)}'),
                            value: 11,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_this_year']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'This Year';
                              recordNo = 2;
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            subtitle: Text('${DateFormat('yyyy').format(lastYearFirstDay)}'),
                            value: 12,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_last_year']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'Previous year';
                              recordNo = 2;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(global.appLocaleValues['lbl_financial_year']),
                    ),
                    // Padding(padding: EdgeInsets.only(top: 10)),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: _financialYearList.length,
                    //   itemBuilder: (context, index) {
                    //     return RadioListTile(
                    //       //  subtitle: Text(''),
                    //       value: _valueList[index],
                    //       groupValue: _selected,
                    //       title: Text('${_financialYearList[index].start} - ${_financialYearList[index].end}'),
                    //       onChanged: (int value) {
                    //         _financialYearList.map((e) => e.isSelected = false).toList();
                    //         _financialYearList[index].isSelected = true;
                    //         _onChangeDateButton(value);
                    //         _timePeriod = 'Financial Year';
                    //       },
                    //     );
                    //   },
                    // )
                    Container(width: MediaQuery.of(context).size.width, child: radioListTileWidget()),
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    RadioListTile(
                      value: 8,
                      groupValue: _selected,
                      title: Text(global.appLocaleValues['lbl_custom']),
                      onChanged: (int value) {
                        FocusScope.of(context).requestFocus(_fFromDateFocusNode);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              controller: _cDateRangeFrom,
                              focusNode: _fFromDateFocusNode,
                              readOnly: true,
                              decoration: InputDecoration(labelText: global.appLocaleValues['lbl_date_from'], counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: TextFormField(
                              controller: _cDateRangeTo,
                              focusNode: _fToDateFocusNode,
                              readOnly: true,
                              maxLength: 5,
                              decoration: InputDecoration(labelText: global.appLocaleValues['lbl_date_to'], counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Flexible(
                          child: RadioListTile(
                            // subtitle: Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(today)}'),
                            value: 9,
                            groupValue: _selected,
                            title: Text(global.appLocaleValues['lbl_all_time']),
                            onChanged: (int value) {
                              _onChangeDateButton(value);
                              _timePeriod = 'All Time';
                              recordNo = 5;
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
    _fFromDateFocusNode.removeListener(_selectdateListener);
    _fToDateFocusNode.removeListener(_selectdateListener);
  }

  Future _init() async {
    try {
      _financialYearList = br.generateFinancialYearList();
      int _value = 9;
      _financialYearList.forEach((element) {
        // create financial year radio button list tile value
        _value++;
        _valueList.add(_value);
      });
      _fFromDateFocusNode.addListener(_selectdateListener);
      _fToDateFocusNode.addListener(_selectdateListener);

      paymentList = await dbHelper.paymentGetLastList(startIndex: 0, fetchRecords: 1, orderBy: 'ASC');
      paymentList.forEach((element) {
        paymentFirstDate = element.transactionDate;
      });
      print('PaymentFirstDate $paymentFirstDate');
    } catch (e) {
      print('Exception - searchReport.dart - _init(): ' + e.toString());
    }
  }

  void _onChangeDateButton(int value) {
    try {
      setState(() {
        _selected = value;
      });
      if (_selected == 0) {
        _dates = '${(today).toString().substring(0, 10)},${(today).toString().substring(0, 10)}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((today).toString().substring(0, 10)))}';
      } else if (_selected == 1) {
        _dates = '${(yesterday).toString().substring(0, 10)},${(yesterday).toString().substring(0, 10)}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((yesterday).toString().substring(0, 10)))}';
      } else if (_selected == 2) {
        _dates = '${(currentWeekMonday).toString().substring(0, 10)},${(today).toString().substring(0, 10)}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((currentWeekMonday).toString().substring(0, 10)))} TO ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((today).toString().substring(0, 10)))}';
      } else if (_selected == 3) {
        _dates = '${(lastWeekMonday).toString().substring(0, 10)},${(lastWeekSunday).toString().substring(0, 10)}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((lastWeekMonday).toString().substring(0, 10)))} TO ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((lastWeekSunday).toString().substring(0, 10)))}';
      } else if (_selected == 4) {
        _dates = '${(last7day).toString().substring(0, 10)},${(today).toString().substring(0, 10)}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((last7day).toString().substring(0, 10)))} TO ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((today).toString().substring(0, 10)))}';
      } else if (_selected == 5) {
        _dates = '${(thisMonthFirstDay).toString().substring(0, 10)},${(thisMonthLastDay).toString().substring(0, 10)}';
        _dateRange = '${DateFormat('MMM').format(today)}';
      } else if (_selected == 6) {
        _dates = '${(lastMonthFirstDay).toString().substring(0, 10)},${(lastMonthLastDay).toString().substring(0, 10)}';
        _dateRange = '${DateFormat('MMM').format(lastMonthFirstDay)}';
      } else if (_selected == 7) {
        _dates = '${(last30day).toString().substring(0, 10)},${(today).toString().substring(0, 10)}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((last30day).toString().substring(0, 10)))} TO ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((today).toString().substring(0, 10)))}';
      } else if (_selected == 8) {
        _dates = '${_dateRangeFrom2.toString()},${_dateRangeTo2.toString()}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((_dateRangeFrom2).toString().substring(0, 10)))} TO ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((_dateRangeTo2).toString().substring(0, 10)))}';
      } else if (_selected == 11) {
        _dates = '${(thisYearFirstDay).toString().substring(0, 10)},${(thisYearCurrentDay).toString().substring(0, 10)}';
        _dateRange = '${DateFormat('yyyy').format(thisYearFirstDay)}';
      } else if (_selected == 12) {
        _dates = '${(lastYearFirstDay).toString().substring(0, 10)},${(lastYearLastDay).toString().substring(0, 10)}';
        _dateRange = '${DateFormat('yyyy').format(lastYearFirstDay)}';
      } else if (_selected == 9) {
        _dates = '${(paymentFirstDate).toString().substring(0, 10)},${(today).toString().substring(0, 10)}';
        _dateRange = '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((paymentFirstDate).toString().substring(0, 10)))} TO ${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse((today).toString().substring(0, 10)))}';
      } else {
        DateTime _startDate = DateTime(_financialYearList.firstWhere((element) => element.isSelected).start, br.generateMonthNumber(br.getSystemFlagValue(global.systemFlagNameList.financialMonth)));
        //   print(_startDate);
        DateTime _endDate = DateTime(_financialYearList.firstWhere((element) => element.isSelected).end, br.generateMonthNumber(br.getSystemFlagValue(global.systemFlagNameList.financialMonth)), 0);
        //   print(_endDate);
        _dates = '${_startDate.toString().substring(0, 10)},${_endDate.toString().substring(0, 10)}';
        _dateRange = '${_financialYearList.firstWhere((element) => element.isSelected).start} TO ${_financialYearList.firstWhere((element) => element.isSelected).end}';
      }
      print(_dates);
    } catch (e) {
      print('Exception - searchReport.dart - _onChangeDateButton(): ' + e.toString());
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        helpText: (_dateFrom) ? global.appLocaleValues['lbl_date_from'] : global.appLocaleValues['lbl_date_to'],
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          //   _date=picked;
          if (_dateFrom) {
            _cDateRangeFrom.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
            _dateRangeFrom2 = picked.toString().substring(0, 10);
            _cDateRangeTo.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(DateTime.now().toString().substring(0, 10)));
            _dateRangeTo2 = DateTime.now().toString().substring(0, 10);
            // FocusScope.of(context).requestFocus(_focusNode);
            if (_cDateRangeFrom.text.isNotEmpty && _cDateRangeTo.text.isNotEmpty) {
              _onChangeDateButton(8);
              _timePeriod = 'CUSTOM';
              customStart = DateTime.parse(_dateRangeFrom2);
              customEnd = DateTime.parse(_dateRangeTo2);
              final difference = customEnd.difference(customStart).inDays;
              if (difference < 7) {
                recordNo = 8;
              } else if (difference <= 30) {
                recordNo = 9;
              } else if (difference > 30) {
                recordNo = 10;
              }
              print('date record $recordNo');

              print('cutsomstart $customStart');
              print('custome end $customEnd');
              print('differtent up $difference');
            }
          } else {
            _cDateRangeTo.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
            _dateRangeTo2 = picked.toString().substring(0, 10);
            // FocusScope.of(context).requestFocus(_focusNode);
            if (_cDateRangeFrom.text.isNotEmpty && _cDateRangeTo.text.isNotEmpty) {
              _onChangeDateButton(8);
              _timePeriod = 'CUSTOM';
              customStart = DateTime.parse(_dateRangeFrom2);
              customEnd = DateTime.parse(_dateRangeTo2);
              final difference = customEnd.difference(customStart).inDays;
              if (difference < 7) {
                recordNo = 8;
              } else if (difference <= 30) {
                recordNo = 9;
              } else if (difference > 30) {
                recordNo = 10;
              }

              print('date record $recordNo');
              // print('cutsomstart $customStart');
              // print('custome end $customEnd');
              // print('differtent $difference');

            }
          }
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - searchReport.dart - _selectDate(): ' + e.toString());
    }
  }

  Future<Null> _selectdateListener() async {
    try {
      if (_fFromDateFocusNode.hasFocus || _fToDateFocusNode.hasFocus) {
        if (_fFromDateFocusNode.hasFocus) {
          _dateFrom = true;
        } else {
          _dateFrom = false;
        }
        _selectDate(context); //open date picker
      }
    } catch (e) {
      print('Exception - searchReport.dart - _selectdateListener(): ' + e.toString());
    }
  }

  Widget radioListTileWidget() {
    try {
      List<Widget> _radioListTile = [];

      for (var i = 0; i < _financialYearList.length; i++) {
        _radioListTile.add(SizedBox(
          width: (MediaQuery.of(context).size.width / 2) - 10,
          child: RadioListTile(
            //  subtitle: Text(''),
            value: _valueList[i],
            groupValue: _selected,
            title: Text('${_financialYearList[i].start} - ${_financialYearList[i].end}'),
            onChanged: (int value) {
              _financialYearList.map((e) => e.isSelected = false).toList();
              _financialYearList[i].isSelected = true;
              _onChangeDateButton(value);
              _timePeriod = 'Financial Year';
              recordNo = 7;
            },
          ),
        ));
      }

      return  Wrap(
        spacing: 3.0,
        runSpacing: 2.0,
        alignment: WrapAlignment.start,
        children: _radioListTile,
      );
    } catch (e) {
      print("Exception - searchReport.dart" + e.toString());
      return SizedBox();
    }
  }
}
