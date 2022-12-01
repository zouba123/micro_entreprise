// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/unitCombinationModel.dart';
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/unitScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';

class UnitCombinationAddScreen extends BaseRoute {
  final UnitCombination unitCombination;
  final int screenId;
  final List<Unit> unitList;
  UnitCombinationAddScreen({@required a, @required o, @required this.screenId, this.unitCombination, this.unitList}) : super(a: a, o: o, r: 'UnitCombinationAddScreen');
  @override
  _UnitCombinationAddScreenState createState() => _UnitCombinationAddScreenState(this.unitCombination, this.screenId, this.unitList);
}

class _UnitCombinationAddScreenState extends BaseRouteState {
  UnitCombination unitCombination;
  List<Unit> unitList;
  int screenId;
  int _selectedPrimaryUnitId;
  int _selectedSecondaryUnitId;
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _cMeasurement = TextEditingController();
  var _fMeasurement = FocusNode();
  bool _validAmount = true;
  bool _isUsed = false;
  bool _autovalidate = false;

  _UnitCombinationAddScreenState(this.unitCombination, this.screenId, this.unitList) : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: (unitCombination.id == null) ? Text(global.appLocaleValues['tle_add_combination']) : Text(global.appLocaleValues['tle_update_combination']),
          actions: <Widget>[
            TextButton(
              child: Text(
                global.appLocaleValues['btn_save'],
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onPressed: () async {
                if (!_isUsed) {
                  await _onSubmit();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${global.appLocaleValues['tle_unit_com_err_vld']}'),
                    backgroundColor: Colors.red,
                  ));
                }
              },
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UnitScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
            return null;
          },
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
                child: Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        DropdownButtonFormField(
                          isDense: true,
                          decoration: InputDecoration(border: nativeTheme().inputDecorationTheme.border, labelText: global.appLocaleValues['lbl_primary_unit']),
                          value: _selectedPrimaryUnitId,
                          items: unitList.map<DropdownMenuItem<int>>((Unit unit) {
                            return DropdownMenuItem<int>(
                              value: unit.id,
                              child: Text('${unit.name}'),
                            );
                          }).toList(),
                          onChanged: (int val) {
                            setState(() {
                              if (val != null) {
                                _selectedPrimaryUnitId = val;
                              }
                            });
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: DropdownButtonFormField(
                            isDense: true,
                            decoration: InputDecoration(border: nativeTheme().inputDecorationTheme.border, labelText: global.appLocaleValues['lbl_secondary_unit']),
                            value: _selectedSecondaryUnitId,
                            items: unitList.map<DropdownMenuItem<int>>((Unit unit) {
                              return DropdownMenuItem<int>(
                                value: unit.id,
                                child: Text('${unit.name}'),
                              );
                            }).toList(),
                            onChanged: (int val) {
                              setState(() {
                                if (val != null) {
                                  _selectedSecondaryUnitId = val;
                                }
                              });
                            },
                            //  hint: Text(global.appLocaleValues['lbl_secondary_unit_err_req']),
                          ),
                        ),
                        (_selectedPrimaryUnitId != null && _selectedSecondaryUnitId != null)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            global.appLocaleValues['lbl_conversoin_rate'],
                                            style: TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                    FittedBox(
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '1 ${unitList.firstWhere((element) => element.id == _selectedPrimaryUnitId).name}',
                                            style: TextStyle(fontSize: 25, color: Colors.grey),
                                          ),
                                          Text(' = ', style: TextStyle(fontSize: 25)),
                                          SizedBox(
                                            width: 80,
                                            height: 60,
                                            child: TextFormField(
                                              controller: _cMeasurement,
                                              focusNode: _fMeasurement,
                                              textAlign: TextAlign.center,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              textInputAction: TextInputAction.done,
                                              textCapitalization: TextCapitalization.sentences,
                                              maxLines: 4,
                                              decoration: InputDecoration(
                                                // border: nativeTheme().inputDecorationTheme.border,
                                                alignLabelWithHint: true,
                                              ),
                                              onChanged: (value) {
                                                unitCombination.measurement = double.parse(value);
                                              },
                                              validator: (value) {
                                                _validAmount = true;
                                                if (value.isEmpty) {
                                                } else if (value.contains(RegExp('[a-zA-Z]'))) {
                                                  _validAmount = false;
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Text(
                                            ' ${unitList.firstWhere((element) => element.id == _selectedSecondaryUnitId).name}',
                                            style: TextStyle(fontSize: 25, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : SizedBox()
                      ],
                    ),
                  ),
                ])),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      _fMeasurement.addListener(_measurementListener);
      if (unitCombination != null) {
        await _filldata();
      } else {
        unitCombination = UnitCombination();
        unitCombination.measurement = 0;
        _cMeasurement.text = unitCombination.measurement.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
        _selectedPrimaryUnitId = unitList.firstWhere((element) => element.isParent).id;
        setState(() {});
      }
    } catch (e) {
      print('Exception - UnitCombinationAddScreen.dart - _getData(): ' + e.toString());
    }
  }

  void _measurementListener() {
    try {
      if (_fMeasurement.hasFocus) {
        if (_cMeasurement.text == '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}') {
          _cMeasurement.clear();
        }
      } else {
        if (_cMeasurement.text == '') {
          _cMeasurement.text = '${0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}';
        }
      }
      setState(() {});
    } catch (e) {
      print('Exception - UnitCombinationAddScreen.dart - _measurementListener(): ' + e.toString());
    }
  }

  Future _filldata() async {
    try {
      _selectedPrimaryUnitId = unitCombination.primaryUnitId;
      _selectedSecondaryUnitId = unitCombination.secondaryUnitId;
      _cMeasurement.text = unitCombination.measurement.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)));
      int _result = await dbHelper.unitCombinationIsUsed(unitCombination.id);
      if (_result > 0) {
        _isUsed = true;
      }
      setState(() {});
    } catch (e) {
      print('Exception - UnitCombinationAddScreen.dart - _filldata(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_formKey.currentState.validate()) {
        if (_selectedSecondaryUnitId != null) {
          if (unitCombination.measurement != 0) {
            showLoader(global.appLocaleValues['txt_wait']);
            unitCombination.primaryUnit = unitList.firstWhere((element) => element.id == _selectedPrimaryUnitId).name;
            unitCombination.secondaryUnit = unitList.firstWhere((element) => element.id == _selectedSecondaryUnitId).name;
            unitCombination.primaryUnitId = _selectedPrimaryUnitId;
            unitCombination.secondaryUnitId = _selectedSecondaryUnitId;
            unitCombination.isMaster = true;
            if (unitCombination.id == null) {
              await dbHelper.unitCombinationInsert(unitCombination);
            } else {
              await dbHelper.unitCombinationUpdate(unitCombination);
            }
            hideLoader();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UnitScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
          } else {
            (_validAmount)
                ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['lbl_measurement_err_vld'])))
                : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(global.appLocaleValues['vel_enter_number_only']),
                  ));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(global.appLocaleValues['lbl_secondary_unit_err_req'])));
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - UnitCombinationAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fMeasurement.removeListener(_measurementListener);
  }
}
