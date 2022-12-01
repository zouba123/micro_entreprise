// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/screens/accountAddScreen.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class AccountSelectDialog extends Base {
  final int returnScreenId;
  final ValueChanged<Account> selectedAccount;
  AccountSelectDialog({@required a, @required o, @required this.returnScreenId, @required this.selectedAccount}) : super(analytics: a, observer: o);
  @override
  _AccountSelectDialogState createState() => _AccountSelectDialogState(this.returnScreenId, this.selectedAccount);
}

class _AccountSelectDialogState extends BaseState {
  int returnScreenId;
  final ValueChanged<Account> selectedAccount;
  List<Account> _accountList = [];
  bool _isDataLoaded = false;

  _AccountSelectDialogState(this.returnScreenId, this.selectedAccount) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['lbl_choose_ac'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: <Widget>[
          (returnScreenId == 1 || returnScreenId == 3 || returnScreenId == 5)
              ? SizedBox()
              : IconButton(
                  icon: Icon(Icons.add),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (BuildContext context) => AccountAddScreen(
                                  a: widget.analytics,
                                  o: widget.observer,
                                  returnScreenId: 1,
                                  isAddAsCustomer: (returnScreenId == 0) ? true : false,
                                )))
                        .then((v) {
                      Navigator.of(context).pop(v);
                    });
                  },
                ),
        ],
      ),
      body: (_isDataLoaded)
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.search,
                    onChanged: (value) async {
                      _isDataLoaded = false;

                      _accountList = (returnScreenId == 2 || returnScreenId == 3) ? await dbHelper.accountGetList(accountType: 'Supplier', isActive: true, searchString: value) : await dbHelper.accountGetList(accountType: 'Customer', isActive: true, searchString: value);
                      _isDataLoaded = true;
                      setState(() {});
                    },
                    //  style: TextStyle(color: Colors.white),
                    // cursorColor: Colors.white,
                    decoration: InputDecoration(
                      hintText: global.appLocaleValues['lbl_search_ac'],
                      prefixIcon: Icon(
                        Icons.search,
                        // color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                (_accountList.length > 0)
                    ? Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: _accountList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text('${br.generateAccountName(_accountList[index])}'
                                        //    '${br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix)}${'0' * (int.parse(br.getSystemFlagValue(global.systemFlagNameList.accountCodeMaxLength)) - (br.getSystemFlagValue(global.systemFlagNameList.accountCodePrefix).length + _accountList[index].accountCode.toString().length))}${_accountList[index].accountCode} - ${_accountList[index].firstName} ${_accountList[index].lastName}'
                                        ),
                                    subtitle: (_accountList[index].businessName != '')
                                        ? Text('${_accountList[index].businessName}')
                                        : (_accountList[index].city != '')
                                            ? Text('${_accountList[index].city}')
                                            : null,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      selectedAccount(_accountList[index]);
                                      setState(() {});
                                      //   getAccounts();
                                    },
                                  ),
                                  ((_accountList.length - 1) != index) ? Divider() : SizedBox()
                                ],
                              );
                            },
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          global.appLocaleValues['txt_no_ac_found'],
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                      ),
              ],
            )
          : Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
    );
  }

  Future _getAccounts() async {
    try {
      if (returnScreenId == 0 || returnScreenId == 1) {
        _accountList = await dbHelper.accountGetList(accountType: 'Customer', isActive: true, screenId: 1);
      } else if (returnScreenId == 2 || returnScreenId == 3) {
        _accountList = await dbHelper.accountGetList(accountType: 'Supplier', isActive: true, screenId: 1);
      } else if (returnScreenId == 4) {
        _accountList = await dbHelper.accountGetList(
          accountType: 'Employee',
        );
        _accountList += await dbHelper.accountGetList(
          accountType: 'Worker',
        );
        _removeDuplicates();
      } else if (returnScreenId == 5) {
        _accountList = await dbHelper.accountGetList(
          accountType: 'Customer',
        );
        _accountList += await dbHelper.accountGetList(
          accountType: 'Supplier',
        );
        _removeDuplicates();
      }
    } catch (e) {
      print('Exception - accountSelectDialog.dart - getAccounts(): ' + e.toString());
      return null;
    }
    setState(() {});
  }

  Future _getData() async {
    await _getAccounts();
    _isDataLoaded = true;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _removeDuplicates() {
    try {
      List<Account> _temp = _accountList.toList();
      _accountList.clear();
      for (int i = 0; i < _temp.length; i++) {
        bool _isExist = false;
        _isExist = _accountList.map((e) => e.id).contains(_temp[i].id);
        if (!_isExist) {
          _accountList.add(_temp[i]);
        }
      }
    } catch (e) {
      print('Exception - accountSelectDialog.dart - _removeDuplicates(): ' + e.toString());
    }
  }
}
