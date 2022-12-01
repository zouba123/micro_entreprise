// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/models/accountSellerReportFilterModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/reports/accountSellerReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AccountSellerReportFilterScreen extends BaseRoute {
  final AccountSellerReportFilterModel appliedFilter;
  AccountSellerReportFilterScreen({@required a, @required o, this.appliedFilter}) : super(a: a, o: o, r: 'AccountSellerReportFilterScreen');
  @override
  _AccountSellerReportFilterScreenState createState() => _AccountSellerReportFilterScreenState(appliedFilter);
}

class _AccountSellerReportFilterScreenState extends BaseRouteState {
  AccountSellerReportFilterModel appliedFilter;
  AccountSellerReportFilterModel _filter;
  TextEditingController _cFristOrderDateFrom = TextEditingController();
  TextEditingController _cFristOrderDateTo = TextEditingController();
  TextEditingController _cLastOrderDateFrom = TextEditingController();
  TextEditingController _cLastOrderDateTo = TextEditingController();
  // GlobalKey<ScaffoldState> _scaffoldKey;

  TextEditingController _cFristOrderAmountFrom = TextEditingController();
  TextEditingController _cFristOrderAmountTo = TextEditingController();
  TextEditingController _cLastOrderAmountFrom = TextEditingController();
  TextEditingController _cLastOrderAmountTo = TextEditingController();

  TextEditingController _cMinOrderAmountFrom = TextEditingController();
  TextEditingController _cMinOrderAmountTo = TextEditingController();
  TextEditingController _cAvgOrderAmountTo = TextEditingController();
  TextEditingController _cAvgOrderAmountFrom = TextEditingController();
  TextEditingController _cMaxOrderAmountTo = TextEditingController();
  TextEditingController _cMaxOrderAmountFrom = TextEditingController();

  TextEditingController _cTotalSpendFrom = TextEditingController();
  TextEditingController _cTotalSpendTo = TextEditingController();
  TextEditingController _cTotalPaidFrom = TextEditingController();
  TextEditingController _cTotalPaidTo = TextEditingController();
  TextEditingController _cTotalPendingFrom = TextEditingController();
  TextEditingController _cTotalPendingTo = TextEditingController();

  TextEditingController _cTotalOrderFrom = TextEditingController();
  TextEditingController _cTotalOrderTo = TextEditingController();

  TextEditingController _cAccountRegistrationFrom = TextEditingController();
  TextEditingController _cAccountRegistrationTo = TextEditingController();

  TextEditingController _cPincode = TextEditingController();
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
              global.appLocaleValues['tle_ac_seller_rpt_fltr'],
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
                  child: Text(global.appLocaleValues['first_order_date'], style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cFristOrderDateFrom,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectDate(context, 1);
                                  },
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['from_date'], border: nativeTheme().inputDecorationTheme.border, counterText: '',
                                    // prefixIcon: Icon(Icons.calendar_today)
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cFristOrderDateTo,
                                  readOnly: true,
                                  maxLength: 5,
                                  onTap: () async {
                                    await _selectDate(context, 2);
                                  },
                                  decoration: InputDecoration(hintText: global.appLocaleValues['to_date'], border: nativeTheme().inputDecorationTheme.border, counterText: ''),
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
                  child: Text(global.appLocaleValues['last_order_date'], style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cLastOrderDateFrom,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectDate(context, 3);
                                  },
                                  decoration: InputDecoration(hintText: global.appLocaleValues['from_date'], border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cLastOrderDateTo,
                                  readOnly: true,
                                  maxLength: 5,
                                  onTap: () async {
                                    await _selectDate(context, 4);
                                  },
                                  decoration: InputDecoration(hintText: global.appLocaleValues['to_date'], border: nativeTheme().inputDecorationTheme.border, counterText: ''),
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
                  child: Text(global.appLocaleValues['first_ord_amt'], style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cFristOrderAmountFrom,
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
                                  controller: _cFristOrderAmountTo,
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
                  child: Text('${global.appLocaleValues['last_ord_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cLastOrderAmountFrom,
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
                                  controller: _cLastOrderAmountTo,
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
                  child: Text('${global.appLocaleValues['min_ord_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cMinOrderAmountFrom,
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
                                  controller: _cMinOrderAmountTo,
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
                  child: Text('${global.appLocaleValues['avg_ord_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cAvgOrderAmountFrom,
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
                                  controller: _cAvgOrderAmountTo,
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
                  child: Text('${global.appLocaleValues['max_ord_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cMaxOrderAmountFrom,
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
                                  controller: _cMaxOrderAmountTo,
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
                  child: Text('${global.appLocaleValues['tlt_spend_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalSpendFrom,
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
                                  controller: _cTotalSpendTo,
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
                  child: Text('${global.appLocaleValues['tlt_paid_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalPaidFrom,
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
                                  controller: _cTotalPaidTo,
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
                  child: Text('${global.appLocaleValues['tlt_pending_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalPendingFrom,
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
                                  controller: _cTotalPendingTo,
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
                  child: Text('${global.appLocaleValues['tlt_orders']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalOrderFrom,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['from_ordres']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cTotalOrderTo,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['to_orders']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
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
                  child: Text('${global.appLocaleValues['ac_reg_date']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cAccountRegistrationFrom,
                                  readOnly: true,
                                  onTap: () async {
                                    await _selectDate(context, 5);
                                  },
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['from_date']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cAccountRegistrationTo,
                                  readOnly: true,
                                  maxLength: 5,
                                  onTap: () async {
                                    await _selectDate(context, 6);
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
      _filter.firstOrderAmountFrom = (_cFristOrderAmountFrom.text.trim().isNotEmpty) ? double.parse(_cFristOrderAmountFrom.text.trim()) : null;
      _filter.firstOrderAmountTo = (_cFristOrderAmountTo.text.trim().isNotEmpty) ? double.parse(_cFristOrderAmountTo.text.trim()) : null;

      _filter.lastOrderAmountFrom = (_cLastOrderAmountFrom.text.trim().isNotEmpty) ? double.parse(_cLastOrderAmountFrom.text.trim()) : null;
      _filter.lastOrderAmountTo = (_cLastOrderAmountTo.text.trim().isNotEmpty) ? double.parse(_cLastOrderAmountTo.text.trim()) : null;

      _filter.minOrderAmountFrom = (_cMinOrderAmountFrom.text.trim().isNotEmpty) ? double.parse(_cMinOrderAmountFrom.text.trim()) : null;
      _filter.minOrderAmountTo = (_cMinOrderAmountTo.text.trim().isNotEmpty) ? double.parse(_cMinOrderAmountTo.text.trim()) : null;

      _filter.avgOrderAmountFrom = (_cAvgOrderAmountFrom.text.trim().isNotEmpty) ? double.parse(_cAvgOrderAmountFrom.text.trim()) : null;
      _filter.avgOrderAmountTo = (_cAvgOrderAmountTo.text.trim().isNotEmpty) ? double.parse(_cAvgOrderAmountTo.text.trim()) : null;

      _filter.maxOrderAmountFrom = (_cMaxOrderAmountFrom.text.trim().isNotEmpty) ? double.parse(_cMaxOrderAmountFrom.text.trim()) : null;
      _filter.maxOrderAmountTo = (_cMaxOrderAmountTo.text.trim().isNotEmpty) ? double.parse(_cMaxOrderAmountTo.text.trim()) : null;

      _filter.totalSpendFrom = (_cTotalSpendFrom.text.trim().isNotEmpty) ? double.parse(_cTotalSpendFrom.text.trim()) : null;
      _filter.totalSpendTo = (_cTotalSpendTo.text.trim().isNotEmpty) ? double.parse(_cTotalSpendTo.text.trim()) : null;

      _filter.totalPaidFrom = (_cTotalPaidFrom.text.trim().isNotEmpty) ? double.parse(_cTotalPaidFrom.text.trim()) : null;
      _filter.totalPaidTo = (_cTotalPaidTo.text.trim().isNotEmpty) ? double.parse(_cTotalPaidTo.text.trim()) : null;

      _filter.totalPendingFrom = (_cTotalPendingFrom.text.trim().isNotEmpty) ? double.parse(_cTotalPendingFrom.text.trim()) : null;
      _filter.totalPendingTo = (_cTotalPendingTo.text.trim().isNotEmpty) ? double.parse(_cTotalPendingTo.text.trim()) : null;

      _filter.totalOrderFrom = (_cTotalOrderFrom.text.trim().isNotEmpty) ? int.parse(_cTotalOrderFrom.text.trim()) : null;
      _filter.totalOrderTo = (_cTotalOrderTo.text.trim().isNotEmpty) ? int.parse(_cTotalOrderTo.text.trim()) : null;
      _filter.pincode = (_cPincode.text.trim().isNotEmpty) ? _cPincode.text.trim() : null;

      if (_filter.firstOrderAmountFrom != null && _filter.firstOrderAmountTo != null && _filter.firstOrderAmountFrom > _filter.firstOrderAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['first_last_order_amt_vld']}')));
      } else if (_filter.lastOrderAmountFrom != null && _filter.lastOrderAmountTo != null && _filter.lastOrderAmountFrom > _filter.lastOrderAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['last_order_amt_vld']}')));
      } else if (_filter.minOrderAmountFrom != null && _filter.minOrderAmountTo != null && _filter.minOrderAmountFrom > _filter.minOrderAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['min_to_amt_vld']}')));
      } else if (_filter.avgOrderAmountFrom != null && _filter.avgOrderAmountTo != null && _filter.avgOrderAmountFrom > _filter.avgOrderAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['avg_to_amt_vld']}')));
      } else if (_filter.maxOrderAmountFrom != null && _filter.maxOrderAmountTo != null && _filter.maxOrderAmountFrom > _filter.maxOrderAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['max_to_amt_vld']}')));
      } else if (_filter.totalSpendFrom != null && _filter.totalSpendTo != null && _filter.totalSpendFrom > _filter.totalSpendTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['spend_to_amt_vld']}')));
      } else if (_filter.totalPaidFrom != null && _filter.totalPaidTo != null && _filter.totalPaidFrom > _filter.totalPaidTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['paid_ro_amt_vld']}')));
      } else if (_filter.totalPendingFrom != null && _filter.totalPendingTo != null && _filter.totalPendingFrom > _filter.totalPendingTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['pending_to_amt_vld']}')));
      } else if (_filter.totalOrderFrom != null && _filter.totalOrderTo != null && _filter.totalOrderFrom > _filter.totalOrderTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['odr_to_amt_vld']}')));
      }

      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AccountSellerReport(
                      a: widget.analytics,
                      o: widget.observer,
                      filter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - AccountSellerReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = AccountSellerReportFilterModel();
      _cFristOrderDateFrom.clear();
      _cFristOrderDateTo.clear();
      _cLastOrderDateFrom.clear();
      _cLastOrderDateTo.clear();
      _cFristOrderAmountFrom.clear();
      _cFristOrderAmountTo.clear();
      _cLastOrderAmountFrom.clear();
      _cLastOrderAmountTo.clear();
      _cMinOrderAmountFrom.clear();
      _cMinOrderAmountTo.clear();
      _cAvgOrderAmountTo.clear();
      _cAvgOrderAmountFrom.clear();
      _cMaxOrderAmountTo.clear();
      _cMaxOrderAmountFrom.clear();
      _cTotalSpendFrom.clear();
      _cTotalSpendTo.clear();
      _cTotalPaidFrom.clear();
      _cTotalPaidTo.clear();
      _cTotalPendingFrom.clear();
      _cTotalPendingTo.clear();
      _cTotalOrderFrom.clear();
      _cTotalOrderTo.clear();
      _cAccountRegistrationFrom.clear();
      _cAccountRegistrationTo.clear();
      _cPincode.clear();

      setState(() {});
    } catch (e) {
      print('Exception - AccountSellerReportFilterScreen.dart - _reset(): ' + e.toString());
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
          if (_filter.firstOrderDateTo != null && !picked.isBefore(_filter.firstOrderDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cFristOrderDateFrom.text = _dateFormat.format(picked);
            _filter.firstOrderDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['first_order_date_vld']}')));
          }
        } else if (id == 2) {
          bool _allow = true;
          if (_filter.firstOrderDateFrom != null && !picked.isAfter(_filter.firstOrderDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cFristOrderDateTo.text = _dateFormat.format(picked);
            _filter.firstOrderDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['first_odr_date_to_vld']}')));
          }
        } else if (id == 3) {
          bool _allow = true;
          if (_filter.lastOrderDateTo != null && !picked.isBefore(_filter.lastOrderDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cLastOrderDateFrom.text = _dateFormat.format(picked);
            _filter.lastOrderDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['last_odr_date_to_vld']}')));
          }
        } else if (id == 4) {
          bool _allow = true;
          if (_filter.lastOrderDateFrom != null && !picked.isAfter(_filter.lastOrderDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cLastOrderDateTo.text = _dateFormat.format(picked);
            _filter.lastOrderDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['last_odr_ate_from_vld']}')));
          }
        } else if (id == 5) {
          bool _allow = true;
          if (_filter.accountRegistrationTo != null && !picked.isBefore(_filter.accountRegistrationTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cAccountRegistrationFrom.text = _dateFormat.format(picked);
            _filter.accountRegistrationFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ac_reg_from_to_dt_vld']}')));
          }
        } else if (id == 6) {
          bool _allow = true;
          if (_filter.accountRegistrationFrom != null && !picked.isAfter(_filter.accountRegistrationFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cAccountRegistrationTo.text = _dateFormat.format(picked);
            _filter.accountRegistrationTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ac_reg_to_from_dt_vld']}')));
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - AccountSellerReportFilterScreen.dart - _selectDate(): ' + e.toString());
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
      _filter = AccountSellerReportFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);

        _cFristOrderDateFrom.text = (_filter.firstOrderDateFrom != null) ? _dateFormat.format(_filter.firstOrderDateFrom) : '';
        _cFristOrderDateTo.text = (_filter.firstOrderDateTo != null) ? _dateFormat.format(_filter.firstOrderDateTo) : '';
        _cLastOrderDateFrom.text = (_filter.lastOrderDateFrom != null) ? _dateFormat.format(_filter.lastOrderDateFrom) : '';
        _cLastOrderDateTo.text = (_filter.lastOrderDateTo != null) ? _dateFormat.format(_filter.lastOrderDateTo) : '';
        _cFristOrderAmountFrom.text = (_filter.firstOrderAmountFrom != null) ? _filter.firstOrderAmountFrom.toString() : '';
        _cFristOrderAmountTo.text = (_filter.firstOrderAmountTo != null) ? _filter.firstOrderAmountTo.toString() : '';
        _cLastOrderAmountFrom.text = (_filter.lastOrderAmountFrom != null) ? _filter.lastOrderAmountFrom.toString() : '';
        _cLastOrderAmountTo.text = (_filter.lastOrderAmountTo != null) ? _filter.lastOrderAmountTo.toString() : '';
        _cMinOrderAmountFrom.text = (_filter.minOrderAmountFrom != null) ? _filter.minOrderAmountFrom.toString() : '';
        _cMinOrderAmountTo.text = (_filter.minOrderAmountTo != null) ? _filter.minOrderAmountTo.toString() : '';
        _cAvgOrderAmountTo.text = (_filter.avgOrderAmountTo != null) ? _filter.avgOrderAmountTo.toString() : '';
        _cAvgOrderAmountFrom.text = (_filter.avgOrderAmountFrom != null) ? _filter.avgOrderAmountFrom.toString() : '';
        _cMaxOrderAmountTo.text = (_filter.maxOrderAmountTo != null) ? _filter.maxOrderAmountTo.toString() : '';
        _cMaxOrderAmountFrom.text = (_filter.maxOrderAmountFrom != null) ? _filter.maxOrderAmountFrom.toString() : '';
        _cTotalSpendFrom.text = (_filter.totalSpendFrom != null) ? _filter.totalSpendFrom.toString() : '';
        _cTotalSpendTo.text = (_filter.totalSpendTo != null) ? _filter.totalSpendTo.toString() : '';
        _cTotalPaidFrom.text = (_filter.totalPaidFrom != null) ? _filter.totalPaidFrom.toString() : '';
        _cTotalPaidTo.text = (_filter.totalPaidTo != null) ? _filter.totalPaidTo.toString() : '';
        _cTotalPendingFrom.text = (_filter.totalPaidFrom != null) ? _filter.totalPaidFrom.toString() : '';
        _cTotalPendingTo.text = (_filter.totalPaidTo != null) ? _filter.totalPaidTo.toString() : '';
        _cTotalOrderFrom.text = (_filter.totalOrderFrom != null) ? _filter.totalOrderFrom.toString() : '';
        _cTotalOrderTo.text = (_filter.totalOrderTo != null) ? _filter.totalOrderTo.toString() : '';
        _cAccountRegistrationFrom.text = (_filter.accountRegistrationFrom != null) ? _dateFormat.format(_filter.accountRegistrationFrom) : '';
        _cAccountRegistrationTo.text = (_filter.accountRegistrationTo != null) ? _dateFormat.format(_filter.accountRegistrationTo) : '';
        _cPincode.text = (_filter.pincode != null) ? _filter.pincode : '';
      }
    } catch (e) {
      print('Exception - AccountSellerReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AccountSellerReport(
                  a: widget.analytics,
                  o: widget.observer,
                  filter: appliedFilter,
                )));
  }
}
