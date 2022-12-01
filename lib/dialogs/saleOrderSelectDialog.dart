// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/saleOrderModel.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ribbon/ribbon.dart';

class SaleOrderSelectDialog extends BaseRoute {
  final Account account;
  SaleOrderSelectDialog({@required a, @required o, this.account}) : super(a: a, o: o, r: 'SaleOrderSelectDialog');
  @override
  _SaleOrderSelectDialogState createState() => _SaleOrderSelectDialogState(this.account);
}

class _SaleOrderSelectDialogState extends BaseRouteState {
  Account account;
  List<SaleOrder> saleOrderList = [];
  // List<SaleOrder> _selectedOrderList = [];
  TextEditingController _cAccount = TextEditingController();
  bool _isDataLoaded = false;
  _SaleOrderSelectDialogState(this.account) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(global.appLocaleValues['tle_select_orders']),
      ),
      body: (_isDataLoaded)
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      controller: _cAccount,
                      readOnly: true,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: global.appLocaleValues['tab_ac'],
                        labelText: global.appLocaleValues['tab_ac'],
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
                (saleOrderList.length > 0)
                    ? Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                              itemCount: saleOrderList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    Card(
                                        child: (saleOrderList[index].finalTax > 0)
                                            ? Ribbon(
                                                nearLength: 47,
                                                farLength: 20,
                                                title: global.appLocaleValues['rbn_with_tax'],
                                                titleStyle: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                                color: Colors.green,
                                                location: RibbonLocation.values[1],
                                                child: _listTileWidget(saleOrderList[index]))
                                            : _listTileWidget(saleOrderList[index])),
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

  Future import(SaleOrder _saleOrder) async {
    try {
      // SaleInvoice _saleInvoice = await br.generateInvoice(_saleOrder, dbHelper);
      // Navigator.of(context).pop(_saleInvoice);
    } catch (e) {
      print('Exception - saleOrderSelectDialog.dart - import() ' + e.toString());
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
        await _getSaleOrders();
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - saleOrderSelectDialog.dart - _getData() ' + e.toString());
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
      await _getSaleOrders();
      setState(() {
        _isDataLoaded = true;
      });
    } catch (e) {
      print('Exception - saleOrderSelectDialog.dart - _accountListener(): ' + e.toString());
    }
  }

  Future _getSaleOrders() async {
    try {
      saleOrderList = await dbHelper.saleOrderGetList(orderBy: "DESC", accountId: account.id, status: 'OPEN');
      for (int i = 0; i < saleOrderList.length; i++) {
        saleOrderList[i].orderDetailList = await dbHelper.saleOrderDetailGetList(orderIdList: [saleOrderList[i].id]);
        saleOrderList[i].orderDetailTaxList = await dbHelper.saleOrderDetailTaxGetList(orderDetailIdList: saleOrderList[i].orderDetailList.map((e) => e.id).toList());
        saleOrderList[i].totalProducts = saleOrderList[i].orderDetailList.length;
      }
    } catch (e) {
      print('Exception - saleOrderSelectDialog.dart - _getSaleOrders(): ' + e.toString());
    }
  }

  Widget _listTileWidget(SaleOrder _saleOrder) {
    return ListTile(
      //   controlAffinity: ListTileControlAffinity.leading,
      title: Text('${_saleOrder.saleOrderNumber} - ${br.generateAccountName(_saleOrder.account)}'),
      subtitle: Row(
        children: <Widget>[
          Text(
              '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(_saleOrder.orderDate)}  ${(br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Product') ? global.appLocaleValues['tle_product'] : (br.getSystemFlagValue(global.systemFlagNameList.businessInventory) == 'Service') ? global.appLocaleValues['tle_service'] : global.appLocaleValues['tle_item']}: ${_saleOrder.totalProducts}'),
          (_saleOrder.finalTax > 0)
              ? Text(
                  '  ${_saleOrder.taxGroup}',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                )
              : SizedBox()
        ],
      ),
      //  value: _saleOrder.isSelected,
      onTap: () async {
        await import(_saleOrder);
      },
    );
  }
}
