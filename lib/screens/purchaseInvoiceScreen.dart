// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/dialogs/productSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentDetailModel.dart';
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/productModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnDetailTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnTaxModel.dart';
import 'package:accounting_app/models/purchaseInvoiceSearchModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/purchaseInvoiceAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:accounting_app/widgets/listTilePurchaseInvoiceWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ribbon/ribbon.dart';

class PurchaseInvoiceScreen extends BaseRoute {
  final Account account;
  PurchaseInvoiceScreen({@required a, @required o, this.account}) : super(a: a, o: o, r: 'PurchaseInvoiceScreen');
  @override
  _PurchaseInvoiceScreenState createState() => _PurchaseInvoiceScreenState(this.account);
}

class _PurchaseInvoiceScreenState extends BaseRouteState {
  List<PurchaseInvoice> _purchaseInvoiceList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _startIndex = 0;
  PurchaseInvoiceSearch _invoiceSearch = PurchaseInvoiceSearch();
  List<int> _searchByInvoiceIdList;
  final Account account;
  bool _isLoaderHide = false;
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  var _refreshKey1 = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController1 = ScrollController();
  int filterCount = 0;
  int _filterIndex = 0;

  _PurchaseInvoiceScreenState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(global.appLocaleValues['lbl_invoices']),
        actions: <Widget>[
          IconButton(
              icon: Icon(MdiIcons.filter), // required

              onPressed: () async {
                await _searchInvoices();
              }),
          IconButton(
            icon: Icon(Icons.add),
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PurchaseInvoiceAddSreen(
                        a: widget.analytics,
                        o: widget.observer,
                        invoice: PurchaseInvoice(),
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
              _purchaseInvoiceTab(_purchaseInvoiceList),
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController1.addListener(_lazyLoadingInvoiceWithTax);
  }

  @override
  void initState() {
    super.initState();

    if (account != null) {
      _invoiceSearch.account = account;
    }
    _getData();
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
                        _startIndex = 0;
                        _purchaseInvoiceList = [];
                        _invoiceSearch.status = null;
                        _invoiceSearch.isWithTax = null;
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
                      _startIndex = 0;
                      _purchaseInvoiceList = [];
                      _filterIndex = 1;
                      _invoiceSearch.status = 'DUE';
                      _invoiceSearch.isWithTax = null;
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
                        child: Text(global.appLocaleValues["tle_due"], style: _filterIndex == 1 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
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
                      _startIndex = 0;
                      _purchaseInvoiceList = [];
                      _invoiceSearch.status = 'PAID';
                      _invoiceSearch.isWithTax = null;
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
                        child: Text(global.appLocaleValues["lbl_paid_cap"], style: _filterIndex == 2 ? Theme.of(context).primaryTextTheme.headline2 : Theme.of(context).primaryTextTheme.headline3),
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
                      _startIndex = 0;
                      _purchaseInvoiceList = [];
                      _filterIndex = 3;
                      _invoiceSearch.status = 'CANCELLED';
                      _invoiceSearch.isWithTax = null;
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
                      _startIndex = 0;
                      _purchaseInvoiceList = [];
                      _invoiceSearch.status = null;
                      _invoiceSearch.isWithTax = true;
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
                          _startIndex = 0;
                          _purchaseInvoiceList = [];
                          _invoiceSearch.status = null;
                          _invoiceSearch.isWithTax = false;
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
      return SizedBox();
    }
  }

  Future _cancelOrRetriveInvoice(PurchaseInvoice _purchaseInvoice, context, bool _actionOfCancelInvoice) async {
    try {
//int _index = index;
      if (_actionOfCancelInvoice) //check it is action of cancel invoice
      {
        try {
          AlertDialog dialog = AlertDialog(
            shape: nativeTheme().dialogTheme.shape,
            title: Text(
              global.appLocaleValues['tle_cancel_invoice'],
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_cancel_invoice']} "${_purchaseInvoice.invoiceNumber}" ?') : Text('"${_purchaseInvoice.invoiceNumber}" ${global.appLocaleValues['txt_cancel_invoice']} ?'),
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
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _purchaseInvoice.status = 'CANCELLED';
                  await dbHelper.purchaseInvoiceUpdate(invoice: _purchaseInvoice, updateFrom: 2);
                  try {
                    AlertDialog dialog = AlertDialog(
                      shape: nativeTheme().dialogTheme.shape,
                      title: Text(
                        global.appLocaleValues['tle_cancel_payments'],
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                      ),
                      content: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_cancel_payments']} "${_purchaseInvoice.invoiceNumber}" ?') : Text('"${_purchaseInvoice.invoiceNumber}" ${global.appLocaleValues['txt_cancel_payments']} ?'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline3),
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await _getPurchaseInvoiceWithTax(true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${global.appLocaleValues['txt_invoice_cancel_success']}'),
                            ));
                          },
                        ),
                        TextButton(
                          child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
                          onPressed: () async {
                            List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoice.id);
                            List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
                            List<PaymentDetail> _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());

                            _paymentInvoiceList.forEach((item) async {
                              item.isCancel = true;
                              await dbHelper.paymentPurchaseInvoiceUpdate(item);
                            });

                            _paymentDetailList.forEach((item) async {
                              item.isCancel = true;
                              await dbHelper.paymentDetailUpdate(item);
                            });

                            _paymentList.forEach((item) async {
                              item.isCancel = true;
                              await dbHelper.paymentUpdate(item);
                            });
                            Navigator.of(context).pop();
                            await _getPurchaseInvoiceWithTax(true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('${global.appLocaleValues['txt_invoice_cancel_success']}'),
                            ));
                          },
                        ),
                      ],
                    );
                    showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          );
          showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
        } catch (e) {
          print(e);
        }
      } else {
        List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoice.id);
        List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        List<PaymentDetail> _paymentDetailList = await dbHelper.paymentDetailGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());

        _paymentInvoiceList.forEach((item) async {
          item.isCancel = false;
          await dbHelper.paymentPurchaseInvoiceUpdate(item);
        });

        _paymentDetailList.forEach((item) async {
          item.isCancel = false;
          await dbHelper.paymentDetailUpdate(item);
        });

        _paymentList.forEach((item) async {
          item.isCancel = false;
          await dbHelper.paymentUpdate(item);
        });

        _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoice.id, isCancel: false);
        _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        double _receivedAmount = 0;
        double _givenAmount = 0;
        if (_paymentList.length != 0) {
          _paymentList.forEach((item) {
            if (item.paymentType == 'GIVEN') {
              _receivedAmount += item.amount;
            } else {
              _givenAmount += item.amount;
            }
          });
        }
        _purchaseInvoice.remainAmount = (_paymentList.length != 0) ? (_purchaseInvoice.netAmount - (_receivedAmount - _givenAmount)) : _purchaseInvoice.netAmount;
        _purchaseInvoice.status = (_purchaseInvoice.remainAmount <= 0) ? 'PAID' : 'DUE';
        await dbHelper.purchaseInvoiceUpdate(invoice: _purchaseInvoice, updateFrom: 2);
        await _getPurchaseInvoiceWithTax(true);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('${global.appLocaleValues['txt_invoice_retrvied_success']}'),
        ));
        // setState(() {});
      }
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _cancelOrRetriveInvoice(): ' + e.toString());
    }
  }

  Future _deleteInvoice(PurchaseInvoice _purchaseInvoice) async {
    try {
      AlertDialog _dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_delete_invoice'],
          style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width - 40,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_delete']} "${_purchaseInvoice.invoiceNumber}" ?') : Text('"${_purchaseInvoice.invoiceNumber}" ${global.appLocaleValues['txt_delete']} ?'),
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
              List<PurchaseInvoiceDetail> _purchaseInvoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoice.id);
              await dbHelper.purchaseInvoiceDetailTaxDelete(invoiceDetailIdList: _purchaseInvoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
              await dbHelper.purchaseInvoiceTaxDelete(_purchaseInvoice.id);
              await dbHelper.purchaseInvoiceDetailDelete(invoiceId: _purchaseInvoice.id);
              await _deletePayment(_purchaseInvoice);
              int _result = await dbHelper.purchaseInvoiceDelete(_purchaseInvoice.id);
              if (_result == 1) {
                _purchaseInvoiceList.removeWhere((f) => f.id == _purchaseInvoice.id);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text('${global.appLocaleValues['txt_invoice_dlt_success']}'),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${global.appLocaleValues['txt_invoice_dlt_fail']}'),
                ));
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _deleteInvoice(): ' + e.toString());
    }
  }

  Future _deletePayment(PurchaseInvoice _purchaseInvoice) async {
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
                  Expanded(child: (global.appLanguage['name'] == 'English') ? Text('${global.appLocaleValues['txt_payment_dlt']} "${_purchaseInvoice.invoiceNumber}" ?') : Text('"${_purchaseInvoice.invoiceNumber}" ${global.appLocaleValues['txt_payment_dlt']} ?')),
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
              List<PaymentPurchaseInvoice> _paymentInvoice = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoice.id);
              await dbHelper.paymentDetailDelete(paymentIdList: _paymentInvoice.map((paymentInvoice) => paymentInvoice.paymentId).toList());
              await dbHelper.paymentPurchaseInvoiceDelete(paymentIdList: _paymentInvoice.map((paymentInvoice) => paymentInvoice.paymentId).toList());
              await dbHelper.paymentDelete(paymentIdList: _paymentInvoice.map((paymentInvoice) => paymentInvoice.paymentId).toList());
            },
          ),
        ],
      );
      await showDialog(builder: (context) => _dialog, context: context, barrierDismissible: false);
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _deletePayment(): ' + e.toString());
    }
  }

  Future _getData() async {
    try {
      await _getPurchaseInvoiceWithTax(false);
      _scrollController1.addListener(_lazyLoadingInvoiceWithTax);
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _getPurchaseInvoiceWithTax(bool _isResetAction) async {
    try {
      if (_isResetAction) {
        _startIndex = 0;
        _purchaseInvoiceList = [];
        setState(() {});
      }
      if (_isRecordPending) {
        if (_purchaseInvoiceList.length != null && _purchaseInvoiceList.length > 0) {
          _startIndex = _purchaseInvoiceList.length;
        } else {
          _purchaseInvoiceList = [];
        }
        _purchaseInvoiceList += await dbHelper.purchaseInvoiceGetList(
            startIndex: _startIndex,
            fetchRecords: global.fetchRecords,
            fetchTaxInvoices: (br.getSystemFlagValue(global.systemFlagNameList.showPurchaseInvoicesSeprated) == 'true') ? true : null,
            startDate: (_invoiceSearch != null)
                ? (_invoiceSearch.dateFrom != null)
                    ? _invoiceSearch.dateFrom
                    : null
                : null,
            endDate: (_invoiceSearch != null)
                ? (_invoiceSearch.dateTo != null)
                    ? _invoiceSearch.dateTo
                    : null
                : null,
            amountFrom: (_invoiceSearch != null)
                ? (_invoiceSearch.amountFrom != null)
                    ? _invoiceSearch.amountFrom
                    : null
                : null,
            amountTo: (_invoiceSearch != null)
                ? (_invoiceSearch.amountTo != null)
                    ? _invoiceSearch.amountTo
                    : null
                : null,
            accountId: (_invoiceSearch != null)
                ? (_invoiceSearch.account != null)
                    ? _invoiceSearch.account.id
                    : null
                : null,
            status: (_invoiceSearch != null)
                ? (_invoiceSearch.status != null)
                    ? _invoiceSearch.status
                    : null
                : null,
            isWithTax: _invoiceSearch.isWithTax,
            invoiceIdList: _searchByInvoiceIdList);
        for (int i = _startIndex; i < _purchaseInvoiceList.length; i++) {
          List<PurchaseInvoiceDetail> _purchaseInvoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoiceList[i].id);
          _purchaseInvoiceList[i].totalProducts = _purchaseInvoiceDetailList.length;
          _purchaseInvoiceList[i].returnProducts = await dbHelper.purchaseInvoiceReturnDetailGetCount(purchaseInvoiceId: _purchaseInvoiceList[i].id);
          List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoiceList[i].id, isCancel: false);
          List<Payment> _paymentList = await dbHelper.paymentGetList(paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
          double _receivedAmount = 0;
          double _givenAmount = 0;
          if (_paymentList.length != 0) {
            _paymentList.forEach((item) {
              if (item.paymentType == 'GIVEN') {
                _receivedAmount += item.amount;
              } else {
                _givenAmount += item.amount;
              }
            });
          }
          _purchaseInvoiceList[i].remainAmount = (_paymentList.length != 0) ? (_purchaseInvoiceList[i].netAmount - (_receivedAmount - _givenAmount)) : _purchaseInvoiceList[i].netAmount;
        }
        _startIndex += global.fetchRecords;
        //_getAccount();
        setState(() {
          (_purchaseInvoiceList.length.isFinite) ? _isLoaderHide = true : _isLoaderHide = false;
        });
      }
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _getPurchaseInvoiceWithTax(): ' + e.toString());
    }
  }

  Future<String> _invoicePrintOrShare(PurchaseInvoice _purchaseInvoice, context, bool _isPrintAction) async {
    try {
      global.isAppOperation = true;
      List<Account> _accountList = await dbHelper.accountGetList(accountId: _purchaseInvoice.accountId);
      _purchaseInvoice.account = _accountList[0];
      _purchaseInvoice.invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoice.id);
      _purchaseInvoice.invoiceTaxList = await dbHelper.purchaseInvoiceTaxGetList(invoiceId: _purchaseInvoice.id);
      _purchaseInvoice.invoiceDetailTaxList = await dbHelper.purchaseInvoiceDetailTaxGetList(invoiceDetailIdList: _purchaseInvoice.invoiceDetailList.map((invoiceDetail) => invoiceDetail.id).toList());
      //  String _address = (_account.addressLine1.isNotEmpty && _account.state.isNotEmpty && _account.country.isNotEmpty && _account.pincode != null) ? ' ${_account.addressLine1}, ${_account.city}, ${_account.state}, ${_account.country}, ${_account.pincode}' : ' ${_account.city}';
      List<PurchaseInvoiceReturnDetail> _returnProductList = [];
      List<TaxMaster> _returnProductTaxList = [];
      double _returnProductSubTotal = 0;
      double _returnProductfinalTotal = 0;
      String _returnProductPaymentStatus = '';
      var html;

      if (_purchaseInvoice.returnProducts > 0) {
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
                item.taxAmount = (item.percentage * _purchaseInvoiceReturn.grossAmount) / 100;
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
      }
      //    Navigator.of(context).pop();
      if (_isPrintAction != null) {
        br.generatePurchaseInvoiceHtml(context,
            invoice: _purchaseInvoice,
            isPrintAction: _isPrintAction,
            returnProductList: _returnProductList,
            returnProductPaymentStatus: _returnProductPaymentStatus,
            returnProductSubTotal: _returnProductSubTotal,
            returnProductTaxList: _returnProductTaxList,
            returnProductfinalTotal: _returnProductfinalTotal);
      } else {
        html = br.generatePurchaseInvoiceHtml(context,
            invoice: _purchaseInvoice,
            isPrintAction: _isPrintAction,
            returnProductList: _returnProductList,
            returnProductPaymentStatus: _returnProductPaymentStatus,
            returnProductSubTotal: _returnProductSubTotal,
            returnProductTaxList: _returnProductTaxList,
            returnProductfinalTotal: _returnProductfinalTotal);
      }
      return html;
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _invoicePrintOrShare(): ' + e.toString());
      return null;
    }
  }

  Future _lazyLoadingInvoiceWithTax() async {
    try {
      int _dataLen = _purchaseInvoiceList.length;
      if (_scrollController1.position.pixels == _scrollController1.position.maxScrollExtent) {
        await _getPurchaseInvoiceWithTax(false);
        if (_dataLen == _purchaseInvoiceList.length) {
          setState(() {
            _isLoaderHide = true;
          });
        }
      }
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _lazyLoadingInvoiceWithTax(): ' + e.toString());
    }
  }

  Widget _purchaseInvoiceTab(List<PurchaseInvoice> _purchaseInvoiceList) {
    try {
      return RefreshIndicator(
          key: _refreshKey1,
          onRefresh: () async {
            await _getPurchaseInvoiceWithTax(true);
          },
          child: (_isDataLoaded)
              ? (_purchaseInvoiceList.isNotEmpty)
                  ? Scrollbar(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          controller: _scrollController1,
                          itemCount: _purchaseInvoiceList.length + 1,
                          itemBuilder: (context, index) {
                            if (_purchaseInvoiceList.length == index) {
                              return (!_isLoaderHide)
                                  ? Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : SizedBox();
                            }

                            return Card(
                              semanticContainer: true,
                              child: Column(
                                children: <Widget>[
                                  (_purchaseInvoiceList[index].finalTax > 0)
                                      ? Ribbon(
                                          nearLength: 47,
                                          farLength: 20,
                                          title: global.appLocaleValues['rbn_with_tax'],
                                          titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                          color: Colors.green,
                                          location: RibbonLocation.values[1],
                                          child: ListTilePurchaseInvoiceWidget(
                                            key: ValueKey(_purchaseInvoiceList[index].id),
                                            purchaseInvoice: _purchaseInvoiceList[index],
                                            tabIndex: 0,
                                            a: widget.analytics,
                                            o: widget.observer,
                                            onDeletePressed: (_saleInvoice) async {
                                              await _deleteInvoice(_saleInvoice);
                                            },
                                            invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                              var html = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                              return html;
                                            },
                                            invoiceCancelOrRetrive: (_saleInvoice, _actionOfCancelInvoice, context) async {
                                              await _cancelOrRetriveInvoice(_saleInvoice, context, _actionOfCancelInvoice);
                                            },
                                          ),
                                        )
                                      : ListTilePurchaseInvoiceWidget(
                                          key: ValueKey(_purchaseInvoiceList[index].id),
                                          purchaseInvoice: _purchaseInvoiceList[index],
                                          tabIndex: 0,
                                          a: widget.analytics,
                                          o: widget.observer,
                                          onDeletePressed: (_saleInvoice) async {
                                            await _deleteInvoice(_saleInvoice);
                                          },
                                          invoicePrintOrShare: (_saleInvoice, _isPrintAction, context) async {
                                            var html = await _invoicePrintOrShare(_saleInvoice, context, _isPrintAction);
                                            return html;
                                          },
                                          invoiceCancelOrRetrive: (_saleInvoice, _actionOfCancelInvoice, context) async {
                                            await _cancelOrRetriveInvoice(_saleInvoice, context, _actionOfCancelInvoice);
                                          },
                                        ),
                                ],
                              ),
                            );
                          },
                        ),
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
                            global.appLocaleValues['tle_tax_invoice_empty'],
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        )
                      ],
                    ))
              : Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ));
    } catch (e) {
      print('Exception - _purchaseInvoiceTab.dart - withTaxTab(): ' + e.toString());
      return null;
    }
  }

  Future _searchInvoices() async {
    try {
      Navigator.of(context)
          .push(PurchaseInvoiceFilter(
        _invoiceSearch,
      ))
          .then((value) async {
        if (value != null) {
          _invoiceSearch = value;
          if (_invoiceSearch.isSearch) {
            _purchaseInvoiceList.clear();
            //  if (_invoiceSearch.isSearch) {
            if (_invoiceSearch.product != null && _invoiceSearch.product.id != null) {
              List<PurchaseInvoiceDetail> _purchaseInvoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(productId: _invoiceSearch.product.id);
              _searchByInvoiceIdList = (_purchaseInvoiceDetailList.length > 0) ? _purchaseInvoiceDetailList.map((invoiceDetail) => invoiceDetail.invoiceId).toList() : [];
            } else {
              _searchByInvoiceIdList = null;
            }
            _isDataLoaded = false;
            setState(() {});
            await _getPurchaseInvoiceWithTax(true);
            _isDataLoaded = true;
            setState(() {});
            //    }
          }
        }
      });
      // Navigator.of(context)
      //     .push(PurchaseInvoiceFilter(
      //   _invoiceSearch,
      // ))
      //     .then((value) async {
      //   _invoiceSearch = value;

      //   if (_invoiceSearch != null) {
      //     if (_invoiceSearch.isSearch = true) {
      //       _purchaseInvoiceList.clear();
      //       _purchaseInvoiceWithoutTaxList.clear();
      //       if (_invoiceSearch.isSearch) {
      //         if (_invoiceSearch.product != null && _invoiceSearch.product.id != null) {
      //         } else {
      //           _searchByInvoiceIdList = null;
      //         }
      //         (_tabController.index == 0) ? await _getPurchaseInvoiceWithTax(true) : await _getPurchaseInvoiceWithoutTax(true);
      //       }
      //     }
      //   }
      // });
    } catch (e) {
      print('Exception - purchaseInvoiceScreen.dart - _searchInvoices(): ' + e.toString());
    }
  }
}

class PurchaseInvoiceFilter extends ModalRoute<PurchaseInvoiceSearch> {
  PurchaseInvoiceSearch saleInvoiceSearch;
  PurchaseInvoiceFilter(this.saleInvoiceSearch);

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
        saleInvoiceSearch: saleInvoiceSearch,
        searchValue: (obj) {
          saleInvoiceSearch = obj;
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
  final PurchaseInvoiceSearch saleInvoiceSearch;
  final ValueChanged<PurchaseInvoiceSearch> searchValue;
  PurchaseInvoiceFilterForm({this.saleInvoiceSearch, this.searchValue});
  @override
  _SaleInvoiceState createState() => _SaleInvoiceState(saleInvoiceSearch, searchValue);
}

class _SaleInvoiceState extends State<PurchaseInvoiceFilterForm> {
  PurchaseInvoiceSearch saleInvoiceSearch;
  final ValueChanged<PurchaseInvoiceSearch> searchValue;
  _SaleInvoiceState(this.saleInvoiceSearch, this.searchValue);
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

  PurchaseInvoiceSearch eSearch = PurchaseInvoiceSearch();

  void resetFilter() {
    resetConfermation();
  }

  void assignValue() {
    _fFromDateFocusNode.addListener(_selectdateListener);
    _fToDateFocusNode.addListener(_selectdateListener);

    if (saleInvoiceSearch != null) {
      _cChooseAccount.text = (saleInvoiceSearch.account != null)
          ? (saleInvoiceSearch.account.firstName != null)
              ? '${saleInvoiceSearch.account.firstName} ${saleInvoiceSearch.account.lastName}'
              //    ? '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + invoiceSearch.account.accountCode.toString().length))}${invoiceSearch.account.accountCode} - ${invoiceSearch.account.firstName} ${invoiceSearch.account.lastName}'
              : ''
          : '';
      _cChooseProduct.text = (saleInvoiceSearch.product != null)
          ? (saleInvoiceSearch.product.productCode != null)
              ? '${saleInvoiceSearch.product.name}'
              : ''
          : '';
      _cDateRangeFrom.text = (saleInvoiceSearch.dateFrom != null) ? '${DateFormat('dd-MM-yyyy').format(saleInvoiceSearch.dateFrom)}' : '';
      _dateRangeFrom2 = (saleInvoiceSearch.dateFrom != null) ? '${saleInvoiceSearch.dateFrom}' : '';
      _cDateRangeTo.text = (saleInvoiceSearch.dateTo != null) ? '${DateFormat('dd-MM-yyyy').format(saleInvoiceSearch.dateTo)}' : '';
      _dateRangeTo2 = (saleInvoiceSearch.dateTo != null) ? '${saleInvoiceSearch.dateTo}' : '';
      _cAmountRangeTo.text = (saleInvoiceSearch.amountTo != null) ? '${saleInvoiceSearch.amountTo}' : '';
      _cAmountRangeFrom.text = (saleInvoiceSearch.amountFrom != null) ? '${saleInvoiceSearch.amountFrom}' : '';
      _account = saleInvoiceSearch.account;
      _product = saleInvoiceSearch.product;
      saleInvoiceSearch.isSearch = false;
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
                returnScreenId: 3,
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
      print('Exception - saleInvoiceSearchDialog.dart - _selectDate(): ' + e.toString());
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
      print('Exception - saleInvoiceSearchDialog.dart - _selectdateListener(): ' + e.toString());
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
      print('Exception - saleInvoiceSearchDialog.dart - _selectProduct(): ' + e.toString());
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
                      FittedBox(
                        child: Text(
                          global.appLocaleValues['tle_search_purchase_invoices'],
                          overflow: TextOverflow.fade,
                          style: Theme.of(context).appBarTheme.titleTextStyle,
                        ),
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
                children: <Widget>[
                  Text(
                    global.appLocaleValues['lbl_choose_ac'],
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
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
                    (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                        ? global.appLocaleValues['tle_choose_product']
                        : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                            ? global.appLocaleValues['tle_choose_service']
                            : global.appLocaleValues['tle_choose_both'],
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
                      decoration: InputDecoration(
                          hintText: (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product')
                              ? global.appLocaleValues['tle_choose_product']
                              : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service')
                                  ? global.appLocaleValues['tle_choose_service']
                                  : global.appLocaleValues['tle_choose_both'],
                          border: nativeTheme().inputDecorationTheme.border,
                          prefixIcon: Icon(Icons.local_mall)),
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
                    )
                    // MaterialButton(
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
                    //         color: Theme.of(context).primaryColorDark,
                    //         size: 18.0,
                    //       ),
                    //       SizedBox(
                    //         width: 3.0,
                    //       ),
                    //       Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline3,)
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
                    )
                    // MaterialButton(
                    //   minWidth: 100.0,
                    //   color: Theme.of(context).primaryColor,
                    //   height: 45.0,
                    //   onPressed: () {
                    //     eSearch.isSearch = true;
                    //     eSearch.account = _account;
                    //     eSearch.product = _product;
                    //     eSearch.isSearch = true;
                    //     eSearch.amountFrom = (_cAmountRangeFrom.text != '') ? double.parse(_cAmountRangeFrom.text) : null;
                    //     eSearch.amountTo = (_cAmountRangeTo.text != '') ? double.parse(_cAmountRangeTo.text) : null;
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
                    //           style: Theme.of(context).primaryTextTheme.headline2,
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
              child: Text('${global.appLocaleValues['btn_cancel']}', style: Theme.of(context).primaryTextTheme.headline3),
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
