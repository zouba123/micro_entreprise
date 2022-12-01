// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/expenseCategoryModel.dart';
import 'package:accounting_app/screens/expenseCategoryScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class ExpenseCategoryAddScreen extends BaseRoute {
  final ExpenseCategory expenseCategory;
  final int screenId;

  ExpenseCategoryAddScreen({a, o, this.expenseCategory, this.screenId}) : super(a: a, o: o, r: 'ExpenseCategoryAddScreen');
  @override
  _ExpenseCategoryAddScreenState createState() => _ExpenseCategoryAddScreenState(this.expenseCategory, this.screenId);
}

class _ExpenseCategoryAddScreenState extends BaseRouteState {
  var _key = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ExpenseCategory expenseCategory;
  bool _autovalidate = false;
  TextEditingController _cName =  TextEditingController();
  TextEditingController _cDescription =  TextEditingController();
  final _fName =  FocusNode();
  final _fDescription =  FocusNode();
  bool _isExpenseCategoryNameExist = false;
  int screenId;
  int _selectParentCategoryId;
  List<ExpenseCategory> _expenseParentCategoryList = [];
  _ExpenseCategoryAddScreenState(this.expenseCategory, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: (expenseCategory.id == null)
              ? Text(
                  global.appLocaleValues['lbl_add_expense_cat'],
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                )
              : Text(
                  global.appLocaleValues['lbl_update_expense_cat'],
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
          actions: <Widget>[
            TextButton(
              child: Text(
                global.appLocaleValues['btn_save'],
                style: Theme.of(context).primaryTextTheme.headline2,
              ),
              onPressed: () {
                _onSubmit();
              },
            )
          ],
        ),
        body: Form(
          key: _key,
         autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 FutureBuilder(
                    future: dbHelper.expenseCategoryGetList(isParentId: true),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData != null) {
                          return  DropdownButtonFormField(
                            isDense: true,
                            decoration: InputDecoration(
                              border: nativeTheme().inputDecorationTheme.border,
                            ),
                            value: expenseCategory.parentCategoryId == null ? _selectParentCategoryId : expenseCategory.parentCategoryId,
                            items: _expenseParentCategoryList.map<DropdownMenuItem<int>>((ExpenseCategory ec) {
                              return  DropdownMenuItem<int>(
                                value: ec.id,
                                child:  Text('${ec.name}'),
                              );
                            }).toList(),
                            hint:  Text(global.appLocaleValues['lbl_select_expense_cat']),

                            // hint: account.accountTypeId != null
                            //     ?  Text('${account.typeName}')
                            //     :  Text("Select Account Type"),

                            onChanged: (int val) {
                              setState(() {
                                if (val != null) {
                                  _selectParentCategoryId = val;
                                  if (_selectParentCategoryId == -1) {
                                    expenseCategory.parentCategoryId = null;
                                  } else {
                                    expenseCategory.parentCategoryId = _selectParentCategoryId;
                                  }
                                } else {
                                  expenseCategory.parentCategoryId = null;
                                }
                              });
                            },
                            validator: (val) {
                              if (val == null) {
                                return global.appLocaleValues['lbl_select_expese_categary'];
                              }
                              return null;
                            },
                          );
                        } else {
                          print('Data is null');
                          return null;
                        }
                      } else {
                        print("waiting");
                        return Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    global.appLocaleValues['lbl_expense_category'],
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: TextFormField(
                    controller: _cName,
                    focusNode: _fName,
                    //   autofocus: true,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    onFieldSubmitted: (v) {
                      FocusScope.of(context).requestFocus(_fDescription);
                    },
                    decoration: InputDecoration(border: nativeTheme().inputDecorationTheme.border, suffixIcon: Icon(Icons.star, size: 9, color: Colors.red), hintText: global.appLocaleValues['lbl_expense_category'], errorText: _isExpenseCategoryNameExist ? '${global.appLocaleValues['lbl_expense_cat_err_vld']}' : null),
                    onChanged: (String value) {
                      _checkExpenseCategoryNameExist(value);
                    },
                    validator: (v) {
                      if (v.isEmpty) {
                        return global.appLocaleValues['lbl_expense_cat_err_req'];
                      } else if (v.contains(RegExp('[0-9]'))) {
                        return global.appLocaleValues['vel_character_only'];
                      } else if (_isExpenseCategoryNameExist == true) {
                        return global.appLocaleValues['lbl_expense_cat_err_vld'];
                      }
                      return null;
                    },
                  ),
                ),
                Text(
                  global.appLocaleValues['lbl_desc'],
                  style: Theme.of(context).primaryTextTheme.headline3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 5),
                  child: TextFormField(
                    controller: _cDescription,
                    focusNode: _fDescription,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: nativeTheme().inputDecorationTheme.border,
                      hintText: global.appLocaleValues['lbl_desc'],
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _getListofExpenseCategory();
    if (expenseCategory == null) {
      expenseCategory =  ExpenseCategory();
    } else {
      _fillData();
    }
  }

  void _getListofExpenseCategory() async {
    try {
      List<ExpenseCategory> _expenseCategoryList = await dbHelper.expenseCategoryGetList(isParentId: true);
      ExpenseCategory _new =  ExpenseCategory();
      //  _new.name = 'No Parent Category';
      _new.id = -1;
      _new.parentCategoryId = null;
      _expenseCategoryList.add(_new);
      _expenseParentCategoryList = _expenseCategoryList.where((e) => e.parentCategoryId == null).toList();

      print("${_expenseParentCategoryList.length}");
    } catch (e) {
      print('Exception - expenseCategoryAddScreen.dart - _getListofExpenseCategory(): ' + e.toString());
    }
  }

  Future<void> _checkExpenseCategoryNameExist(value) async {
    try {
      _isExpenseCategoryNameExist = (expenseCategory.id != null) ? await dbHelper.expenseCategoryCheckNameExist(expenseId: expenseCategory.id, categoryName: value) : await dbHelper.expenseCategoryCheckNameExist(categoryName: value);
      setState(() {});
    } catch (e) {
      print('Exception - expenseCategoryAddScreen.dart - _checkExpenseCategoryNameExist(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _fillData() async // display details during update product
  {
    try {
      _cName.text = expenseCategory.name;
      _cDescription.text = expenseCategory.description;
    } catch (e) {
      print('Exception - expenseCategoryAddScreen.dart - _fillData(): ' + e.toString());
    }
  }

  Future _onSubmit() async {
    try {
      if (_key.currentState.validate()) {
        showLoader(global.appLocaleValues['txt_wait']);
        setState(() {});
        expenseCategory.name = _cName.text.trim();
        expenseCategory.description = _cDescription.text.trim();

        if (expenseCategory.id == null) {
          expenseCategory.id = await dbHelper.expenseCategoryInsert(expenseCategory);
        } else {
          await dbHelper.expenseCategoryUpdate(expenseCategory);
        }
        hideLoader();
        setState(() {});
        if (screenId == 0) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => ExpenseCategoriesScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )));
        } else {
          // Navigator.of(context).pop(MaterialPageRoute(
          //     builder: (context) => ExpenseAddScreen(
          //           a:widget.analytics,
          //          o:widget.observer,
          //

          //         )));
          Navigator.of(context).pop(expenseCategory);
        }
      } else {
        _autovalidate = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - expenseCategoryAddScreen.dart - _onSubmit(): ' + e.toString());
    }
  }
}
