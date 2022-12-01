// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/registrationPersonalDetailsScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';

class RegistrationAskPermissionsScreen extends BaseRoute {
  RegistrationAskPermissionsScreen({@required a, @required o}) : super(a: a, o: o, r: 'RegistrationAskPermissionsScreen');
  @override
  _RegistrationAskPermissionsScreenState createState() => _RegistrationAskPermissionsScreenState();
}

class _RegistrationAskPermissionsScreenState extends BaseRouteState {
  // List<PermissionGroup> _permissionList = [];
  // PermissionStatus _permissionLocation;
  PermissionStatus _permissionCamera;
  PermissionStatus _permissionStorage;
  PermissionStatus _permissionContact;
  PermissionStatus _permissionPhone;
  bool _isPermissionGiven = false;

  _RegistrationAskPermissionsScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
          onWillPop: () {
            return null;
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 80,
                      ),
                      //-----
                      // Row(
                      //   children: [
                      //     Text(
                      //       global.appLocaleValues['tle_required_permission'],
                      //       style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                      //     ),
                      //   ],
                      // ),
                      //-----
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   width: 15,
                          // ),
                          Expanded(
                            child: Center(
                              child: Text(
                                global.appLocaleValues['tle_required_permission'],
                                style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          // ChangeLanguageButtonWidget(a: widget.analytics, o: widget.observer)
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        global.appLocaleValues['lbl_permission_message'],
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 60),
                        child: Column(
                          children: <Widget>[
                            (global.isAndroidPlatform)
                                ? Card(
                                    shape: nativeTheme().cardTheme.shape,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: (_permissionPhone == PermissionStatus.granted) ? Colors.green : Theme.of(context).primaryColorLight,
                                        radius: 22,
                                        child: Icon(
                                          Icons.phone,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        global.appLocaleValues['lbl_phone'],
                                        style: TextStyle(color: _titleColor(permissionStatus: _permissionPhone), fontSize: 20),
                                      ),
                                      subtitle: Text('To auto fetch your contact number.'),
                                      onTap: () async {
                                        if (_permissionPhone == PermissionStatus.denied || _permissionPhone == PermissionStatus.restricted) {
                                          _permissionPhone = await Permission.phone.request();
                                          // await PermissionHandler().requestPermissions([PermissionGroup.phone]);
                                          await _checkPermissions();
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  )
                                : SizedBox(),
                            //
                            Card(
                              shape: nativeTheme().cardTheme.shape,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: (_permissionContact == PermissionStatus.granted) ? Colors.green : Theme.of(context).primaryColorLight,
                                  radius: 22,
                                  child: Icon(
                                    Icons.people,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  global.appLocaleValues['lbl_contacts'],
                                  style: TextStyle(color: _titleColor(permissionStatus: _permissionContact), fontSize: 20),
                                ),
                                subtitle: Text(global.appLocaleValues['lbl_contact_stle']),
                                onTap: () async {
                                  if (_permissionContact == PermissionStatus.denied || _permissionContact == PermissionStatus.restricted) {
                                    _permissionContact = await Permission.contacts.request();
                                    //  await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
                                    await _checkPermissions();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            Card(
                              shape: nativeTheme().cardTheme.shape,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: (_permissionCamera == PermissionStatus.granted) ? Colors.green : Theme.of(context).primaryColorLight,
                                  radius: 22,
                                  child: Icon(
                                    Icons.camera,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  global.appLocaleValues['lbl_camera'],
                                  style: TextStyle(color: _titleColor(permissionStatus: _permissionCamera), fontSize: 20),
                                ),
                                subtitle: Text(global.appLocaleValues['lbl_camera_stle']),
                                onTap: () async {
                                  if (_permissionCamera == PermissionStatus.denied || _permissionCamera == PermissionStatus.restricted) {
                                    _permissionCamera = await Permission.camera.request();
                                    //   await PermissionHandler().requestPermissions([PermissionGroup.camera]);
                                    await _checkPermissions();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            Card(
                              shape: nativeTheme().cardTheme.shape,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: (_permissionStorage == PermissionStatus.granted) ? Colors.green : Theme.of(context).primaryColorLight,
                                  radius: 22,
                                  child: Icon(
                                    Icons.usb,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  global.appLocaleValues['lbl_storage'],
                                  style: TextStyle(color: _titleColor(permissionStatus: _permissionStorage), fontSize: 20),
                                ),
                                subtitle: Text(global.appLocaleValues['lbl_storage_stle']),
                                onTap: () async {
                                  if (_permissionStorage == PermissionStatus.denied || _permissionStorage == PermissionStatus.restricted) {
                                    _permissionStorage = await Permission.storage.request();
                                    //  await PermissionHandler().requestPermissions([PermissionGroup.storage]);
                                    await _checkPermissions();
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            // Card(
                            //   shape: nativeTheme().cardTheme.shape,
                            //   child: ListTile(
                            //     leading: CircleAvatar(
                            //       backgroundColor: (_permissionLocation == PermissionStatus.granted) ? Theme.of(context).primaryColorLight : Colors.black54,
                            //       radius: 22,
                            //       child: Icon(
                            //         Icons.location_on,
                            //         size: 20,
                            //         color: Colors.white,
                            //       ),
                            //     ),
                            //     title: Text(
                            //       global.appLocaleValues['lbl_location'],
                            //       style: TextStyle(color: _titleColor(permissionStatus: _permissionLocation), fontSize: 20),
                            //     ),
                            //     subtitle: Text(global.appLocaleValues['lbl_location_message']),
                            //     onTap: () async {
                            //       if (_permissionLocation == PermissionStatus.denied || _permissionLocation == PermissionStatus.undetermined) {
                            //         _permissionLocation = await Permission.location.request();
                            //         // await PermissionHandler().requestPermissions([PermissionGroup.phone]);
                            //         await _checkPermissions();
                            //       }
                            //       setState(() {});
                            //     },
                            //   ),
                            // ),
                            //
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
      bottomSheet: Padding(
        padding: EdgeInsets.only(left: 8, right: 8, bottom: 20),
        child: (!_isPermissionGiven)
            ? TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FittedBox(
                      child: Text(
                        global.appLocaleValues['btn_give_permission'], style: Theme.of(context).primaryTextTheme.headline2,
                        // style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                onPressed: () async {
                  _isPermissionGiven = true;
                  await _getPermissions();
                  setState(() {});
                },
              )
            : TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FittedBox(
                      child: Text(global.appLocaleValues['btn_continue'], style: Theme.of(context).primaryTextTheme.headline2),
                    ),
                  ],
                ),
                onPressed: (_isPermissionGiven)
                    ? () async {
                        await _permissionsDone();
                        // Navigator.of(context).push(PageTransition(
                        //     type: PageTransitionType.rightToLeft,
                        //     child: RegistrationSetSecurityPinScreen(
                        //       a: widget.analytics,
                        //       o: widget.observer,
                        //     )));
                        Navigator.of(context).push(PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: RegistrationPersonalDetailsScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )));
                      }
                    : null,
              ),
      ),
    );
  }

  _titleColor({PermissionStatus permissionStatus}) {
    try {
      if (permissionStatus == PermissionStatus.granted) {
        return Colors.green;
      } else {
        return Theme.of(context).primaryColorLight;
      }
    } catch (e) {
      print("Exception - registrationAskPermissionsScreen.dart - _titleColor():" + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _permissionsDone() async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.permissionsGranted, 'true');
    } catch (e) {
      print('Exception - askPermissionsScreen.dart - _permissionsDone(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future _checkPermissions() async {
    try {
      if(global.isAndroidPlatform)
      {
          _permissionPhone = await Permission.phone.status;
      }
      _permissionContact = await Permission.contacts.status;
      _permissionCamera = await Permission.camera.status;
      _permissionStorage = await Permission.storage.status;
      //    _permissionLocation = await Permission.location.status;
      setState(() {});
    } catch (e) {
      print('Exception - askPermissionsScreen.dart - _checkPermissions(): ' + e.toString());
    }
  }

  Future _getPermissions() async {
    try {
      if(global.isAndroidPlatform)
      {
        _permissionPhone = await Permission.phone.request();
      setState(() {});
      }
      _permissionContact = await Permission.contacts.request();
      setState(() {});
      _permissionCamera = await Permission.camera.request();
      setState(() {});
      _permissionStorage = await Permission.storage.request();
      setState(() {});
      // _permissionLocation = await Permission.location.request();
      // setState(() {});
    } catch (e) {
      print('Exception - askPermissionsScreen.dart - _getPermissions(): ' + e.toString());
    }
  }
}
