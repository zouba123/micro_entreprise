// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/expenseCategoryModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/screens/expenseCategoryAddScreen.dart';

import 'package:flutter/material.dart';

import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExpenseCategoriesScreen extends BaseRoute {
  ExpenseCategoriesScreen({a, o}) : super(a: a, o: o, r: 'ExpenseCategoriesScreen');
  @override
  _ExpenseCategoriesScreenState createState() => _ExpenseCategoriesScreenState();
}

class _ExpenseCategoriesScreenState extends BaseRouteState {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ExpenseCategory> _searchResult = [];

  List<ExpenseCategory> categoryList = [];
  List<ExpenseCategory> _tCategoryList = [];

  // bool _isRecordPending = true;
  bool _isDataLoaded = false;
  String _cSearch = '';

  _ExpenseCategoriesScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['tle_expense_cats'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ExpenseCategoryAddScreen(
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
      body: WillPopScope(
        onWillPop: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DashboardScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
          return null;
        },
        child: (_isDataLoaded)
            ? (categoryList.isNotEmpty)
                ? ListView(
                    children: <Widget>[Column(children: _cSearch != '' ? onSearchTextChanged(_cSearch) : _catergoryList(categoryList))],
                  )
                : Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        MdiIcons.currencyUsd,
                        color: Colors.grey,
                        size: 180,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FittedBox(
                        child: Text(
                          global.appLocaleValues['tle_expense_cats_empty'],
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      )
                    ],
                  ))
            : Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  generateChildSearchedList(List<ExpenseCategory> searchedList, String searchString) {
    try {
      List<int> childCategoryIds = [];
      for (var i = 0; i < searchedList.length; i++) {
        if (searchedList[i].name.toLowerCase().contains(searchString.toLowerCase()) && searchedList[i].hasLeaf) {
          var tchildCategories = categoryList.where((child) => child.parentCategoryId == searchedList[i].id).toList();
          for (var j = 0; j < tchildCategories.length; j++) {
            if (!childCategoryIds.contains(tchildCategories[j].id) && !searchedList.contains(tchildCategories[j])) {
              childCategoryIds.add(tchildCategories[j].id);
            }
          }
        }
      }

      if (childCategoryIds.length > 0) {
        searchedList = categoryList.where((test) => childCategoryIds.contains(test.id)).toList();
        for (var i = 0; i < searchedList.length; i++) {
          if (!_searchResult.contains(searchedList[i])) {
            _searchResult.add(searchedList[i]);
          }
        }
        generateChildSearchedList(searchedList, searchString);
      }
    } catch (e) {
      print("Exception - expenseCategoryScreen.dart - generateChildSearchedList()" + e.toString());
    }
  }

  generateSearchedList(List<ExpenseCategory> searchedList) {
    try {
      List<int> parentCategoryIds = [];
      for (var i = 0; i < searchedList.length; i++) {
        if (searchedList[i].parentCategoryId != null && !parentCategoryIds.contains(searchedList[i].parentCategoryId) && searchedList.where((c) => c.id == searchedList[i].parentCategoryId).length == 0) {
          parentCategoryIds.add(searchedList[i].parentCategoryId);
        }
      }

      if (parentCategoryIds.length > 0) {
        searchedList = categoryList.where((test) => parentCategoryIds.contains(test.id)).toList();
        for (var i = 0; i < searchedList.length; i++) {
          if (!_searchResult.contains(searchedList[i])) {
            _searchResult.add(searchedList[i]);
          }
        }
        generateSearchedList(searchedList);
      }
    } catch (e) {
      print("Exception - expenseCategoryScreen.dart - generateSearchedList()" + e.toString());
    }
  }

  Future getCategory() async {
    try {
      _tCategoryList = await dbHelper.expenseCategoryGetList();
      if (_tCategoryList.isNotEmpty) {
        categoryList.addAll(_tCategoryList);
        // _isRecordPending = false;
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print("Exception - expenseCategoryScreen.dart - getCategory()" + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getCategory();
  }

  List<Widget> onSearchTextChanged(String text) {
    try {
      _searchResult.clear();
      if (text == '') {
        return _catergoryList(categoryList);
      } else {
        _searchResult = categoryList.where((test) => test.name.toLowerCase().contains(text.toLowerCase())).toList();
        generateSearchedList(_searchResult);
        generateChildSearchedList(_searchResult, text);
        return _catergoryList(_searchResult);
      }
    } catch (e) {
      print("Exception - expenseCategoryScreen.dart - onSearchTextChanged()" + e.toString());
      return null;
    }
  }

  List<Widget> _catergoryList(List<ExpenseCategory> categoryList) {
    try {
      List<ExpenseCategory> parentCategoryList = [];
      for (int i = 0; i < categoryList.length; i++) {
        categoryList[i].isActive = false;
        if (categoryList[i].parentCategoryId == null) {
          parentCategoryList.add(categoryList[i]);
        }
      }
      List<Widget> widgetList = [];
      if (parentCategoryList.length > 0) {
        for (int i = 0; i < parentCategoryList.length; i++) {
          widgetList.add(ExpansionTile(
            tilePadding: EdgeInsets.only(left: 10,right: 8),
            title: Text("${parentCategoryList[i].name}"),
            trailing: parentCategoryList[i].isMaster == true
                ? null
                : PopupMenuButton(
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
                                builder: (context) => ExpenseCategoryAddScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      expenseCategory: parentCategoryList[i],
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
                              Text(global.appLocaleValues['lbl_delete']),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _deleteExpenseCategory(i, parentCategoryList[i].name, parentCategoryList[i].id);
                          },
                        ),
                      )
                    ],
                  ),
            children: _childCategoryList(id: parentCategoryList[i].id),
          ));
        }
      }
      return widgetList;
    } catch (e) {
      print("Exception - expenseCategoryScreen.dart - _catergoryList():" + e.toString());
    }
    return null;
  }

  List<Widget> _childCategoryList({int id}) {
    try {
      List<Widget> childcategorywidget = [];
      List<ExpenseCategory> _childCategory = categoryList.where((c) => c.parentCategoryId == id).toList();
      for (int a = 0; a < _childCategory.length; a++) {
        childcategorywidget.add(Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("${_childCategory[a].name}"),
                onTap: () {
                  if (_childCategory[a].isMaster == false) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ExpenseCategoryAddScreen(
                              a: widget.analytics,
                              o: widget.observer,
                              expenseCategory: _childCategory[a],
                              screenId: 0,
                            )));
                  }
                },
                trailing: _childCategory[a].isMaster == true
                    ? null
                    : PopupMenuButton(
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
                                    builder: (context) => ExpenseCategoryAddScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          expenseCategory: _childCategory[a],
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
                                  Text(global.appLocaleValues['lbl_delete']),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                _deleteExpenseCategory(a, _childCategory[a].name, _childCategory[a].id);
                              },
                            ),
                          )
                        ],
                      ),
              ),
            ],
          ),
        ));
      }
      return childcategorywidget;
    } catch (e) {
      print("Exception - expenseCategoryScreen.dart - _childCategoryList():" + e.toString());
      return null;
    }
  }

  void _deleteExpenseCategory(index, name, id) {
    try {
      AlertDialog _dialog =  AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(global.appLocaleValues['tle_dt_expense_cat'], style: Theme.of(context).primaryTextTheme.headline1),
        content: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_delete']} "$name" ?', style: Theme.of(context).primaryTextTheme.headline3) : Text('"$name" ${global.appLocaleValues['txt_delete']} ?', style: Theme.of(context).primaryTextTheme.headline3),
        actions: <Widget>[
          TextButton(
            // textColor: Theme.of(context).primaryColor,
            child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_delete'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              int _productTypeIsUsed = await dbHelper.expenseCategoryIsUsed(id);
              if (_productTypeIsUsed == 0) {
                int _result = await dbHelper.expenseCategoryDelete(id);
                if (_result == 1) {
                  await getCategory();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('${global.appLocaleValues['txt_expense_cat_dlt_success']}'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('${global.appLocaleValues['txt_expense_cat_dlt_fail']}'),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${global.appLocaleValues['txt_expense_cat_dlt_failed']}'),
                ));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context);
    } catch (e) {
      print('Exception - expenseCategoryScreen.dart - _deleteExpenseCategory(): ' + e.toString());
    }
  }
}
