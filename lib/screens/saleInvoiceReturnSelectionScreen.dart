// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/dialogs/accountSelectDialog.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/saleInvoiceModel.dart';
import 'package:accounting_app/screens/saleInvoiceReturnAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class SaleInvoiceReturnSelectionScreen extends BaseRoute {
  SaleInvoiceReturnSelectionScreen({@required a, @required o}) : super(a: a, o: o, r: 'SaleInvoiceReturnSelectionScreen');
  @override
  _SaleInvoiceReturnSelectionScreenState createState() => _SaleInvoiceReturnSelectionScreenState();
}

class _SaleInvoiceReturnSelectionScreenState extends BaseRouteState {
  TextEditingController _cAccount = TextEditingController();
  Account _account;
  List<SaleInvoice> _saleInvoiceList = [];
  int _count = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _SaleInvoiceReturnSelectionScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(global.appLocaleValues['tle_sales_invoice_return']),
        actions: <Widget>[],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5, top: 10),
                  child: Text(global.appLocaleValues['tab_ac'], style: Theme.of(context).primaryTextTheme.headline3),
                ),
                Padding(
                  padding: EdgeInsets.only(),
                  child: TextFormField(
                    controller: _cAccount,
                    readOnly: true,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: global.appLocaleValues['tab_ac'],
                      border: nativeTheme().inputDecorationTheme.border,
                      // labelText: global.appLocaleValues['tab_ac'],
                      suffixIcon: Icon(
                        Icons.star,
                        size: 9,
                        color: Colors.red,
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return global.appLocaleValues['lbl_ac_err_req'];
                      }
                      return null;
                    },
                    onTap: () async {
                      try {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AccountSelectDialog(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  returnScreenId: 1,
                                  selectedAccount: (selectedAccount) async {
                                    _saleInvoiceList.clear();
                                    _account = selectedAccount;
                                    //      String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
                                    _cAccount.text = '${_account.firstName} ${_account.lastName}';

                                    _saleInvoiceList = await dbHelper.saleInvoiceGetList(accountId: _account.id, lastDays: int.parse(br.getSystemFlagValue(global.systemFlagNameList.salesReturnDays)), isCancelled: false);
                                    setState(() {});
                                  },
                                )));
                        //
                        // await showDialog(
                        //     context: context,
                        //     builder: (_) {
                        //       return AccountSelectDialog(
                        //         a: widget.analytics,
                        //         o: widget.observer,
                        //         returnScreenId: 1,
                        //         selectedAccount: (selectedAccount) async {
                        //           _saleInvoiceList.clear();
                        //           _account = selectedAccount;
                        //           String _code = '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _account.accountCode.toString().length))}${_account.accountCode}';
                        //           _cAccount.text = '$_code - ${_account.firstName} ${_account.lastName}';

                        //           _saleInvoiceList = await dbHelper.saleInvoiceGetList(accountId: _account.id, lastDays: int.parse(br.getSystemFlagValue(global.systemFlagNameList.salesReturnDays)), isCancelled: false);
                        //           setState(() {});
                        //         },
                        //       );
                        //     });
                      } catch (e) {
                        print('Exception - SaleInvoiceReturnSelectionScreen.dart - _cAccount(): ' + e.toString());
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (_account != null)
                    ? (_saleInvoiceList.length > 0)
                        ? Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    global.appLocaleValues['tle_select_sale_invoice'],
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              SizedBox(width: 5),
                              Padding(
                                padding: const EdgeInsets.only(bottom:80.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: _saleInvoiceList.length,
                                  itemBuilder: (context, index) {
                                    return CheckboxListTile(
                                      value: _saleInvoiceList[index].isSelect,
                                      title: Text(
                                          '${br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.invoiceNoMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.invoiceNoPrefix).length + _saleInvoiceList[index].invoiceNumber.toString().length))}${_saleInvoiceList[index].invoiceNumber} - ${br.generateAccountName(_saleInvoiceList[index].account)}'),
                                      onChanged: (value) {
                                        _saleInvoiceList[index].isSelect = (value) ? true : false;
                                        _count = 0;
                                        _saleInvoiceList.map((f) {
                                          if (f.isSelect) {
                                            _count++;
                                          }
                                        }).toList();
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          )
                        : Text(
                            global.appLocaleValues['tle_return_sale_empty_msg'],
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          )
                    : SizedBox()
              ],
            ),
          ),
        ),
      ),
      bottomSheet: (_account != null && _saleInvoiceList.length > 0)
          ? Container(
              color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              '${global.appLocaleValues['btn_select']} ($_count)',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _selectedRetruns();
                      },
                    ),
                  ],
                ),
              ),
          )
          : SizedBox(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void _selectedRetruns() {
    try {
      List<SaleInvoice> _tempList = [];
      _saleInvoiceList.forEach((saleInvoice) {
        if (saleInvoice.isSelect) {
          _tempList.add(saleInvoice);
        }
      });

      if (_tempList.length > 0) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SaleInvoiceReturnAddScreen(
                  a: widget.analytics,
                  o: widget.observer,
                  saleInvoiceList: _tempList,
                )));
      } else {
        showToast('${global.appLocaleValues['btn_select_err_req_']}');
      }
    } catch (e) {
      print('Exception - SaleInvoiceReturnSelectionScreen.dart - _selectedRetruns(): ' + e.toString());
    }
  }
}
