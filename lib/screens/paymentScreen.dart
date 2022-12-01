// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/expensePaymentsModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/paymentSaleQuotesModel.dart';
import 'package:accounting_app/models/paymentSearchModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/paymentAddScreen.dart';
import 'package:accounting_app/screens/paymentDetailScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PaymentScreen extends BaseRoute {
  final Account account;
  PaymentScreen({@required a, @required o, this.account}) : super(a: a, o: o, r: 'PaymentScreen');

  @override
  _PaymentScreenState createState() => _PaymentScreenState(this.account);
}

class _PaymentScreenState extends BaseRouteState {
  var _refreshKey = GlobalKey<RefreshIndicatorState>();
  final Account account;
  final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  int _startIndex = 0;
  List<Payment> _paymentList = [];
  bool _actionOfIsCancel;
  bool _isPaymentPrintAction;
  List<int> _searchByPaymentIdList;
  bool _isDataLoaded = false;
  bool _isLoaderHide = false;
  bool _isRecordPending = true;
  int filterCount = 0;
  int _filterIndex;
  PaymentSearch _paymentSearch =  PaymentSearch();

  _PaymentScreenState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['lbl_payments'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          // BadgeIconButton(
          //     itemCount: filterCount, // required
          //     icon: Icon(MdiIcons.filter), // required
          //     badgeColor: Colors.green, // default: Colors.red
          //     badgeTextColor: Colors.white, // default: Colors.white
          //     hideZeroCount: true, // default: true
          //     onPressed: () async {
          //       await _searchPayments();
          //     }),

          IconButton(
            icon: Icon(MdiIcons.filter),
            iconSize: 20,
            onPressed: () async {
              await _searchPayments();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PaymentAddScreen(
                        a: widget.analytics,
                        o: widget.observer,
                        returnScreenId: 0,
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
        onRefresh: _refreshData,
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
          child: Column(
            children: [
              _filterTab(),
              (_isDataLoaded)
                  ? (_paymentList.isNotEmpty)
                      ? Expanded(
                          child: Scrollbar(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: ListView.builder(
                                controller: _scrollController,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: _paymentList.length,
                                itemBuilder: (context, index) {
                                  if (_paymentList.length == index) {
                                    return (!_isLoaderHide)
                                        ? Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : SizedBox();
                                  }
                                  return Card(
                                    margin: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                                    child: ListTile(
                                        contentPadding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 0),
                                        leading: CircleAvatar(
                                          backgroundColor: Theme.of(context).primaryColorDark,
                                          // foregroundColor: Colors.black,
                                          radius: 26,
                                          child: Text(
                                            '${global.currency.symbol} ${_paymentList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                            style: Theme.of(context).primaryTextTheme.bodyText2,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        title: Text(
                                          (_paymentList[index].account != null) ? '${br.generateAccountName(_paymentList[index].account)}' : global.appLocaleValues['lbl_expense_cap'],
                                          style: Theme.of(context).primaryTextTheme.subtitle1,

                                          overflow: TextOverflow.ellipsis,

                                          // style: TextStyle(fontSize: 14, color: (_paymentList[index].account != null) ? Colors.black : Colors.black45),
                                        ),
                                        subtitle: Column(
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_paymentList[index].transactionDate)}',
                                                  style: Theme.of(context).primaryTextTheme.subtitle2,
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: <Widget>[
                                                (_paymentList[index].invoiceNumber != null)
                                                    ?
                                                    // Text(global.appLocaleValues['lbl_sale_order_'], style: Theme.of(context).primaryTextTheme.subtitle2,),
                                                    Text(
                                                        (_paymentList[index].isSaleInvoiceRef) ? 'ref: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _paymentList[index].invoiceNumber.toString().length))}${_paymentList[index].invoiceNumber}' : 'ref: ${_paymentList[index].invoiceNumber}',
                                                        style: Theme.of(context).primaryTextTheme.subtitle2,
                                                      )
                                                    : (_paymentList[index].isSaleInvoiceReturnRef)
                                                        ? Text(
                                                            'ref: ${global.appLocaleValues['ref_sales_return']}',
                                                            style: Theme.of(context).primaryTextTheme.subtitle2,
                                                          )
                                                        : (_paymentList[index].isPurchaseInvoiceReturnRef)
                                                            ? Text(
                                                                'ref: ${global.appLocaleValues['ref_purchase_return']}',
                                                                style: Theme.of(context).primaryTextTheme.subtitle2,
                                                              )
                                                            : (_paymentList[index].isExpenseRef)
                                                                ? Text(
                                                                    'ref: ${global.appLocaleValues['lbl_expense_small']}',
                                                                    style: Theme.of(context).primaryTextTheme.subtitle2,
                                                                  )
                                                                : (_paymentList[index].isSaleOrderRef)
                                                                    ? Text(
                                                                        'ref: ${global.appLocaleValues['lbl_sale_order_']} ${_paymentList[index].orderNumber}',
                                                                        style: Theme.of(context).primaryTextTheme.subtitle2,
                                                                      )
                                                                    : SizedBox()
                                              ],
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>  PaymentDetailScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    payment: _paymentList[index],
                                                  )));
                                        },
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context).size.width * 0.2,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  (_paymentList[index].paymentType == 'RECEIVED')
                                                      ? Text(
                                                          '${_paymentList[index].paymentType}',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                                                        )
                                                      : Text('${_paymentList[index].paymentType}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                                                  //  Text(, textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  (_paymentList[index].isCancel == true)
                                                      ? Text('CANCELLED', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, height: 1, fontSize: 12))
                                                      : SizedBox(
                                                          width: 0,
                                                        )
                                                ],
                                              ),
                                            ),
                                            PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: Theme.of(context).iconTheme.color,
                                              ),
                                              itemBuilder: (context) => [
                                                // (_paymentList[index].isCancel != true)
                                                //     ?
                                                (_paymentList[index].isCancel != true)
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
                                                          onTap: () {
                                                            Navigator.of(context).pop();
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => PaymentAddScreen(
                                                                      a: widget.analytics,
                                                                      o: widget.observer,
                                                                      payment: _paymentList[index],
                                                                      returnScreenId: 0,
                                                                    )));
                                                          },
                                                        ),
                                                      )
                                                    : null,
                                                // : null,
                                                (_paymentList[index].isCancel == false)
                                                    ? PopupMenuItem(
                                                        child: ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Icon(
                                                                  Icons.cancel,
                                                                  color: Theme.of(context).primaryColor,
                                                                ),
                                                              ),
                                                              Text(global.appLocaleValues['txt_cancel']),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            Navigator.of(context).pop();
                                                            _actionOfIsCancel = true;
                                                            await _cancelOrRetrivePayment(index);
                                                          },
                                                        ),
                                                      )
                                                    : null,
                                                (_paymentList[index].isCancel == true && (DateTime.now().difference(_paymentList[index].modifiedAt).inDays) == 0)
                                                    ? PopupMenuItem(
                                                        child: ListTile(
                                                          contentPadding: EdgeInsets.zero,
                                                          title: Row(
                                                            children: <Widget>[
                                                              Padding(
                                                                padding: const EdgeInsets.only(right: 10),
                                                                child: Icon(
                                                                  Icons.undo,
                                                                  color: Theme.of(context).primaryColor,
                                                                ),
                                                              ),
                                                              Text(global.appLocaleValues['lbl_retrive']),
                                                            ],
                                                          ),
                                                          onTap: () async {
                                                            Navigator.of(context).pop();
                                                            _actionOfIsCancel = false;
                                                            await _cancelOrRetrivePayment(index);
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
                                                      await _deletePayment(index);
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
                                                            Icons.print,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                        Text(global.appLocaleValues['lt_print']),
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      Navigator.of(context).pop();
                                                      _isPaymentPrintAction = true;
                                                      global.isAppOperation = true;
                                                      await br.generatePaymentReceiptHtml(context, payment: _paymentList[index], isPrintAction: _isPaymentPrintAction);
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
                                                      global.isAppOperation = true;
                                                      _isPaymentPrintAction = false;
                                                      await br.generatePaymentReceiptHtml(context, payment: _paymentList[index], isPrintAction: _isPaymentPrintAction);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.credit_card,
                              color: Colors.grey,
                              size: 180,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FittedBox(
                              child: Text(
                                global.appLocaleValues['tle_payment_empty'],
                                style: TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            )
                          ],
                        ))
                  : Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_lazyLoading);
  }

  @override
  void initState() {
    super.initState();
    _getInit();
    _filterIndex = 0;
  }

  Future _getInit() async {
    try {
      if (account != null) {
        _paymentSearch.account = account;
      }
      _scrollController.addListener(_lazyLoading);
      await _getPaymentsData();
    } catch (e) {
      print('Exception - paymentScreen.dart - _getInit(): ' + e.toString());
    }
  }

  Future _cancelOrRetrivePayment(int index) async {
    try {
      _paymentList[index].paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: [_paymentList[index].id]);
      List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(paymentId: _paymentList[index].id);
      List<PaymentSaleInvoiceReturn> _paymentInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(paymentId: _paymentList[index].id);
      List<PaymentSaleOrder> _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(paymentIdList: [_paymentList[index].id]);
      List<PaymentPurchaseInvoice> _paymentPurchaseInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(paymentId: _paymentList[index].id);
      List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(paymentId: _paymentList[index].id);
      _paymentList[index].paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;

      _paymentList[index].isCancel = (_actionOfIsCancel) ? true : false;
      int _result = await dbHelper.paymentUpdate(_paymentList[index]);
      if (_result == 1) {
        _paymentList[index].paymentDetailList.forEach((item) async {
          item.isCancel = _paymentList[index].isCancel;
          await dbHelper.paymentDetailUpdate(item);
        });
        for (int i = 0; i < _paymentInvoiceList.length; i++) {
          _paymentInvoiceList[i].isCancel = (_actionOfIsCancel) ? true : false;
          await dbHelper.paymentSaleInvoiceUpdate(_paymentInvoiceList[i]);
        }

        for (int i = 0; i < _paymentInvoiceReturnList.length; i++) {
          _paymentInvoiceReturnList[i].isCancel = (_actionOfIsCancel) ? true : false;
          await dbHelper.paymentSaleInvoiceReturnUpdate(_paymentInvoiceReturnList[i]);
        }

        for (int i = 0; i < _paymentSaleOrderList.length; i++) {
          _paymentSaleOrderList[i].isCancel = (_actionOfIsCancel) ? true : false;
          await dbHelper.paymentSaleOrderUpdate(_paymentSaleOrderList[i]);
        }

        for (int i = 0; i < _paymentPurchaseInvoiceList.length; i++) {
          _paymentPurchaseInvoiceList[i].isCancel = (_actionOfIsCancel) ? true : false;
          await dbHelper.paymentPurchaseInvoiceUpdate(_paymentPurchaseInvoiceList[i]);
        }

        for (int i = 0; i < _paymentPurchaseInvoiceReturnList.length; i++) {
          _paymentPurchaseInvoiceReturnList[i].isCancel = (_actionOfIsCancel) ? true : false;
          await dbHelper.paymentPurchaseInvoiceReturnUpdate(_paymentPurchaseInvoiceReturnList[i]);
        }
        await _manageInvoiceOrOrder(index, false);
        await _refreshData();
        if (_actionOfIsCancel) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('${global.appLocaleValues['txt_payment_cancel_success']}'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('${global.appLocaleValues['txt_payment_retrive_success']}'),
          ));
        }
      } else {
        if (_actionOfIsCancel) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('${global.appLocaleValues['txt_payment_cancel_fail']}'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('${global.appLocaleValues['txt_payment_retrive_fail']}'),
          ));
        }
      }
    } catch (e) {
      print('Exception - paymentScreen.dart - _cancelOrRetrivePayment(): ' + e.toString());
    }
  }

  Future _deletePayment(index) async {
    try {
      AlertDialog _dialog =  AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(global.appLocaleValues['tle_payment_delete'], style: Theme.of(context).primaryTextTheme.headline1),
        content: Container(
          //  height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width - 40,
          child: FittedBox(
            //   fit: BoxFit.fitWidth,
            child: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_delete']} "${global.currency.symbol} ${_paymentList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} - ${_paymentList[index].paymentType}" ?', style: Theme.of(context).primaryTextTheme.headline3) : Text('"${global.currency.symbol} ${_paymentList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))} - ${_paymentList[index].paymentType}" ${global.appLocaleValues['txt_delete']} ?', style: Theme.of(context).primaryTextTheme.headline3),
          ),
        ),
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
              await dbHelper.paymentSaleOrderDelete(paymentIdList: [_paymentList[index].id]);
              await dbHelper.paymentDetailDelete(paymentIdList: [_paymentList[index].id]);
              await _manageInvoiceOrOrder(index, true);
              int _result = await dbHelper.paymentDelete(paymentIdList: [_paymentList[index].id]);
              if (_result == 1) {
                await _refreshData();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('${global.appLocaleValues['txt_payment_delete_success']}'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${global.appLocaleValues['txt_payment_delete_fail']}'),
                ));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - paymentScreen.dart - _deletePayment(): ' + e.toString());
    }
  }

  Future _getPaymentsData() async {
    try {
      if (_isRecordPending) {
        if (_paymentList.length != null && _paymentList.length > 0) {
          _startIndex = _paymentList.length;
        } else {
          _paymentList = [];
        }
        _paymentList += await dbHelper.paymentGetList(isDelete: false, orderBy: 'DESC', startIndex: _startIndex, fetchRecords: global.fetchRecords, accountId: (_paymentSearch.account != null) ? _paymentSearch.account.id : null, paymentIdList: _searchByPaymentIdList, paymentType: _paymentSearch.paymentType, isCancel: _paymentSearch.isCancel);


    
        for (int i = _startIndex; i < _paymentList.length; i++) {
          if (_paymentList[i].accountId != null) {
            List<Account> _accountList = await dbHelper.accountGetList(accountId: _paymentList[i].accountId);
            _paymentList[i].account = (_accountList.length > 0) ? _accountList[0] : null;
          }
          List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(paymentId: _paymentList[i].id);
          PaymentSaleInvoice _paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;
          List<PaymentPurchaseInvoice> _paymentPurchaseInvoiceList;
          PaymentPurchaseInvoice _paymentPurchaseInvoice;
          List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList;
          PaymentSaleInvoiceReturn _paymentSaleInvoiceReturn;
          List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList;
          PaymentPurchaseInvoiceReturn _paymentPurchaseInvoiceReturn;
          PaymentSaleQuotes _paymentSaleQuote;
          List<PaymentSaleQuotes> _paymentSaleQuoteList;
          ExpensePayments _expensePayment;
          List<ExpensePayments> _expensePaymentList;

          if (_paymentInvoice == null) {
            _paymentPurchaseInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(paymentId: _paymentList[i].id);
            _paymentPurchaseInvoice = (_paymentPurchaseInvoiceList.length > 0) ? _paymentPurchaseInvoiceList[0] : null;
          }
          if (_paymentPurchaseInvoice == null) {
            _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(paymentId: _paymentList[i].id);
            _paymentSaleInvoiceReturn = (_paymentSaleInvoiceReturnList.length > 0) ? _paymentSaleInvoiceReturnList[0] : null;
          }

          if (_paymentSaleInvoiceReturn == null) {
            _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(paymentId: _paymentList[i].id);
            _paymentPurchaseInvoiceReturn = (_paymentPurchaseInvoiceReturnList.length > 0) ? _paymentPurchaseInvoiceReturnList[0] : null;
          }

          if (_paymentInvoice == null) {
            _paymentSaleQuoteList = await dbHelper.paymentSaleQuoteGetList(paymentIdList: [_paymentList[i].id]);
            _paymentSaleQuote = (_paymentSaleQuoteList.length > 0) ? _paymentSaleQuoteList[0] : null;
          }

          if (_paymentSaleQuote == null) {
            _expensePaymentList = await dbHelper.expensePaymentsGetList(paymentId: _paymentList[i].id);
            _expensePayment = (_expensePaymentList.length > 0) ? _expensePaymentList[0] : null;
          }

          if (_paymentInvoice != null) {
            _paymentList[i].invoiceNumber = _paymentInvoice.invoiceNumber;
            _paymentList[i].isSaleInvoiceRef = true;
          }
          else if (_paymentPurchaseInvoice != null) {
            _paymentList[i].invoiceNumber = _paymentPurchaseInvoice.invoiceNumber;
            _paymentList[i].isPurchaseInvoiceRef = true;
          }
           else if (_paymentSaleInvoiceReturn != null) {
            _paymentList[i].isSaleInvoiceReturnRef = true;
          }
          else if (_paymentPurchaseInvoiceReturn != null) {
            _paymentList[i].isPurchaseInvoiceReturnRef = true;
          }
          else if (_paymentSaleQuote != null) {
            _paymentList[i].saleQuoteNumber = _paymentSaleQuote.saleQuoteId;
            _paymentList[i].isSaleOrderRef = true;
            setState(() {});
          } else if (_expensePayment != null) {
            _paymentList[i].isExpenseRef = true;
          }
        }
        _startIndex += global.fetchRecords;
        setState(() {
          (_paymentList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
          _isDataLoaded = true;
        });
      }
    } catch (e) {
      print('Exception - paymentScreen.dart - _getPaymensData(): ' + e.toString());
    }
  }

  Future _lazyLoading() async {
    try {
      int _dataLen = _paymentList.length;
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _getPaymentsData();
        if (_dataLen == _paymentList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - paymentScreen.dart - _lazyLoading(): ' + e.toString());
    }
  }

  Future _refreshData({bool isResetAction}) async {
    try {
      _startIndex = 0;
      _paymentList.clear();
      if (isResetAction == null) {
        _searchByPaymentIdList = null;
      }
      await _getPaymentsData();
      _isLoaderHide = false;
      _scrollController.position.jumpTo(1);
      setState(() {});
    } catch (e) {
      print('Exception - paymentScreen.dart - _refreshData(): ' + e.toString());
    }
  }

  Future _searchPayments() async {
    try {
      Navigator.of(context)
          .push(PaymentFilter(
        _paymentSearch,
      ))
          .then((value) async {
        if (value != null) {
          _paymentSearch = value;
          if (_paymentSearch != null && _paymentSearch.isSearch) {
            _paymentList.clear();
            if (_paymentSearch.isSearch) {
              await _refreshData(isResetAction: true);
            }
          }
        }
      });
      setState(() {});
    } catch (e) {
      print('Exception - paymentScreen.dart - _searchPayments(): ' + e.toString());
    }
  }

  Future _manageInvoiceOrOrder(index, bool _isDeleteAction) async {
    try {
      List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(paymentId: _paymentList[index].id);
      PaymentSaleInvoice _paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;
      PaymentPurchaseInvoice _paymentPurchaseInvoice;
      List<PaymentPurchaseInvoice> _paymentPurchaseInvoiceList;
      PaymentSaleInvoiceReturn _paymentSaleInvoiceReturn;
      List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList;
      PaymentPurchaseInvoiceReturn _paymentPurchaseInvoiceReturn;
      List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList;
      if (_paymentInvoice == null) {
        _paymentPurchaseInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(paymentId: _paymentList[index].id);
        _paymentPurchaseInvoice = (_paymentPurchaseInvoiceList.length > 0) ? _paymentPurchaseInvoiceList[0] : null;
      }
      if (_paymentPurchaseInvoice == null) {
        _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(paymentId: _paymentList[index].id);
        _paymentSaleInvoiceReturn = (_paymentSaleInvoiceReturnList.length > 0) ? _paymentSaleInvoiceReturnList[0] : null;
      }

      if (_paymentSaleInvoiceReturn == null) {
        _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(paymentId: _paymentList[index].id);
        _paymentPurchaseInvoiceReturn = (_paymentPurchaseInvoiceReturnList.length > 0) ? _paymentPurchaseInvoiceReturnList[0] : null;
      }

      if (_paymentInvoice != null) {
        if (_isDeleteAction) {
          await dbHelper.paymentSaleInvoiceDelete(paymentIdList: [_paymentList[index].id]);
        }
        _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _paymentInvoice.invoiceId, isCancel: false);
        List<SaleInvoice> _saleInvoiceList = await dbHelper.saleInvoiceGetList(invoiceIdList: [_paymentInvoice.invoiceId]);
        SaleInvoice _invoice = (_saleInvoiceList.length != 0) ? _saleInvoiceList[0] : null;

        if (_invoice.status != 'CANCELLED') {
          double netAmount = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.amount).reduce((sum, amount) => sum + amount) : 0;
          if (netAmount == _invoice.netAmount) {
            _invoice.status = 'PAID';
          } else {
            _invoice.status = 'DUE';
          }
          await dbHelper.saleInvoiceUpdate(invoice: _invoice, updateFrom: 2);
        }
      } else if (_paymentPurchaseInvoice != null) {
        if (_isDeleteAction) {
          await dbHelper.paymentPurchaseInvoiceDelete(paymentIdList: [_paymentList[index].id]);
        }
        _paymentPurchaseInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceIdList: [_paymentPurchaseInvoice.invoiceId], isCancel: false);
        List<PurchaseInvoice> _purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(invoiceIdList: [_paymentPurchaseInvoice.invoiceId]);
        PurchaseInvoice _purchaseInvoice = (_purchaseInvoiceList.length != 0) ? _purchaseInvoiceList[0] : null;
        if (_purchaseInvoice.status != 'CANCELLED') {
          double netAmount = (_paymentPurchaseInvoiceList.length != 0) ? _paymentPurchaseInvoiceList.map((paymentInvoice) => paymentInvoice.amount).reduce((sum, amount) => sum + amount) : 0;
          if (netAmount == _purchaseInvoice.netAmount) {
            _purchaseInvoice.status = 'PAID';
          } else {
            _purchaseInvoice.status = 'DUE';
          }
          await dbHelper.purchaseInvoiceUpdate(invoice: _purchaseInvoice, updateFrom: 2);
        }
      } else if (_paymentSaleInvoiceReturn != null) {
        if (_isDeleteAction) {
          await dbHelper.paymentSaleInvoiceReturnDelete(paymentIdList: [_paymentList[index].id]);
        }
        _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(transactionGroupId: _paymentSaleInvoiceReturn.transactionGroupId, isCancel: false);
        List<SaleInvoiceReturn> _transactionChildList = await dbHelper.saleInvoiceReturnGetList(transactionGroupIdList: [_paymentSaleInvoiceReturn.transactionGroupId]);
        if (_transactionChildList.length > 0 && _transactionChildList[0].status != 'CANCELLED') {
          double _totalSpent = _transactionChildList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);
          double _totalPaid = (_paymentSaleInvoiceReturnList.length > 0) ? _paymentSaleInvoiceReturnList.map((f) => f.amount).reduce((sum, amt) => sum + amt) : 0;
          if (_totalSpent <= _totalPaid) {
            _transactionChildList.map((f) => f.status = 'REFUNDED').toList();
          } else {
            _transactionChildList.map((f) => f.status = 'PENDING').toList();
          }
          await dbHelper.saleInvoiceReturnUpdate(saleInvoiceReturnList: _transactionChildList, updateFrom: 0);
        }
      } else if (_paymentPurchaseInvoiceReturn != null) {
        if (_isDeleteAction) {
          await dbHelper.paymentPurchaseInvoiceReturnDelete(paymentIdList: [_paymentList[index].id]);
        }
        _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: _paymentPurchaseInvoiceReturn.transactionGroupId, isCancel: false);
        List<PurchaseInvoiceReturn> _transactionChildList = await dbHelper.purchaseInvoiceReturnGetList(transactionGroupIdList: [_paymentPurchaseInvoiceReturn.transactionGroupId]);
        if (_transactionChildList.length > 0 && _transactionChildList[0].status != 'CANCELLED') {
          double _totalSpent = _transactionChildList.map((f) => f.netAmount).reduce((sum, amt) => sum + amt);
          double _totalPaid = (_paymentPurchaseInvoiceReturnList.length > 0) ? _paymentPurchaseInvoiceReturnList.map((f) => f.amount).reduce((sum, amt) => sum + amt) : 0;
          if (_totalSpent <= _totalPaid) {
            _transactionChildList.map((f) => f.status = 'REFUNDED').toList();
          } else {
            _transactionChildList.map((f) => f.status = 'PENDING').toList();
          }
          await dbHelper.purchaseInvoiceReturnUpdate(purchaseInvoiceReturnList: _transactionChildList, updateFrom: 0);
        }
      }
    } catch (e) {
      print('Exception - paymentScreen.dart - _manageInvoiceOrOrder(): ' + e.toString());
    }
  }

  Widget _filterTab() {
    try {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _paymentList.clear();
                  _paymentSearch.paymentType = null;
                  _paymentSearch.isCancel = null;
                  await _getInit();
                  _isLoaderHide = false;
                  setState(() {
                    _filterIndex = 0;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["txt_All"], style: _filterIndex == 0 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _paymentList.clear();
                  _paymentSearch.paymentType = 'RECEIVED';
                    _paymentSearch.isCancel = null;
                  await _getInit();
                  _isLoaderHide = false;
                  setState(() {
                    _filterIndex = 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["lbl_received"], style: _filterIndex == 1 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _paymentList.clear();
                  _paymentSearch.paymentType = 'GIVEN';
                    _paymentSearch.isCancel = null;
                  await _getInit();
                  _isLoaderHide = false;
                  setState(() {
                    _filterIndex = 2;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 4, left: 4),
                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 2 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["lbl_given"], style: _filterIndex == 2 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                highlightColor: Colors.transparent,
                onTap: () async {
                  _startIndex = 0;
                  _paymentList.clear();
                    _paymentSearch.paymentType = null;
                  _paymentSearch.isCancel = true;
                  await _getInit();
                  _isLoaderHide = false;
                  setState(() {
                    _filterIndex = 3;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:  BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                      color: _filterIndex == 3 ? Theme.of(context).primaryColor : Colors.transparent),
                  padding: EdgeInsets.all(4),
                  height: 30,
                  child: Center(
                    child: Text(global.appLocaleValues["txt_cancelled"], style: _filterIndex == 3 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Exception - saleInvoiceScreen.dart - _filterTab(): ' + e.toString());
      return null;
    }
  }
}

class PaymentFilter extends ModalRoute<PaymentSearch> {
  PaymentSearch paymentSearch;
  PaymentFilter(this.paymentSearch);

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
    return SaleInvoiceFilterForm(
        paymentSearch: paymentSearch,
        searchValue: (obj) {
          paymentSearch = obj;
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
class SaleInvoiceFilterForm extends StatefulWidget {
  final PaymentSearch paymentSearch;
  final ValueChanged<PaymentSearch> searchValue;
  SaleInvoiceFilterForm({this.paymentSearch, this.searchValue});
  @override
  _SaleInvoiceState createState() => _SaleInvoiceState(paymentSearch, searchValue);
}

class _SaleInvoiceState extends State<SaleInvoiceFilterForm> {
  PaymentSearch paymentSearch;
  final ValueChanged<PaymentSearch> searchValue;
  _SaleInvoiceState(this.paymentSearch, this.searchValue);

  var _cChooseAccount = TextEditingController();
  var _fChooseAccount =  FocusNode();
  bool isReset = true;
  Account _account;

  PaymentSearch eSearch =  PaymentSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    if (paymentSearch != null) {
      _cChooseAccount.text = (paymentSearch.account != null)
          ? (paymentSearch.account.firstName != null)
              ? '${paymentSearch.account.firstName} ${paymentSearch.account.lastName}'
              //    ? '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoiceSearch.account.accountCode.toString().length))}${invoiceSearch.account.accountCode} - ${invoiceSearch.account.firstName} ${invoiceSearch.account.lastName}'
              : ''
          : '';

      _account = paymentSearch.account;

      paymentSearch.isSearch = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    assignValue();
    // if (accountSearch.searchBar != null || accountSearch.isCredit != null || accountSearch.isDue != null) {
    //   assignValue();
    // } else {
    //   accountSearch.isCredit = false;
    //   accountSearch.isDue = false;
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _selectAccount() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>  AccountSelectDialog(
                a: null,
                o: null,
                returnScreenId: 5,
                selectedAccount: (selectedAccount) {
                  _account = selectedAccount;
                },
              )));
      setState(() {
        if (_account.id != null) {
          _cChooseAccount.text = '${_account.firstName} ${_account.lastName}';
          //  '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode} - ${_account.firstName} ${_account.lastName}';
        }
      });
      //
      // if (_fChooseAccount.hasFocus) {
      //   await showDialog(
      //       context: context,
      //       builder: (_) {
      //         return AccountSelectDialog(
      //           a: widget.analytics,
      //           o: widget.observer,
      //           returnScreenId: 1,
      //           selectedAccount: (account) {
      //             _account = account;
      //           },
      //         );
      //       });
      //   setState(() {
      //     _cChooseAccount.text =
      //         '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode} - ${_account.firstName} ${_account.lastName}';
      //     FocusScope.of(context).requestFocus(_focusNode);
      //   });
      // }
    } catch (e) {
      print('Exception - saleInvoiceSearchDialog.dart - _selectAccount(): ' + e.toString());
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
                        size: 20,
                      ),
                      SizedBox(
                        width: 31.0,
                      ),
                      Text(
                        global.appLocaleValues['tle_search_payment'],
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
                          Text('${global.appLocaleValues['btn_reset']}', style: Theme.of(context).primaryTextTheme.headline2),
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
                      Text(global.appLocaleValues['lbl_choose_ac'], style: Theme.of(context).primaryTextTheme.headline3),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextFormField(
                          controller: _cChooseAccount,
                          focusNode: _fChooseAccount,
                          readOnly: true,
                          decoration: InputDecoration(hintText: global.appLocaleValues['lbl_choose_ac'], border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.people)),
                          onTap: () async {
                            await _selectAccount();
                          },
                        ),
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
                        Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline3)
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
                      eSearch.isSearch = true;
                      eSearch.account = _account;
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
          title: Text('${global.appLocaleValues['lbl_reset']}', style: Theme.of(context).primaryTextTheme.headline1),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${global.appLocaleValues['txt_filter']}', style: Theme.of(context).primaryTextTheme.headline3),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('${global.appLocaleValues['btn_ok']}', style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () {
                setState(() {
                  isReset = false;
                  eSearch.isSearch = true;
                  eSearch.account = null;

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
