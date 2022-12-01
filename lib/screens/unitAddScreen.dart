// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/unitScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UnitAddScreen extends BaseRoute {
  final Unit unit;
  final int screenId;
  UnitAddScreen({@required a, @required o, @required this.screenId, this.unit}) : super(a: a, o: o, r: 'UnitAddScreen');
  @override
  _UnitAddScreenState createState() => _UnitAddScreenState(this.unit, this.screenId);
}

class _UnitAddScreenState extends BaseRouteState {
  Unit unit;
  int screenId;
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _cName =  TextEditingController();
  TextEditingController _cCode =  TextEditingController();
  TextEditingController _cDescription =  TextEditingController();
  bool _isExist = false;
  bool _isUsed = false;
  var _fName = FocusNode();
  var _fCode = FocusNode();
  var _fDescription = FocusNode();
  bool _autovalidate = false;

  _UnitAddScreenState(this.unit, this.screenId) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: (unit.id == null) ? Text(global.appLocaleValues['tle_unit_add']) : Text(global.appLocaleValues['tle_unit_update']),
          actions: <Widget>[
            TextButton(
              child: Text(
                global.appLocaleValues['btn_save'],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () {
                if (!_isUsed) {
                  _onSubmit();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${global.appLocaleValues['tle_unit_err_vld']}'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
              key: _formKey,
               autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _cName,
                          focusNode: _fName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          //   inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Za-z]'))],
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Za-z]'))],

                          onFieldSubmitted: (v) {
                            FocusScope.of(context).requestFocus(_fCode);
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.star,
                                size: 9,
                                color: Colors.red,
                              ),
                              border: nativeTheme().inputDecorationTheme.border,
                              hintText: global.appLocaleValues['lbl_unit_name_err_req'],
                              labelText: global.appLocaleValues['lbl_unit_name'],
                              errorText: _isExist ? global.appLocaleValues['lbl_unit_name_err_vld'] : null),
                          onChanged: (value) async {
                            await _unitNameExist(value);
                          },
                          validator: (v) {
                            if (v.isEmpty) {
                              return global.appLocaleValues['lbl_unit_name_err_req'];
                            } else if (v.contains(RegExp('[0-9]'))) {
                              return global.appLocaleValues['vel_character_only'];
                            } else if (_isExist == true) {
                              return global.appLocaleValues['lbl_unit_name_err_vld'];
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _cCode,
                          focusNode: _fCode,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.characters,
                          // inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Z]'))],
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z]'))],

                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.star,
                                size: 9,
                                color: Colors.red,
                              ),
                              hintText: global.appLocaleValues['lbl_unit_code_err_req'],
                              border: nativeTheme().inputDecorationTheme.border,
                              labelText: global.appLocaleValues['lbl_unit_code']),
                          validator: (v) {
                            if (v.isEmpty) {
                              return global.appLocaleValues['lbl_unit_code_err_req'];
                            } else if (v.contains(RegExp('[0-9]'))) {
                              return global.appLocaleValues['vel_character_only'];
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _cDescription,
                          focusNode: _fDescription,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 4,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_desc'], border: nativeTheme().inputDecorationTheme.border, alignLabelWithHint: true, labelText: '${global.appLocaleValues['lbl_desc']} (${global.appLocaleValues['lbl_optional']})'),
                        ),
                      ),
                    ],
                  ),
                ),
              ])),
        ));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      if (unit != null) {
        await _filldata();
      } else {
        unit =  Unit();
      }
    } catch (e) {
      print('Exception - unitAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _filldata() async {
    try {
      _cName.text = unit.name;
      _cDescription.text = unit.description;
      _cCode.text = unit.code;
      int _result = await dbHelper.unitIsUsed(unit.id);
      if (_result > 0) {
        _isUsed = true;
      }
      setState(() {});
    } catch (e) {
      print('Exception - unitAddScreen.dart - _filldata(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_formKey.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        unit.name = _cName.text.trim();
        unit.description = _cDescription.text.trim();
        unit.code = _cCode.text.trim();
        if (unit.id == null) {
          unit.id = await dbHelper.unitInsert(unit);
        } else {
          await dbHelper.unitUpdate(unit);
        }
        hideLoader();
        setState(() {});
        if (screenId == 0) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UnitScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - unitAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  Future _unitNameExist(value) async {
    try {
      _isExist = unit.id != null ? await dbHelper.unitNameExist(unitName: value, unitId: unit.id) : await dbHelper.unitNameExist(unitName: value);
      setState(() {});
    } catch (e) {
      print('Exception - unitAddScreen.dart - _unitNameExist(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
