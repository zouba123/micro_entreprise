// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals

import 'dart:core';
import 'dart:io';

import 'package:accounting_app/models/EmployeeSalaryStructuresModel.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/paymentModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceModel.dart';
import 'package:accounting_app/models/paymentPurchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceModel.dart';
import 'package:accounting_app/models/paymentSaleInvoiceReturnModel.dart';
import 'package:accounting_app/models/purchaseInvoiceDetailModel.dart';
import 'package:accounting_app/models/purchaseInvoiceModel.dart';
import 'package:accounting_app/models/purchaseInvoiceReturnModel.dart';
import 'package:accounting_app/models/saleInvoiceDetailModel.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/saleInvoiceReturnModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/paymentDetailScreen.dart';
import 'package:accounting_app/screens/paymentScreen.dart';
import 'package:accounting_app/screens/salarySetUpAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeDetailScreen extends BaseRoute {
  final Account account;
  final int screenId;
  EmployeeDetailScreen({@required a, @required o, @required this.account, this.screenId}) : super(a: a, o: o, r: 'AccountDetailScreen');
  @override
  _EmployeeDetailScreenState createState() => _EmployeeDetailScreenState(this.account, this.screenId);
}

class _EmployeeDetailScreenState extends BaseRouteState {
  List<SaleInvoice> _saleInvoiceList = [];
  List<PurchaseInvoice> _purchaseInvoiceList = [];
  List<Payment> _paymentList = [];
  List<SaleInvoiceReturn> _sTransactionGroupIdList = [];
  List<PurchaseInvoiceReturn> _pTransactionGroupIdList = [];
  List<EmployeeSalaryStructures> _empSalaryStrucList = [];
  bool _isPaymentPrintAction = false;
  Account account;
  int screenId;
  bool _isDataLoaded = false;
  TextEditingController _cMsg =  TextEditingController();
  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();

  var _tabController;

  _EmployeeDetailScreenState(this.account, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    return DefaultTabController(
        length: 2,
        child: WillPopScope(
          onWillPop: () {
            if (screenId != null) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>  DashboardScreen(
                        o: widget.observer,
                        a: widget.analytics,
                      )));
            } else {
              Navigator.of(context).pop();
            }
            return null;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('${br.generateAccountName(account)}'),
              bottom: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    text: global.appLocaleValues['lbl_emp_salary'],
                  ),
                  Tab(
                    text: global.appLocaleValues['tab_profile'],
                  ),
                ],
              ),
              actions: <Widget>[],
            ),
            body: TabBarView(controller: _tabController, children: <Widget>[
              SingleChildScrollView(
                //  physics: ScrollPhysics(),
                child: Column(children: <Widget>[
                  Card(
                    shape: nativeTheme().cardTheme.shape,
                    child: SizedBox(
                      height: 556,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                              title: Text(
                                global.appLocaleValues['lbl_emp_salary'],
                                style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                              ),
                              trailing: IconButton(
                                  icon: Icon(Icons.add),
                                  color: Theme.of(context).primaryColor,
                                  iconSize: 25,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (BuildContext context) =>  SalarySetUpAddScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                              account: account,
                                            )));
                                  })),
                          (_isDataLoaded)
                              ? (_empSalaryStrucList.isNotEmpty)
                                  ? Container(
                                      height: 500,
                                      child: SingleChildScrollView(
                                        child: ListView.builder(
                                          //physics: NeverScrollableScrollPhysics(),
                                          itemCount: _empSalaryStrucList.length,
                                          shrinkWrap: true,
                                          controller: _scrollController,
                                          scrollDirection: Axis.vertical,
                                          // physics: NeverScrollableScrollPhysics(),

                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                                leading: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColorLight,
                                                  foregroundColor: Colors.black,
                                                  radius: 25,
                                                  child: Text(
                                                    '${global.currency.symbol} ${_empSalaryStrucList[index].salary.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                title: Text(
                                                  '${_empSalaryStrucList[index].salaryType}',
                                                  // '${br.generateAccountName(_paymentList[index].account)}',
                                                  style: TextStyle(fontSize: 14),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                subtitle: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_empSalaryStrucList[index].startDate)}')],
                                                    ),
                                                    // Row(
                                                    //   children: <Widget>[
                                                    //     (_paymentList[index].invoiceNumber != null)
                                                    //         ? Text((_paymentList[index].isSaleInvoiceRef)
                                                    //             ? 'ref: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _paymentList[index].invoiceNumber.toString().length))}${_paymentList[index].invoiceNumber}'
                                                    //             : 'ref: ${_paymentList[index].invoiceNumber}')
                                                    //         : (_paymentList[index].isSaleInvoiceReturnRef) ? Text('ref: ${global.appLocaleValues['ref_sales_return']}') : (_paymentList[index].isPurchaseInvoiceReturnRef) ? Text('ref: ${global.appLocaleValues['ref_purchase_return']}') : SizedBox()
                                                    //   ],
                                                    // ),
                                                  ],
                                                ),
                                                isThreeLine: true,
                                                onTap: () {
                                                  // Navigator.of(context).push(MaterialPageRoute(
                                                  //     builder: (context) =>  PaymentDetailScreen(
                                                  //           a: widget.analytics,
                                                  //           o: widget.observer,
                                                  //           payment: _paymentList[index],
                                                  //         )));
                                                },
                                                trailing: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
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
                                                                    builder: (context) => SalarySetUpAddScreen(
                                                                          a: widget.analytics,
                                                                          o: widget.observer,
                                                                          account: account,
                                                                          employeeSalaryStructures: _empSalaryStrucList[index],
                                                                        )));
                                                              }),
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
                                                              onTap: () async {
                                                                Navigator.of(context).pop();
                                                                await _deleteEmpSt(_empSalaryStrucList[index]);
                                                              }),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          },
                                        ),
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(top: 50),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.1,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 20, bottom: 10),
                                            child: Icon(
                                              Icons.credit_card,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              global.appLocaleValues['tle_recent_salary_setup_empty_msg'],
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: nativeTheme().cardTheme.shape,
                    child: SizedBox(
                      height: 570,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              global.appLocaleValues['tle_recent_payments'],
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                            ),
                            trailing: TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) =>  PaymentScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                            account: account,
                                          )));
                                },
                                label: Icon(
                                  Icons.navigate_next,
                                  color: Colors.white,
                                ),
                                icon: Text(global.appLocaleValues['btn_view_all'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          ),
                          (_isDataLoaded)
                              ? (_paymentList.isNotEmpty)
                                  ? Column(
                                      children: <Widget>[
                                        ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                          itemCount: _paymentList.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                                contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
                                                leading: CircleAvatar(
                                                  backgroundColor: Theme.of(context).primaryColorLight,
                                                  foregroundColor: Colors.black,
                                                  radius: 25,
                                                  child: Text(
                                                    '${global.currency.symbol} ${_paymentList[index].amount.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                title: Text(
                                                  '${br.generateAccountName(_paymentList[index].account)}',
                                                  style: TextStyle(fontSize: 14),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                subtitle: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_paymentList[index].transactionDate)}')],
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        (_paymentList[index].invoiceNumber != null)
                                                            ? Text((_paymentList[index].isSaleInvoiceRef)
                                                                ? 'ref: ${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _paymentList[index].invoiceNumber.toString().length))}${_paymentList[index].invoiceNumber}'
                                                                : 'ref: ${_paymentList[index].invoiceNumber}')
                                                            : (_paymentList[index].isSaleInvoiceReturnRef) ? Text('ref: ${global.appLocaleValues['ref_sales_return']}') : (_paymentList[index].isPurchaseInvoiceReturnRef) ? Text('ref: ${global.appLocaleValues['ref_purchase_return']}') : SizedBox()
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                isThreeLine: true,
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
                                                          (_paymentList[index].paymentType == 'RECEIVED') ? Text('${_paymentList[index].paymentType}', textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)) : Text('${_paymentList[index].paymentType}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                                          SizedBox(
                                                            height: 3,
                                                          ),
                                                          (_paymentList[index].isCancel == true)
                                                              ? Text('${global.appLocaleValues['status_cancelled']}', textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                                              : SizedBox(
                                                                  width: 0,
                                                                )
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
                                                                    Icons.remove_red_eye,
                                                                    color: Theme.of(context).primaryColor,
                                                                  ),
                                                                ),
                                                                Text(global.appLocaleValues['lt_view']),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                  builder: (context) =>  PaymentDetailScreen(
                                                                        a: widget.analytics,
                                                                        o: widget.observer,
                                                                         payment: _paymentList[index],
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
                                                                    Icons.print,
                                                                    color: Theme.of(context).primaryColor,
                                                                  ),
                                                                ),
                                                                Text(global.appLocaleValues['lt_print']),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                              _isPaymentPrintAction = true;
                                                              br.generatePaymentReceiptHtml(context, payment: _paymentList[index], isPrintAction: _isPaymentPrintAction);
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
                                                            onTap: () {
                                                              Navigator.of(context).pop();
                                                              _isPaymentPrintAction = false;
                                                              br.generatePaymentReceiptHtml(context, payment: _paymentList[index], isPrintAction: _isPaymentPrintAction);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          },
                                        ),
                                      ],
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(top: 50),
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.1,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 20, bottom: 10),
                                            child: Icon(
                                              Icons.credit_card,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          ),
                                          FittedBox(
                                            child: Text(
                                              global.appLocaleValues['tle_recent_payments_empty_msg'],
                                              style: TextStyle(color: Colors.grey),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    )
                              : Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ]),
                padding: const EdgeInsets.only(bottom: 50),
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child:  Column(
                    children: <Widget>[
                       SizedBox(
                        height: _height / 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8, right: 8),
                            child:  Center(
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(borderRadius:  BorderRadius.circular(10.0), border:  Border.all(color: Colors.grey[200]), image: account.imagePath != null ? DecorationImage(image: FileImage(File(account.imagePath))) : null),
                                    child: account.imagePath == ''
                                        ? Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:  BorderRadius.circular(10.0),
                                              border:  Border.all(color: Colors.grey[200]),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${account.firstName[0]} ${account.lastName[0]}",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: Colors.grey, fontSize: 25),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child:  ListTile(
                              contentPadding: EdgeInsets.all(0),
                              subtitle: Text(
                                "${account.businessName}",
                                style: TextStyle(fontSize: 16),
                              ),
                              title:  Text(
                                "${br.generateAccountName(account)}",
                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //
                      Card(
                        shape: Theme.of(context).cardTheme.shape,
                        child: Column(
                          children: [
                            (account.gstNo != '')
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['lbl_gst_no_']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      '${account.gstNo}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            (account.email != '')
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['txt_email']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      account.email,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onTap: () async {
                                      global.isAppOperation = true;
                                      final MailOptions mailOptions = MailOptions(
                                        body: '',
                                        subject: '',
                                        recipients: ['${account.email}'],
                                        isHTML: true,
                                        bccRecipients: [],
                                        ccRecipients: [],
                                      );

                                      await FlutterMailer.send(mailOptions);
                                    },
                                    trailing: IconButton(
                                      icon: Icon(Icons.content_copy),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: '${account.email}'));
                                        showToast(global.appLocaleValues['txt_copied']);
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            (account.mobile != '')
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['txt_mobile_no']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      '+${account.mobileCountryCode} ${account.mobile}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onTap: () async {
                                      global.isAppOperation = true;
                                      launch('tel:+${account.mobileCountryCode}${account.mobile}');
                                    },
                                    trailing: IconButton(
                                      icon: Icon(Icons.content_copy),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: '+${account.mobileCountryCode} ${account.mobile}'));
                                        showToast(global.appLocaleValues['txt_copied']);
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            (account.phone != '')
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['txt_phone_no']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      '+${account.phoneCountryCode} ${account.phone}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    onTap: () async {
                                      global.isAppOperation = true;
                                      launch('tel:+${account.phoneCountryCode}${account.phone}');
                                    },
                                    trailing: IconButton(
                                      icon: Icon(Icons.content_copy),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: '+${account.mobileCountryCode} ${account.mobile}'));
                                        showToast(global.appLocaleValues['txt_copied']);
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            (br.generateAccountAddress(account) != '')
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['txt_address']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      '${br.generateAccountAddress(account)}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.content_copy),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: '${br.generateAccountAddress(account)}'));
                                        showToast(global.appLocaleValues['txt_copied']);
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            ListTile(
                              title: Text(
                                "${global.appLocaleValues['lbl_emp_type']}",
                                style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                              ),
                              subtitle:  Text(
                                (account.accountType == ',Employee,Worker,') ? 'Employee and Worker' : '${(account.accountType)}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            (account.gender != null)
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['lbl_gender']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      '${account.gender}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            (account.birthdate != null)
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['txt_birthday']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(account.birthdate)}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                            (account.anniversary != null)
                                ? ListTile(
                                    title: Text(
                                      "${global.appLocaleValues['lbl_anniversary']}",
                                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                    ),
                                    subtitle:  Text(
                                      '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(account.anniversary)}',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 60),
              )
            ]),
            bottomSheet: Container(
               color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          String _contact = '';
                          if (account.phone != '') {
                            _contact = await br.selectMobileNumber(['+${account.mobileCountryCode} ${account.mobile}', '+${account.phoneCountryCode} ${account.phone}'], context);
                          } else {
                            _contact = '+${account.mobileCountryCode} ${account.mobile}';
                          }
                          AlertDialog dialog =  AlertDialog(
                            shape: nativeTheme().dialogTheme.shape,
                            title: Text(
                              global.appLocaleValues['tle_whtsapp_msg'],
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                            ),
                            content: Form(
                              key: _formKey,
                              child: TextFormField(
                                autofocus: true,
                                controller: _cMsg,
                                decoration: InputDecoration(icon: Icon(FontAwesomeIcons.whatsapp), hintText: global.appLocaleValues['lbl_whtsapp_msg']),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return global.appLocaleValues['lbl_whtsapp_msg'];
                                  }
                                  return null;
                                },
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  _cMsg.text = '';
                                  Navigator.of(context).pop();
                                },
                                child: Text(global.appLocaleValues['btn_cancel']),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    Navigator.of(context).pop();
                                    global.isAppOperation = true;
                                    var whatsappUrl = "whatsapp://send?phone=$_contact&text=${_cMsg.text.trim()}";
                                    await canLaunch(whatsappUrl) ? launch(whatsappUrl) : showToast(global.appLocaleValues['err_whtsapp']);
                                  }
                                  _cMsg.text = '';
                                },
                                child: Text(global.appLocaleValues['btn_send']),
                              ),
                            ],
                          );
                          showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.message,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          String _contact = '';
                          if (account.phone != '') {
                            _contact = await br.selectMobileNumber(['+${account.mobileCountryCode} ${account.mobile}', '+${account.phoneCountryCode} ${account.phone}'], context);
                          } else {
                            _contact = '+${account.mobileCountryCode} ${account.mobile}';
                          }
                          _cMsg.text = '';
                          AlertDialog dialog =  AlertDialog(
                            shape: nativeTheme().dialogTheme.shape,
                            title: Text(
                              global.appLocaleValues['tle_text_msg'],
                              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                            ),
                            content: Form(
                              key: _formKey,
                              child: TextFormField(
                                autofocus: true,
                                controller: _cMsg,
                                decoration: InputDecoration(icon: Icon(Icons.message), hintText: global.appLocaleValues['lbl_text_msg']),
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return global.appLocaleValues['lbl_text_msg'];
                                  }
                                  return null;
                                },
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  _cMsg.text = '';

                                  Navigator.of(context).pop();
                                },
                                child: Text(global.appLocaleValues['btn_cancel'], style: TextStyle(color: Theme.of(context).primaryColor)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  global.isAppOperation = true;
                                  await launch('sms: $_contact?body=${_cMsg.text}');
                                },
                                child: Text(global.appLocaleValues['btn_send'], style: TextStyle(color: Theme.of(context).primaryColor)),
                              ),
                            ],
                          );
                          showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                          icon: Icon(
                            Icons.call,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () async {
                            String _contact = '';
                            if (account.phone != '') {
                              _contact = await br.selectMobileNumber(['+${account.mobileCountryCode} ${account.mobile}', '+${account.phoneCountryCode} ${account.phone}'], context);
                            } else {
                              _contact = '+${account.mobileCountryCode} ${account.mobile}';
                            }
                            global.isAppOperation = true;
                            launch('tel:$_contact');
                          }),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.email,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () async {
                          global.isAppOperation = true;
                          final MailOptions mailOptions = MailOptions(
                            body: '',
                            subject: '',
                            recipients: ['${account.email}'],
                            isHTML: true,
                            bccRecipients: [],
                            ccRecipients: [],
                          );

                          await FlutterMailer.send(mailOptions);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget rowCell(String lable, String type) =>  Expanded(
          child:  Column(
        children: <Widget>[
           Text(
            lable,
            style:  TextStyle(color: Colors.black, fontSize: 16),
          ),
           Text(type, style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20))
        ],
      ));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _getData();
  }

  Future _getSalaryData() async {
    _empSalaryStrucList = await dbHelper.employeeSalaryStructuresGetList(accountId: [account.id]);
    for (int i = 0; i < _empSalaryStrucList.length; i++) {
      if (_empSalaryStrucList[i].accountId != null) {
        List<Account> _accountList = await dbHelper.accountGetList(accountId: _empSalaryStrucList[i].accountId);
        _empSalaryStrucList[i].account = (_accountList.length > 0) ? _accountList[0] : null;
      }
    }
  }

  Future _deleteEmpSt(EmployeeSalaryStructures employeeSalaryStructures) async {
    AlertDialog _dialog =  AlertDialog(
      shape: nativeTheme().dialogTheme.shape,
      title: Text(
        global.appLocaleValues['tle_delete_salary'],
        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
      ),
      content: (global.appLanguage['name'] == 'English')
          ? Text('${global.appLocaleValues['txt_delete']} "${employeeSalaryStructures.salaryType} - ${global.currency.symbol} ${employeeSalaryStructures.salary.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}"?')
          : Text('"${employeeSalaryStructures.salaryType} - ${global.currency.symbol} ${employeeSalaryStructures.salary.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}" ${global.appLocaleValues['txt_delete']}?'),
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
            Navigator.of(context, rootNavigator: true).pop();
            int _result = await dbHelper.employeeSalaryStructuresDelete(empStId: employeeSalaryStructures.id);
            if (_result == 1) {
              _getData();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green,
                content: Text('${global.appLocaleValues['txt_salary_setup_dlt_success']}'),
              ));
            }
          },
        ),
      ],
    );
    showDialog(builder: (context) => _dialog, context: context);
  }

  Future _getData() async {
    try {
      _getSalaryData();
      _paymentList = await dbHelper.paymentGetList(startIndex: 0, fetchRecords: 5, accountId: account.id, orderBy: 'DESC');
      _paymentList.map((e) => e.account = account).toList();
      if (account.accountType == 'Employee') {
        await _getCustomerInvoiceData();
        await _getCustomerPaymentData();
        _isDataLoaded = true;
        setState(() {});
      } else if (account.accountType == 'Worker') {
        await _getSupplierInvoiceData();
        await _getSupplierPaymentData();
        _isDataLoaded = true;
        setState(() {});
      } else if (account.accountType == ',Employee,Worker,') {
        await _getCustomerInvoiceData();
        await _getSupplierInvoiceData();
        await _getCustomerPaymentData();
        await _getSupplierPaymentData();
        _isDataLoaded = true;
        setState(() {});
      }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getData(): ' + e.toString());
    }
  }

  Future _getCustomerPaymentData() async {
    try {
      for (int i = 0; i < _paymentList.length; i++) {
        List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(paymentId: _paymentList[i].id);
        PaymentSaleInvoice _paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;
        if (_paymentInvoice != null) {
          _paymentList[i].isSaleInvoiceRef = true;
          _paymentList[i].invoiceNumber = _paymentInvoice.invoiceNumber;
        } else {
          List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(paymentId: _paymentList[i].id);
          PaymentSaleInvoiceReturn _paymentSaleInvoiceReturn = (_paymentSaleInvoiceReturnList.length > 0) ? _paymentSaleInvoiceReturnList[0] : null;
          if (_paymentSaleInvoiceReturn != null) {
            _paymentList[i].isSaleInvoiceReturnRef = true;
          }
        }
      }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getCustomerPaymentData(): ' + e.toString());
    }
  }

  Future _getSupplierPaymentData() async {
    try {
      for (int i = 0; i < _paymentList.length; i++) {
        List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(paymentId: _paymentList[i].id);
        PaymentPurchaseInvoice _paymentInvoice = (_paymentInvoiceList.length != 0) ? _paymentInvoiceList[0] : null;
        if (_paymentInvoice != null) {
          _paymentList[i].isPurchaseInvoiceRef = true;
          _paymentList[i].invoiceNumber = _paymentInvoice.invoiceNumber;
        } else {
          List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(paymentId: _paymentList[i].id);
          PaymentPurchaseInvoiceReturn _paymentPurchaseInvoiceReturn = (_paymentPurchaseInvoiceReturnList.length > 0) ? _paymentPurchaseInvoiceReturnList[0] : null;
          if (_paymentPurchaseInvoiceReturn != null) {
            _paymentList[i].isPurchaseInvoiceReturnRef = true;
          }
        }
      }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getCustomerPaymentData(): ' + e.toString());
    }
  }

  Future _getCustomerInvoiceData() async {
    try {
      _saleInvoiceList = await dbHelper.saleInvoiceGetList(accountId: account.id, orderBy: 'DESC', startIndex: 0, fetchRecords: 5);
      for (int i = 0; i < _saleInvoiceList.length; i++) {
        List<SaleInvoiceDetail> _invoiceDetailList = await dbHelper.saleInvoiceDetailGetList(invoiceIdList: [_saleInvoiceList[i].id]);
        _saleInvoiceList[i].totalProducts = _invoiceDetailList.length;
        _saleInvoiceList[i].returnProducts = await dbHelper.saleInvoiceReturnDetailGetCount(invoiceId: _saleInvoiceList[i].id);
        List<PaymentSaleInvoice> _paymentInvoiceList = await dbHelper.paymentSaleInvoiceGetList(invoiceId: _saleInvoiceList[i].id);
        double _paidAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'RECEIVED', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        double _givenAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'GIVEN', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        if (_paidAmount != null && _givenAmount != null) {
          _saleInvoiceList[i].remainAmount = _saleInvoiceList[i].grossAmount - (_paidAmount - _givenAmount);
        } else if (_paidAmount != null && _givenAmount == null) {
          _saleInvoiceList[i].remainAmount = _saleInvoiceList[i].grossAmount - _paidAmount;
        } else if (_paidAmount == null && _givenAmount == null) {
          _saleInvoiceList[i].remainAmount = _saleInvoiceList[i].grossAmount;
        }
      }

      // get sales return data
      _sTransactionGroupIdList += await dbHelper.saleInvoiceReturnTransactionGroupGetList(accountId: account.id, startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
      for (int i = 0; i < _sTransactionGroupIdList.length; i++) {
        _sTransactionGroupIdList[i].childList = await dbHelper.saleInvoiceReturnGetList(transactionGroupIdList: [_sTransactionGroupIdList[i].transactionGroupId]);
        List<PaymentSaleInvoiceReturn> _paymentSaleInvoiceReturnList = await dbHelper.paymentSaleInvoiceReturnGetList(transactionGroupId: _sTransactionGroupIdList[i].transactionGroupId);
        List<Payment> _paymentList = (_paymentSaleInvoiceReturnList.length > 0) ? await dbHelper.paymentGetList(paymentIdList: _paymentSaleInvoiceReturnList.map((f) => f.paymentId).toList()) : [];
        double _receivedAmount = 0;
        double _givenAmount = 0;
        if (_paymentList.length > 0) {
          _paymentList.forEach((item) {
            if (item.paymentType == 'GIVEN') {
              _receivedAmount += item.amount;
            } else {
              _givenAmount += item.amount;
            }
          });
        }

        _sTransactionGroupIdList[i].remainAmount = (_paymentList.length != 0) ? (_sTransactionGroupIdList[i].totalSpent - (_receivedAmount - _givenAmount)) : _sTransactionGroupIdList[i].totalSpent;
      }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getCustomerInvoiceData(): ' + e.toString());
    }
  }

  Future _getSupplierInvoiceData() async {
    try {
      _purchaseInvoiceList = await dbHelper.purchaseInvoiceGetList(accountId: account.id, orderBy: 'DESC', startIndex: 0, fetchRecords: 5);

      for (int i = 0; i < _purchaseInvoiceList.length; i++) {
        List<PurchaseInvoiceDetail> _invoiceDetailList = await dbHelper.purchaseInvoiceDetailGetList(invoiceId: _purchaseInvoiceList[i].id);
        _purchaseInvoiceList[i].totalProducts = _invoiceDetailList.length;
        _purchaseInvoiceList[i].returnProducts = await dbHelper.purchaseInvoiceReturnDetailGetCount(purchaseInvoiceId: _purchaseInvoiceList[i].id);
        List<PaymentPurchaseInvoice> _paymentInvoiceList = await dbHelper.paymentPurchaseInvoiceGetList(invoiceId: _purchaseInvoiceList[i].id);
        double _paidAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'GIVEN', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        double _givenAmount = await dbHelper.paymentGetSumOfAmount(paymentType: 'RECEIVED', paymentIdList: _paymentInvoiceList.map((paymentInvoice) => paymentInvoice.paymentId).toList());
        if (_paidAmount != null && _givenAmount != null) {
          _purchaseInvoiceList[i].remainAmount = _purchaseInvoiceList[i].grossAmount - (_paidAmount - _givenAmount);
        } else if (_paidAmount != null && _givenAmount == null) {
          _purchaseInvoiceList[i].remainAmount = _purchaseInvoiceList[i].grossAmount - _paidAmount;
        } else if (_paidAmount == null && _givenAmount == null) {
          _purchaseInvoiceList[i].remainAmount = _purchaseInvoiceList[i].grossAmount;
        }
      }

      // get purchase return data
      _pTransactionGroupIdList += await dbHelper.purchaseInvoiceReturnTransactionGroupGetList(accountId: account.id, startIndex: 0, fetchRecords: 5, orderBy: 'DESC');
      for (int i = 0; i < _pTransactionGroupIdList.length; i++) {
        _pTransactionGroupIdList[i].childList = await dbHelper.purchaseInvoiceReturnGetList(transactionGroupIdList: [_pTransactionGroupIdList[i].transactionGroupId]);
        List<PaymentPurchaseInvoiceReturn> _paymentPurchaseInvoiceReturnList = await dbHelper.paymentPurchaseInvoiceReturnGetList(transactionGroupId: _pTransactionGroupIdList[i].transactionGroupId);
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

        _pTransactionGroupIdList[i].remainAmount = (_paymentList.length != 0) ? (_pTransactionGroupIdList[i].totalSpent - (_receivedAmount - _givenAmount)) : _pTransactionGroupIdList[i].totalSpent;
      }
    } catch (e) {
      print('Exception - accountDetailsScreen.dart - _getSupplierInvoiceData(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
