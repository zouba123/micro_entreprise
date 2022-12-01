// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/quotesGeneralReportFilterModel.dart';
import 'package:accounting_app/reports/quotesGeneralReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class QuotesGeneralReportFilterScreen extends BaseRoute {
  final QuotesGeneralReportFilterModel appliedFilter;
  QuotesGeneralReportFilterScreen({@required a, @required o, this.appliedFilter}) : super(a: a, o: o, r: 'QuotesGeneralReportFilterScreen');
  @override
  _QuotesGeneralReportFilterScreenState createState() => _QuotesGeneralReportFilterScreenState(appliedFilter);
}

class _QuotesGeneralReportFilterScreenState extends BaseRouteState {
  QuotesGeneralReportFilterModel appliedFilter;
  QuotesGeneralReportFilterModel _filter;

  TextEditingController _cAccount = TextEditingController();
  TextEditingController _cStatus = TextEditingController();

  TextEditingController _cQuoteDateFrom = TextEditingController();
  TextEditingController _cQuoteDateTo = TextEditingController();

  TextEditingController _cNetAmountFrom = TextEditingController();
  TextEditingController _cNetAmountTo = TextEditingController();

  TextEditingController _cDiscountAmountFrom = TextEditingController();
  TextEditingController _cDiscountAmountTo = TextEditingController();

  TextEditingController _cTaxAmountFrom = TextEditingController();
  TextEditingController _cTaxAmountTo = TextEditingController();

  DateFormat _dateFormat;

  _QuotesGeneralReportFilterScreenState(this.appliedFilter) : super();

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
              '${global.appLocaleValues['quotegen_rep_fltr']}',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['quote_date']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cQuoteDateFrom,
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
                                  controller: _cQuoteDateTo,
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
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['tab_ac']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                            controller: _cAccount,
                            readOnly: true,
                            onTap: () async {
                              await _selectAccount(context);
                            },
                            decoration: InputDecoration(
                              hintText: '${global.appLocaleValues['lbl_select_account']}',
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
                  padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['quote_status']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                            controller: _cStatus,
                            readOnly: true,
                            onTap: () async {
                              await _selectStatus(context);
                            },
                            decoration: InputDecoration(
                              hintText: '${global.appLocaleValues['sel_sta']}',
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
                  child: Text('${global.appLocaleValues['quote_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cNetAmountFrom,
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
                                  controller: _cNetAmountTo,
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
                  child: Text('${global.appLocaleValues['dis_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cDiscountAmountFrom,
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
                                  controller: _cDiscountAmountTo,
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
                  child: Text('${global.appLocaleValues['tax_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTaxAmountFrom,
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
                                  controller: _cTaxAmountTo,
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
      _filter.netAmountFrom = (_cNetAmountFrom.text.trim().isNotEmpty) ? double.parse(_cNetAmountFrom.text.trim()) : null;
      _filter.netAmountTo = (_cNetAmountTo.text.trim().isNotEmpty) ? double.parse(_cNetAmountTo.text.trim()) : null;

      _filter.discountAmountFrom = (_cDiscountAmountFrom.text.trim().isNotEmpty) ? double.parse(_cDiscountAmountFrom.text.trim()) : null;
      _filter.discountAmountTo = (_cDiscountAmountTo.text.trim().isNotEmpty) ? double.parse(_cDiscountAmountTo.text.trim()) : null;

      _filter.taxAmountFrom = (_cTaxAmountFrom.text.trim().isNotEmpty) ? double.parse(_cTaxAmountFrom.text.trim()) : null;
      _filter.taxAmountTo = (_cTaxAmountTo.text.trim().isNotEmpty) ? double.parse(_cTaxAmountTo.text.trim()) : null;

      if (_filter.netAmountFrom != null && _filter.netAmountTo != null && _filter.netAmountFrom > _filter.netAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['quote_amt_to_vld']}')));
      } else if (_filter.discountAmountFrom != null && _filter.discountAmountTo != null && _filter.discountAmountFrom > _filter.discountAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['dis_amt_to_vld']}')));
      } else if (_filter.taxAmountFrom != null && _filter.taxAmountTo != null && _filter.taxAmountFrom > _filter.taxAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['tax_amt_to_vld']}')));
      }

      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => QuotesGeneralReport(
                      a: widget.analytics,
                      o: widget.observer,
                      filter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - QuotesGeneralReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = QuotesGeneralReportFilterModel();
      _filter.quoteDateFrom = DateTime.parse(DateTime.now().subtract(Duration(days: 7)).toString().substring(0, 10));
      _filter.quoteDateTo = DateTime.parse(DateTime.now().toString().substring(0, 10));
      _cQuoteDateFrom.text = _dateFormat.format(_filter.quoteDateFrom);
      _cQuoteDateTo.text = _dateFormat.format(_filter.quoteDateTo);

      _cNetAmountFrom.clear();
      _cNetAmountTo.clear();
      _cDiscountAmountFrom.clear();
      _cDiscountAmountTo.clear();
      _cTaxAmountFrom.clear();
      _cTaxAmountTo.clear();
      _cAccount.clear();
      _cStatus.clear();

      setState(() {});
    } catch (e) {
      print('Exception - QuotesGeneralReportFilterScreen.dart - _reset(): ' + e.toString());
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
          if (_filter.quoteDateTo != null && !picked.isBefore(_filter.quoteDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cQuoteDateFrom.text = _dateFormat.format(picked);
            _filter.quoteDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['quote_dt_to_vld']}')));
          }
        } else if (id == 2) {
          bool _allow = true;
          if (_filter.quoteDateFrom != null && !picked.isAfter(_filter.quoteDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cQuoteDateTo.text = _dateFormat.format(picked);
            _filter.quoteDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['quote_dt_from_vld']}')));
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - QuotesGeneralReportFilterScreen.dart - _selectDate(): ' + e.toString());
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
      _filter = QuotesGeneralReportFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);

        _cAccount.text = (_filter.account != null && _filter.account.id != null) ? _filter.account.firstName + ' ' + _filter.account.lastName : '';
        _cStatus.text = (_filter.quoteStatus != null && _filter.quoteStatus.isNotEmpty) ? _filter.quoteStatus : '';

        _cQuoteDateFrom.text = (_filter.quoteDateFrom != null) ? _dateFormat.format(_filter.quoteDateFrom) : '';
        _cQuoteDateTo.text = (_filter.quoteDateTo != null) ? _dateFormat.format(_filter.quoteDateTo) : '';

        _cNetAmountFrom.text = (_filter.netAmountFrom != null) ? _filter.netAmountFrom.toString() : '';
        _cNetAmountTo.text = (_filter.netAmountTo != null) ? _filter.netAmountTo.toString() : '';

        _cDiscountAmountFrom.text = (_filter.discountAmountFrom != null) ? _filter.discountAmountFrom.toString() : '';
        _cDiscountAmountTo.text = (_filter.discountAmountTo != null) ? _filter.discountAmountTo.toString() : '';

        _cTaxAmountFrom.text = (_filter.taxAmountFrom != null) ? _filter.taxAmountFrom.toString() : '';
        _cTaxAmountTo.text = (_filter.taxAmountTo != null) ? _filter.taxAmountTo.toString() : '';
      }
    } catch (e) {
      print('Exception - QuotesGeneralReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => QuotesGeneralReport(
                  a: widget.analytics,
                  o: widget.observer,
                  filter: appliedFilter,
                )));
  }

  Future _selectAccount(context) async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccountSelectDialog(
                a: widget.analytics,
                o: widget.observer,
                returnScreenId: 0,
                selectedAccount: (selectedAccount) {
                  if (selectedAccount != null) {
                    _filter.account = selectedAccount;
                    _cAccount.text = '${selectedAccount.firstName} ${selectedAccount.lastName}';
                  }
                },
              )));
      setState(() {});
    } catch (e) {
      print('Exception - QuotesGeneralReportFilterScreen.dart - _selectAccount(): ' + e.toString());
    }
  }

  Future _selectStatus(context) async {
    try {
      List<String> _statusList = ['OPEN', 'INVOICED', 'CANCELLED'];
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          'Select Status',
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width - 40,
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _statusList.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('${_statusList[index]}'),
                      onTap: () async {
                        Navigator.of(context).pop();
                        _filter.quoteStatus = _statusList[index];
                        _cStatus.text = _statusList[index];
                        setState(() {});
                      },
                    ),
                    Divider()
                  ],
                );
              },
            ),
          ),
        ),
      );
      await showDialog(builder: (context) => dialog, context: context);
      setState(() {});
    } catch (e) {
      print('Exception - QuotesGeneralReportFilterScreen.dart - _chooseDateFormate(): ' + e.toString());
      return null;
    }
  }
}
