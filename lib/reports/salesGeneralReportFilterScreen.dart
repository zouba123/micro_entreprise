// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/salesGeneralReportFilterModel.dart';
import 'package:accounting_app/reports/salesGeneralReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SalesGeneralReportFilterScreen extends BaseRoute {
  final SalesGeneralReportFilterModel appliedFilter;
  SalesGeneralReportFilterScreen({@required a, @required o, this.appliedFilter}) : super(a: a, o: o, r: 'SalesGeneralReportFilterScreen');
  @override
  _SalesGeneralReportFilterScreenState createState() => _SalesGeneralReportFilterScreenState(appliedFilter);
}

class _SalesGeneralReportFilterScreenState extends BaseRouteState {
  SalesGeneralReportFilterModel appliedFilter;
  SalesGeneralReportFilterModel _filter;

  TextEditingController _cAccount = TextEditingController();
  TextEditingController _cStatus = TextEditingController();
  TextEditingController _cInvoiceDateFrom = TextEditingController();
  TextEditingController _cInvoiceDateTo = TextEditingController();
  TextEditingController _cDeliveryDateFrom = TextEditingController();
  TextEditingController _cDeliveryDateTo = TextEditingController();

  TextEditingController _cNetAmountFrom = TextEditingController();
  TextEditingController _cNetAmountTo = TextEditingController();
  TextEditingController _cDiscountAmountFrom = TextEditingController();
  TextEditingController _cDiscountAmountTo = TextEditingController();

  TextEditingController _cTaxAmountFrom = TextEditingController();
  TextEditingController _cTaxAmountTo = TextEditingController();
  TextEditingController _cPaymentDoneAmountFrom = TextEditingController();
  TextEditingController _cPaymentDoneAmountTo = TextEditingController();
  TextEditingController _cPaymentPendingAmountFrom = TextEditingController();
  TextEditingController _cPaymentPendingAmountTo = TextEditingController();
  DateFormat _dateFormat;

  _SalesGeneralReportFilterScreenState(this.appliedFilter) : super();

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
              '${global.appLocaleValues['sal_gen_rep_flter']}',
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
                  child: Text('${global.appLocaleValues['lbl_invoice_date_']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cInvoiceDateFrom,
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
                                  controller: _cInvoiceDateTo,
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
                  child: Text('${global.appLocaleValues['lbl_delivery_date_']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cDeliveryDateFrom,
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
                                  controller: _cDeliveryDateTo,
                                  readOnly: true,
                                  maxLength: 5,
                                  onTap: () async {
                                    await _selectDate(context, 4);
                                  },
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['from_date']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
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
                  child: Text('${global.appLocaleValues['inv_sta']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                  child: Text('${global.appLocaleValues['inv_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 10, bottom: 5, left: 8),
                  child: Text('${global.appLocaleValues['payment_done_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cPaymentDoneAmountTo,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['from_amt']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cPaymentDoneAmountFrom,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['to_amt']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
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
                  child: Text('${global.appLocaleValues['payment_pending_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cPaymentPendingAmountTo,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['from_amt']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cPaymentPendingAmountFrom,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['to_amt']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
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

      _filter.paymentDoneAmountFrom = (_cPaymentDoneAmountTo.text.trim().isNotEmpty) ? double.parse(_cPaymentDoneAmountTo.text.trim()) : null;
      _filter.paymentDoneAmountTo = (_cPaymentDoneAmountFrom.text.trim().isNotEmpty) ? double.parse(_cPaymentDoneAmountFrom.text.trim()) : null;

      _filter.paymentPendingAmountFrom = (_cPaymentPendingAmountTo.text.trim().isNotEmpty) ? double.parse(_cPaymentPendingAmountTo.text.trim()) : null;
      _filter.paymentPendingAmountTo = (_cPaymentPendingAmountFrom.text.trim().isNotEmpty) ? double.parse(_cPaymentPendingAmountFrom.text.trim()) : null;

      if (_filter.netAmountFrom != null && _filter.netAmountTo != null && _filter.netAmountFrom > _filter.netAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invoice amount from should be lesser or equal to To amount')));
      } else if (_filter.discountAmountFrom != null && _filter.discountAmountTo != null && _filter.discountAmountFrom > _filter.discountAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Discount amount from should be lesser or equal to To amount')));
      } else if (_filter.taxAmountFrom != null && _filter.taxAmountTo != null && _filter.taxAmountFrom > _filter.taxAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tax amount from should be lesser or equal to To amount')));
      } else if (_filter.paymentPendingAmountFrom != null && _filter.paymentPendingAmountTo != null && _filter.paymentPendingAmountFrom > _filter.paymentPendingAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment pending amount from should be lesser or equal to To amount')));
      } else if (_filter.paymentDoneAmountFrom != null && _filter.paymentDoneAmountTo != null && _filter.paymentDoneAmountFrom > _filter.paymentDoneAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment done amount from should be lesser or equal to To amount')));
      }

      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SalesGeneralReport(
                      a: widget.analytics,
                      o: widget.observer,
                      salesGeneralReportFilter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - SalesGeneralReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = SalesGeneralReportFilterModel();
      _filter.invoiceDateFrom = DateTime.parse(DateTime.now().subtract(Duration(days: 7)).toString().substring(0, 10));
      _filter.invoiceDateTo = DateTime.parse(DateTime.now().toString().substring(0, 10));
      _cInvoiceDateFrom.text = _dateFormat.format(_filter.invoiceDateFrom);
      _cInvoiceDateTo.text = _dateFormat.format(_filter.invoiceDateTo);
      _cDeliveryDateFrom.clear();
      _cDeliveryDateTo.clear();
      _cNetAmountFrom.clear();
      _cNetAmountTo.clear();
      _cDiscountAmountFrom.clear();
      _cDiscountAmountTo.clear();
      _cTaxAmountFrom.clear();
      _cTaxAmountTo.clear();
      _cPaymentDoneAmountFrom.clear();
      _cPaymentDoneAmountTo.clear();
      _cPaymentPendingAmountFrom.clear();
      _cPaymentPendingAmountTo.clear();
      _cAccount.clear();
      _cStatus.clear();

      setState(() {});
    } catch (e) {
      print('Exception - SalesGeneralReportFilterScreen.dart - _reset(): ' + e.toString());
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
          if (_filter.invoiceDateTo != null && !picked.isBefore(_filter.invoiceDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cInvoiceDateFrom.text = _dateFormat.format(picked);
            _filter.invoiceDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invoice from date should be lesser or equal to To date')));
          }
        } else if (id == 2) {
          bool _allow = true;
          if (_filter.invoiceDateFrom != null && !picked.isAfter(_filter.invoiceDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cInvoiceDateTo.text = _dateFormat.format(picked);
            _filter.invoiceDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invoice to date should be greater or equal to From date')));
          }
        } else if (id == 3) {
          bool _allow = true;
          if (_filter.deliveryDateTo != null && !picked.isBefore(_filter.deliveryDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cDeliveryDateFrom.text = _dateFormat.format(picked);
            _filter.deliveryDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delivery from date should be lesser or equal to To date')));
          }
        } else if (id == 4) {
          bool _allow = true;
          if (_filter.deliveryDateFrom != null && !picked.isAfter(_filter.deliveryDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cDeliveryDateTo.text = _dateFormat.format(picked);
            _filter.deliveryDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delivery to date should be greater or equal to From date')));
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - SalesGeneralReportFilterScreen.dart - _selectDate(): ' + e.toString());
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
      _filter = SalesGeneralReportFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);

        _cAccount.text = (_filter.account != null && _filter.account.id != null) ? _filter.account.firstName + ' ' + _filter.account.lastName : '';
        _cStatus.text = (_filter.invoiceStatus != null && _filter.invoiceStatus.isNotEmpty) ? _filter.invoiceStatus : '';

        _cInvoiceDateFrom.text = (_filter.invoiceDateFrom != null) ? _dateFormat.format(_filter.invoiceDateFrom) : '';
        _cInvoiceDateTo.text = (_filter.invoiceDateTo != null) ? _dateFormat.format(_filter.invoiceDateTo) : '';

        _cDeliveryDateFrom.text = (_filter.deliveryDateFrom != null) ? _dateFormat.format(_filter.deliveryDateFrom) : '';
        _cDeliveryDateTo.text = (_filter.deliveryDateTo != null) ? _dateFormat.format(_filter.deliveryDateTo) : '';

        _cNetAmountFrom.text = (_filter.netAmountFrom != null) ? _filter.netAmountFrom.toString() : '';
        _cNetAmountTo.text = (_filter.netAmountTo != null) ? _filter.netAmountTo.toString() : '';

        _cDiscountAmountFrom.text = (_filter.discountAmountFrom != null) ? _filter.discountAmountFrom.toString() : '';
        _cDiscountAmountTo.text = (_filter.discountAmountTo != null) ? _filter.discountAmountTo.toString() : '';

        _cTaxAmountFrom.text = (_filter.taxAmountFrom != null) ? _filter.taxAmountFrom.toString() : '';
        _cTaxAmountTo.text = (_filter.taxAmountTo != null) ? _filter.taxAmountTo.toString() : '';

        _cPaymentDoneAmountFrom.text = (_filter.paymentDoneAmountTo != null) ? _filter.paymentDoneAmountTo.toString() : '';
        _cPaymentDoneAmountTo.text = (_filter.paymentDoneAmountFrom != null) ? _filter.paymentDoneAmountFrom.toString() : '';

        _cPaymentPendingAmountFrom.text = (_filter.paymentPendingAmountTo != null) ? _filter.paymentPendingAmountTo.toString() : '';
        _cPaymentPendingAmountTo.text = (_filter.paymentPendingAmountFrom != null) ? _filter.paymentPendingAmountFrom.toString() : '';
      }
    } catch (e) {
      print('Exception - SalesGeneralReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => SalesGeneralReport(
                  a: widget.analytics,
                  o: widget.observer,
                  salesGeneralReportFilter: appliedFilter,
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
      print('Exception - SalesGeneralReportFilterScreen.dart - _selectAccount(): ' + e.toString());
    }
  }

  Future _selectStatus(context) async {
    try {
      List<String> _statusList = ['PAID', 'DUE', 'CANCELLED'];
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
                        _filter.invoiceStatus = _statusList[index];
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
      print('Exception - SalesGeneralReportFilterScreen.dart - _chooseDateFormate(): ' + e.toString());
      return null;
    }
  }
}
