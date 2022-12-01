// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/models/salesQuotesModel.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ribbon/ribbon.dart';

class SaleQuoteSelectDialog extends BaseRoute {
  final Account account;
  SaleQuoteSelectDialog({@required a, @required o, this.account}) : super(a: a, o: o, r: 'SaleOrderSelectDialog');
  @override
  _SaleQuoteSelectDialogState createState() => _SaleQuoteSelectDialogState(this.account);
}

class _SaleQuoteSelectDialogState extends BaseRouteState {
  Account account;
  List<SaleQuote> saleQuoteList = [];
  // List<SaleOrder> _selectedOrderList = [];
  TextEditingController _cAccount = TextEditingController();
  bool _isDataLoaded = false;
  _SaleQuoteSelectDialogState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['tle_select_orders'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: (_isDataLoaded)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 0, top: 10),
                  child: Text(
                    global.appLocaleValues['tab_ac'],
                    style: Theme.of(context).primaryTextTheme.headline3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: _cAccount,
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: global.appLocaleValues['tab_ac'],
                        border: nativeTheme().inputDecorationTheme.border,
                        suffixIcon: Icon(
                          Icons.star,
                          size: 9,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () async {
                        await _accountListener();
                      }),
                ),
                (saleQuoteList.length > 0)
                    ? Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                              itemCount: saleQuoteList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    Card(
                                        child: (saleQuoteList[index].finalTax > 0)
                                            ? Ribbon(
                                                nearLength: 47,
                                                farLength: 20,
                                                title: global.appLocaleValues['rbn_with_tax'],
                                                titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                                color: Colors.green,
                                                location: RibbonLocation.values[1],
                                                child: _listTileWidget(saleQuoteList[index]))
                                            : _listTileWidget(saleQuoteList[index])),
                                  ],
                                );
                              }),
                        ),
                      )
                    : Center(child: Text(global.appLocaleValues['txt_no_order_found'], style: TextStyle(color: Colors.grey, fontSize: 18))),
              ],
            )
          : Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
      //bottomSheet: (_isDataLoaded)
      //     ? Padding(
      //         padding: EdgeInsets.all(5),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           children: <Widget>[
      //             TextButton(
      //               color: Colors.blue,
      //               textColor: Colors.white,
      //               height: 50,
      //               minWidth: MediaQuery.of(context).size.width,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                   FittedBox(
      //                     child: Text(
      //                       '${global.appLocaleValues['btn_import']}',
      //                       style: TextStyle(fontWeight: FontWeight.bold),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               onPressed: () async {
      //                 await import();
      //               },
      //             ),
      //           ],
      //         ),
      //       )
      //     : SizedBox(),
    );
  }

  Future import(SaleQuote _saleQuote) async {
    try {
      SaleInvoice _saleInvoice = await br.generateSalesQuotesInvoice(_saleQuote, dbHelper);
      Navigator.of(context).pop(_saleInvoice);
    } catch (e) {
      print('Exception - saleQuoteSelectDialog.dart - import() ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      if (account != null) {
        _cAccount.text = '${account.firstName} ${account.lastName}';
        await _getSaleQuotes();
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleQuoteSelectDialog.dart - _getData() ' + e.toString());
    }
  }

  Future _accountListener() async {
    try {
      await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccountSelectDialog(
                a: widget.analytics,
                o: widget.observer,
                returnScreenId: 1,
                selectedAccount: (selectedAccount) {
                  account = selectedAccount;
                  _cAccount.text = '${account.firstName} ${account.lastName}';
                },
              )));
      _isDataLoaded = false;
      setState(() {});
      await _getSaleQuotes();
      setState(() {
        _isDataLoaded = true;
      });
    } catch (e) {
      print('Exception - saleQuoteSelectDialog.dart - _accountListener(): ' + e.toString());
    }
  }

  Future _getSaleQuotes() async {
    try {
      saleQuoteList = await dbHelper.saleQuoteGetList(orderBy: "DESC", accountId: account.id, status: 'OPEN');
      for (int i = 0; i < saleQuoteList.length; i++) {
        saleQuoteList[i].quoteDetailList = await dbHelper.saleQuoteDetailGetList(orderIdList: [saleQuoteList[i].id]);
        saleQuoteList[i].quoteDetailTaxList = await dbHelper.saleQuoteDetailTaxGetList(quoteDetailIdList: saleQuoteList[i].quoteDetailList.map((e) => e.id).toList());
        saleQuoteList[i].totalProducts = saleQuoteList[i].quoteDetailList.length;
      }
    } catch (e) {
      print('Exception - saleQuoteSelectDialog.dart - _getSaleOrders(): ' + e.toString());
    }
  }

  Widget _listTileWidget(SaleQuote _saleQuote) {
    return ListTile(
      //   controlAffinity: ListTileControlAffinity.leading,
      title: Text('${_saleQuote.saleQuoteNumber} - ${br.generateAccountName(_saleQuote.account)}', style: Theme.of(context).primaryTextTheme.subtitle1),
      subtitle: Row(
        children: <Widget>[
          Text(
              '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_saleQuote.orderDate)}  ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${_saleQuote.totalProducts}',
              style: Theme.of(context).primaryTextTheme.subtitle2),
          (_saleQuote.finalTax > 0)
              ? Text(
                  '  ${_saleQuote.taxGroup}',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                )
              : SizedBox()
        ],
      ),
      trailing: Text(
        'Revision no.${_saleQuote.versionNumber}',
        style: Theme.of(context).primaryTextTheme.subtitle1,
      ),
      //  value: _saleOrder.isSelected,
      onTap: () async {
        await import(_saleQuote);
      },
    );
  }
}
