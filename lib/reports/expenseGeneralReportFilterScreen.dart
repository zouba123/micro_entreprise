// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/dialogs/expenseCategorySelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/expenseGeneralReportFilterModel.dart';
import 'package:accounting_app/reports/expenseGeneralReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpenseGeneralReportFilterScreen extends BaseRoute {
  final ExpenseGeneralReportFilterModel appliedFilter;
  ExpenseGeneralReportFilterScreen({@required a, @required o, this.appliedFilter}) : super(a: a, o: o, r: 'ExpenseGeneralReportFilterScreen');
  @override
  _AccountSellerReportFilterScreenState createState() => _AccountSellerReportFilterScreenState(appliedFilter);
}

class _AccountSellerReportFilterScreenState extends BaseRouteState {
  ExpenseGeneralReportFilterModel appliedFilter;
  ExpenseGeneralReportFilterModel _filter;

  TextEditingController _cAmountFrom = TextEditingController();
  TextEditingController _cAmountTo = TextEditingController();
  TextEditingController _cCategory = TextEditingController();
  TextEditingController _cTransactionDateFrom = TextEditingController();
  TextEditingController _cTransactionDateTo = TextEditingController();

  TextEditingController _cPaidAmountFrom = TextEditingController();
  TextEditingController _cPaidAmountTo = TextEditingController();

  TextEditingController _cPendingAmountFrom = TextEditingController();
  TextEditingController _cPendingAmountTo = TextEditingController();

  DateFormat _dateFormat;

  _AccountSellerReportFilterScreenState(this.appliedFilter) : super();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          _backButtonFunction();
          return null;
        },
        child: Scaffold(
          // key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              '${global.appLocaleValues['exp_gen_rep_fltr']}',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(top: 0, bottom: 5, left: 8),
                    child: Text('${global.appLocaleValues['exp_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: _cAmountFrom,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['from_amt']}',
                                    border: nativeTheme().inputDecorationTheme.border,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cAmountTo,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['to_amt']}',
                                    border: nativeTheme().inputDecorationTheme.border,
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['tle_expense_cat']}', style: Theme.of(context).primaryTextTheme.headline3),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: _cCategory,
                            readOnly: true,
                            onTap: () async {
                              await _selectCategory(context);
                            },
                            decoration: InputDecoration(
                              hintText: '${global.appLocaleValues['slt_cat']}',
                              border: nativeTheme().inputDecorationTheme.border,
                              counterText: '',
                            ),
                          )
                        ],
                      ),
                    )),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['lbl_transaction_date_']}', style: Theme.of(context).primaryTextTheme.headline3),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: _cTransactionDateFrom,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectDate(context, 1);
                                  },
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['from_date']}', border: nativeTheme().inputDecorationTheme.border, counterText: '',
                                    // prefixIcon: Icon(Icons.calendar_today)
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cTransactionDateTo,
                                  readOnly: true,
                                  maxLength: 5,
                                  onTap: () async {
                                    await _selectDate(context, 2);
                                  },
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['to_date']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['paid_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: _cPaidAmountFrom,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['from_amt']}',
                                    border: nativeTheme().inputDecorationTheme.border,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cPaidAmountTo,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['to_amt']}',
                                    border: nativeTheme().inputDecorationTheme.border,
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['pending_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: TextFormField(
                                  controller: _cPendingAmountFrom,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['from_amt']}',
                                    border: nativeTheme().inputDecorationTheme.border,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cPendingAmountTo,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['to_amt']}',
                                    border: nativeTheme().inputDecorationTheme.border,
                                    counterText: '',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                              _reset();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  MdiIcons.restore,
                                  color: Theme.of(context).primaryColorDark,
                                  size: 18.0,
                                ),
                                SizedBox(
                                  width: 3.0,
                                ),
                                Text('${global.appLocaleValues['btn_reset']}', style: Theme.of(context).primaryTextTheme.headline3)
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
                              _search();
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
                                  style: Theme.of(context).primaryTextTheme.headline2,
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
            ),
          ),
        ));
  }

  void _search() {
    try {
      bool _allow = true;
      _filter.amountFrom = (_cAmountFrom.text.trim().isNotEmpty) ? double.parse(_cAmountFrom.text.trim()) : null;
      _filter.amountTo = (_cAmountTo.text.trim().isNotEmpty) ? double.parse(_cAmountTo.text.trim()) : null;

      _filter.paidAmountFrom = (_cPaidAmountFrom.text.trim().isNotEmpty) ? double.parse(_cPaidAmountFrom.text.trim()) : null;
      _filter.paidAmountTo = (_cPaidAmountTo.text.trim().isNotEmpty) ? double.parse(_cPaidAmountTo.text.trim()) : null;

      _filter.pendingAmountFrom = (_cPendingAmountFrom.text.trim().isNotEmpty) ? double.parse(_cPendingAmountFrom.text.trim()) : null;
      _filter.pendingAmountTo = (_cPendingAmountTo.text.trim().isNotEmpty) ? double.parse(_cPendingAmountTo.text.trim()) : null;

      if (_filter.amountFrom != null && _filter.amountTo != null && _filter.amountFrom > _filter.amountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['exp_amt_to_vld']}')));
      } else if (_filter.paidAmountFrom != null && _filter.paidAmountTo != null && _filter.paidAmountFrom > _filter.paidAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['paid_amt_to_vld']}')));
      } else if (_filter.pendingAmountFrom != null && _filter.pendingAmountTo != null && _filter.pendingAmountFrom > _filter.pendingAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['pending_to_amt_vld']}')));
      }

      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ExpenseGeneralReport(
                      a: widget.analytics,
                      o: widget.observer,
                      filter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - ExpenseGeneralReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = ExpenseGeneralReportFilterModel();
      _cTransactionDateFrom.clear();
      _cTransactionDateTo.clear();
      _cAmountFrom.clear();
      _cAmountTo.clear();
      _cCategory.clear();
      _cPaidAmountFrom.clear();
      _cPaidAmountTo.clear();
      _cPendingAmountFrom.clear();
      _cPendingAmountTo.clear();
      setState(() {});
    } catch (e) {
      print('Exception - ExpenseGeneralReportFilterScreen.dart - _reset(): ' + e.toString());
    }
  }

  Future _selectDate(BuildContext context, int id) async {
    try {
      // choose dob
      DateTime _initialDate = DateTime.now();
      DateTime _firstDate = DateTime(1940);

      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _initialDate,
        firstDate: _firstDate,
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        if (id == 1) {
          bool _allow = true;
          if (_filter.transactionDateTo != null && !picked.isBefore(_filter.transactionDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cTransactionDateFrom.text = _dateFormat.format(picked);
            _filter.transactionDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['from_dt_to_vld']}')));
          }
        } else if (id == 2) {
          bool _allow = true;
          if (_filter.transactionDateFrom != null && !picked.isAfter(_filter.transactionDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cTransactionDateTo.text = _dateFormat.format(picked);
            _filter.transactionDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['to_dt_to_vld']}')));
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - ExpenseGeneralReportFilterScreen.dart - _selectDate(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fillData();
  }

  void _fillData() {
    try {
      _dateFormat = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat));
      _filter = ExpenseGeneralReportFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);

        _cTransactionDateFrom.text = (_filter.transactionDateFrom != null) ? _dateFormat.format(_filter.transactionDateFrom) : '';
        _cTransactionDateTo.text = (_filter.transactionDateTo != null) ? _dateFormat.format(_filter.transactionDateTo) : '';
        _cCategory.text = (_filter.category != null && _filter.category.id != null) ? _filter.category.name : '';

        _cAmountFrom.text = (_filter.amountFrom != null) ? _filter.amountFrom.toString() : '';
        _cAmountTo.text = (_filter.amountTo != null) ? _filter.amountTo.toString() : '';

        _cPaidAmountFrom.text = (_filter.paidAmountFrom != null) ? _filter.paidAmountFrom.toString() : '';
        _cPaidAmountTo.text = (_filter.paidAmountTo != null) ? _filter.paidAmountTo.toString() : '';

        _cPendingAmountFrom.text = (_filter.pendingAmountFrom != null) ? _filter.pendingAmountFrom.toString() : '';
        _cPendingAmountTo.text = (_filter.pendingAmountTo != null) ? _filter.pendingAmountTo.toString() : '';
        setState(() {});
      }
    } catch (e) {
      print('Exception - ExpenseGeneralReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ExpenseGeneralReport(
                  a: widget.analytics,
                  o: widget.observer,
                  filter: appliedFilter,
                )));
  }

  Future _selectCategory(context) async {
    try {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return ExpenseCategorySelectDialog(
              a: widget.analytics,
              o: widget.observer,
              returnScreenId: 0,
              selectedExpense: (obj) {
                if (obj != null) {
                  _filter.category = obj;
                  _cCategory.text = obj.name;
                }
              },
            );
          });
      setState(() {});
      setState(() {});
    } catch (e) {
      print('Exception - ExpenseGeneralReportFilterScreen.dart - _selectCategory(): ' + e.toString());
    }
  }
}
