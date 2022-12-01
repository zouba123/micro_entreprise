// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/unitModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/unitCombinationAddScreen.dart';
import 'package:accounting_app/screens/unitAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:flutter/material.dart';


class UnitScreen extends BaseRoute {
  UnitScreen({@required a, @required o}) : super(a: a, o: o, r: 'UnitScreen');
  @override
  _UnitScreenState createState() => _UnitScreenState();
}

class _UnitScreenState extends BaseRouteState {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Unit> _unitList = [];
  bool _isDataLoaded = false;

  _UnitScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: 
  
         AppBar(
            title: Text(global.appLocaleValues['tle_units'],style: Theme.of(context).appBarTheme.titleTextStyle,),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UnitAddScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 0,
                          )));
                },
              )
            ],
        
        
        ),
        
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width - 90,
          child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
        ),
        body: RefreshIndicator(
          onRefresh: refreshData,
          key: _refreshKey,
          child: WillPopScope(
            onWillPop: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DashboardScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
              return null;
            },
            child: (_isDataLoaded)
                ? (_unitList.length > 0)
                    ? Scrollbar(
                        child: ListView.builder(
                          itemCount: _unitList.length,
                          itemBuilder: (context, index) {
                            return ExpansionTile(
                              title: Text('${_unitList[index].name} (${_unitList[index].code})'),
                              subtitle: Text(
                                '${global.appLocaleValues['lbl_combinations']}: ${_unitList[index].unitCombinationsList.length}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.edit,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          Text(global.appLocaleValues['lbl_edit']),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => UnitAddScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  unit: _unitList[index],
                                                  screenId: 0,
                                                )));
                                      },
                                    ),
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.add,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                          ),
                                          Text(global.appLocaleValues['tle_add_combination']),
                                        ],
                                      ),
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        _unitList.map((e) => e.isParent = false).toList();
                                        _unitList[index].isParent = true;
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => UnitCombinationAddScreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  unitList: _unitList,
                                                  screenId: 0,
                                                )));
                                      },
                                    ),
                                  ),
                                  // PopupMenuItem(
                                  //   child: ListTile(
                                  //     title: Text(global.appLocaleValues['lbl_delete']),
                                  //     leading: Icon(
                                  //       Icons.delete,
                                  //       color: Theme.of(context).primaryColor,
                                  //     ),
                                  //     onTap: () async {
                                  //       Navigator.of(context).pop();
                                  //       await _deleteUnit(index);
                                  //     },
                                  //   ),
                                  // )
                                ],
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _unitList[index].unitCombinationsList.length,
                                  itemBuilder: (context, i) {
                                    return (_unitList[index].unitCombinationsList[i].measurement != null)
                                        ? ListTile(
                                            title: Text(
                                              '1 ${_unitList[index].unitCombinationsList[i].primaryUnit}  =  ${_unitList[index].unitCombinationsList[i].measurement.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} ${_unitList[index].unitCombinationsList[i].secondaryUnit}',
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                            trailing: PopupMenuButton(
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                        Text(global.appLocaleValues['tle_update_combination']),
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      Navigator.of(context).pop();
                                                      _unitList.map((e) => e.isParent = false).toList();
                                                      _unitList[index].isParent = true;
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => UnitCombinationAddScreen(
                                                                a: widget.analytics,
                                                                o: widget.observer,
                                                                unitList: _unitList,
                                                                unitCombination: _unitList[index].unitCombinationsList[i],
                                                                screenId: 0,
                                                              )));
                                                    },
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                        Text(global.appLocaleValues['tle_delete_combination']),
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      Navigator.of(context).pop();
                                                      await _deleteCombination(index, i);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : SizedBox();
                                  },
                                )
                              ],
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.view_list,
                            color: Colors.grey,
                            size: 180,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            child: Text(
                              global.appLocaleValues['tle_unit_empty_msg'],
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          )
                        ],
                      ))
                : Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2
                    ),
                  ),
          ),
        ));
  }

  Future refreshData() async {
    await getData();
    setState(() {});
  }

  Future getData() async {
    _unitList = await dbHelper.unitGetList();
    for (int i = 0; i < _unitList.length; i++) {
      _unitList[i].unitCombinationsList = await dbHelper.unitCombinationGetList(unitIdList: [_unitList[i].id]);
    }
    _isDataLoaded = true;
    setState(() {});
  }

  // Future _deleteUnit(index) {
  //   try {
  //     AlertDialog _dialog =  AlertDialog(
  //       shape: nativeTheme().dialogTheme.shape,
  //       title: Text(
  //         global.appLocaleValues['tle_dlt_unit'],
  //         style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
  //       ),
  //       content: Container(
  //         height: 60,
  //         child: Column(
  //           children: <Widget>[
  //             Row(
  //               children: <Widget>[
  //                 (global.appLanguage['name'] == 'English')
  //                     ? Expanded(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text('${global.appLocaleValues['txt_delete']} "${_unitList[index].name}" ?'),
  //                             Text(
  //                               global.appLocaleValues['txt_dlt_unit'],
  //                               style: TextStyle(color: Colors.grey),
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     : Expanded(
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text('"${_unitList[index].name}" ${global.appLocaleValues['txt_delete']} ? '),
  //                             Text(
  //                               global.appLocaleValues['txt_dlt_unit'],
  //                               style: TextStyle(color: Colors.grey),
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           textColor: Colors.blue,
  //           child: Text(global.appLocaleValues['btn_cancel']),
  //           onPressed: () {
  //             Navigator.of(context, rootNavigator: true).pop();
  //           },
  //         ),
  //         TextButton(
  //           child: Text(global.appLocaleValues['btn_delete'], style: TextStyle(color: Colors.blue)),
  //           onPressed: () async {
  //             Navigator.of(context).pop();
  //             int result = await dbHelper.unitIsUsed(_unitList[index].id);
  //             if (result == 0) {
  //               await dbHelper.unitCombinationDelete(primaryUnitId: _unitList[index].id);
  //               int _result = await dbHelper.unitDelete(_unitList[index].id);
  //               if (_result == 1) {
  //                 _unitList.removeAt(index);
  //                 setState(() {});
  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['txt_unit_dlt_success']}')));
  //               } else {
  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                   content: Text('${global.appLocaleValues['txt_unit_dlt_fail']}'),
  //                   backgroundColor: Colors.red,
  //                 ));
  //               }
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                 content: Text('${global.appLocaleValues['txt_unit_dlt_failed']}'),
  //                 backgroundColor: Colors.red,
  //               ));
  //             }
  //           },
  //         ),
  //       ],
  //     );
  //     showDialog(context: context, child: _dialog);
  //     return null;
  //   } catch (e) {
  //     print('Exception - unitScreen.dart - _deleteUnit(): ' + e.toString());
  //     return null;
  //   }
  // }

  Future _deleteCombination(int index, int combinationIndex) {
    try {
      AlertDialog _dialog =  AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_delete_combination'],
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  (global.appLanguage['name'] == 'English')
                      ? Expanded(child: Text('${global.appLocaleValues['txt_delete']} "${_unitList[index].unitCombinationsList[combinationIndex].primaryUnit} - ${_unitList[index].unitCombinationsList[combinationIndex].secondaryUnit}" ?'))
                      : Expanded(child: Text('"${_unitList[index].unitCombinationsList[combinationIndex].primaryUnit} - ${_unitList[index].unitCombinationsList[combinationIndex].secondaryUnit}" ${global.appLocaleValues['txt_delete']} ? ')),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            // textColor: Theme.of(context).primaryColor,
            child: Text(global.appLocaleValues['btn_cancel']),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_delete'], style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: () async {
              Navigator.of(context).pop();
              int result = await dbHelper.unitCombinationIsUsed(_unitList[index].unitCombinationsList[combinationIndex].id);
              if (result == 0) {
                int _result = await dbHelper.unitCombinationDelete(combinationId: _unitList[index].unitCombinationsList[combinationIndex].id);
                if (_result == 1) {
                  _unitList[index].unitCombinationsList.removeAt(combinationIndex);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${global.appLocaleValues['txt_combination_dlt_success']}')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${global.appLocaleValues['txt_combination_dlt_fail']}'),
                    backgroundColor: Colors.red,
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${global.appLocaleValues['txt_combination_dlt_failed']}'),
                  backgroundColor: Colors.red,
                ));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context);
      return null;
    } catch (e) {
      print('Exception - unitScreen.dart - _deleteCombination(): ' + e.toString());
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
}
