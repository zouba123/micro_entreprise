// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/dialogs/productTypeSelectDialog.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/productGeneralReportFilterModel.dart';
import 'package:accounting_app/reports/productGeneralReport.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProductGeneralReportFilterScreen extends BaseRoute {
  final ProductGeneralReportFilterModel appliedFilter;
  ProductGeneralReportFilterScreen({@required a, @required o, this.appliedFilter}) : super(a: a, o: o, r: 'ProductGeneralReportFilterScreen');
  @override
  _AccountSellerReportFilterScreenState createState() => _AccountSellerReportFilterScreenState(appliedFilter);
}

class _AccountSellerReportFilterScreenState extends BaseRouteState {
  ProductGeneralReportFilterModel appliedFilter;
  ProductGeneralReportFilterModel _filter;

  TextEditingController _cPriceFrom = TextEditingController();
  TextEditingController _cPriceTo = TextEditingController();
  TextEditingController _cType = TextEditingController();

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
              '${global.appLocaleValues['pro_gen_rep_filter']}',
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
                                  controller: _cPriceFrom,
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
                                  controller: _cPriceTo,
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
                                      '${global.appLocaleValues['show_pro_des']}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                trailing: Switch(
                                  value: _filter.showProductDescription,
                                  onChanged: (value) {
                                    setState(() {
                                      _filter.showProductDescription = value;
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
      _filter.priceFrom = (_cPriceFrom.text.trim().isNotEmpty) ? double.parse(_cPriceFrom.text.trim()) : null;
      _filter.priceTo = (_cPriceTo.text.trim().isNotEmpty) ? double.parse(_cPriceTo.text.trim()) : null;

      if (_filter.priceFrom != null && _filter.priceTo != null && _filter.priceFrom > _filter.priceTo) {
        _allow = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['pro_amt_to_vld']}')));
      }

      if (_allow) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => ProductGeneralReport(
                      a: widget.analytics,
                      o: widget.observer,
                      filter: _filter,
                    )));
      }
    } catch (e) {
      print('Exception - ProductGeneralReportFilterScreen.dart - _search(): ' + e.toString());
    }
  }

  void _reset() {
    try {
      _filter = ProductGeneralReportFilterModel();
      _cPriceFrom.clear();
      _cPriceTo.clear();
      _cType.clear();
      setState(() {});
    } catch (e) {
      print('Exception - ProductGeneralReportFilterScreen.dart - _reset(): ' + e.toString());
    }
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
      print('Exception - ProductGeneralReportFilterScreen.dart - _selectType(): ' + e.toString());
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
      _filter = ProductGeneralReportFilterModel();
      if (appliedFilter != null) {
        _filter = _filter.copyFrom(appliedFilter);
        _cPriceFrom.text = (_filter.priceFrom != null) ? _filter.priceFrom.toString() : '';
        _cPriceTo.text = (_filter.priceTo != null) ? _filter.priceTo.toString() : '';
        _cType.text = (_filter.productType != null && _filter.productType.id != null) ? _filter.productType.name : '';
      }
    } catch (e) {
      print('Exception - ProductGeneralReportFilterScreen.dart - _fillData(): ' + e.toString());
    }
  }

  void _backButtonFunction() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ProductGeneralReport(
                  a: widget.analytics,
                  o: widget.observer,
                  filter: appliedFilter,
                )));
  }
}
