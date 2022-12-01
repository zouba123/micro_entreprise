// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/salesTaxAndDiscountReportFilterModel.dart';
import 'package:accounting_app/reports/salesTaxAndDiscountReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SalesTaxAndDiscountReportFilterScreen extends BaseRoute {
  final SalesTaxAndDiscountReportFilterModel appliedFilter;
  SalesTaxAndDiscountReportFilterScreen({@required a, @required o, this.appliedFilter}) : super(a: a, o: o, r: 'SalesTaxAndDiscountReportFilterScreen');
  @override
  _AccountSellerReportFilterScreenState createState() => _AccountSellerReportFilterScreenState(appliedFilter);
}

class _AccountSellerReportFilterScreenState extends BaseRouteState {
  SalesTaxAndDiscountReportFilterModel appliedFilter;
  SalesTaxAndDiscountReportFilterModel _filter;

  TextEditingController _cSalesInvoiceDateFrom = TextEditingController();
  TextEditingController _cSalesInvoiceDateTo = TextEditingController();
  TextEditingController _cAccountRegistrationDateFrom = TextEditingController();
  TextEditingController _cAccountRegistrationDateTo = TextEditingController();

  TextEditingController _cPincode = TextEditingController();

  TextEditingController _cTotalDiscountAmountFrom = TextEditingController();
  TextEditingController _cTotalDiscountAmountTo = TextEditingController();
  TextEditingController _cTotalTaxAmountFrom = TextEditingController();
  TextEditingController _cTotalTaxAmountTo = TextEditingController();

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
              '${global.appLocaleValues['sal_tax_dis_rep_filte']}',
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
                  child: Text('${global.appLocaleValues['sal_inv_dt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cSalesInvoiceDateFrom,
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
                                  controller: _cSalesInvoiceDateTo,
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
                  child: Text('${global.appLocaleValues['ac_reg_dt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cAccountRegistrationDateFrom,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectDate(context, 3);
                                  },
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['from_date']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cAccountRegistrationDateTo,
                                  readOnly: true,
                                  maxLength: 5,
                                  onTap: () async {
                                    await _selectDate(context, 4);
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
                  child: Text('${global.appLocaleValues['ttl_dis_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalDiscountAmountFrom,
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
                                  controller: _cTotalDiscountAmountTo,
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
                  child: Text('${global.appLocaleValues['ttl_tax_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalTaxAmountFrom,
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
                                  controller: _cTotalTaxAmountTo,
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
                  child: Text('${global.appLocaleValues['ac_zip_code']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                            controller: _cPincode,
                            // keyboardType:  keyboardType: TextInputType.numberWithOptions(decimal: true),,
                            maxLength: 7,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z 0-9]'))],
                            decoration: InputDecoration(hintText: '${global.appLocaleValues['zip_code']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                          )
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
      _filter.totalDiscountAmountFrom = (_cTotalDiscountAmountFrom.text.trim().isNotEmpty) ? double.parse(_cTotalDiscountAmountFrom.text.trim()) : null;
      _filter.totalDiscountAmountTo = (_cTotalDiscountAmountTo.text.trim().isNotEmpty) ? double.parse(_cTotalDiscountAmountTo.text.trim()) : null;

      _filter.totalTaxAmountFrom = (_cTotalTaxAmountFrom.text.trim().isNotEmpty) ? double.parse(_cTotalTaxAmountFrom.text.trim()) : null;
      _filter.totalTaxAmountTo = (_cTotalTaxAmountTo.text.trim().isNotEmpty) ? double.parse(_cTotalTaxAmountTo.text.trim()) : null;

      _filter.accountPincode = (_cPincode.text.trim().isNotEmpty) ? _cPincode.text.trim() : null;

      if (_filter.totalDiscountAmountFrom != null && _filter.totalDiscountAmountTo != null && _filter.totalDiscountAmountFrom > _filter.totalDiscountAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ttl_dis_to_vld']}')));
      } else if (_filter.totalTaxAmountFrom != null && _filter.totalTaxAmountTo != null && _filter.totalTaxAmountFrom > _filter.totalTaxAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ttl_tax_to_vld']}')));
      }

      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SalesTaxAndDiscountReport(
                      a: widget.analytics,
                      o: widget.observer,
                      taxAndDiscountReportFilter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - SalesTaxAndDiscountReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = SalesTaxAndDiscountReportFilterModel();
      _cSalesInvoiceDateFrom.clear();
      _cSalesInvoiceDateTo.clear();
      _cAccountRegistrationDateFrom.clear();
      _cAccountRegistrationDateTo.clear();
      _cTotalDiscountAmountFrom.clear();
      _cTotalDiscountAmountTo.clear();
      _cTotalTaxAmountFrom.clear();
      _cTotalTaxAmountTo.clear();
      _cPincode.clear();

      setState(() {});
    } catch (e) {
      print('Exception - SalesTaxAndDiscountReportFilterScreen.dart - _reset(): ' + e.toString());
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
          if (_filter.salesInvoiceDateTo != null && !picked.isBefore(_filter.salesInvoiceDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cSalesInvoiceDateFrom.text = _dateFormat.format(picked);
            _filter.salesInvoiceDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['first_order_date_vld']}')));
          }
        } else if (id == 2) {
          bool _allow = true;
          if (_filter.salesInvoiceDateFrom != null && !picked.isAfter(_filter.salesInvoiceDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cSalesInvoiceDateTo.text = _dateFormat.format(picked);
            _filter.salesInvoiceDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['first_odr_date_to_vld']}')));
          }
        } else if (id == 3) {
          bool _allow = true;
          if (_filter.accountRegistrationDateTo != null && !picked.isBefore(_filter.accountRegistrationDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cAccountRegistrationDateFrom.text = _dateFormat.format(picked);
            _filter.accountRegistrationDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['last_odr_date_to_vld']}')));
          }
        } else if (id == 4) {
          bool _allow = true;
          if (_filter.accountRegistrationDateFrom != null && !picked.isAfter(_filter.accountRegistrationDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cAccountRegistrationDateTo.text = _dateFormat.format(picked);
            _filter.accountRegistrationDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['last_odr_ate_from_vld']}')));
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - SalesTaxAndDiscountReportFilterScreen.dart - _selectDate(): ' + e.toString());
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
      _filter = SalesTaxAndDiscountReportFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);

        _cSalesInvoiceDateFrom.text = (_filter.salesInvoiceDateFrom != null) ? _dateFormat.format(_filter.salesInvoiceDateFrom) : '';
        _cSalesInvoiceDateTo.text = (_filter.salesInvoiceDateTo != null) ? _dateFormat.format(_filter.salesInvoiceDateTo) : '';
        _cAccountRegistrationDateFrom.text = (_filter.accountRegistrationDateFrom != null) ? _dateFormat.format(_filter.accountRegistrationDateFrom) : '';
        _cAccountRegistrationDateTo.text = (_filter.accountRegistrationDateTo != null) ? _dateFormat.format(_filter.accountRegistrationDateTo) : '';
        _cTotalDiscountAmountFrom.text = (_filter.totalDiscountAmountFrom != null) ? _filter.totalDiscountAmountFrom.toString() : '';
        _cTotalDiscountAmountTo.text = (_filter.totalDiscountAmountTo != null) ? _filter.totalDiscountAmountTo.toString() : '';
        _cTotalTaxAmountFrom.text = (_filter.totalTaxAmountFrom != null) ? _filter.totalTaxAmountFrom.toString() : '';
        _cTotalTaxAmountTo.text = (_filter.totalTaxAmountTo != null) ? _filter.totalTaxAmountTo.toString() : '';
        _cPincode.text = (_filter.accountPincode != null) ? _filter.accountPincode : '';
      }
    } catch (e) {
      print('Exception - SalesTaxAndDiscountReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SalesTaxAndDiscountReport(
                  a: widget.analytics,
                  o: widget.observer,
                  taxAndDiscountReportFilter: appliedFilter,
                )));
  }
}
