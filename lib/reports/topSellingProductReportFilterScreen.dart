// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/dialogs/productTypeSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/topSellingProductReportFilterModel.dart';
import 'package:accounting_app/reports/topSellingProductsReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class TopSellingProductReportFilterScreen extends BaseRoute {
  final TopSellingProductReportFilterModel appliedFilter;
  TopSellingProductReportFilterScreen({@required a, @required o, this.appliedFilter}) : super(a: a, o: o, r: 'TopSellingProductReportFilterScreen');
  @override
  _AccountSellerReportFilterScreenState createState() => _AccountSellerReportFilterScreenState(appliedFilter);
}

class _AccountSellerReportFilterScreenState extends BaseRouteState {
  TopSellingProductReportFilterModel appliedFilter;
  TopSellingProductReportFilterModel _filter;

  TextEditingController _cDateFrom = TextEditingController();
  TextEditingController _cDateTo = TextEditingController();
  TextEditingController _cType = TextEditingController();
  TextEditingController _cTotalSoldQtyFrom = TextEditingController();
  TextEditingController _cTotalSoldQtyTo = TextEditingController();
  TextEditingController _cTotalSoldAmountFrom = TextEditingController();
  TextEditingController _cTotalSoldAmountTo = TextEditingController();
  TextEditingController _cProductPriceFrom = TextEditingController();
  TextEditingController _cProductPriceTo = TextEditingController();
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
              '${global.appLocaleValues['top_sel_pro_rep_fltr']}',
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
                  child: Text('${global.appLocaleValues['lbl_date']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cDateFrom,
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
                                  controller: _cDateTo,
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
                  child: Text('${global.appLocaleValues['pro_type']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                            controller: _cType,
                            readOnly: true,
                            onTap: () async {
                              await _selectType(context);
                            },
                            decoration: InputDecoration(
                              hintText: '${global.appLocaleValues['sel_type']}',
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
                  child: Text('${global.appLocaleValues['tlt_sold_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalSoldAmountFrom,
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
                                  controller: _cTotalSoldAmountTo,
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
                  child: Text('${global.appLocaleValues['ttl_sold_qty']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cTotalSoldQtyFrom,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['from_qty']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: TextFormField(
                                  controller: _cTotalSoldQtyTo,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 7,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
                                  decoration: InputDecoration(hintText: '${global.appLocaleValues['to_qty']}', border: nativeTheme().inputDecorationTheme.border, counterText: ''),
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
                  child: Text('${global.appLocaleValues['pro_price_amt']}', style: Theme.of(context).primaryTextTheme.headline3),
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
                                  controller: _cProductPriceFrom,
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
                                  controller: _cProductPriceTo,
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
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                  ),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              // color: Colors.red,
                              height: 40,
                              child: ListTile(
                                contentPadding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      '${global.appLocaleValues['pro_active']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                trailing: Switch(
                                  value: _filter.isActive,
                                  onChanged: (value) {
                                    setState(() {
                                      _filter.isActive = value;
                                    });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
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
      _filter.totalSoldQtyFrom = (_cTotalSoldQtyFrom.text.trim().isNotEmpty) ? int.parse(_cTotalSoldQtyFrom.text.trim()) : null;
      _filter.totalSoldQtyTo = (_cTotalSoldQtyTo.text.trim().isNotEmpty) ? int.parse(_cTotalSoldQtyTo.text.trim()) : null;

      _filter.totalSoldAmountFrom = (_cTotalSoldAmountFrom.text.trim().isNotEmpty) ? double.parse(_cTotalSoldAmountFrom.text.trim()) : null;
      _filter.totalSoldAmountTo = (_cTotalSoldAmountTo.text.trim().isNotEmpty) ? double.parse(_cTotalSoldAmountTo.text.trim()) : null;

      _filter.productPriceFrom = (_cProductPriceFrom.text.trim().isNotEmpty) ? double.parse(_cProductPriceFrom.text.trim()) : null;
      _filter.productPriceTo = (_cProductPriceTo.text.trim().isNotEmpty) ? double.parse(_cProductPriceTo.text.trim()) : null;

      if (_filter.totalSoldQtyFrom != null && _filter.totalSoldQtyTo != null && _filter.totalSoldQtyFrom > _filter.totalSoldQtyTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ttl_sld_qty_to_vld']}')));
      } else if (_filter.totalSoldAmountFrom != null && _filter.totalSoldAmountTo != null && _filter.totalSoldAmountFrom > _filter.totalSoldAmountTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['ttl_sld_qty_from_vld']}')));
      } else if (_filter.productPriceFrom != null && _filter.productPriceTo != null && _filter.productPriceFrom > _filter.productPriceTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['pro_amt_to_vld']}')));
      }

      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => TopSellingProductsReport(
                      a: widget.analytics,
                      o: widget.observer,
                      filter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - TopSellingProductReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = TopSellingProductReportFilterModel();
      _cDateFrom.clear();
      _cDateTo.clear();
      _cTotalSoldAmountFrom.clear();
      _cTotalSoldAmountTo.clear();
      _cProductPriceFrom.clear();
      _cProductPriceTo.clear();
      _cTotalSoldQtyFrom.clear();
      _cTotalSoldQtyTo.clear();
      _cType.clear();
      setState(() {});
    } catch (e) {
      print('Exception - TopSellingProductReportFilterScreen.dart - _reset(): ' + e.toString());
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
          if (_filter.dateTo != null && !picked.isBefore(_filter.dateTo.add(Duration(days: 1)))) {
            _allow = false;
          }

          if (_allow) {
            _cDateFrom.text = _dateFormat.format(picked);
            _filter.dateFrom = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['from_dt_to_vld']}')));
          }
        } else if (id == 2) {
          bool _allow = true;
          if (_filter.dateFrom != null && !picked.isAfter(_filter.dateFrom.subtract(Duration(days: 1)))) {
            _allow = false;
          }
          if (_allow) {
            _cDateTo.text = _dateFormat.format(picked);
            _filter.dateTo = picked;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['to_dt_to_vld']}')));
          }
        }
        setState(() {});
      }
    } catch (e) {
      print('Exception - TopSellingProductReportFilterScreen.dart - _selectDate(): ' + e.toString());
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
      _filter = TopSellingProductReportFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);

        _cDateFrom.text = (_filter.dateFrom != null) ? _dateFormat.format(_filter.dateFrom) : '';
        _cDateTo.text = (_filter.dateTo != null) ? _dateFormat.format(_filter.dateTo) : '';
        _cType.text = (_filter.productType != null && _filter.productType.name != null) ? _filter.productType.name : '';

        _cTotalSoldAmountFrom.text = (_filter.totalSoldAmountFrom != null) ? _filter.totalSoldAmountFrom.toString() : '';
        _cTotalSoldAmountTo.text = (_filter.totalSoldAmountTo != null) ? _filter.totalSoldAmountTo.toString() : '';
        _cTotalSoldQtyFrom.text = (_filter.totalSoldQtyFrom != null) ? _filter.totalSoldQtyFrom.toString() : '';
        _cTotalSoldQtyTo.text = (_filter.totalSoldQtyTo != null) ? _filter.totalSoldQtyTo.toString() : '';
        _cProductPriceFrom.text = (_filter.productPriceFrom != null) ? _filter.productPriceFrom.toString() : '';
        _cProductPriceTo.text = (_filter.productPriceTo != null) ? _filter.productPriceTo.toString() : '';
      }
    } catch (e) {
      print('Exception - TopSellingProductReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => TopSellingProductsReport(
                  a: widget.analytics,
                  o: widget.observer,
                  filter: appliedFilter,
                )));
  }

  Future _selectType(context) async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductTypeSelectDialog(
              a: widget.analytics,
              o: widget.observer,
              selectedProductType: (obj) async {
                if (obj != null) {
                  _filter.productType = obj;
                  _cType.text = obj.name;
                }
                setState(() {});
              })));
    } catch (e) {
      print('Exception - TopSellingProductReportFilterScreen.dart - _selectType(): ' + e.toString());
    }
  }
}
