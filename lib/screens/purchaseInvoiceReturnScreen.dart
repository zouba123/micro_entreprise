// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnSearchModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/paymentAddScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceDetailScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceReturnAddScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceReturnDetailScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceReturnSelectionScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PurchaseInvoiceReturnScreen extends BaseRoute {
  final Account account;
  PurchaseInvoiceReturnScreen({@required a, @required o, this.account}) : super(a: a, o: o, r: 'PurchaseInvoiceReturnScreen');
  @override
  _PurchaseInvoiceReturnScreenState createState() => _PurchaseInvoiceReturnScreenState(this.account);
}

class _PurchaseInvoiceReturnScreenState extends BaseRouteState {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Account account;
  int _startIndex = 0;
  ScrollController _scrollController = ScrollController();
  bool _isLoaderHide = false;
  bool _isDataLoaded = false;
  List<PurchaseInvoiceReturn> _transactionGroupIdList = [];
  //List<int> _searchByInvoiceReturnIdList;
  PurchaseInvoiceReturnSearch _invoiceReturnSearch = PurchaseInvoiceReturnSearch();
  int filterCount = 0;
  bool _isPrintAction = true;

  _PurchaseInvoiceReturnScreenState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            global.appLocaleValues['tle_purchase_return'],
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(MdiIcons.filter), // required

                onPressed: () async {
                  await _searchPurchaseReturn();
                }),
            IconButton(
              icon: Icon(Icons.add),
              iconSize: 30,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PurchaseInvoiceReturnSelectionScreen(
                          a: widget.analytics,
                          o: widget.observer,
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
          key: _refreshKey,
          onRefresh: _refreshData,
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
                ? (_transactionGroupIdList.isNotEmpty)
                    ? Scrollbar(
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: _transactionGroupIdList.length + 1,
                          itemBuilder: (context, index) {
                            if (_transactionGroupIdList.length == index) {
                              return (!_isLoaderHide)
                                  ? Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : SizedBox();
                            }
                            return Card(
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                    title: Text(
                                      '${br.generateAccountName(_transactionGroupIdList[index].account)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    subtitle: Row(
                                      children: <Widget>[
                                        Text(
                                          '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_transactionGroupIdList[index].invoiceDate)}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        (_transactionGroupIdList[index].remainAmount != null)
                                            ? (_transactionGroupIdList[index].remainAmount < 0)
                                                ? Text(' ${global.appLocaleValues['lbl_credit']}: ${global.currency.symbol} ${(_transactionGroupIdList[index].remainAmount * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}', style: TextStyle(color: Colors.green))
                                                : Text(
                                                    ' ${global.appLocaleValues['lbl_due']}: ${global.currency.symbol} ${_transactionGroupIdList[index].remainAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                    style: TextStyle(color: Colors.red),
                                                  )
                                            : SizedBox()
                                      ],
                                    ),
                                    trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                      Text(
                                        '${global.currency.symbol} ${(_transactionGroupIdList[index].totalSpent != null) ? _transactionGroupIdList[index].totalSpent.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces))) : 0.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          height: 0.9,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      PopupMenuButton(
                                        itemBuilder: (context) => [
                                          ((DateTime.now().difference(_transactionGroupIdList[index].createdAt).inDays) == 0)
                                              ? PopupMenuItem(
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
                                                    onTap: () async {
                                                      try {
                                                        Navigator.of(context).pop();
                                                        _transactionGroupIdList[index].childList.map((f) => f.invoiceReturnDetailList.clear()).toList();
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => PurchaseInvoiceReturnAddScreen(
                                                                  a: widget.analytics,
                                                                  o: widget.observer,
                                                                  purchaseReturnList: _transactionGroupIdList[index].childList,
                                                                  isTransactionUpdate: true,
                                                                )));
                                                      } catch (e) {
                                                        print('Exception - PurchaseInvoiceReturnScreen.dart - _editTransaction(): ' + e.toString());
                                                      }
                                                    },
                                                  ),
                                                )
                                              : null,
                                          (_transactionGroupIdList[index].status == 'PENDING')
                                              ? PopupMenuItem(
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Icon(
                                                            Icons.payment,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                        Text(global.appLocaleValues['lt_take_payment']),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => PaymentAddScreen(
                                                                a: widget.analytics,
                                                                o: widget.observer,
                                                                purchaseInvoiceReturn: _transactionGroupIdList[index],
                                                                returnScreenId: 11,
                                                              )));
                                                    },
                                                  ),
                                                )
                                              : null,
                                          (_transactionGroupIdList[index].status != 'CANCELLED' && _transactionGroupIdList[index].remainAmount < 0)
                                              ? PopupMenuItem(
                                                  child: ListTile(
                                                    contentPadding: EdgeInsets.zero,
                                                    title: Row(
                                                      children: <Widget>[
                                                        Padding(
                                                          padding: const EdgeInsets.only(right: 10),
                                                          child: Icon(
                                                            Icons.payment,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                        Text(global.appLocaleValues['lt_give_payment']),
                                                      ],
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(context).pop();
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => PaymentAddScreen(
                                                                a: widget.analytics,
                                                                o: widget.observer,
                                                                purchaseInvoiceReturn: _transactionGroupIdList[index],
                                                                returnScreenId: 12,
                                                              )));
                                                    },
                                                  ),
                                                )
                                              : null,
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
                                              onTap: () async {
                                                try {
                                                  Navigator.of(context).pop();
                                                  await _deleteInvoice(_transactionGroupIdList[index].childList, true);
                                                } catch (e) {
                                                  print('Exception - PurchaseInvoiceReturnScreen.dart - _deleteTransaction(): ' + e.toString());
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                    onTap: () async {
                                      try {
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PurchaseInvoiceReturnDetailScreen(a: widget.analytics, o: widget.observer, invoiceReturnList: _transactionGroupIdList[index].childList, remainAmount: _transactionGroupIdList[index].remainAmount)));
                                      } catch (e) {
                                        print('Exception - PurchaseInvoiceReturnScreen.dart - _onTap(): ' + e.toString());
                                      }
                                    },
                                  ),
                                  Card(
                                      color: Colors.blue[50],
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _transactionGroupIdList[index].childList.length,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, i) {
                                          return ListTile(
                                            contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                            title: Text(
                                              '${_transactionGroupIdList[index].childList[i].purchaseInvoiceNumber}',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            subtitle: Text('${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_products'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_services'] : global.appLocaleValues['tle_both']}: ${_transactionGroupIdList[index].childList[i].totalProducts}'),
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context).size.width * .3,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: Text(
                                                              '${global.currency.symbol} ${_transactionGroupIdList[index].childList[i].netAmount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                height: 0.9,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Center(
                                                          child: (_transactionGroupIdList[index].childList[i].status != 'CANCELLED')
                                                              ? (_transactionGroupIdList[index].childList[i].status == 'REFUNDED')
                                                                  ? Text(
                                                                      '${_transactionGroupIdList[index].childList[i].status}',
                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9),
                                                                    )
                                                                  : Text(
                                                                      '${_transactionGroupIdList[index].childList[i].status}',
                                                                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9),
                                                                    )
                                                              : Text(
                                                                  '${_transactionGroupIdList[index].childList[i].status}',
                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, height: 0.9),
                                                                ))
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuButton(
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      child: ListTile(
                                                        contentPadding: EdgeInsets.zero,
                                                        title: Row(
                                                          children: <Widget>[
                                                            Padding(
                                                              padding: const EdgeInsets.only(right: 10),
                                                              child: Icon(
                                                                Icons.print,
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                            Text(global.appLocaleValues['lt_print']),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          Navigator.of(context).pop();
                                                          _isPrintAction = true;
                                                          _showLoader();
                                                          await _purchaseInvoiceReturnPrintOrShare(context, _transactionGroupIdList[index].childList[i].purchaseInvoiceId);
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
                                                                Icons.share,
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                            Text(global.appLocaleValues['lt_share']),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          Navigator.of(context).pop();
                                                          _isPrintAction = false;
                                                          _showLoader();
                                                          await _purchaseInvoiceReturnPrintOrShare(context, _transactionGroupIdList[index].childList[i].purchaseInvoiceId);
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
                                                                Icons.remove_red_eye,
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                            Text(global.appLocaleValues['lt_view_purchase_invoice']),
                                                          ],
                                                        ),
                                                        onTap: () async {
                                                          Navigator.of(context).pop();
                                                          List<PurchaseInvoice> _purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(invoiceNumber: _transactionGroupIdList[index].childList[i].purchaseInvoiceNumber);
                                                          PurchaseInvoice _purchaseInvoice = (_purchaseInvoiceList.length > 0) ? _purchaseInvoiceList[0] : null;
                                                          if (_purchaseInvoice != null) {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => PurchaseInvoiceDetailScreen(
                                                                      a: widget.analytics,
                                                                      o: widget.observer,
                                                                      invoice: _purchaseInvoice,
                                                                    )));
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    ((DateTime.now().difference(_transactionGroupIdList[index].childList[i].createdAt).inDays) == 0)
                                                        ? PopupMenuItem(
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
                                                              onTap: () async {
                                                                try {
                                                                  Navigator.of(context).pop();
                                                                  _transactionGroupIdList[index].childList[i].invoiceReturnDetailList.clear();
                                                                  Navigator.of(context).push(MaterialPageRoute(
                                                                      builder: (context) => PurchaseInvoiceReturnAddScreen(
                                                                            a: widget.analytics,
                                                                            o: widget.observer,
                                                                            purchaseReturnList: [_transactionGroupIdList[index].childList[i]],
                                                                            isTransactionUpdate: false,
                                                                          )));
                                                                } catch (e) {
                                                                  print('Exception - PurchaseInvoiceReturnScreen.dart - _editRecord(): ' + e.toString());
                                                                }
                                                              },
                                                            ),
                                                          )
                                                        : null,
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
                                                        onTap: () async {
                                                          Navigator.of(context).pop();
                                                          await _deleteInvoice([_transactionGroupIdList[index].childList[i]], false);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      ))
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.grey,
                            size: 180,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FittedBox(
                            child: Text(
                              global.appLocaleValues['tle_purchase_return_empty'],
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                            ),
                          )
                        ],
                      ))
                : Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_lazyLoading);
  }

  @override
  void initState() {
    super.initState();
    if (account != null) {
      _invoiceReturnSearch.account = account;
    }
    _scrollController.addListener(_lazyLoading);
    _getData();
    _isDataLoaded = true;
  }

  Future _lazyLoading() async {
    try {
      int _dataLen = _transactionGroupIdList.length;
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        await _getData();
        if (_dataLen == _transactionGroupIdList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnScreen.dart - _lazyLoading(): ' + e.toString());
    }
  }

  Future _getData() async {
    _transactionGroupIdList += await dbHelper.purchaseInvoiceReturnTransactionGroupGetList(
      startIndex: _startIndex,
      fetchRecords: global.fetchRecords,
      startDate: (_invoiceReturnSearch != null)
          ? (_invoiceReturnSearch.dateFrom != null)
              ? _invoiceReturnSearch.dateFrom
              : null
          : null,
      endDate: (_invoiceReturnSearch != null)
          ? (_invoiceReturnSearch.dateTo != null)
              ? _invoiceReturnSearch.dateTo
              : null
          : null,
      accountId: (_invoiceReturnSearch != null)
          ? (_invoiceReturnSearch.account != null)
              ? _invoiceReturnSearch.account.id
              : null
          : null,
    );

    for (int i = _startIndex; i < _transactionGroupIdList.length; i++) {
      _transactionGroupIdList[i].childList = await dbHelper.purchaseInvoiceReturnGetList(transactionGroupIdList: [_transactionGroupIdList[i].transactionGroupId]);
      for (int j = 0; j < _transactionGroupIdList[i].childList.length; j++) {
        _transactionGroupIdList[i].childList[j].totalProducts = await dbHelper.purchaseInvoiceReturnDetailGetCount(purchaseInvoiceReturnId: _transactionGroupIdList[i].childList[j].id);
      }
      List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: _transactionGroupIdList[i].transactionGroupId);
      List<Payment> _paymentList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
      double _receivedAmount = 0;
      double _givenAmount = 0;
      if (_paymentList.length > 0) {
        _paymentList.forEach((item) {
          if (item.paymentType == 'RECEIVED') {
            _receivedAmount += item.amount;
          } else {
            _givenAmount += item.amount;
          }
        });
      }

      _transactionGroupIdList[i].remainAmount = (_paymentList.length != 0) ? (_transactionGroupIdList[i].totalSpent - (_receivedAmount - _givenAmount)) : _transactionGroupIdList[i].totalSpent;
    }

    _startIndex += global.fetchRecords;
    (_transactionGroupIdList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
    setState(() {});
  }

  Future _refreshData({bool isResetAction}) async {
    try {
      _startIndex = 0;
      _transactionGroupIdList.clear();
      // _searchByInvoiceReturnIdList = null;
      await _getData();
      _scrollController.position.jumpTo(1);
      _isLoaderHide = false;
      setState(() {});
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnScreen.dart - _refreshData(): ' + e.toString());
    }
  }

  Future _deleteInvoice(List<PurchaseInvoiceReturn> _purchaseInvoiceReturnDeleteList, bool _isTransactionDelete) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_purchase_return_dlt'],
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text(global.appLocaleValues['txt_purchase_return_dlt'])),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            // textColor: Theme.of(context).primaryColor,
            child: Text(global.appLocaleValues['btn_cancel'],style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_delete'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              for (int i = 0; i < _purchaseInvoiceReturnDeleteList.length; i++) {
                List<PurchaseInvoiceReturnDetail> _purchaseInvoiceReturnDetailList = await dbHelper.purchaseInvoiceReturnDetailGetList(purchaseInvoiceId: _purchaseInvoiceReturnDeleteList[i].id);
                await dbHelper.purchaseInvoiceReturnDetailTaxDelete(_purchaseInvoiceReturnDetailList.map((invoiceReturnDetail) => invoiceReturnDetail.id).toList());
                await dbHelper.purchaseInvoiceReturnTaxDelete(_purchaseInvoiceReturnDeleteList[i].id);
                await dbHelper.purchaseInvoiceReturnDetailDelete(purchaseInvoiceReturnId: _purchaseInvoiceReturnDeleteList[i].id);
                await dbHelper.purchaseInvoiceReturnDelete(_purchaseInvoiceReturnDeleteList[i].id);
              }
              if (_isTransactionDelete) {
                await _deletePayment(_purchaseInvoiceReturnDeleteList[0].transactionGroupId);
              }
              await _refreshData();
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnScreen.dart - _deleteInvoice(): ' + e.toString());
    }
  }

  Future _deletePayment(String _transactionGroupId) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_payment_dlt'],
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text(global.appLocaleValues['txt_purchase_return_payment_dlt'])),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            // textColor: Theme.of(context).primaryColor,
            child: Text(global.appLocaleValues['btn_no'],style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: _transactionGroupId);
              List<Payment> _paymentList = (_paymentPurchaseInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentPurchaseInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
              if (_paymentList.length > 0) {
                await dbHelper.paymentPurchaseInvoiceReturnDelete(paymentIdList: _paymentList.map((f) => f.id).toList());
                await dbHelper.paymentDetailDelete(paymentIdList: _paymentList.map((f) => f.id).toList());
                await dbHelper.paymentDelete(paymentIdList: _paymentList.map((f) => f.id).toList());
              }
            },
          ),
        ],
      );
      await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnScreen.dart - _deletePayment(): ' + e.toString());
    }
  }

  Future _purchaseInvoiceReturnPrintOrShare(context, int purchaseInvoiceId) async {
    try {
      List<PurchaseInvoice> _purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(invoiceIdList: [purchaseInvoiceId]);
      PurchaseInvoice _purchaseInvoice = (_purchaseInvoiceList.length > 0) ? _purchaseInvoiceList[0] : null;
      if (_purchaseInvoice != null) {
        List<Account> _accountList = await dbHelper.accountGetList(accountId: _purchaseInvoice.accountId);
        _purchaseInvoice.account = _accountList[0];
        _purchaseInvoice.invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoice.id);
        _purchaseInvoice.invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: _purchaseInvoice.id);
        _purchaseInvoice.invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: _purchaseInvoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
        //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
        List<PaymentPurchaseInvoice> _paymentInvoiceList = [];
        List<Payment> _paymentList = [];
        double _receivedAmount = 0;
        double _givenAmount = 0;
        List<PurchaseInvoiceReturnDetail> _returnProductList = [];
        List<TaxMaster> _returnProductTaxList = [];
        double _returnProductSubTotal = 0;
        double _returnProductfinalTotal = 0;
        String _returnProductPaymentStatus = '';

        _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoice.id, isCancel: false);
        _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        if (_paymentList.length != 0) {
          _paymentList.forEach((item) {
            if (item.paymentType == 'GIVEN') {
              _receivedAmount += item.amount;
            } else {
              _givenAmount += item.amount;
            }
          });
          _receivedAmount -= _givenAmount;
        }
        _purchaseInvoice.remainAmount = _purchaseInvoice.netAmount - _receivedAmount;
        _purchaseInvoice.returnProducts = 1;

        _purchaseInvoice.remainAmount = (_paymentList.length != 0) ? (_purchaseInvoice.netAmount - (_receivedAmount - _givenAmount)) : _purchaseInvoice.netAmount;

        _returnProductList = await dbHelper.purchaseInvoiceReturnDetailGetList(purchaseInvoiceId: _purchaseInvoice.id);
        List<PurchaseInvoiceReturnDetailTax> _purchaseInvoiceReturnDetailTaxList = await dbHelper.purchaseInvoiceReturnDetailTaxGetList(purchaseInvoiceReturnDetailIdList: _returnProductList.map((f) => f.id).toList());
        List<PurchaseInvoiceReturn> _purchaseInvoiceReturnList = await dbHelper.purchaseInvoiceReturnGetList(purchaseInvoiceReturnIdList: [_returnProductList[0].purchaseInvoiceReturnId]);
        PurchaseInvoiceReturn _purchaseInvoiceReturn = (_purchaseInvoiceReturnList.length > 0) ? _purchaseInvoiceReturnList[0] : null;
        _returnProductPaymentStatus = _purchaseInvoiceReturn.status;

        if (_purchaseInvoiceReturnDetailTaxList.length > 0) // when purchase return tax is product wise
        {
          _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _purchaseInvoiceReturnDetailTaxList.map((f) => f.taxId).toSet().toList());
          _returnProductTaxList.forEach((f) {
            double _taxAmount = 0;
            _purchaseInvoiceReturnDetailTaxList.forEach((item) {
              if (item.taxId == f.id) {
                _taxAmount += item.taxAmount;
              }
            });
            f.taxAmount = _taxAmount;
          });

          _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
          _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
        } else // when purchase return tax is tax wise
        {
          List<PurchaseInvoiceReturnTax> _purchaseInvoiceReturnTaxList = await dbHelper.purchaseInvoiceReturnTaxGetList(purchaseInvoiceReturnId: _returnProductList[0].purchaseInvoiceReturnId);

          if (_purchaseInvoiceReturn != null) {
            if (_purchaseInvoiceReturnTaxList.length > 0) {
              _returnProductTaxList = await dbHelper.taxMasterGetList(taxMasterIdList: _purchaseInvoiceReturnTaxList.map((f) => f.taxId).toList());
              _returnProductTaxList.forEach((item) {
                item.taxAmount = (item.percentage * _purchaseInvoiceReturn.netAmount) / 100;
              });
              _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
              _returnProductfinalTotal = _returnProductSubTotal + _returnProductTaxList.map((f) => f.taxAmount).reduce((sum, amt) => sum + amt);
            } else // when purchase return tax not available
            {
              _returnProductSubTotal = _returnProductList.map((f) => f.amount).reduce((sum, amt) => sum + amt);
              _returnProductfinalTotal = _returnProductSubTotal;
            }
          }
        }

        Navigator.of(context).pop();
        br.generatePurchaseInvoiceHtml(context, invoice: _purchaseInvoice, isPrintAction: _isPrintAction, returnProductList: _returnProductList, returnProductPaymentStatus: _returnProductPaymentStatus, returnProductSubTotal: _returnProductSubTotal, returnProductTaxList: _returnProductTaxList, returnProductfinalTotal: _returnProductfinalTotal);
      }
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnScreen.dart - _purchaseInvoiceReturnPrintOrShare(): ' + e.toString());
    }
  }

  void _showLoader() {
    AlertDialog _dialog = AlertDialog(
      shape: nativeTheme().dialogTheme.shape,
      title: Text(
        global.appLocaleValues['txt_wait'],
        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width - 40,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
    showDialog(builder: (context) => _dialog, context: context);
  }

  Future _searchPurchaseReturn() async {
    try {
      Navigator.of(context)
          .push(PurchaseInvoiceReturnFilter(
        _invoiceReturnSearch,
      ))
          .then((value) async {
        if (value != null) {
          _invoiceReturnSearch = value;
          if (_invoiceReturnSearch.isSearch) {
            _isDataLoaded = false;
            setState(() {});
            await _refreshData(isResetAction: true);
            _isDataLoaded = true;
            setState(() {});
          }
        }
      });
    } catch (e) {
      print('Exception - PurchaseInvoiceReturnScreen.dart - _searchPurchaseReturn(): ' + e.toString());
    }
  }
}

class PurchaseInvoiceReturnFilter extends ModalRoute<PurchaseInvoiceReturnSearch> {
  PurchaseInvoiceReturnSearch purchaseInvoiceReturnSearch;
  PurchaseInvoiceReturnFilter(this.purchaseInvoiceReturnSearch);

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
    return PurchaseInvoiceFilterForm(
        purchaseInvoiceReturnSearch: purchaseInvoiceReturnSearch,
        searchValue: (obj) {
          purchaseInvoiceReturnSearch = obj;
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

// ignore: must_be_immutable
class PurchaseInvoiceFilterForm extends StatefulWidget {
  final PurchaseInvoiceReturnSearch purchaseInvoiceReturnSearch;
  final ValueChanged<PurchaseInvoiceReturnSearch> searchValue;
  PurchaseInvoiceFilterForm({this.purchaseInvoiceReturnSearch, this.searchValue});
  @override
  _SaleInvoiceState createState() => _SaleInvoiceState(purchaseInvoiceReturnSearch, searchValue);
}

class _SaleInvoiceState extends State<PurchaseInvoiceFilterForm> {
  PurchaseInvoiceReturnSearch purchaseInvoiceReturnSearch;
  final ValueChanged<PurchaseInvoiceReturnSearch> searchValue;
  _SaleInvoiceState(this.purchaseInvoiceReturnSearch, this.searchValue);

  var _cDateRangeTo = TextEditingController();
  var _cDateRangeFrom = TextEditingController();
  // var _cPaymentMode = TextEditingController();
  var _cChooseAccount = TextEditingController();
  var _fFromDateFocusNode = FocusNode();
  var _fToDateFocusNode = FocusNode();
  var _fChooseAccount = FocusNode();
  var _focusNode = FocusNode();
  bool isReset = true;

  bool _dateFrom = false;
  String _dateRangeFrom2 = '', _dateRangeTo2 = '';
  Account _account;

  PurchaseInvoiceReturnSearch eSearch = PurchaseInvoiceReturnSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    _fFromDateFocusNode.addListener(_selectdateListener);
    _fToDateFocusNode.addListener(_selectdateListener);

    if (purchaseInvoiceReturnSearch != null) {
      _cChooseAccount.text = (purchaseInvoiceReturnSearch.account != null)
          ? (purchaseInvoiceReturnSearch.account.firstName != null)
              ? '${purchaseInvoiceReturnSearch.account.firstName} ${purchaseInvoiceReturnSearch.account.lastName}'
              //    ? '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoiceReturnSearch.account.accountCode.toString().length))}${invoiceReturnSearch.account.accountCode} - ${invoiceReturnSearch.account.firstName} ${invoiceReturnSearch.account.lastName}'
              : ''
          : '';
      //   _cChooseProduct.text = (invoiceReturnSearch.product != null) ? (invoiceReturnSearch.product.productCode != null) ? '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + invoiceReturnSearch.product.productCode.toString().length))}${invoiceReturnSearch.product.productCode} - ${invoiceReturnSearch.product.name}' : '' : '';
      _cDateRangeFrom.text = (purchaseInvoiceReturnSearch.dateFrom != null) ? '${DateFormat('dd-MM-yyyy').format(purchaseInvoiceReturnSearch.dateFrom)}' : '';
      _dateRangeFrom2 = (purchaseInvoiceReturnSearch.dateFrom != null) ? '${purchaseInvoiceReturnSearch.dateFrom}' : '';
      _cDateRangeTo.text = (purchaseInvoiceReturnSearch.dateTo != null) ? '${DateFormat('dd-MM-yyyy').format(purchaseInvoiceReturnSearch.dateTo)}' : '';
      _dateRangeTo2 = (purchaseInvoiceReturnSearch.dateTo != null) ? '${purchaseInvoiceReturnSearch.dateTo}' : '';
      //  _cAmountRangeTo.text = (invoiceReturnSearch.amountTo != null) ? '${invoiceReturnSearch.amountTo}' : '';
      //   _cAmountRangeFrom.text = (invoiceReturnSearch.amountFrom != null) ? '${invoiceReturnSearch.amountFrom}' : '';
      _account = purchaseInvoiceReturnSearch.account;
//    _product = invoiceReturnSearch.product;
      purchaseInvoiceReturnSearch.isSearch = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    assignValue();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _selectAccount() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccountSelectDialog(
                a: null,
                o: null,
                returnScreenId: 3,
                selectedAccount: (selectedAccount) {
                  _account = selectedAccount;
                },
              )));
      setState(() {
        if (_account.id != null) {
          _cChooseAccount.text = '${_account.firstName} ${_account.lastName}';
          //   '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode} - ${_account.firstName} ${_account.lastName}';
        }
      });
    } catch (e) {
      print('Exception - purchaseInvoiceReturnSearchDialog.dart - _selectAccount(): ' + e.toString());
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != DateTime(2000)) {
        setState(() {
          //   _date=picked;
          if (_dateFrom) {
            _cDateRangeFrom.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(picked.toString().substring(0, 10)));
            _dateRangeFrom2 = picked.toString().substring(0, 10);
          } else {
            _cDateRangeTo.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(picked.toString().substring(0, 10)));
            _dateRangeTo2 = picked.toString().substring(0, 10);
          }
        });
      }
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (e) {
      print('Exception - purchaseInvoiceReturnSearchDialog.dart - _selectDate(): ' + e.toString());
    }
  }

  Future<Null> _selectdateListener() async {
    try {
      if (_fFromDateFocusNode.hasFocus || _fToDateFocusNode.hasFocus) {
        if (_fFromDateFocusNode.hasFocus) {
          _dateFrom = true;
        } else {
          _dateFrom = false;
        }
        _selectDate(context); //open date picker
      }
    } catch (e) {
      print('Exception - purchaseInvoiceReturnSearchDialog.dart - _selectdateListener(): ' + e.toString());
    }
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
                        global.appLocaleValues['tle_search_purchase_return'],
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    global.appLocaleValues['lbl_choose_ac'],
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _cChooseAccount,
                          focusNode: _fChooseAccount,
                          readOnly: true,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_choose_ac'], border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.people)),
                          onTap: () async {
                            await _selectAccount();
                          },
                        ),
                      ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      '${global.appLocaleValues['lbl_date_err_req']}',
                      style: Theme.of(context).primaryTextTheme.headline3,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: _cDateRangeFrom,
                          focusNode: _fFromDateFocusNode,
                          readOnly: true,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_date_from'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: TextFormField(
                          controller: _cDateRangeTo,
                          focusNode: _fToDateFocusNode,
                          readOnly: true,
                          maxLength: 5,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_date_to'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.calendar_today)),
                        ),
                      ),
                    ],
                  ),
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
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            MdiIcons.close,
                            color: Theme.of(context).primaryColorDark,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Text(
                            '${global.appLocaleValues['btn_cancel']}',
                            style: Theme.of(context).primaryTextTheme.headline3,
                          )
                        ],
                      ),
                    )
                    // MaterialButton(
                    //   color: Theme.of(context).primaryColorLight,
                    //   minWidth: 100.0,
                    //   height: 45.0,
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Icon(
                    //         MdiIcons.close,
                    //         color: Colors.white,
                    //         size: 18.0,
                    //       ),
                    //       SizedBox(
                    //         width: 3.0,
                    //       ),
                    //       Text('${global.appLocaleValues['btn_cancel']}')
                    //     ],
                    //   ),
                    // ),
                    ),
                SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    flex: 5,
                    child: TextButton(
                      onPressed: () {
                        eSearch.isSearch = true;
                        eSearch.account = _account;
                        eSearch.dateFrom = (_dateRangeFrom2 != '') ? DateTime.parse(_dateRangeFrom2) : null;
                        eSearch.dateTo = (_dateRangeTo2 != '') ? DateTime.parse(_dateRangeTo2) : null;
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
                            style: Theme.of(context).primaryTextTheme.headline2,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    )
                    //  MaterialButton(
                    //   color: Theme.of(context).primaryColor,
                    //   minWidth: 100.0,
                    //   height: 45.0,
                    //   onPressed: () {
                    //     eSearch.isSearch = true;
                    //     eSearch.account = _account;
                    //     eSearch.dateFrom = (_dateRangeFrom2 != '') ? DateTime.parse(_dateRangeFrom2) : null;
                    //     eSearch.dateTo = (_dateRangeTo2 != '') ? DateTime.parse(_dateRangeTo2) : null;
                    //     searchValue(eSearch);
                    //     Navigator.pop(context, eSearch);
                    //   },
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Icon(
                    //         Icons.search,
                    //         color: Colors.white,
                    //         size: 18.0,
                    //       ),
                    //       SizedBox(
                    //         width: 3.0,
                    //       ),
                    //       Text(
                    //         '${global.appLocaleValues['btn_search']}',
                    //         textAlign: TextAlign.center,
                    //       )
                    //     ],
                    //   ),
                    // ),
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
                  eSearch.account = null;
                  eSearch.dateFrom = null;
                  eSearch.dateTo = null;
                  eSearch.isSearch = true;
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
