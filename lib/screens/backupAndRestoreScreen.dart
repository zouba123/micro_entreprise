// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unused_element
import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as googleDrive;
import 'dart:io';
import 'package:archive/archive_io.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:accounting_app/Theme/nativeTheme.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
// import 'package:invoices/models/businessLayer/methodResultModel.dart';
import 'package:accounting_app/models/googleHttpClientModel.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/screens/networkErrorScreen.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';

class BackupAndRestoreScreen extends BaseRoute {
  BackupAndRestoreScreen({@required a, @required o}) : super(a: a, o: o, r: 'BackupAndRestoreScreen');
  @override
  _BackupAndRestoreScreenState createState() => _BackupAndRestoreScreenState();
}

class _BackupAndRestoreScreenState extends BaseRouteState {
  // TabController _tabController;
  DateTime googleBackupTime;
  // DateTime localBackupTime;
  bool isGoogleBackupExist;
  // bool _enableRestoreFromLocal = false;
  bool isConnected = false;
  // MethodResult _googleBackupResult;
  // MethodResult _localBackupResult;

  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: global.googleSignInScopeList,
  // );

  _BackupAndRestoreScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('${global.appLocaleValues['backup']}', style: Theme.of(context).appBarTheme.titleTextStyle),
            actions: [
              (br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail).isNotEmpty)
                  ? FlatButton(
                      onPressed: () async {
                        try {
                          _logoutDialog(context);
                        } catch (e) {
                          print('logout exception: ${e.toString()}');
                        }
                      },
                      child: Text(
                        '${global.appLocaleValues['logout']}',
                        style: TextStyle(color: Colors.white),
                      ))
                  : SizedBox()
            ],
            // bottom: TabBar(controller: _tabController, tabs: <Widget>[
            //   Tab(
            //     text: 'Google Drive',
            //   ),
            //   Tab(
            //     text: 'Local',
            //   ),
            // ]),
          ),
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width - 90,
            child: DrawerWidget(
              a: widget.analytics,
              o: widget.observer,
              routeName: widget.routeName,
            ),
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
            child:
                //  TabBarView(
                // controller: _tabController,
                // children: <Widget>[
                _googleDriveTab(),
            // _localTab(),
            // ],
            // ),
          )),
    );
  }

  Widget _googleDriveTab() {
    try {
      return WillPopScope(
          key: Key('1'),
          onWillPop: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      a: widget.analytics,
                      o: widget.observer,
                    )));
            return null;
          },
          child: Scrollbar(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(0),
                child: (br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail).isNotEmpty)
                    ? Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Card(
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/images/googleicon.png',
                                  width: 35,
                                ),
                                title: Text(
                                  br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail),
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          isGoogleBackupExist == null
                              ? Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColorLight,
                                        foregroundColor: Colors.white,
                                        radius: 25,
                                        child: Icon(
                                          Icons.cloud_upload,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        '${global.appLocaleValues['tle_check_backup_on_drive']}',
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                      trailing: SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(0),
                                        title: (isGoogleBackupExist != null && isGoogleBackupExist)
                                            ? Text(
                                                "${global.appLocaleValues['lbl_last_backup_available']}",
                                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
                                              )
                                            : Text(
                                                "${global.appLocaleValues['lbl_no_backup_available']}",
                                                style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
                                              ),
                                        subtitle: (isGoogleBackupExist != null && isGoogleBackupExist && googleBackupTime != null)
                                            ? Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  "${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat) + ' hh:mm a').format(googleBackupTime)}",
                                                  style: TextStyle(fontSize: 16.0),
                                                ),
                                              )
                                            : null,
                                        trailing: (isGoogleBackupExist != null && isGoogleBackupExist)
                                            ? IconButton(
                                                onPressed: () {
                                                  _deleteGoogleBackupDialog(context);
                                                },
                                                icon: Icon(Icons.delete, color: Theme.of(context).primaryColor))
                                            : null,
                                      ),
                                    ),
                                  ),
                                ),
                          global.googleBackupResult != null
                              ? Card(
                                  child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColorLight,
                                        foregroundColor: Colors.white,
                                        radius: 25,
                                        child: Icon(
                                          Icons.cloud_upload,
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: global.googleBackupResult.statusMessage != null ? Text(global.googleBackupResult.statusMessage) : null,
                                      title: Text(
                                        '${global.appLocaleValues['tle_google_drive_backup']}',
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                      trailing: global.googleBackupResult.statusCode == 0
                                          ? Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            )
                                          : global.googleBackupResult.statusCode == 1
                                              ? Icon(Icons.check_circle, color: Colors.green)
                                              : global.googleBackupResult.statusCode == 2
                                                  ? Icon(
                                                      Icons.signal_wifi_off,
                                                      color: Colors.grey,
                                                    )
                                                  : SizedBox(
                                                      width: 25,
                                                      height: 25,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                    )),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                            contentPadding: EdgeInsets.all(0),
                                            title: Text(
                                              "${global.appLocaleValues['lbl_backup']}",
                                              style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: Text(
                                                "${global.appLocaleValues['lbl_backup_msg']}",
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: (MediaQuery.of(context).size.height - (574)) / 2,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: RaisedButton(
                                              color: Theme.of(context).primaryColor,
                                              // shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all( Radius.circular(10.0))),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.cloud_upload,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    '${global.appLocaleValues['lbl_backup']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () async {
                                                await backupConfirmationDialog(context, (isGoogleBackupExist != null) ? isGoogleBackupExist : false, false, () async {
                                                  await isBackupAvailable();
                                                  // await isLocalBackupAvailable();
                                                  googleBackupStatusRefresh();
                                                  // localBackupStatusRefresh();
                                                  setState(() {});
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          global.googleBackupResult != null
                              ? SizedBox()
                              : isGoogleBackupExist != null && isGoogleBackupExist
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              ListTile(
                                                contentPadding: EdgeInsets.all(0),
                                                title: Text(
                                                  "${global.appLocaleValues['lbl_restore']}",
                                                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
                                                ),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets.only(top: 4.0),
                                                  child: Text(
                                                    "${global.appLocaleValues['lbl_restore_msg']}",
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: (MediaQuery.of(context).size.height - (574)) / 2,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                child: RaisedButton(
                                                  color: Theme.of(context).primaryColor,
                                                  //shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all( Radius.circular(10.0))),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.cloud_download,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        '${global.appLocaleValues['lbl_restore']}',
                                                        style: TextStyle(color: Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  onPressed: () async {
                                                    isConnected = await checkConnectivity();
                                                    if (isConnected) {
                                                      _restoreConfirmationDialog(context, true);
                                                    } else {
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (BuildContext context) => NetWorkErrorScreen(
                                                                a: widget.analytics,
                                                                o: widget.observer,
                                                              )));
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                        ],
                      )
                    : Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      title: Text(
                                        "${global.appLocaleValues['conn']}",
                                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          "${global.appLocaleValues['ggl_backup_des']}",
                                          style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryTextTheme.headline3.color),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        // shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all( Radius.circular(10.0))),
                                        child: Row(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 22,
                                              child: Image.asset(
                                                'assets/images/googleicon.png',
                                                width: 30.0,
                                                height: 25,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 30),
                                              child: Text(
                                                '   ${global.appLocaleValues['sel_ac']}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        onPressed: () async {
                                          await isBackupAvailable();
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ));
    } catch (e) {
      print('Exception - backupAndRestoreScreen.dart - _googleDriveTab(): ' + e.toString());
      return SizedBox();
    }
  }

  // Widget _localTab() {
  //   try {
  //     return WillPopScope(
  //         key: Key('2'),
  //         onWillPop: () {
  //           Navigator.of(context).push(MaterialPageRoute(
  //               builder: (context) => DashboardScreen(
  //                     a: widget.analytics,
  //                     o: widget.observer,
  //                   )));
  //           return null;
  //         },
  //         child: Scrollbar(
  //           child: SingleChildScrollView(
  //             child: Container(
  //               padding: EdgeInsets.all(0),
  //               child: Column(
  //                 children: <Widget>[
  //                   _enableRestoreFromLocal == null
  //                       ? Padding(
  //                           padding: const EdgeInsets.only(bottom: 8.0),
  //                           child: Card(
  //                             child: ListTile(
  //                               leading: CircleAvatar(
  //                                 backgroundColor: Theme.of(context).primaryColorLight,
  //                                 foregroundColor: Colors.white,
  //                                 radius: 25,
  //                                 child: Icon(
  //                                   Icons.cloud_upload,
  //                                   color: Colors.white,
  //                                 ),
  //                               ),
  //                               title: Text(
  //                                 'Checking backup in local',
  //                                 style: TextStyle(color: Theme.of(context).primaryColor),
  //                               ),
  //                               trailing: SizedBox(
  //                                 width: 25,
  //                                 height: 25,
  //                                 child: CircularProgressIndicator(
  //                                   strokeWidth: 2,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       : Padding(
  //                           padding: const EdgeInsets.only(bottom: 8.0),
  //                           child: Card(
  //                             child: Padding(
  //                               padding: const EdgeInsets.only(left: 8.0, right: 8.0),
  //                               child: ListTile(
  //                                 contentPadding: EdgeInsets.all(0),
  //                                 title: (_enableRestoreFromLocal != null && _enableRestoreFromLocal)
  //                                     ? Text(
  //                                         "${global.appLocaleValues['lbl_last_backup_available']}",
  //                                         style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
  //                                       )
  //                                     : Text(
  //                                         "${global.appLocaleValues['lbl_no_backup_available']}",
  //                                         style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
  //                                       ),
  //                                 subtitle: (_enableRestoreFromLocal != null && _enableRestoreFromLocal)
  //                                     ? Padding(
  //                                         padding: const EdgeInsets.only(top: 4.0),
  //                                         child: Text(
  //                                           "${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat) + ' hh:mm a').format(localBackupTime)}",
  //                                           style: TextStyle(fontSize: 16.0),
  //                                         ),
  //                                       )
  //                                     : null,
  //                                 trailing: (_enableRestoreFromLocal != null && _enableRestoreFromLocal)
  //                                     ? IconButton(
  //                                         onPressed: () {
  //                                           _deleteLocalBackupDialog(context);
  //                                         },
  //                                         icon: Icon(Icons.delete, color: Theme.of(context).primaryColor))
  //                                     : null,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                   _localBackupResult != null
  //                       ? Card(
  //                           child: ListTile(
  //                               leading: CircleAvatar(
  //                                 backgroundColor: Theme.of(context).primaryColorLight,
  //                                 foregroundColor: Colors.white,
  //                                 radius: 25,
  //                                 child: Icon(
  //                                   Icons.cloud_upload,
  //                                   color: Colors.white,
  //                                 ),
  //                               ),
  //                               subtitle: _localBackupResult.statusMessage != null ? Text(_localBackupResult.statusMessage) : null,
  //                               title: Text(
  //                                 'Local Backup',
  //                                 style: TextStyle(color: Theme.of(context).primaryColor),
  //                               ),
  //                               trailing: _localBackupResult.statusCode == 0
  //                                   ? Icon(
  //                                       Icons.cancel,
  //                                       color: Colors.red,
  //                                     )
  //                                   : _localBackupResult.statusCode == 1
  //                                       ? Icon(Icons.check_circle, color: Colors.green)
  //                                       : _localBackupResult.statusCode == 2
  //                                           ? Icon(
  //                                               Icons.signal_wifi_off,
  //                                               color: Colors.grey,
  //                                             )
  //                                           : SizedBox(
  //                                               width: 25,
  //                                               height: 25,
  //                                               child: CircularProgressIndicator(
  //                                                 strokeWidth: 2,
  //                                               ),
  //                                             )),
  //                         )
  //                       : Padding(
  //                           padding: const EdgeInsets.only(bottom: 8.0),
  //                           child: Card(
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(8.0),
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: <Widget>[
  //                                   ListTile(
  //                                     contentPadding: EdgeInsets.all(0),
  //                                     title: Text(
  //                                       "${global.appLocaleValues['lbl_backup']}",
  //                                       style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
  //                                     ),
  //                                     subtitle: Padding(
  //                                       padding: const EdgeInsets.only(top: 4.0),
  //                                       child: Text(
  //                                         "Back up your data localy. You can restore them when you reinstall Invoices.",
  //                                         style: TextStyle(
  //                                           fontSize: 16.0,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   SizedBox(
  //                                     height: (MediaQuery.of(context).size.height - (504)) / 2,
  //                                   ),
  //                                   Container(
  //                                     width: MediaQuery.of(context).size.width,
  //                                     child: RaisedButton(
  //                                       color: Theme.of(context).primaryColor,
  //                                       child: Row(
  //                                         mainAxisSize: MainAxisSize.min,
  //                                         mainAxisAlignment: MainAxisAlignment.center,
  //                                         crossAxisAlignment: CrossAxisAlignment.center,
  //                                         children: <Widget>[
  //                                           Icon(
  //                                             Icons.cloud_upload,
  //                                             color: Colors.white,
  //                                           ),
  //                                           SizedBox(
  //                                             width: 5.0,
  //                                           ),
  //                                           Text(
  //                                             '${global.appLocaleValues['lbl_backup']}',
  //                                             style: TextStyle(
  //                                               color: Colors.white,
  //                                             ),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       onPressed: () async {
  //                                         _localBackupConfirmationDialog(context);
  //                                       },
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                   _localBackupResult != null
  //                       ? SizedBox()
  //                       : localBackupTime != null
  //                           ? Padding(
  //                               padding: const EdgeInsets.only(bottom: 8.0),
  //                               child: Card(
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.all(8.0),
  //                                   child: Column(
  //                                     mainAxisAlignment: MainAxisAlignment.start,
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     children: <Widget>[
  //                                       ListTile(
  //                                         contentPadding: EdgeInsets.all(0),
  //                                         title: Text(
  //                                           "${global.appLocaleValues['lbl_restore']}",
  //                                           style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22),
  //                                         ),
  //                                         subtitle: Padding(
  //                                           padding: const EdgeInsets.only(top: 4.0),
  //                                           child: Text(
  //                                             "Restore your data Localy. Only last back up will be available to restore.",
  //                                             style: TextStyle(
  //                                               fontSize: 16.0,
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       SizedBox(
  //                                         height: (MediaQuery.of(context).size.height - (504)) / 2,
  //                                       ),
  //                                       Container(
  //                                         width: MediaQuery.of(context).size.width,
  //                                         child: RaisedButton(
  //                                           color: Theme.of(context).primaryColor,
  //                                           child: Row(
  //                                             mainAxisSize: MainAxisSize.min,
  //                                             mainAxisAlignment: MainAxisAlignment.center,
  //                                             crossAxisAlignment: CrossAxisAlignment.center,
  //                                             children: <Widget>[
  //                                               Icon(
  //                                                 Icons.cloud_download,
  //                                                 color: Colors.white,
  //                                               ),
  //                                               SizedBox(
  //                                                 width: 5,
  //                                               ),
  //                                               Text(
  //                                                 '${global.appLocaleValues['lbl_restore']}',
  //                                                 style: TextStyle(color: Colors.white),
  //                                               ),
  //                                             ],
  //                                           ),
  //                                           onPressed: () async {
  //                                             _restoreConfirmationDialog(context, false);
  //                                           },
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             )
  //                           : SizedBox(),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ));
  //   } catch (e) {
  //     print('Exception - backupAndRestoreScreen.dart - _localTab(): ' + e.toString());
  //     return SizedBox();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    try {
      global.googleBackupResult = null;
      // _tabController = TabController(length: 2, vsync: this);
      // _tabController.addListener(() {
      // used for just show/hide logout button
      // setState(() {});
      // });

      // googleBackupStatusRefresh();
      // localBackupStatusRefresh();

      // await isLocalBackupAvailable();
      if (br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail).isNotEmpty) {
        await isBackupAvailable();
      }
    } catch (e) {
      print('Exception - backupAndRestoreScreen.dart - _init(): ' + e.toString());
    }
  }

  void _decodeZip(zipPath, outPath) {
    try {
      List<int> bytes = File(zipPath).readAsBytesSync();

      // Decode the Zip file
      Archive archive = ZipDecoder().decodeBytes(bytes);

      // Extract the contents of the Zip archive to disk.
      for (ArchiveFile file in archive) {
        String filename = file.name;
        if (file.isFile) {
          List<int> data = file.content;
          File(outPath + filename)
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory(outPath + filename)..create(recursive: true);
        }
      }
    } catch (e) {
      print('Exception: backupAndRestoreScreen.dart - _decodeZip() ' + e.toString());
    }
  }

   Future<bool> _checkBackupExist(String fileName, googleDrive.DownloadOptions downloadOptions) async {
     try {
       final httpClient = await handleGoogleSignIn();
       if (httpClient != null) {
         String folderId;
         var drive = googleDrive.DriveApi(httpClient);
         var folder = await drive.files.list(
           q: "name='${global.googleDriveBackupFolder}' and mimeType='application/vnd.google-apps.folder'",
           // includeItemsFromAllDrives: true,
           // includeTeamDriveItems: true,
           // supportsAllDrives: true,
           // supportsTeamDrives: true,
         );

         if (folder.files.length > 0) {
           folderId = folder.files[0].id;

           googleDrive.File googleFile = googleDrive.File();
           googleFile.name = fileName;
           googleFile.parents = [folderId].toList();

           await drive.files.list(q: "name='$fileName' and '$folderId' in parents", $fields: 'files(id, name, parents, trashed, modifiedTime)').then((response) async {
             if (response.files.length > 0) {
               googleBackupTime = response.files[0].modifiedTime;

               //    if (this.mounted) {
               setState(() {});
               //   }
               fileResponse = await drive.files.get(
                 response.files[0].id,
                 downloadOptions: downloadOptions,
               );
             }
           }).catchError((error) async {
             print('No backup available');
           });
         } else {
           print('No backup available');
         }
       } else {
         print('Google Authentication Error');
       }
       return (fileResponse != null) ? true : false;
     } catch (err) {
       print('Exception: backupAndRestoreScreen.dart - _checkBackupExist() ' + err.toString());
       return false;
     }
   }

  Future<void> _download(File file, GoogleHttpClient httpClient) async {
    try {
      await _checkBackupExist('easyaccount.bak', googleDrive.DownloadOptions.fullMedia);

      List<int> bytes = List<int>();
      if (fileResponse != null) {
        fileResponse.stream.listen(
          (onData) {
            bytes.addAll(onData);
          },
          onError: (err) {
            print(err);
          },
          onDone: () async {
            if (await file.exists()) {
              await file.delete();
            }
            var result = await File(file.path).writeAsBytes(bytes);
            if (result != null) {
              if (await Directory(global.contentDirectoryPath).exists()) {
                await Directory(global.contentDirectoryPath).delete(recursive: true);
              }
              _decodeZip(file.path, global.contentDirectoryPath);
              await showStatusMessage(global.appLocaleValues['txt_backup_success_desc'], Icon(Icons.cloud_done, color: Colors.green, size: 50.0));
              exit(0);
            } else {
              print('Backup download failed');
            }
          },
        );
      } else {
        print('Backup download failed');
      }
    } catch (err) {
      print('Exception: backupAndRestoreScreen.dart - _download() ' + err.toString());
    }
  }

  // Future<GoogleHttpClient> _handleGoogleSignIn() async {
  //   try {
  //     if (br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail).isEmpty) {
  //       await _googleSignIn.signIn();
  //       if (_googleSignIn.currentUser != null && _googleSignIn.currentUser.email != null && _googleSignIn.currentUser.email.isNotEmpty) {
  //         await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.googleBackupEmail, _googleSignIn.currentUser.email);
  //         // await br.updateSystemFlagValue(global.systemFlagNameList.googleBackupEmail, _googleSignIn.currentUser.email);

  //         await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.emailForEmail, _googleSignIn.currentUser.email);
  //         // await br.updateSystemFlagValue(global.systemFlagNameList.emailForEmail, _googleSignIn.currentUser.email);
  //       }
  //     } else {
  //       await _googleSignIn.signInSilently();
  //     }

  //     if (br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail).isNotEmpty && _googleSignIn.currentUser == null) {
  //       await _googleSignIn.disconnect();
  //       await _googleSignIn.signOut();
  //       await _googleSignIn.signIn();
  //     }

  //     return GoogleHttpClient(await _googleSignIn.currentUser.authHeaders);
  //   } catch (error) {
  //     print('Exception: backupAndRestoreScreen.dart - _handleGoogleSignIn() ' + error.toString());
  //     return null;
  //   }
  // }

  void _restoreConfirmationDialog(BuildContext context, bool isGoogleRestore) {
    AlertDialog dialog = AlertDialog(
      title: Text(
        global.appLocaleValues['lbl_restore_data'],
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      shape: nativeTheme().dialogTheme.shape,
      content: Text(global.appLocaleValues['lbl_restore_data_message']),
      actions: <Widget>[
        FlatButton(
          child: Text(global.appLocaleValues['btn_no']),
          onPressed: () {
            closeDialog();
          },
        ),
        FlatButton(
          child: Text(global.appLocaleValues['btn_yes']),
          onPressed: () {
            if (isGoogleRestore) {
              _restoreFromGoogleDrive();
            } else {
              // _restoreFromLocalStorage();
            }
          },
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  void _restoreFromGoogleDrive() async {
    try {
      showLoader(global.appLocaleValues['lbl_restoring']);
      final httpClient = await handleGoogleSignIn();
      if (httpClient != null) {
        File file = File(global.documentsDirectoryPath + '/easyaccount.bak');
        await _download(file, httpClient);
        hideLoader();
      } else {
        print('Google Authentication Error');
      }
    } catch (err) {
      print('Exception: backupAndRestoreScreen.dart - _restoreFromGoogleDrive() ' + err.toString());
    }
  }

  Future isBackupAvailable() async {
    try {
       isConnected = await checkConnectivity();
       if (isConnected) {
         isGoogleBackupExist = await _checkBackupExist('easyaccount.bak', googleDrive.DownloadOptions.metadata);
         if (googleBackupTime != null) {
           googleBackupTime = googleBackupTime.toLocal();
         }
         setState(() {});
       }
    } catch (e) {
      print('Exception: backupAndRestoreScreen.dart - isBackupAvailable() ' + e.toString());
    }
  }

  // void _localBackupConfirmationDialog(BuildContext context) async {
  //   if
  //       // (screenId == 1 ?
  //       // (isGoogleBackupExist != null && isGoogleBackupExist) :
  //       (_enableRestoreFromLocal != null && _enableRestoreFromLocal)
  //   // )
  //   {
  //     // show dialog if backup available
  //     AlertDialog dialog = AlertDialog(
  //       title: Text(
  //         global.appLocaleValues['lbl_backup_data'],
  //         style: TextStyle(
  //           color: Theme.of(context).accentColor,
  //         ),
  //       ),
  //       shape: nativeTheme().dialogTheme.shape,
  //       content: Text(global.appLocaleValues['desc_backup_data']),
  //       actions: <Widget>[
  //         FlatButton(
  //           child: Text(global.appLocaleValues['btn_no']),
  //           onPressed: () {
  //             closeDialog();
  //           },
  //         ),
  //         FlatButton(
  //           child: Text(global.appLocaleValues['btn_yes']),
  //           onPressed: () async {
  //             closeDialog();
  //             // if (screenId == 1) {
  //             //   isConnected = await checkConnectivity();
  //             //   if (isConnected) {
  //             //     await _backUpData(true);
  //             //     localBackupStatusRefresh();
  //             //     googleBackupStatusRefresh();
  //             //   } else {
  //             //     Navigator.of(context).push(MaterialPageRoute(
  //             //         builder: (BuildContext context) => NetWorkErrorScreen(
  //             //               a: widget.analytics,
  //             //               o: widget.observer,
  //             //             )));
  //             //   }
  //             // }
  //             //  else {

  //             await _localBackUpData();
  //             localBackupStatusRefresh();
  //             await isLocalBackupAvailable();
  //             setState(() {});
  //             // }
  //           },
  //         ),
  //       ],
  //     );

  //     showDialog(context: context, builder: (_) => dialog);
  //   } else {
  //     // if (screenId == 1) {
  //     //   isConnected = await checkConnectivity();
  //     //   if (isConnected) {
  //     //     await _backUpData(true);
  //     //     localBackupStatusRefresh();
  //     //     googleBackupStatusRefresh();
  //     //   } else {
  //     //     Navigator.of(context).push(MaterialPageRoute(
  //     //         builder: (BuildContext context) => NetWorkErrorScreen(
  //     //               a: widget.analytics,
  //     //               o: widget.observer,
  //     //             )));
  //     //   }
  //     // } else {
  //     await _localBackUpData();
  //     localBackupStatusRefresh();
  //     await isLocalBackupAvailable();
  //     setState(() {});
  //     // }
  //   }
  // }

  void _logoutDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: Text(
        '${global.appLocaleValues['tle_logout']}',
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      shape: nativeTheme().dialogTheme.shape,
      content: Text('${global.appLocaleValues['ggl_logout_desc']}'),
      actions: <Widget>[
        FlatButton(
          child: Text(global.appLocaleValues['btn_no']),
          onPressed: () {
            closeDialog();
          },
        ),
        FlatButton(
          child: Text(global.appLocaleValues['btn_yes']),
          onPressed: () async {
            closeDialog();
            await googleSignIn.signOut();
            await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.googleBackupEmail, null);
            await br.updateSystemFlagValue(global.systemFlagNameList.googleBackupEmail, null);
            setState(() {});
          },
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  // void _deleteLocalBackupDialog(BuildContext context) {
  //   AlertDialog dialog = AlertDialog(
  //     title: Text(
  //       'Delete Backup',
  //       style: TextStyle(
  //         color: Theme.of(context).accentColor,
  //       ),
  //     ),
  //     shape: nativeTheme().dialogTheme.shape,
  //     content: Text(
  //       'Local backup can not be recovered once deleted. Are you sure you want to permanent delete local backup?',
  //       textAlign: TextAlign.justify,
  //     ),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: Text(global.appLocaleValues['btn_no']),
  //         onPressed: () {
  //           closeDialog();
  //         },
  //       ),
  //       FlatButton(
  //         child: Text(global.appLocaleValues['btn_yes']),
  //         onPressed: () async {
  //           closeDialog();
  //           File _file = File(global.localBackupDirectoryPath);
  //           try {
  //             await _file.delete();
  //           } catch (e) {
  //             print(e.toString());
  //           }
  //           await isLocalBackupAvailable();
  //           setState(() {});
  //         },
  //       ),
  //     ],
  //   );

  //   showDialog(context: context, builder: (_) => dialog);
  // }

  void _deleteGoogleBackupDialog(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      title: Text(
        '${global.appLocaleValues['dlt_backup']}',
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      shape: nativeTheme().dialogTheme.shape,
      content: Text(
        '${global.appLocaleValues['dlt_backup_desc']}',
        textAlign: TextAlign.justify,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(global.appLocaleValues['btn_no']),
          onPressed: () {
            closeDialog();
          },
        ),
        FlatButton(
          child: Text(global.appLocaleValues['btn_yes']),
          onPressed: () async {
            await _deleteBackup();
          },
        ),
      ],
    );

    showDialog(context: context, builder: (_) => dialog);
  }

  Future _deleteBackup() async {
    try {
       closeDialog();
       final httpClient = await handleGoogleSignIn();
       var drive = googleDrive.DriveApi(httpClient);
       await drive.files.list(q: "name='${global.googleDriveBackupFolder}' and mimeType='application/vnd.google-apps.folder'").then((response) async {
         if (response.files.length > 0) {
           await drive.files.delete(response.files[0].id);
         }
       }).catchError((error) async {
         print('Unable to delete google backup file');
       });
       // await isBackupAvailable(true);
       isGoogleBackupExist = false;
       googleBackupTime = null;
       global.googleBackupResult = null;
       setState(() {});
    } catch (e) {
      print('Exception in delete google backup: ${e.toString()}');
    }
  }

  // _backUpData(bool _isGoogleBackup) async {
  //   try {
  //     if (_googleBackupResult == null) {
  //       _googleBackupResult = MethodResult();
  //       _googleBackupResult.statusMessage = '${global.appLocaleValues['txt_taking_backup']}';
  //       if (this.mounted) {
  //         setState(() {});
  //       }
  //       _googleBackupResult = await _takeGoogleBackUp();
  //       if (this.mounted) {
  //         setState(() {});
  //       }
  //       await isLocalBackupAvailable();
  //       await isBackupAvailable();
  //       if (this.mounted) {
  //         setState(() {});
  //       }

  //       global.isAppStarted = false;
  //     }
  //   } catch (e) {
  //     print("Exception - backupAndRestoreScreen.dart - _backUpData():" + e.toString());
  //   }
  // }

  // _localBackUpData() async {
  //   try {
  //     if (_localBackupResult == null) {
  //       _localBackupResult = MethodResult();
  //       _localBackupResult.statusMessage = '${global.appLocaleValues['txt_taking_backup']}';
  //       if (this.mounted) {
  //         setState(() {});
  //       }
  //       _localBackupResult = await _takeLocalBackUp();
  //       if (this.mounted) {
  //         setState(() {});
  //       }
  //       if (this.mounted) {
  //         setState(() {});
  //       }

  //       global.isAppStarted = false;
  //     }
  //   } catch (e) {
  //     print("Exception - backupAndRestoreScreen.dart - _backUpData():" + e.toString());
  //   }
  // }

  // Future isLocalBackupAvailable() async {
  //   try {
  //     _enableRestoreFromLocal = false;
  //     localBackupTime = null;
  //     File _file = File(global.localBackupDirectoryPath);
  //     if (await _file.exists()) {
  //       localBackupTime = await _file.lastModified();
  //       if (localBackupTime != null) {
  //         localBackupTime = localBackupTime.toLocal();
  //       }
  //       setState(() {
  //         _enableRestoreFromLocal = true;
  //       });
  //     } else {
  //       print('local backup is not available');
  //     }
  //   } catch (e) {
  //     print('Exception: backupAndRestoreScreen.dart - isLocalBackupAvailable() ' + e.toString());
  //   }
  // }

  // Future _restoreFromLocalStorage() async {
  //   try {
  //     showLoader('restoring...');
  //     if (await File(global.localBackupDirectoryPath).exists()) {
  //       if (await Directory(global.contentDirectoryPath).exists()) {
  //         await Directory(global.contentDirectoryPath).delete(recursive: true);
  //       }
  //       File _file = File(global.localBackupDirectoryPath);
  //       _decodeZip(_file.path, global.contentDirectoryPath);
  //       await showStatusMessage('Your data successfully restored. Please restart the app', Icon(Icons.cloud_done, color: Colors.green, size: 50.0));
  //       exit(0);
  //     }
  //   } catch (e) {
  //     print('Exception: backupAndRestoreScreen.dart - _restoreFromLocalStorage() ' + e.toString());
  //   }
  // }

  // Future<MethodResult> _takeLocalBackUp() async {
  //   MethodResult result = MethodResult();
  //   try {
  //     bool _uploadResult = false;
  //     // showLoader(message);
  //     var encoder = ZipFileEncoder();
  //     encoder.zipDirectory(Directory(global.contentDirectoryPath), filename: global.documentsDirectoryPath + '/invoices.bak');
  //     File file = File(global.documentsDirectoryPath + '/invoices.bak');

  //     File _file = File(global.localBackupDirectoryPath);
  //     try {
  //       if (!await _file.exists()) {
  //         await file.copy(global.localBackupDirectoryPath);
  //         _uploadResult = true;
  //       } else {
  //         await _file.delete();
  //         await file.copy(global.localBackupDirectoryPath);
  //         _uploadResult = true;
  //       }
  //     } catch (e) {
  //       print(e.toString());
  //     }

  //     // hideLoader();
  //     if (_uploadResult) {
  //       result.statusCode = 1;
  //       result.statusMessage = '${global.appLocaleValues['txt_backup_success']}';
  //     } else {
  //       result.statusCode = 0;
  //       result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
  //     }
  //   } catch (e) {
  //     result.statusCode = -1;
  //     result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
  //     print("Exception - backupAndRestoreScreen.dart - _takeLocalBackUp():" + e.toString());
  //   }
  //   return result;
  // }

  // Future<MethodResult> _takeGoogleBackUp() async {
  //   MethodResult result = MethodResult();
  //   try {
  //     if (br.getSystemFlagValue(global.systemFlagNameList.enableGoogleBackupRestore) == 'true') {
  //       bool isConnected = await checkConnectivity();
  //       if (isConnected) {
  //         bool _uploadResult = false;
  //         // showLoader(message);
  //         final httpClient = await _handleGoogleSignIn();
  //         if (httpClient != null) {
  //           var encoder = ZipFileEncoder();
  //           encoder.zipDirectory(Directory(global.contentDirectoryPath), filename: global.documentsDirectoryPath + '/invoices.bak');
  //           File file = File(global.documentsDirectoryPath + '/invoices.bak');
  //           _uploadResult = await _upload(file, httpClient);
  //           File _file = File(global.localBackupDirectoryPath);
  //           try {
  //             if (await _file.exists()) {
  //               await _file.delete();
  //             }
  //             await file.copy(global.localBackupDirectoryPath);
  //             _uploadResult = true;
  //           } catch (e) {
  //             print(e.toString());
  //           }

  //           // hideLoader();
  //           if (_uploadResult) {
  //             result.statusCode = 1;
  //             result.statusMessage = '${global.appLocaleValues['txt_backup_success']}';
  //             await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.backUpTime, DateTime.now().toIso8601String());
  //             await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'false');
  //           } else {
  //             result.statusCode = 0;
  //             result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
  //           }
  //         } else {
  //           result.statusCode = 0;
  //           result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
  //           print('Google Authentication Error');
  //         }
  //       } else {
  //         result.statusCode = 2;
  //         result.statusMessage = '${global.appLocaleValues['lbl_offline']}';
  //       }
  //     }
  //   } catch (e) {
  //     result.statusCode = -1;
  //     result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
  //     print("Exception - base.dart - _takeGoogleBackUp():" + e.toString());
  //   }
  //   return result;
  // }

  // Future<bool> _upload(File file, httpClient) async {
  //   try {
  //     var folderResponse;
  //     var fileResponse;
  //     String folderId;
  //     var drive = googleDrive.DriveApi(httpClient);
  //     var folder = await drive.files.list(q: "name='${global.googleDriveBackupFolder}' and mimeType='application/vnd.google-apps.folder'");
  //     for (var item in folder.files) {
  //       print(item.name);
  //     }

  //     if (folder.files.length == 0) {
  //       googleDrive.File googleFolder = googleDrive.File();
  //       googleFolder.name = global.googleDriveBackupFolder;
  //       googleFolder.mimeType = 'application/vnd.google-apps.folder';
  //       folderResponse = await drive.files.create(googleFolder);

  //       if (folderResponse != null) {
  //         folderId = folderResponse.id;
  //       } else {
  //         print('Unable to create backup folder');
  //       }
  //     } else {
  //       folderId = folder.files[0].id;
  //     }

  //     googleDrive.File googleFile = googleDrive.File();
  //     googleFile.name = p.basename(file.absolute.path);

  //     if (folderId != "") {
  //       print(file.absolute.path);
  //       await drive.files.list(q: "name='${p.basename(file.absolute.path)}' and '$folderId' in parents").then((response) async {
  //         if (response.files.length > 0) {
  //           fileResponse = await drive.files.update(
  //             googleFile,
  //             response.files[0].id,
  //             uploadMedia: googleDrive.Media(
  //               file.openRead(),
  //               file.lengthSync(),
  //             ),
  //           );
  //         } else {
  //           googleFile.parents = [folderId].toList();
  //           fileResponse = await drive.files.create(
  //             googleFile,
  //             uploadMedia: googleDrive.Media(
  //               file.openRead(),
  //               file.lengthSync(),
  //             ),
  //           );
  //         }
  //       }).catchError((error) async {
  //         print('Unable to sync backup file');
  //       });
  //     }
  //     if (fileResponse != null) {
  //       print(fileResponse.id);
  //       return true;
  //     }
  //   } catch (err) {
  //     print(err.toString());
  //   }
  //   return false;
  // }

  void googleBackupStatusRefresh() {
    //Update backup status if taken from other screen
    if (global.googleBackupResult != null) {
      Timer.periodic(Duration(seconds: 3), (Timer t) {
        setState(() {});

        if (global.googleBackupResult.statusCode != null && global.googleBackupResult.statusCode >= 0) {
          t.cancel();
          //backup success
          Timer(Duration(seconds: 3), () {
            global.googleBackupResult = null;
            setState(() {});
          });
        }
      });
    }
  }

  // void localBackupStatusRefresh() {
  //   //Update backup status if taken from other screen
  //   if (_localBackupResult != null) {
  //     Timer.periodic(Duration(seconds: 3), (Timer t1) {
  //       setState(() {});

  //       if (_localBackupResult.statusCode != null && _localBackupResult.statusCode >= 0) {
  //         t1.cancel();
  //         //backup success
  //         Timer(Duration(seconds: 3), () {
  //           _localBackupResult = null;
  //           setState(() {});
  //         });
  //       }
  //     });
  //   }
  // }
}
