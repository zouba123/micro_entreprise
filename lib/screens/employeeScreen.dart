// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:accounting_app/models/EmployeeSalaryModel.dart';
import 'package:accounting_app/models/EmployeeSalaryPaymentModel.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/contactListScreen.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/employeeAddScreen.dart';
import 'package:accounting_app/screens/salarySetUpAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/widgets/listTileEmployeeWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ribbon/ribbon.dart';

class EmployeeScreen extends BaseRoute {
  final AccountSearch accountSearch;
  final bool redirectToCustomersTab;
  EmployeeScreen({@required this.redirectToCustomersTab, @required a, @required o, @required this.accountSearch}) : super(a: a, o: o, r: 'EmployeeScreen');
  @override
  _EmployeeScreenState createState() => _EmployeeScreenState(this.redirectToCustomersTab, this.accountSearch);
}

class _EmployeeScreenState extends BaseRouteState {
  AccountSearch accountSearch;
  final bool redirectToCustomersTab;
  List<Account> _customerList = [];
  List<Account> _supplierList = [];
  var _refreshKey1 = GlobalKey<RefreshIndicatorState>();
  var _refreshKey2 = GlobalKey<RefreshIndicatorState>();
  List<EmployeeSalary> empSal = [];
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController _scrollController1 =  ScrollController();
  ScrollController _scrollController2 =  ScrollController();
  int _startIndex = 0;
  int _startIndex2 = 0;
  TabController _tabController;
  bool _isDataLoaded = false;
  bool _isCustTabLoaderHide = false;
  bool _isRecordPending = true;
  int filterCount = 0;
  AccountSearch accountSearc =  AccountSearch();

  _EmployeeScreenState(this.redirectToCustomersTab, this.accountSearch) : super();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(global.appLocaleValues['tle_emp'],style: Theme.of(context).appBarTheme.titleTextStyle,),
            bottom: TabBar(controller: _tabController, tabs: <Widget>[
              Tab(
                text: global.appLocaleValues['tle_emp'],
              ),
              Tab(
                text: global.appLocaleValues['tab_Worker'],
              ),
            ]),
            actions: <Widget>[
              IconButton(
                tooltip: global.appLocaleValues['tt_import_contact'],
                icon: Icon(Icons.import_contacts),
                iconSize: 25,
                color: Colors.white,
                onPressed: () async {
                  int accountCode = await dbHelper.accountGetNewAccountCode();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>  ContactListScreen(
                            accountType: (_tabController.index == 0) ? 'Employee' : 'Worker',
                            accountCode: accountCode,
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 2,
                          )));
                },
              ),
              // BadgeIconButton(
              //     itemCount: filterCount, // required
              //     icon: Icon(MdiIcons.filter), // required
              //     badgeColor: Colors.green, // default: Colors.red
              //     badgeTextColor: Colors.white, // default: Colors.white
              //     hideZeroCount: true, // default: true
              //     onPressed: () async {
              //       await _searchAccount();
              //     }),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                        title: Text(global.appLocaleValues['tle_add_emp']),
                        leading: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  EmployeeAddScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                    returnScreenId: 0,
                                    isAddAsEmployee: (_tabController.index == 0) ? true : false,
                                  )));
                        }),
                  ),
                  (_customerList.length > 0 || _supplierList.length > 0)
                      ? PopupMenuItem(
                          child: ListTile(
                              title: Text(global.appLocaleValues['lbl_add_salarySetup']),
                              leading: Icon(
                                Icons.add,
                                color: Theme.of(context).primaryColor,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SalarySetUpAddScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          //account: account,
                                          employeeSalaryStructures: null,
                                        )));
                              }),
                        )
                      : null,
                ],
              ),

              // IconButton(
              //   icon: Icon(Icons.add),
              //   iconSize: 30,
              //   color: Colors.white,
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(
              //         builder: (context) =>  EmployeeAddScreen(
              //               a: widget.analytics,
              //               o: widget.observer,
              //               returnScreenId: 0,
              //               isAddAsEmployee: (_tabController.index == 0) ? true : false,
              //             )));
              //   },
              // ),
            ],
          ),
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width - 90,
            child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
          ),
          body: WillPopScope(
            onWillPop: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  DashboardScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
              return null;
            },
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _accountsTab(_customerList, 0),
                _accountsTab(_supplierList, 1),
              ],
            ),
          )),
    );
    // : Scaffold(
    //     backgroundColor: Colors.white,
    //     key: _scaffoldKey,
    //     appBar: AppBar(
    //       title: Text(global.appLocaleValues['tle_emp']),
    //       actions: <Widget>[
    //         IconButton(
    //           icon: Icon(Icons.import_contacts),
    //           iconSize: 25,
    //           color: Colors.white,
    //           onPressed: () async {
    //             int accountCode = await dbHelper.accountGetNewAccountCode();
    //             Navigator.of(context).push(MaterialPageRoute(
    //                 builder: (context) =>  ContactListScreen(
    //                       accountType: 'Employee',
    //                       accountCode: accountCode,
    //                       a: widget.analytics,
    //                       o: widget.observer,
    //                       screenId: 2,
    //                     )));
    //           },
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.search),
    //           iconSize: 25,
    //           color: Colors.white,
    //           onPressed: () async {
    //             await _searchAccount();
    //           },
    //         ),
    //         IconButton(
    //           icon: Icon(Icons.add),
    //           iconSize: 30,
    //           color: Colors.white,
    //           onPressed: () {
    //             Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  EmployeeAddScreen(a: widget.analytics, o: widget.observer, returnScreenId: 0, isAddAsEmployee: true)));
    //           },
    //         ),
    //       ],
    //     ),
    //     drawer: SizedBox(
    //       width: MediaQuery.of(context).size.width - 90,
    //       child: DrawerWidget(a: widget.analytics, o: widget.observer),
    //     ),
    //     body: WillPopScope(
    //       onWillPop: () {
    //         Navigator.of(context).push(MaterialPageRoute(
    //             builder: (context) =>  DashboardScreen(
    //                   a: widget.analytics,
    //                   o: widget.observer,
    //                 )));
    //         return null;
    //       },
    //       child: _accountsTab(_customerList, 0),
    //     )
    //);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController1.removeListener(_lazyLoadingCustomers);
    _scrollController2.removeListener(_lazyLoadingSuppliers);
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      await _getEmployee(false);
      await _getWorker(false);
      _tabController = TabController(length: 2, vsync: this);
      _scrollController1.addListener(_lazyLoadingCustomers);
      _scrollController2.addListener(_lazyLoadingSuppliers);
      _isDataLoaded = true;
      if (br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true') {
        _tabController.animateTo((redirectToCustomersTab) ? (_tabController.index) % 2 : (_tabController.index + 1) % 2);
      }
    } catch (e) {
      print('Exception - AccountScreen.dart - _getData(): ' + e.toString());
      return null;
    }
  }

  Widget _accountsTab(List<Account> _accountList, int _tabIndex) {
    try {
      return RefreshIndicator(
          key: _tabIndex == 0 ? _refreshKey1 : _refreshKey2,
          onRefresh: () async {
            (_tabIndex == 0) ? await _getEmployee(true) : await _getWorker(true);
          },
          child: (_isDataLoaded)
              ? (_accountList.isNotEmpty)
                  ? Scrollbar(
                      child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _tabIndex == 0 ? _scrollController1 : _scrollController2,
                      itemCount: _accountList.length + 1,
                      itemBuilder: (context, index) {
                        if (_accountList.length == index) {
                          return (!_isCustTabLoaderHide)
                              ? Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : SizedBox();
                        }

                        return Card(
                          semanticContainer: true,
                          child:  Column(
                            children: <Widget>[
                              (_accountList[index].accountType == ',Employee,Worker,' && br.getSystemFlagValue(global.systemFlagNameList.enablePurchaseAndSupplierModule) == 'true')
                                  ? Ribbon(
                                      nearLength: 47,
                                      farLength: 20,
                                      title: _tabIndex == 0 ? global.appLocaleValues['rbn_also_worker'] : global.appLocaleValues['rbn_also_employee'],
                                      titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                      color: Colors.green,
                                      location: RibbonLocation.values[1],
                                      child: ListTileEmployeeWidget(
                                          key: ValueKey(_accountList[index].id),
                                          account: _accountList[index],
                                          tabIndex: _tabIndex,
                                          a: widget.analytics,
                                          o: widget.observer,
                                          onDeletePressed: (_account, _tabIndex) async {
                                            await _deleteAccount(_account, _tabIndex);
                                          }),
                                    )
                                  : ListTileEmployeeWidget(
                                      key: ValueKey(_accountList[index].id),
                                      account: _accountList[index],
                                      tabIndex: _tabIndex,
                                      a: widget.analytics,
                                      o: widget.observer,
                                      onDeletePressed: (_account, _tabIndex) async {
                                        await _deleteAccount(_account, _tabIndex);
                                      }),
                            ],
                          ),
                        );
                      },
                    ))
                  : Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.people,
                          color: Colors.grey,
                          size: 180,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Text(
                            (_tabIndex == 0) ? global.appLocaleValues['tle_emp_empty_msg'] : global.appLocaleValues['tle_work_empty_msg'],
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ))
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ));
    } catch (e) {
      print('Exception - AccountScreen.dart - ${_tabIndex == 0 ? 'customersTab()' : 'supplierstab()'}: ' + e.toString());
      return null;
    }
  }

  Future _deleteAccount(Account _account, int _tabIndex) async {
    //user delete account
    try {
      int _count = await dbHelper.accountExistInInvoiceOrPayment(accountIn: 'Attendance', accountId: _account.id);
      if (_tabIndex == 0) {
        AlertDialog _dialog =  AlertDialog(
          shape: nativeTheme().dialogTheme.shape,
          title: Text(
            global.appLocaleValues['tle_delete_emp'],
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: (_account.accountType == ',Employee,Worker,') ? 250 : 200,
            child: Column(
              children: <Widget>[
                (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_delete']} "${_account.firstName} ${_account.lastName}" ?') : Text('"${_account.firstName} ${_account.lastName}" ${global.appLocaleValues['txt_delete']} ?'),
                (_account.accountType == ',Employee,Worker,')
                    ? Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                          children: <Widget>[Text(global.appLocaleValues['txt_delete_also_worker'], style: TextStyle(color: Colors.grey))],
                        ),
                      )
                    : SizedBox(
                        height: 20,
                      ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                   
                    onPressed: () async {
                      if (_count == 0) {
                        await dbHelper.employeeSalaryStructuresDelete(accountIdList: [_account.id]);
                        int _result = await dbHelper.accountDelete('${_account.id}');
                        if (_result == 1) {
                          await _getEmployee(true);
                          await _getWorker(true);
                          setState(() {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(global.appLocaleValues['msg_ac_dlt']),
                            ));
                          });
                        } else {
                          setState(() {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(global.appLocaleValues['msg_ac_cannot_dlt']),
                            ));
                          });
                        }
                      } else {
                        setState(() {
                          Navigator.of(context, rootNavigator: true).pop();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(global.appLocaleValues['msg_ac_can_not_deleted']),
                          ));
                        });
                      }
                    },
                    child: Text(global.appLocaleValues['btn_delete'], style: TextStyle(color: Colors.white)),
                  ),
                ),
                (_account.accountType == ',Employee,Worker,')
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextButton(
                           
                            onPressed: () async {
                              _account.accountType = 'Worker';
                              int _result = await dbHelper.accountUpdate(_account);
                              if (_result == 1) {
                                await _getEmployee(true);
                                await _getWorker(true);
                                setState(() {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(global.appLocaleValues['msg_emp_dlt']),
                                  ));
                                });
                              } else {
                                setState(() {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(global.appLocaleValues['msg_emp_not_deleted']),
                                  ));
                                });
                              }
                            },
                            child: Text(global.appLocaleValues['btn_delete_as_emp'], style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                     
                      child: Text(global.appLocaleValues['btn_cancel'], style: TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
      } else {
        AlertDialog _dialog =  AlertDialog(
          shape: nativeTheme().dialogTheme.shape,
          title: Text(
            global.appLocaleValues['tle_delete_emp'],
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: (_account.accountType == ',Employee,Worker,') ? 250 : 200,
            child: Column(
              children: <Widget>[
                (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_delete']} "${_account.firstName} ${_account.lastName}" ?') : Text('"${_account.firstName} ${_account.lastName}" ${global.appLocaleValues['txt_delete']} ?'),
                (_account.accountType == ',Employee,Worker,,')
                    ? Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Row(
                          children: <Widget>[Text(global.appLocaleValues['txt_delete_also_emp'], style: TextStyle(color: Colors.grey))],
                        ),
                      )
                    : SizedBox(
                        height: 20,
                      ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                   
                    onPressed: () async {
                      int _result = await dbHelper.accountDelete('${_account.id}');
                      if (_count == 0) {
                        if (_result == 1) {
                          await _getWorker(true);
                          await _getEmployee(true);
                          setState(() {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(global.appLocaleValues['msg_ac_dlt']),
                            ));
                          });
                        } else {
                          setState(() {
                            Navigator.of(context, rootNavigator: true).pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(global.appLocaleValues['msg_ac_cannot_dlt']),
                            ));
                          });
                        }
                      } else {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(global.appLocaleValues['msg_ac_can_not_deleted']),
                          ));
                        });
                      }
                    },
                    child: Text(global.appLocaleValues['btn_delete']),
                  ),
                ),
                (_account.accountType == ',Employee,Worker,')
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: TextButton(
                           
                            onPressed: () async {
                              _account.accountType = 'Employee';
                              int _result = await dbHelper.accountUpdate(_account);
                              if (_result == 1) {
                                await _getWorker(true);
                                await _getEmployee(true);

                                setState(() {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(global.appLocaleValues['msg_emp_dlt']),
                                  ));
                                });
                              } else {
                                setState(() {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(global.appLocaleValues['msg_emp_not_deleted']),
                                  ));
                                });
                              }
                            },
                            child: Text(global.appLocaleValues['btn_delete_as_woeker']),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextButton(
                     
                      
                      child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline2),
                      onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
      }
    } catch (e) {
      print('Exception - AccountScreen.dart - _deleteAccount(): ' + e.toString());
    }
  }

  Future _getEmployee(bool _isResetAction) async {
    try {
      if (_isResetAction) {
        _startIndex = 0;
        _customerList = [];
        setState(() {});
      }
      if (_isRecordPending) {
        if (_customerList.length != null && _customerList.length > 0) {
          _startIndex = _customerList.length;
        } else {
          _customerList = [];
        }
        setState(() {});
        _customerList += await dbHelper.accountGetList(accountType: 'Employee', startIndex: _startIndex, fetchRecords: global.fetchRecords, searchString: accountSearch.searchBar, isDue: accountSearch.isDue, isCredit: accountSearch.isCredit, screenId: 1);

        for (int i = _startIndex; i < _customerList.length; i++) {
          List<EmployeeSalaryPayment> _employeSalaryPayment = await dbHelper.employeeSalaryPaymentGetList(accountId: [_customerList[i].id], isAdvance: "true");
          _employeSalaryPayment.forEach((element) {
            _customerList[i].totalAdvanced = _employeSalaryPayment.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt);
          });
          List<EmployeeSalary> _employeeSalary = await dbHelper.employeeSalaryAmountGetList(accountId: [_customerList[i].id], status: 'Due', withoutPaid: 'Paid');
          _employeeSalary.forEach((element) {
            _customerList[i].totalDue = _employeeSalary.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt);
          });
        }
        _startIndex += global.fetchRecords;

        setState(() {
          (_customerList.length.isFinite) ? _isCustTabLoaderHide = true : _isCustTabLoaderHide = false;
        });
      }
      setState(() {});
    } catch (e) {
      print('Exception - AccountScreen.dart - _getCustomers(): ' + e.toString());
    }
  }

  Future _getWorker(bool _isResetAction) async {
    try {
      if (_isResetAction) {
        _startIndex2 = 0;
        _supplierList.clear();
        setState(() {});
      }
      if (_isRecordPending) {
        if (_supplierList.length != null && _supplierList.length > 0) {
          _startIndex2 = _supplierList.length;
        } else {
          _supplierList = [];
        }
        setState(() {});
        _supplierList += await dbHelper.accountGetList(accountType: 'Worker', startIndex: _startIndex2, fetchRecords: global.fetchRecords, searchString: accountSearch.searchBar, isDue: accountSearch.isDue, isCredit: accountSearch.isCredit, screenId: 1);
        for (int i = _startIndex; i < _supplierList.length; i++) {
          List<EmployeeSalaryPayment> _employeSalaryPayment = await dbHelper.employeeSalaryPaymentGetList(accountId: [_supplierList[i].id], isAdvance: "true");
          _employeSalaryPayment.forEach((element) {
            _supplierList[i].totalAdvanced = _employeSalaryPayment.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt);
          });
          List<EmployeeSalary> _employeeSalary = await dbHelper.employeeSalaryAmountGetList(accountId: [_supplierList[i].id], status: 'Due', withoutPaid: 'Paid');
          _employeeSalary.forEach((element) {
            _supplierList[i].totalDue = _employeeSalary.map((f) => f.salaryAmount).reduce((sum, amt) => sum + amt);
          });
        }
        _startIndex2 += global.fetchRecords;

        setState(() {
          (_supplierList.length.isFinite) ? _isCustTabLoaderHide = true : _isCustTabLoaderHide = false;
        });
      }
      setState(() {});
    } catch (e) {
      print('Exception - AccountScreen.dart - _getSuppliers(): ' + e.toString());
    }
  }

  Future _lazyLoadingCustomers() async {
    try {
      int _dataLen = _customerList.length;
      if (_scrollController1.position.pixels == _scrollController1.position.maxScrollExtent) {
        await _getEmployee(false);
        if (_dataLen == _customerList.length) {
          setState(() {
            _isCustTabLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - AccountScreen.dart - _lazyLoadingCustomers(): ' + e.toString());
    }
  }

  Future _lazyLoadingSuppliers() async {
    try {
      int _dataLen = _supplierList.length;
      if (_scrollController2.position.pixels == _scrollController2.position.maxScrollExtent) {
        await _getWorker(false);
        if (_dataLen == _supplierList.length) {
          setState(() {
            _isCustTabLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - AccountScreen.dart - _lazyLoadingSuppliers(): ' + e.toString());
    }
  }

  // Future _searchAccount() async {
  //   try {
  //     Navigator.of(context)
  //         .push(EmployeeFilter(
  //       accountSearch,
  //       _tabController.index,
  //     ))
  //         .then((value) async {
  //       if (value != null) {
  //         accountSearch = value;
  //         if (accountSearch.isSearch) {
  //           (_tabController.index == 0) ? _customerList.clear() : _supplierList.clear();
  //           if (accountSearch.isSearch != null || accountSearch.isSearch || accountSearch.isDue || accountSearch.isCredit) {
  //             (_tabController.index == 0) ? await _getEmployee(true) : await _getWorker(true);
  //             setState(() {});
  //           }
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     print('Exception - accountsScreen.dart - _searchAccount(): ' + e.toString());
  //   }
  // }


}

class EmployeeFilter extends ModalRoute<AccountSearch> {
  AccountSearch accountSearch;
  int tabIndex;
  EmployeeFilter(this.accountSearch, this.tabIndex);

  @override
  Duration get transitionDuration => Duration(milliseconds: 2);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.3);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return EmployeeFilterForm(
        accountSearch: accountSearch,
        searchValue: (obj) {
          accountSearch = obj;
        });
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class EmployeeFilterForm extends StatefulWidget {
  final AccountSearch accountSearch;
  final ValueChanged<AccountSearch> searchValue;
  final int tabIndex;
  EmployeeFilterForm({this.accountSearch, this.searchValue, this.tabIndex});
  @override
  _EventFilterFormState createState() => _EventFilterFormState(accountSearch, searchValue, tabIndex);
}

class _EventFilterFormState extends State<EmployeeFilterForm> {
  AccountSearch accountSearch;
  final ValueChanged<AccountSearch> searchValue;
  final int tabIndex;

  _EventFilterFormState(this.accountSearch, this.searchValue, this.tabIndex);

  bool isText = false; //search text avalaibal or not.
  bool isReset = true;
  Account _searchByAccount;

  var _cSearchBar = TextEditingController();

  AccountSearch eSearch =  AccountSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    if (accountSearch != null) {
      _cSearchBar.text = (accountSearch.searchBar.isNotEmpty) ? accountSearch.searchBar : '';
      setState(() {
        if (_searchByAccount != null) {
          isReset = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (accountSearch != null && accountSearch.searchBar != null) {
      assignValue();
    } else {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 56.0,
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 8,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 4,
                      ),
                      Icon(
                        MdiIcons.filter,
                        color: Colors.white,
                        size: 26.0,
                      ),
                      SizedBox(
                        width: 31.0,
                      ),
                      Text(
                        global.appLocaleValues['tle_search_employee'],
                        style: TextStyle(color: Colors.white, fontFamily: 'WhitneyBold', fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: InkWell(
                      onTap: () {
                        resetFilter();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(
                            MdiIcons.restore,
                            color: Colors.white,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Text(
                            '${global.appLocaleValues['btn_reset']}',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:  Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _cSearchBar,
                        decoration: InputDecoration(hintText: global.appLocaleValues['lbl_search_here'], border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.search)),
                      ),
                    ],
                  ),
                ),
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
                  child: MaterialButton(
                    color: Theme.of(context).primaryColorLight,
                    minWidth: 100.0,
                    height: 45.0,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          MdiIcons.close,
                          color: Colors.white,
                          size: 18.0,
                        ),
                        SizedBox(
                          width: 3.0,
                        ),
                        Text('${global.appLocaleValues['btn_cancel']}', style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  flex: 5,
                  child: MaterialButton(
                    color: Theme.of(context).primaryColor,
                    minWidth: 100.0,
                    height: 45.0,
                    onPressed: () {
                      eSearch.isSearch = true;
                      eSearch.searchBar = _cSearchBar.text;
                      searchValue(eSearch);
                      Navigator.pop(context, eSearch);
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
                          style: TextStyle(color: Colors.white),
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
    );
  }

  Future<void> resetConfermation() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${global.appLocaleValues['lbl_reset']}', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${global.appLocaleValues['txt_filter']}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${global.appLocaleValues['btn_cancel']}'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${global.appLocaleValues['btn_ok']}'),
              onPressed: () {
                setState(() {
                  isReset = false;
                  eSearch.isSearch = true;
                  eSearch.isSearch = true;
                  eSearch.searchBar = null;
                  Navigator.of(context).pop();
                  Navigator.pop(context, eSearch);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
