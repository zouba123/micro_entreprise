// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/expenseCategoryModel.dart';
import 'package:accounting_app/screens/expenseCategoryAddScreen.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class ExpenseCategorySelectDialog extends Base {
  final returnScreenId;
  final ValueChanged<ExpenseCategory> selectedExpense;
  ExpenseCategorySelectDialog({a, o, this.returnScreenId, @required this.selectedExpense}) : super(analytics: a, observer: o);
  @override
  _ExpenseCategorySelectDialogState createState() => _ExpenseCategorySelectDialogState(this.returnScreenId, this.selectedExpense);
}

class _ExpenseCategorySelectDialogState extends BaseState {
  int screenId;
  final ValueChanged<ExpenseCategory> selectedExpense;

  //List<ExpenseCategory> _expenseCategoryList = [];

  _ExpenseCategorySelectDialogState(this.screenId, this.selectedExpense) : super();
  List<ExpenseCategory> categoryList = [];
  List<ExpenseCategory> _tCategoryList =[];

  List<ExpenseCategory> _searchResult = [];
  bool _isRecordPending = true;
  var _cSearch =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            ' ${global.appLocaleValues['tle_expense_cat']}',style: Theme.of(context).appBarTheme.titleTextStyle,
           // style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            screenId == 1
                ? SizedBox()
                : IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
                      Navigator.of(context)
                          .push(MaterialPageRoute(
                              builder: (BuildContext context) =>  ExpenseCategoryAddScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    screenId: 1,
                                  )))
                          .then((v) {
                        Navigator.of(context).pop(v);
                      });
                    },
                  )
          ],
        ),
        body: _isRecordPending == false
            
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8,top: 8,right: 8),
                      child: Text(global.appLocaleValues['lbl_search_expense_cat']),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _cSearch,
                        decoration: InputDecoration(
                          border: nativeTheme().inputDecorationTheme.border,
                          hintText: global.appLocaleValues['lbl_search_expense_cat'],
                          suffixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) async {
                          setState(() {
                            print(value);
                            onSearchTextChanged(value);
                          });
                        },
                      ),
                    ),
                    Divider(),
                    Expanded(
                      child: ListView(
                        children: <Widget>[Column(children: _cSearch.text != '' ? onSearchTextChanged(_cSearch.text) : _catergoryList(categoryList))],
                      ),
                    )
                  ],
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2
                ),
              ));
  }

  @override
  void initState() {
    super.initState();
    _getExpenseCategories();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> _childCategoryList({int id}) {
    try {
      List<Widget> childcategorywidget = [];
      List<ExpenseCategory> _parentCategory = categoryList.where((c) => c.parentCategoryId == id).toList();
      for (int a = 0; a < _parentCategory.length; a++) {
        childcategorywidget.add(Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("${_parentCategory[a].name}"),
                onTap: () {
                  setState(() {
                    selectedExpense(_parentCategory[a]);
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          ),
        ));
      }
      return childcategorywidget;
    } catch (e) {
      print("Exception - expenseCategorySelectDialog.dart - _childCategoryList():" + e.toString());
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
            title: Text("${parentCategoryList[i].name}"),
            children: _childCategoryList(id: parentCategoryList[i].id),
          ));
        }
      }
      return widgetList;
    } catch (e) {
      print("Exception - expenseCategorySelectDialog.dart - _catergoryList():" + e.toString());
    }
    return null;
  }

  List<Widget> onSearchTextChanged(String text) {
    _searchResult.clear(); //search result clear on every text changed called.

    //if text is empty then return simple category list
    if (text == '') {
      return _catergoryList(categoryList);
    }
    //else process the search result.
    else {
      _searchResult = categoryList.where((test) => test.name.toLowerCase().contains(text.toLowerCase())).toList();
      generateSearchedList(_searchResult);
      generateChildSearchedList(_searchResult, text);
      return _catergoryList(_searchResult);
    }
  }

  // #region genrate parent search result and check avilable any child category if child category available then call generateChildSearchedList.
  generateSearchedList(List<ExpenseCategory> searchedList) {
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
  }
  // #endregion

  // #region add child category in search result.
  generateChildSearchedList(List<ExpenseCategory> searchedList, String searchString) {
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
  }

  Future _getExpenseCategories() async {
    try {
      _tCategoryList = await dbHelper.expenseCategoryGetList();
      if (_tCategoryList.isNotEmpty) {
        categoryList.addAll(_tCategoryList);
        _isRecordPending = false;
      }
      setState(() {});
    } catch (e) {
      print('Exception - expenseCategorySelectDialog.dart - _getExpenseCategories(): ' + e.toString());
    }
  }
}
