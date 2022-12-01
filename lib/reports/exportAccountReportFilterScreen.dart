// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/exportAccountFilterModel.dart';
import 'package:accounting_app/reports/exportAccountReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExportAccountReportFilterScreen extends BaseRoute {
  final ExportAccountFilterModel appliedFilter;
  ExportAccountReportFilterScreen({@required a, @required o, @required this.appliedFilter}) : super(a: a, o: o, r: 'ExportAccountReportFilterScreen');
  @override
  _ExportAccountReportFilterScreenState createState() => _ExportAccountReportFilterScreenState(appliedFilter);
}

class _ExportAccountReportFilterScreenState extends BaseRouteState {
  ExportAccountFilterModel appliedFilter;
  ExportAccountFilterModel _filter;

  TextEditingController _cAccountRegistrationDateFrom = TextEditingController();
  TextEditingController _cAccountRegistrationDateTo = TextEditingController();

  TextEditingController _cPincode = TextEditingController();
  DateFormat _dateFormat;

  _ExportAccountReportFilterScreenState(this.appliedFilter) : super();

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
              '${global.appLocaleValues['exp_ac_rep_fltr']}',
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
                                  controller: _cAccountRegistrationDateFrom,
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
                                  controller: _cAccountRegistrationDateTo,
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
      _filter.pincode = (_cPincode.text.trim().isNotEmpty) ? _cPincode.text.trim() : null;
      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ExportAccountReport(
                      a: widget.analytics,
                      o: widget.observer,
                      filter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - ExportAccountReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = ExportAccountFilterModel();
      _cAccountRegistrationDateFrom.clear();
      _cAccountRegistrationDateTo.clear();
      _cPincode.clear();

      setState(() {});
    } catch (e) {
      print('Exception - ExportAccountReportFilterScreen.dart - _reset(): ' + e.toString());
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
        if (id == 5) {
          bool _allow = true;
          if (_filter.registrationDateTo != null && !picked.isBefore(_filter.registrationDateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cAccountRegistrationDateFrom.text = _dateFormat.format(picked);
            _filter.registrationDateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ac_reg_from_to_dt_vld']}')));
          }
        } else if (id == 6) {
          bool _allow = true;
          if (_filter.registrationDateFrom != null && !picked.isAfter(_filter.registrationDateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cAccountRegistrationDateTo.text = _dateFormat.format(picked);
            _filter.registrationDateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ac_reg_to_from_dt_vld']}')));
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - ExportAccountReportFilterScreen.dart - _selectDate(): ' + e.toString());
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
      _filter = ExportAccountFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);
        _cAccountRegistrationDateFrom.text = (_filter.registrationDateFrom != null) ? _dateFormat.format(_filter.registrationDateFrom) : '';
        _cAccountRegistrationDateTo.text = (_filter.registrationDateTo != null) ? _dateFormat.format(_filter.registrationDateTo) : '';
        _cPincode.text = (_filter.pincode != null) ? _filter.pincode : '';
      }
    } catch (e) {
      print('Exception - ExportAccountReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ExportAccountReport(
                  a: widget.analytics,
                  o: widget.observer,
                  filter: appliedFilter,
                )));
  }
}
