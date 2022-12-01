// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:io';

import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/employeeAddScreen.dart';
import 'package:accounting_app/screens/employeeDetailScreen.dart';
import 'package:accounting_app/screens/employeePaymentAddScreen.dart';
import 'package:accounting_app/screens/employeeStatementScreen.dart';
import 'package:accounting_app/screens/salarySetUpAddScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ListTileEmployeeWidget extends Base {
  final Account account;
  final int tabIndex;
  final onDeletePressed;
  ListTileEmployeeWidget({@required Key key, @required this.account, @required this.tabIndex, @required a, @required o, this.onDeletePressed}) : super(key: key, analytics: a, observer: o);
  @override
  _ListTileEmployeeWidgetState createState() => _ListTileEmployeeWidgetState(this.account, this.tabIndex, this.onDeletePressed);
}

class _ListTileEmployeeWidgetState extends BaseState {
  Account account;
  final int _tabIndex;
  final onDeletePressed;
  var _formKey = GlobalKey<FormState>();
  TextEditingController _cMsg =  TextEditingController();

  _ListTileEmployeeWidgetState(this.account, this._tabIndex, this.onDeletePressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        child: Row(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width * 15) / 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColorLight,
                  foregroundColor: Colors.black,
                  radius: 25,
                  child: (account.imagePath.isNotEmpty)
                      ? ClipOval(
                          child: Image.file(File(account.imagePath)),
                        )
                      : Text(
                          '${account.firstName.substring(0, 1)}${account.lastName != '' ? account.lastName.substring(0, 1) : ''}',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width * 47.5) / 100,
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${br.generateAccountName(account)}',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        (account.businessName != '') ? Expanded(child: Text('${account.businessName}', style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor))) : SizedBox(),
                      ],
                    ),
                    Row(
                      children: [
                        (account.mobile != '')
                            ? Text(
                                '+${account.mobileCountryCode} ${account.mobile}',
                                style: TextStyle(color: Colors.grey),
                              )
                            : SizedBox()
                      ],
                    ),
                    Row(
                      children: [
                        (account.totalAdvanced != null)
                            ? Text(
                                '${global.appLocaleValues['lbl_advance']}',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9, fontSize: 12),
                              )
                            : SizedBox(),
                        (account.totalAdvanced != null)
                            ? Text(
                                ' ${global.currency.symbol} ${account.totalAdvanced.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                style: TextStyle(color: Colors.green, height: 0.9, fontSize: 12),
                              )
                            : SizedBox()
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width * 21) / 100,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      (account.totalDue != 0.0 && account.totalDue != null)
                          ? Container(
                              width: 75,
                              padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Colors.red)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    global.appLocaleValues['tle_due'],
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9, fontSize: 12),
                                    textAlign: TextAlign.right,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    ' ${global.currency.symbol} ${account.totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
                                    style: TextStyle(color: Colors.red, height: 0.9, fontSize: 12),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  (!account.isActive)
                      ? Row(
                          children: <Widget>[Text(global.appLocaleValues['lbl_inactive'], style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
                        )
                      : SizedBox()
                ],
              ),
            ),
            Container(
                width: (MediaQuery.of(context).size.width * 9) / 100,
                child: PopupMenuButton(
                    itemBuilder: (context) => [
                          (account.accountType.contains('Employee') == true)
                              ? PopupMenuItem(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.library_books,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        Text(global.appLocaleValues['tle_emp_statement']),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) =>  EmployeeStatementScreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                                account: account,
                                                screenId: (_tabIndex < 2) ? 1 : 0,
                                              )));
                                    },
                                  ),
                                )
                              : null,
                          // PopupMenuItem(
                          //   child: ListTile(
                          //     contentPadding: EdgeInsets.zero,
                          //     title: Row(
                          //       children: <Widget>[
                          //         Padding(
                          //           padding: const EdgeInsets.only(right: 10),
                          //           child: Icon(
                          //             Icons.share,
                          //             color: Theme.of(context).primaryColor,
                          //           ),
                          //         ),
                          //         Text(global.appLocaleValues['lbl_share_contact']),
                          //       ],
                          //     ),
                          //     onTap: () async {
                          //       Navigator.of(context).pop();
                          //       global.isAppOperation = true;
                          //       // await br.shareAccountCard(account);
                          //     },
                          //   ),
                          // ),
                          PopupMenuItem(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.sms,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(global.appLocaleValues['tle_text_msg']),
                                ],
                              ),
                              onTap: () async {
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
                                      decoration: InputDecoration(prefixIcon: Icon(Icons.message), border: nativeTheme().inputDecorationTheme.border, hintText: global.appLocaleValues['lbl_text_msg']),
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
                                        Navigator.of(context, rootNavigator: true).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(global.appLocaleValues['btn_cancel']),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                          global.isAppOperation = true;
                                          await launch('sms: $_contact?body=${_cMsg.text}');
                                        }
                                      },
                                      child: Text(global.appLocaleValues['btn_send']),
                                    ),
                                  ],
                                );
                                showDialog(builder: (context) => dialog, context: context, barrierDismissible: false);
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
                                      FontAwesomeIcons.whatsapp,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(global.appLocaleValues['tle_whtsapp_msg']),
                                ],
                              ),
                              onTap: () async {
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
                                      decoration: InputDecoration(prefixIcon: Icon(FontAwesomeIcons.whatsapp), border: nativeTheme().inputDecorationTheme.border, hintText: global.appLocaleValues['lbl_whtsapp_msg']),
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
                                        Navigator.of(context, rootNavigator: true).pop();
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
                                          var whatsappUrl = "whatsapp://send?phone=$_contact&text=${_cMsg.text}";
                                          await canLaunch(whatsappUrl) ? launch(whatsappUrl) : showToast('${global.appLocaleValues['err_whtsapp']}');
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
                          PopupMenuItem(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      FontAwesomeIcons.phoneAlt,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(global.appLocaleValues['tle_call']),
                                ],
                              ),
                              onTap: () async {
                                Navigator.of(context).pop();
                                String _contact = '';
                                if (account.phone != '') {
                                  _contact = await br.selectMobileNumber(['+${account.mobileCountryCode} ${account.mobile}', '+${account.phoneCountryCode} ${account.phone}'], context);
                                } else {
                                  _contact = '+${account.mobileCountryCode} ${account.mobile}';
                                }
                                global.isAppOperation = true;
                                launch('tel://$_contact');
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
                                      Icons.email,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(global.appLocaleValues['txt_email']),
                                ],
                              ),
                              onTap: () async {
                                Navigator.of(context).pop();
                                global.isAppOperation = true;
                                final MailOptions mailOptions = MailOptions(
                                  body: '',
                                  subject: '',
                                  recipients: ['${account.email}'],
                                  isHTML: true,
                                  bccRecipients: [''],
                                  ccRecipients: [''],
                                );

                                await FlutterMailer.send(mailOptions);
                              },
                            ),
                          ),
                          _tabIndex < 2
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
                                          builder: (context) => EmployeeAddScreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                                account: account,
                                                returnScreenId: 0,
                                                isAddAsEmployee: true,
                                              )));
                                    },
                                  ),
                                )
                              : null,
                          _tabIndex < 2
                              ? PopupMenuItem(
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
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      onDeletePressed(account, _tabIndex);
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
                                      Icons.account_balance_wallet,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(global.appLocaleValues['lbl_salary_setup']),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop();

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SalarySetUpAddScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          account: account,
                                          employeeSalaryStructures: null,
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
                                      Icons.account_balance_wallet,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(global.appLocaleValues['lbl_pay_salary']),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop();

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EmployeePaymentAddScreen(
                                          a: widget.analytics,
                                          o: widget.observer,
                                          account: account,
                                          returnScreenId: 14,
                                        )));
                              },
                            ),
                          )
                        ]))
          ],
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EmployeeDetailScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    account: account,
                  )));
        },
      ),
    );

    // return ListTile(
    //   contentPadding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
    //   leading: CircleAvatar(
    //     backgroundColor: Colors.lightBlue,
    //     foregroundColor: Colors.black,
    //     radius: 25,
    //     child: (account.imagePath.isNotEmpty)
    //         ? ClipOval(
    //             child: Image.file(File(account.imagePath)),
    //           )
    //         : Text(
    //             '${account.firstName.substring(0, 1)}${account.lastName != '' ? account.lastName.substring(0, 1) : ''}',
    //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
    //           ),
    //   ),
    //   onTap: () {
    //     Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => AccountDetailScreen(
    //               a: widget.analytics,
    //               o: widget.observer,
    //               account: account,
    //             )));
    //   },
    //   //isThreeLine: true,
    //   title: Text(
    //     '${br.generateAccountName(account)}',
    //     style: TextStyle(fontSize: 14),
    //   ),
    //   subtitle: Column(
    //     children: <Widget>[
    //       Row(
    //         children: <Widget>[(account.businessName != '') ? Text('${account.businessName}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)) : SizedBox()],
    //       ),
    //       Column(
    //         children: <Widget>[
    //           Row(
    //             children: <Widget>[
    //              (account.mobile != '') ? Text('+${account.mobileCountryCode} ${account.mobile}  ') : Text(''),
    //               (account.totalDue != null && account.totalDue != 0.0)
    //                   ? (account.totalDue < 0)
    //                       ? Container(
    //                           width: 100,
    //                           padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
    //                           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Colors.green)),
    //                           child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                             children: <Widget>[
    //                               Text(
    //                                 global.appLocaleValues['tle_creadit'],
    //                                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, height: 0.9, fontSize: 12),
    //                               ),
    //                               Text(
    //                                 ' ${global.currency.symbol} ${(account.totalDue * -1).toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
    //                                 style: TextStyle(color: Colors.green, height: 0.9, fontSize: 12),
    //                               )
    //                             ],
    //                           ),
    //                         )
    //                       : Container(
    //                           width: 100,
    //                           padding: const EdgeInsets.only(top: 5, bottom: 3, left: 5, right: 5),
    //                           decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Colors.red)),
    //                           child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                             children: <Widget>[
    //                               Text(
    //                                 'DUE',
    //                                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, height: 0.9, fontSize: 12),
    //                                 textAlign: TextAlign.right,
    //                               ),
    //                               Text(
    //                                 ' ${global.currency.symbol} ${account.totalDue.toStringAsFixed(int.parse(br.getSystemFlagValue(global.systemFlagNameList.decimalPlaces)))}',
    //                                 style: TextStyle(color: Colors.red, height: 0.9, fontSize: 12),
    //                               )
    //                             ],
    //                           ),
    //                         )
    //                   : SizedBox()
    //             ],
    //           ),
    //           (!account.isActive)
    //               ? Row(
    //                   children: <Widget>[Text(global.appLocaleValues['lbl_inactive'], style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))],
    //                 )
    //               : SizedBox()
    //         ],
    //       )
    //     ],
    //   ),
    //   trailing: PopupMenuButton(
    //     itemBuilder: (context) => [
    //       (account.accountType.contains('Customer') == true)
    //           ? PopupMenuItem(
    //               child: ListTile(
    //                 leading: Icon(
    //                   Icons.library_books,
    //                   color: Colors.blue,
    //                 ),
    //                 title: Text(global.appLocaleValues['tle_ac_statement']),
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                   Navigator.of(context).push(MaterialPageRoute(
    //                       builder: (BuildContext context) =>  AccountStatementScreen(
    //                             a: widget.analytics,
    //                             o: widget.observer,
    //                             account: account,
    //                             screenId: (_tabIndex < 2) ? 1 : 0,
    //                           )));
    //                 },
    //               ),
    //             )
    //           : null,
    //       PopupMenuItem(
    //         child: ListTile(
    //           leading: Icon(
    //             Icons.sms,
    //             color: Colors.blue,
    //           ),
    //           title: Text(global.appLocaleValues['tle_text_msg']),
    //           onTap: () {
    //             _cMsg.text = '';
    //             AlertDialog dialog =  AlertDialog(
    //               shape: nativeTheme().dialogTheme.shape,
    //               title: Text(
    //                 global.appLocaleValues['tle_text_msg'],
    //                 style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    //               ),
    //               content: Form(
    //                 key: _formKey,
    //                 child: TextFormField(
    //                   autofocus: true,
    //                   controller: _cMsg,
    //                   decoration: InputDecoration(prefixIcon: Icon(Icons.message), border: nativeTheme().inputDecorationTheme.border, hintText: global.appLocaleValues['lbl_text_msg']),
    //                   validator: (String value) {
    //                     if (value.isEmpty) {
    //                       return global.appLocaleValues['lbl_text_msg'];
    //                     }
    //                     return null;
    //                   },
    //                 ),
    //               ),
    //               actions: <Widget>[
    //                 TextButton(
    //                   onPressed: () {
    //                     _cMsg.text = '';
    //                     Navigator.of(context, rootNavigator: true).pop();
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: Text(global.appLocaleValues['btn_cancel'], style: TextStyle(color: Colors.blue)),
    //                 ),
    //                 TextButton(
    //                   onPressed: () async {
    //                     if (_formKey.currentState.validate()) {
    //                       Navigator.of(context).pop();
    //                       Navigator.of(context).pop();
    //                       await launch('sms: ${account.mobileCountryCode}${account.mobile}?body=${_cMsg.text}');
    //                     }
    //                   },
    //                   child: Text(global.appLocaleValues['btn_send'], style: TextStyle(color: Colors.blue)),
    //                 ),
    //               ],
    //             );
    //             showDialog(context: context, barrierDismissible: false, child: dialog);
    //           },
    //         ),
    //       ),
    //       PopupMenuItem(
    //         child: ListTile(
    //           leading: Icon(
    //             FontAwesomeIcons.whatsapp,
    //             color: Colors.blue,
    //           ),
    //           title: Text(global.appLocaleValues['tle_whtsapp_msg']),
    //           onTap: () async {
    //             AlertDialog dialog =  AlertDialog(
    //               shape: nativeTheme().dialogTheme.shape,
    //               title: Text(
    //                 global.appLocaleValues['tle_whtsapp_msg'],
    //                 style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    //               ),
    //               content: Form(
    //                 key: _formKey,
    //                 child: TextFormField(
    //                   autofocus: true,
    //                   controller: _cMsg,
    //                   decoration: InputDecoration(prefixIcon: Icon(FontAwesomeIcons.whatsapp), border: nativeTheme().inputDecorationTheme.border, hintText: global.appLocaleValues['lbl_whtsapp_msg']),
    //                   validator: (String value) {
    //                     if (value.isEmpty) {
    //                       return global.appLocaleValues['lbl_whtsapp_msg'];
    //                     }
    //                     return null;
    //                   },
    //                 ),
    //               ),
    //               actions: <Widget>[
    //                 TextButton(
    //                   onPressed: () {
    //                     _cMsg.text = '';
    //                     Navigator.of(context, rootNavigator: true).pop();
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: Text(global.appLocaleValues['btn_cancel'], style: TextStyle(color: Colors.blue)),
    //                 ),
    //                 TextButton(
    //                   onPressed: () async {
    //                     if (_formKey.currentState.validate()) {
    //                       Navigator.of(context, rootNavigator: true).pop();
    //                       Navigator.of(context).pop();
    //                       var whatsappUrl = "whatsapp://send?phone=${account.mobileCountryCode}${account.mobile}&text=${_cMsg.text}";
    //                       await canLaunch(whatsappUrl) ? launch(whatsappUrl) : showToast('${global.appLocaleValues['err_whtsapp']}');
    //                     }
    //                     _cMsg.text = '';
    //                   },
    //                   child: Text(global.appLocaleValues['btn_send'], style: TextStyle(color: Colors.blue)),
    //                 ),
    //               ],
    //             );
    //             showDialog(context: context, barrierDismissible: false, child: dialog);
    //           },
    //         ),
    //       ),
    //       PopupMenuItem(
    //         child: ListTile(
    //           leading: Icon(
    //             FontAwesomeIcons.phoneAlt,
    //             color: Colors.blue,
    //           ),
    //           title: Text(global.appLocaleValues['tle_call']),
    //           onTap: () {
    //             Navigator.of(context).pop();
    //             launch('tel://${account.mobileCountryCode}${account.mobile}');
    //           },
    //         ),
    //       ),
    //       PopupMenuItem(
    //         child: ListTile(
    //           leading: Icon(
    //             Icons.email,
    //             color: Colors.blue,
    //           ),
    //           title: Text(global.appLocaleValues['txt_email']),
    //           onTap: () async {
    //             Navigator.of(context).pop();

    //             final MailOptions mailOptions = MailOptions(
    //               body: '',
    //               subject: '',
    //               recipients: ['${account.email}'],
    //               isHTML: true,
    //               bccRecipients: [''],
    //               ccRecipients: [''],
    //             );

    //             await FlutterMailer.send(mailOptions);
    //           },
    //         ),
    //       ),
    //       _tabIndex < 2
    //           ? PopupMenuItem(
    //               child: ListTile(
    //                 leading: Icon(
    //                   Icons.edit,
    //                   color: Colors.blue,
    //                 ),
    //                 title: Text(global.appLocaleValues['lbl_edit']),
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                   Navigator.of(context).push(MaterialPageRoute(
    //                       builder: (context) => AccountAddScreen(
    //                             a: widget.analytics,
    //                             o: widget.observer,
    //                             account: account,
    //                             isAddAsCustomer: true,
    //                           )));
    //                 },
    //               ),
    //             )
    //           : null,
    //       _tabIndex < 2
    //           ? PopupMenuItem(
    //               child: ListTile(
    //                 leading: Icon(
    //                   Icons.delete,
    //                   color: Colors.blue,
    //                 ),
    //                 title: Text(global.appLocaleValues['lbl_delete']),
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                   onDeletePressed(account, _tabIndex);
    //                 },
    //               ),
    //             )
    //           : null,
    //     ],
    //   ),
    // );
  }
}
