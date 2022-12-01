// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/productSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentSaleOrderModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleOrderDetailModel.dart';
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/models/saleOrderSearchModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/saleInvoiceAddScreen.dart';
import 'package:accounting_app/screens/saleOrderAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/widgets/listTileSaleOrderWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ribbon/ribbon.dart';

class SaleOrderScreen extends BaseRoute {
  final Account account;
  SaleOrderScreen({@required a, @required o, this.account}) : super(a: a, o: o, r: 'SaleOrderScreen');
  @override
  _SaleOrderScreenState createState() => _SaleOrderScreenState(this.account);
}

class _SaleOrderScreenState extends BaseRouteState {
  List<SaleOrder> _saleOrderList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  SaleOrderSearch _orderSearch = SaleOrderSearch();
  List<int> _searchByOrderIdList;
  final Account account;
  bool _isLoaderHide = false;
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  var _refreshKey1 = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController1 = ScrollController();
  int _filterIndex;
  int _startIndex2 = 0;
  int filterCount = 0;

  _SaleOrderScreenState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${global.appLocaleValues['tle_sale_orders']}',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          // (br.getSystemFlagValue(global.systemFlagNameList.showSaleOrdersSeprated) == 'true')
          //     ? IconButton(
          //         tooltip: '${global.appLocaleValues['tt_show_combined']}',
          //         icon: Icon(Icons.view_day),
          //         iconSize: 20,
          //         onPressed: () async {
          //           await _changeLayout(false);
          //         },
          //       )
          //     : SizedBox(),

          IconButton(
            icon: Icon(MdiIcons.filter),
            iconSize: 20,
            onPressed: () async {
              await _searchOrders();
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SaleOrderAddSreen(
                        a: widget.analytics,
                        o: widget.observer,
                        order: SaleOrder(),
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
        child: Column(
          children: [
            _filterTab(),
            Expanded(child: _saleOrderTab(_saleOrderList)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController1.addListener(_lazyLoadingOrderWithoutTax);
  }

  @override
  void initState() {
    super.initState();
    _filterIndex = 0;
    if (account != null) {
      _orderSearch.account = account;
    }
    _getData();
  }

  Future _getData() async {
    try {
      await _getSaleOrderWithoutTax(false);

      _scrollController1.addListener(_lazyLoadingOrderWithoutTax);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _cancelOrRetriveOrder(SaleOrder _saleOrder, context, bool _actionOfCancelOrder) async {
    try {
      if (_actionOfCancelOrder) //check it is action of cancel invoice
      {
        try {
          AlertDialog dialog = AlertDialog(
            shape: nativeTheme().dialogTheme.shape,
            title: Text(global.appLocaleValues['tle_cancel_order'], style: Theme.of(context).primaryTextTheme.headline1),
            content: (global.appLanguage['name'] == 'English')
                ? Text(
                    '${global.appLocaleValues['txt_cancel_invoice']} "${br.generateAccountName(_saleOrder.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleOrder.saleOrderNumber.toString().length))}${_saleOrder.saleOrderNumber}" ?',
                    style: Theme.of(context).primaryTextTheme.headline3)
                : Text(
                    '"${br.generateAccountName(_saleOrder.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleOrder.saleOrderNumber.toString().length))}${_saleOrder.saleOrderNumber}" ${global.appLocaleValues['txt_cancel_invoice']} ?',
                    style: Theme.of(context).primaryTextTheme.headline3),
            actions: <Widget>[
              TextButton(
                child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _saleOrder.status = 'CANCELLED';
                  await dbHelper.saleOrderUpdate(order: _saleOrder, updateFrom: 2);
                  setState(() {});
                  // try {
                  //   AlertDialog dialog =  AlertDialog(
                  //     shape: nativeTheme().dialogTheme.shape,
                  //     title: Text(
                  //       global.appLocaleValues['tle_cancel_payments'],
                  //       style: TextStyle(fontWeight: FontWeight.bold),
                  //     ),
                  //     content: Container(
                  //       width: MediaQuery.of(context).size.width - 40,
                  //       height: MediaQuery.of(context).size.height * 0.1,
                  //       child: Column(
                  //         children: <Widget>[
                  //           Row(
                  //             children: <Widget>[
                  //               Expanded(
                  //                 child: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_cancel_payments']} "${br.generateAccountName(_saleOrder.account)} ${_saleOrder.saleOrderNumber}" ?') : Text('"${br.generateAccountName(_saleOrder.account)} ${_saleOrder.saleOrderNumber}" ${global.appLocaleValues['txt_cancel_payments']} ?'),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     actions: <Widget>[
                  //       TextButton(
                  //         child: Text(
                  //           global.appLocaleValues['btn_no'],
                  //           style: TextStyle(color: Theme.of(context).primaryColor),
                  //         ),
                  //         onPressed: () async {
                  //           Navigator.of(context).pop();
                  //           await _getSaleOrderWithoutTax(true);
                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //             content: Text('${global.appLocaleValues['txt_order_cancel_success']}'),
                  //           ));
                  //         },
                  //       ),
                  //       TextButton(
                  //         child: Text(global.appLocaleValues['btn_yes']),
                  //         onPressed: () async {
                  //           // await _cancelOrRetrivePayments(_saleOrder.id, true);
                  //           Navigator.of(context).pop();
                  //           await _getSaleOrderWithoutTax(true);
                  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //             content: Text('${global.appLocaleValues['txt_order_cancel_success']}'),
                  //           ));
                  //         },
                  //       ),
                  //     ],
                  //   );
                  //   showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                  // } catch (e) {
                  //   print('Exception - SaleOrderScreen.dart - _cancelOrRetriveOrder(): ' + e.toString());
                  // }
                },
              ),
            ],
          );
          showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
        } catch (e) {
          print('Exception - SaleOrderScreen.dart - _cancelOrRetriveOrder(): ' + e.toString());
        }
      } else {
        // await _cancelOrRetrivePayments(_saleOrder.id, false);
        List<SaleOrderDetail> _saleOrderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrder.id]);
        bool _isSame = true;
        _saleOrderDetailList.forEach((element) {
          if (element.quantity != element.invoicedQuantity) {
            _isSame = false;
          }
        });
        _saleOrder.status = (_isSame) ? "INVOICED" : "OPEN";
        await dbHelper.saleOrderUpdate(order: _saleOrder, updateFrom: 2).then((value) {
          _saleOrderList.clear();
        });
        await _getSaleOrderWithoutTax(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('${global.appLocaleValues['txt_order_retrvied_success']}'),
        ));
        setState(() {});
      }
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _cancelOrRetriveOrder(): ' + e.toString());
    }
  }

  Future _deleteOrder(SaleOrder _saleOrder) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_delete_order'],
          style: Theme.of(context).primaryTextTheme.headline1,
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  (global.appLanguage['name'] == 'English')
                      ? Expanded(
                          child: Text(
                          '${global.appLocaleValues['txt_delete']} "${br.generateAccountName(_saleOrder.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleOrder.saleOrderNumber.toString().length))}${_saleOrder.saleOrderNumber}" ?',
                          style: Theme.of(context).primaryTextTheme.headline3,
                        ))
                      : Expanded(
                          child: Text(
                              '"${br.generateAccountName(_saleOrder.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleOrder.saleOrderNumber.toString().length))}${_saleOrder.saleOrderNumber}" ${global.appLocaleValues['txt_delete']} ?',
                              style: Theme.of(context).primaryTextTheme.headline3)),
                ],
              ),
            ],
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
              bool _isUsed = await dbHelper.saleOrderisUsed(_saleOrder.id);
              if (!_isUsed) {
                List<SaleOrderDetail> _saleOrderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrder.id]);
                await dbHelper.saleOrderDetailTaxDelete(orderDetailIdList: _saleOrderDetailList.map((orderDetail) => orderDetail.id).toList());
                await dbHelper.saleOrderTaxDelete(_saleOrder.id);
                await dbHelper.saleOrderDetailDelete(orderId: _saleOrder.id);
                await _deletePayment(_saleOrder);
                int _result = await dbHelper.saleOrderDelete(_saleOrder.id);
                if (_result == 1) {
                  _saleOrderList.removeWhere((f) => f.id == _saleOrder.id);
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('${global.appLocaleValues['txt_order_dlt_success']}'),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('${global.appLocaleValues['txt_order_dlt_fail']}'),
                  ));
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${global.appLocaleValues['txt_order_dlt_failed']}'),
                ));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _deleteOrder(): ' + e.toString());
    }
  }

  Future _deletePayment(SaleOrder _saleOrder) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(global.appLocaleValues['tle_payment_dlt'], style: Theme.of(context).primaryTextTheme.headline1),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: (global.appLanguage['name'] == 'English')
                          ? Text(
                              '${global.appLocaleValues['txt_payment_dlt']} "${br.generateAccountName(_saleOrder.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleOrder.saleOrderNumber.toString().length))}${_saleOrder.saleOrderNumber}" ?',
                              style: Theme.of(context).primaryTextTheme.headline3)
                          : Text(
                              '"${br.generateAccountName(_saleOrder.account)} ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleOrder.saleOrderNumber.toString().length))}${_saleOrder.saleOrderNumber}" ${global.appLocaleValues['txt_payment_dlt']} ?',
                              style: Theme.of(context).primaryTextTheme.headline3)),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            // textColor: Theme.of(context).primaryColor,
            child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              List<PaymentSaleOrder> _paymentOrder = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrder.id]);
              await dbHelper.paymentDetailDelete(paymentIdList: _paymentOrder.map((paymentOrder) => paymentOrder.paymentId).toList());
              await dbHelper.paymentSaleOrderDelete(paymentIdList: _paymentOrder.map((paymentOrder) => paymentOrder.paymentId).toList());
              await dbHelper.paymentDelete(paymentIdList: _paymentOrder.map((paymentOrder) => paymentOrder.paymentId).toList());
            },
          ),
        ],
      );
      await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _deletePayment(): ' + e.toString());
    }
  }

  Future<String> _orderPrintOrShare(SaleOrder _saleOrder, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _saleOrder.accountId);
      _saleOrder.account = _accountList[0];
      _saleOrder.orderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrder.id]);
      _saleOrder.orderTaxList = await dbHelper.saleOrderTaxGetList(saleOrderId: _saleOrder.id);
      _saleOrder.orderDetailTaxList = await dbHelper.saleOrderDetailTaxGetList(orderDetailIdList: _saleOrder.orderDetailList.map((orderDetail) => orderDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      // List<PaymentSaleOrder> _paymentSaleOrderList = [];
      // List<Payment> _paymentList = [];
      // List<PaymentDetail> _paymentDetailList = [];
      var htmlContent;

      // _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrder.id], isCancel: false);
      // _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
      // _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
      // if (_paymentList.length != 0) {
      //   _paymentList.forEach((item) {
      //     if (item.paymentType == 'RECEIVED') {
      //       _paymentDetailList.forEach((paymentDetail) {
      //         if (item.id == paymentDetail.paymentId) {
      //           if (paymentDetail.paymentMode == 'Cheque') {
      //             _saleOrder.paymentByCheque += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Cash') {
      //             _saleOrder.paymentByCash += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'Card') {
      //             _saleOrder.paymentByCard += paymentDetail.amount;
      //           } else if (paymentDetail.paymentMode == 'EWallet' || paymentDetail.paymentMode == 'eWallet') {
      //             _saleOrder.paymentByEWallet += paymentDetail.amount;
      //           } else {
      //             _saleOrder.paymentByNetBanking += paymentDetail.amount;
      //           }
      //         }
      //       });
      //     }
      //   });
      // }
      if (_isPrintAction != null) {
        br.generateSaleOrderHtml(
          context,
          order: _saleOrder,
          isPrintAction: _isPrintAction,
        );
      } else {
        htmlContent = br.generateSaleOrderHtml(
          context,
          order: _saleOrder,
          isPrintAction: _isPrintAction,
        );
      }
      return htmlContent;
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _orderPrintOrShare(): ' + e.toString());
      return null;
    }
  }

  Future _lazyLoadingOrderWithoutTax() async {
    try {
      int _dataLen = _saleOrderList.length;
      if (_scrollController1.position.pixels == _scrollController1.position.maxScrollExtent) {
        await _getSaleOrderWithoutTax(false);
        if (_dataLen == _saleOrderList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _lazyLoadingOrderWithoutTax(): ' + e.toString());
    }
  }

  Future _searchOrders() async {
    try {
      Navigator.of(context)
          .push(SaleOrderFilter(
        _orderSearch,
      ))
          .then((value) async {
        if (value != null) {
          _orderSearch = value;
          if (_orderSearch.isSearch) {
            _saleOrderList.clear();
            if (_orderSearch.product != null && _orderSearch.product.id != null) {
              List<SaleOrderDetail> _saleOrderDetailList = await dbHelper.saleOrderDetailGetList(productId: _orderSearch.product.id);
              _searchByOrderIdList = (_saleOrderDetailList.length > 0) ? _saleOrderDetailList.map((orderDetail) => orderDetail.saleOrderId).toList() : [];
            } else {
              _searchByOrderIdList = null;
            }
            _isDataLoaded = false;
            setState(() {});
            await _getSaleOrderWithoutTax(true);
            _isDataLoaded = true;
            setState(() {});
            //    }
          }
        }
      });
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _searchOrders(): ' + e.toString());
    }
  }

  Widget _saleOrderTab(List<SaleOrder> _saleOrderList) {
    try {
      return RefreshIndicator(
          key: _refreshKey1,
          onRefresh: () async {
            await _getSaleOrderWithoutTax(false);
          },
          child: (_isDataLoaded)
              ? (_saleOrderList.isNotEmpty)
                  ? Scrollbar(
                      child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: _scrollController1,
                          itemCount: _saleOrderList.length,
                          itemBuilder: (context, index) {
                            if (_saleOrderList.length == index) {
                              return (!_isLoaderHide)
                                  ? Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : SizedBox();
                            }

                            return Card(
                              margin: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                              semanticContainer: true,
                              child: (_saleOrderList[index].finalTax > 0)
                                  ? Ribbon(
                                      nearLength: 47,
                                      farLength: 20,
                                      title: global.appLocaleValues['rbn_with_tax'],
                                      titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                      color: Colors.green,
                                      location: RibbonLocation.values[1],
                                      child: ListTileSaleOrderWidget(
                                        key: ValueKey(_saleOrderList[index].id),
                                        saleOrder: _saleOrderList[index],
                                        a: widget.analytics,
                                        o: widget.observer,
                                        onGenerateInvoicePressed: (_saleOrder) async {
                                          SaleInvoice _saleInvoice = await br.generateInvoiceFromOrder(_saleOrder, dbHelper);
                                          _saleInvoice.salesOrderId = _saleOrder.id;
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (BuildContext context) => SaleInvoiceAddSreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                    invoice: _saleInvoice,
                                                    screenId: 2,
                                                  )));
                                        },
                                        onDeletePressed: (_saleOrder) async {
                                          await _deleteOrder(_saleOrder);
                                        },
                                        orderPrintOrShare: (_saleOrder, _isPrintAction, context) async {
                                          var htmlContent = await _orderPrintOrShare(_saleOrder, context, _isPrintAction);
                                          return htmlContent;
                                        },
                                        orderCancelOrRetrive: (_saleOrder, _actionOfCancelOrder, context) async {
                                          await _cancelOrRetriveOrder(_saleOrder, context, _actionOfCancelOrder);
                                        },
                                      ),
                                    )
                                  : ListTileSaleOrderWidget(
                                      key: ValueKey(_saleOrderList[index].id),
                                      saleOrder: _saleOrderList[index],
                                      a: widget.analytics,
                                      o: widget.observer,
                                      onGenerateInvoicePressed: (_saleOrder) async {
                                        SaleInvoice _saleInvoice = await br.generateInvoiceFromOrder(_saleOrder, dbHelper);
                                        _saleInvoice.salesOrderId = _saleOrder.id;
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (BuildContext context) => SaleInvoiceAddSreen(
                                                  a: widget.analytics,
                                                  o: widget.observer,
                                                  invoice: _saleInvoice,
                                                  screenId: 2,
                                                )));
                                      },
                                      onDeletePressed: (_saleOrder) async {
                                        await _deleteOrder(_saleOrderList[index]);
                                      },
                                      orderPrintOrShare: (_saleOrder, _isPrintAction, context) async {
                                        var htmlContent = await _orderPrintOrShare(_saleOrder, context, _isPrintAction);
                                        return htmlContent;
                                      },
                                      orderCancelOrRetrive: (_saleOrder, _actionOfCancelOrder, context) async {
                                        await _cancelOrRetriveOrder(_saleOrder, context, _actionOfCancelOrder);
                                      },
                                    ),
                            );
                          }),
                    ))
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
                            (br.getSystemFlagValue(global.systemFlagNameList.showSaleOrdersSeprated) == 'true') ? global.appLocaleValues['tle_tax_order_empty_'] : global.appLocaleValues['tle_without_tax_order_empty_'],
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ))
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ));
    } catch (e) {
      print('Exception - _saleOrderTab.dart - ${'withTaxTab()'}: ' + e.toString());
      return null;
    }
  }

  Widget _filterTab() {
    try {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
        child: SizedBox(
          height: 40,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                    height: 30,
                    width: 50,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _startIndex2 = 0;
                        _saleOrderList = [];
                        _orderSearch.status = null;
                        _orderSearch.isWithTax = null;
                        await _getData();
                        setState(() {
                          _filterIndex = 0;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
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
                ),
                SizedBox(
                  height: 30,
                  width: 70,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleOrderList = [];
                      _filterIndex = 1;
                      _orderSearch.status = 'OPEN';
                      _orderSearch.isWithTax = null;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          color: _filterIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent),
                      padding: EdgeInsets.all(4),
                      height: 30,
                      child: Center(
                        child: Text(global.appLocaleValues["txt_open"], style: _filterIndex == 1 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleOrderList = [];
                      _orderSearch.status = 'INVOICED';
                      _orderSearch.isWithTax = null;
                      _filterIndex = 2;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 4, left: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          color: _filterIndex == 2 ? Theme.of(context).primaryColor : Colors.transparent),
                      padding: EdgeInsets.all(4),
                      height: 30,
                      child: Center(
                        child: Text(global.appLocaleValues["txt_invoiced"], style: _filterIndex == 2 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                  width: 80,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleOrderList = [];
                      _filterIndex = 3;
                      _orderSearch.status = 'CANCELLED';
                      _orderSearch.isWithTax = null;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
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
                SizedBox(
                  height: 30,
                  width: 80,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      _startIndex2 = 0;
                      _saleOrderList = [];
                      _orderSearch.status = null;
                      _orderSearch.isWithTax = true;
                      _filterIndex = 4;
                      await _getData();
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 4, left: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                          color: _filterIndex == 4 ? Theme.of(context).primaryColor : Colors.transparent),
                      padding: EdgeInsets.all(4),
                      height: 30,
                      child: Center(
                        child: Text(global.appLocaleValues["tle_with_tax"], style: _filterIndex == 4 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      height: 30,
                      width: 90,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          _startIndex2 = 0;
                          _saleOrderList = [];
                          _orderSearch.status = null;
                          _orderSearch.isWithTax = false;
                          _filterIndex = 5;
                          await _getData();
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                              color: _filterIndex == 5 ? Theme.of(context).primaryColor : Colors.transparent),
                          padding: EdgeInsets.all(4),
                          height: 30,
                          child: Center(
                            child: Text(global.appLocaleValues["tle_without_tax"], style: _filterIndex == 5 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Exception - _saleOrderTab.dart - _filterTab(): ' + e.toString());
      return null;
    }
  }

  Future _getSaleOrderWithoutTax(bool _isResetAction) async {
    try {
      if (_isResetAction) {
        _startIndex2 = 0;
        _saleOrderList = [];
        setState(() {});
      }
      if (_isRecordPending) {
        if (_saleOrderList.length != null && _saleOrderList.length > 0) {
          _startIndex2 = _saleOrderList.length;
        } else {
          _saleOrderList = [];
        }
        _saleOrderList += await dbHelper.saleOrderGetList(
            startIndex: _startIndex2,
            fetchRecords: global.fetchRecords,
            // fetchTaxOrders: true,
            startDate: (_orderSearch != null)
                ? (_orderSearch.dateFrom != null)
                    ? _orderSearch.dateFrom
                    : null
                : null,
            endDate: (_orderSearch != null)
                ? (_orderSearch.dateTo != null)
                    ? _orderSearch.dateTo
                    : null
                : null,
            amountFrom: (_orderSearch != null)
                ? (_orderSearch.amountFrom != null)
                    ? _orderSearch.amountFrom
                    : null
                : null,
            amountTo: (_orderSearch != null)
                ? (_orderSearch.amountTo != null)
                    ? _orderSearch.amountTo
                    : null
                : null,
            accountId: (_orderSearch != null)
                ? (_orderSearch.account != null)
                    ? _orderSearch.account.id
                    : null
                : null,
            status: (_orderSearch != null)
                ? (_orderSearch.status != null)
                    ? _orderSearch.status
                    : null
                : null,
            isWithTax: _orderSearch.isWithTax,
            orderIdList: _searchByOrderIdList);

        for (int i = _startIndex2; i < _saleOrderList.length; i++) {
          List<SaleOrderDetail> _saleOrderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [_saleOrderList[i].id]);
          _saleOrderList[i].totalProducts = _saleOrderDetailList.length;
          _saleOrderList[i].orderDetailList = _saleOrderDetailList;

          List<PaymentSaleOrder> _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrderList[i].id], isCancel: false);
          List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());

          double _givenAmount = 0;
          if (_paymentList.length != 0) {
            _paymentList.forEach((item) {
              if (item.paymentType == 'RECEIVED') {
                _saleOrderList[i].advanceAmount += item.amount;
              } else {
                _givenAmount += item.amount;
              }
            });
          }
          _saleOrderList[i].remainAmount = (_paymentList.length != 0) ? (_saleOrderList[i].netAmount - (_saleOrderList[i].advanceAmount - _givenAmount)) : _saleOrderList[i].netAmount;
          _saleOrderList[i].isEditable = await dbHelper.saleOrderisUsed(_saleOrderList[i].id);
          _saleOrderList[i].isEditable = !_saleOrderList[i].isEditable;
          print('_saleOrderWithoutTaxList2 ${_saleOrderList.length}');
        }
        _startIndex2 += global.fetchRecords;
        // _getAccount();
        setState(() {
          (_saleOrderList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
        });
      }
      print('_saleOrderWithoutTaxList3 ${_saleOrderList.length}');
    } catch (e) {
      print('Exception - SaleOrderScreen.dart - _getSaleOrderWithoutTax(): ' + e.toString());
    }
  }

  // Future _cancelOrRetrivePayments(int _saleOrderId, bool _isCancelling) async {
  //   try {
  //     List<PaymentSaleOrder> _paymentSaleOrderList = await dbHelper.paymentSaleOrderGetList(orderIdList: [_saleOrderId]);
  //     List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());
  //     List<PaymentDetail> _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentSaleOrderList.map((paymentOrder) => paymentOrder.paymentId).toList());

  //     _paymentSaleOrderList.forEach((item) async {
  //       item.isCancel = _isCancelling;
  //       await dbHelper.paymentSaleOrderUpdate(item);
  //     });

  //     _paymentDetailList.forEach((item) async {
  //       item.isCancel = _isCancelling;
  //       await dbHelper.paymentDetailUpdate(item);
  //     });

  //     _paymentList.forEach((item) async {
  //       item.isCancel = _isCancelling;
  //       await dbHelper.paymentUpdate(item);
  //     });
  //   } catch (e) {
  //     print('Exception - SaleOrderScreen.dart - _cancelOrRetrivePayments(): ' + e.toString());
  //   }
  // }

}

class SaleOrderFilter extends ModalRoute<SaleOrderSearch> {
  SaleOrderSearch saleOrderSearch;
  SaleOrderFilter(this.saleOrderSearch);

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
    return SaleOrderFilterForm(
        saleOrderSearch: saleOrderSearch,
        searchValue: (obj) {
          saleOrderSearch = obj;
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
class SaleOrderFilterForm extends StatefulWidget {
  final SaleOrderSearch saleOrderSearch;
  final ValueChanged<SaleOrderSearch> searchValue;
  SaleOrderFilterForm({this.saleOrderSearch, this.searchValue});
  @override
  _SaleOrderState createState() => _SaleOrderState(saleOrderSearch, searchValue);
}

class _SaleOrderState extends State<SaleOrderFilterForm> {
  SaleOrderSearch saleOrderSearch;
  final ValueChanged<SaleOrderSearch> searchValue;
  _SaleOrderState(this.saleOrderSearch, this.searchValue);
  BusinessRule br = BusinessRule();
  var _cAmountRangeFrom = TextEditingController();
  var _cAmountRangeTo = TextEditingController();
  var _cDateRangeTo = TextEditingController();
  var _cDateRangeFrom = TextEditingController();
  // var _cPaymentMode = TextEditingController();
  var _cChooseAccount = TextEditingController();
  var _cChooseProduct = TextEditingController();
  var _fFromDateFocusNode = FocusNode();
  var _fToDateFocusNode = FocusNode();
  var _fChooseAccount = FocusNode();
  var _fChooseProduct = FocusNode();
  var _focusNode = FocusNode();
  bool isReset = true;

  bool _dateFrom = false;
  String _dateRangeFrom2 = '', _dateRangeTo2 = '';
  Account _account;
  Product _product;

  SaleOrderSearch eSearch = SaleOrderSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    _fFromDateFocusNode.addListener(_selectdateListener);
    _fToDateFocusNode.addListener(_selectdateListener);

    if (saleOrderSearch != null) {
      _cChooseAccount.text = (saleOrderSearch.account != null)
          ? (saleOrderSearch.account.firstName != null)
              ? '${saleOrderSearch.account.firstName} ${saleOrderSearch.account.lastName}'
              //    ? '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoiceSearch.account.accountCode.toString().length))}${invoiceSearch.account.accountCode} - ${invoiceSearch.account.firstName} ${invoiceSearch.account.lastName}'
              : ''
          : '';
      _cChooseProduct.text = (saleOrderSearch.product != null)
          ? (saleOrderSearch.product.productCode != null)
              ? '${saleOrderSearch.product.name}'
              : ''
          : '';
      _cDateRangeFrom.text = (saleOrderSearch.dateFrom != null) ? '${DateFormat('dd-MM-yyyy').format(saleOrderSearch.dateFrom)}' : '';
      _dateRangeFrom2 = (saleOrderSearch.dateFrom != null) ? '${saleOrderSearch.dateFrom}' : '';
      _cDateRangeTo.text = (saleOrderSearch.dateTo != null) ? '${DateFormat('dd-MM-yyyy').format(saleOrderSearch.dateTo)}' : '';
      _dateRangeTo2 = (saleOrderSearch.dateTo != null) ? '${saleOrderSearch.dateTo}' : '';
      _cAmountRangeTo.text = (saleOrderSearch.amountTo != null) ? '${saleOrderSearch.amountTo}' : '';
      _cAmountRangeFrom.text = (saleOrderSearch.amountFrom != null) ? '${saleOrderSearch.amountFrom}' : '';
      _account = saleOrderSearch.account;
      _product = saleOrderSearch.product;
      saleOrderSearch.isSearch = false;
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
          builder: (context) => AccountSelectDialog(
                a: null,
                o: null,
                returnScreenId: 1,
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
      print('Exception - saleOrderSearchDialog.dart - _selectAccount(): ' + e.toString());
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
      print('Exception - saleOrderSearchDialog.dart - _selectDate(): ' + e.toString());
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
      print('Exception - saleOrderSearchDialog.dart - _selectdateListener(): ' + e.toString());
    }
  }

  Future _selectProduct() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductSelectDialog(
                a: null,
                o: null,
                returnScreenId: 1,
                onValueSelected: (product) {
                  _product = product[0];
                },
              )));
      setState(() {
        if (_product.id != null) {
          _cChooseProduct.text = '${_product.name}';
          FocusScope.of(context).requestFocus(_focusNode);
        }
      });
      // if (_fChooseProduct.hasFocus) {
      //   await showDialog(
      //       context: context,
      //       builder: (_) {
      //         return ProductSelectDialog(
      //           a: widget.analytics,
      //           o: widget.observer,
      //           returnScreenId: 1,
      //           onValueSelected: (product) {
      //             _product = product[0];
      //           },
      //         );
      //       });
      //   setState(() {
      //     _cChooseProduct.text = '${br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.productCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.productCodePrefix).length + _product.productCode.toString().length))}${_product.productCode} - ${_product.name}';
      //     FocusScope.of(context).requestFocus(_focusNode);
      //   });
      // }
    } catch (e) {
      print('Exception - saleOrderSearchDialog.dart - _selectProduct(): ' + e.toString());
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
                        '${global.appLocaleValues['tle_sale_orders']}',
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
                            style: Theme.of(context).primaryTextTheme.headline2,
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
                          decoration: InputDecoration(border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.people), hintText: 'Choose account'),
                          onTap: () async {
                            await _selectAccount();
                          },
                        ),
                      ],
                    ),
                  ),
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
                children: [
                  Text(
                    global.appLocaleValues['tle_choose_product'],
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: TextFormField(
                      controller: _cChooseProduct,
                      focusNode: _fChooseProduct,
                      onTap: () async {
                        await _selectProduct();
                      },
                      readOnly: true,
                      decoration: InputDecoration(hintText: 'Choose product/services', border: nativeTheme().inputDecorationTheme.border, prefixIcon: Icon(Icons.local_mall)),
                    ),
                  ),
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
                  Text(
                    '${global.appLocaleValues['lbl_enter_amount']}',
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            controller: _cAmountRangeFrom,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            maxLength: 5,
                            decoration: InputDecoration(hintText: global.appLocaleValues['lbl_from_amount'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.credit_card)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            controller: _cAmountRangeTo,
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            maxLength: 5,
                            decoration: InputDecoration(hintText: global.appLocaleValues['lbl_to_amount'], border: nativeTheme().inputDecorationTheme.border, counterText: '', prefixIcon: Icon(Icons.credit_card)),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                  Text(
                    '${global.appLocaleValues['lbl_date_err_req']}',
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
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
                      eSearch.product = _product;
                      eSearch.isSearch = true;
                      eSearch.amountFrom = (_cAmountRangeFrom.text != '') ? double.parse(_cAmountRangeFrom.text) : null;
                      eSearch.amountTo = (_cAmountRangeTo.text != '') ? double.parse(_cAmountRangeTo.text) : null;
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
                  eSearch.product = null;
                  eSearch.amountFrom = null;
                  eSearch.amountTo = null;
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
