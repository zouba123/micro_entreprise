// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/userModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ProfilePersonalSettingsScreen extends BaseRoute {
  ProfilePersonalSettingsScreen({@required a, @required o}) : super(a: a, o: o, r: 'ProfilePersonalSettingsScreen');
  @override
  _ProfilePersonalSettingsScreenState createState() => _ProfilePersonalSettingsScreenState();
}

class _ProfilePersonalSettingsScreenState extends BaseRouteState {
  var _formKey = GlobalKey<FormState>();
  var _cFirstName = TextEditingController();
  var _cLastName = TextEditingController();
  var _cEmail = TextEditingController();
  var _cMobile = TextEditingController();
  var _cBirthdate = TextEditingController();
  bool _autovalidate = false;
  List<User> list = [];
  bool readOnly = true;
  String birthDate2;

  _ProfilePersonalSettingsScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['tle_personal_profile'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
      ),
      floatingActionButton: (readOnly)
          ? FloatingActionButton(
              child: Icon(Icons.edit),
              //    backgroundColor: Colors.orangeAccent,
              elevation: 0,
              mini: true,
              onPressed: () {
                setState(() {
                  readOnly = false;
                });
              },
            )
          : SizedBox(),
      body: WillPopScope(
        onWillPop: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  a: widget.analytics,
                  o: widget.observer,
                ))),
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: (_autovalidate) ? AutovalidateMode.always : AutovalidateMode.disabled,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: <Widget>[
                    (readOnly)
                        ? Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    "${global.appLocaleValues['lbl_name']}",
                                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                  ),
                                  subtitle: Text('${global.user.firstName} ${global.user.lastName}', style: Theme.of(context).primaryTextTheme.headline3),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: Text(
                                    "${global.appLocaleValues['txt_email']}",
                                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                  ),
                                  subtitle: Text('${global.user.email}', style: Theme.of(context).primaryTextTheme.headline3),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: Text(
                                    "${global.appLocaleValues['lbl_contact_']}",
                                    style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                  ),
                                  subtitle: Text('${global.user.mobile}', style: Theme.of(context).primaryTextTheme.headline3),
                                ),
                              ),
                              (global.user.birthdate != null)
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "${global.appLocaleValues['lbl_birth_date']}",
                                          style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                        ),
                                        subtitle: Text('${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(global.user.birthdate)}', style: Theme.of(context).primaryTextTheme.headline3),
                                      ),
                                    )
                                  : SizedBox()
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Full Name', style: Theme.of(context).primaryTextTheme.headline3),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _cFirstName,
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return global.appLocaleValues['vel_firstName'];
                                          } else if (v.contains(RegExp('[0-9]'))) {
                                            return global.appLocaleValues['vel_character_only'];
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: global.appLocaleValues['txt_firstName'],
                                          border: nativeTheme().inputDecorationTheme.border,
                                          suffixIcon: Icon(
                                            Icons.star,
                                            size: 9,
                                            color: Colors.red,
                                          ),
                                          // labelText: global.appLocaleValues['txt_firstName'],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: TextFormField(
                                        textCapitalization: TextCapitalization.sentences,
                                        controller: _cLastName,
                                        validator: (v) {
                                          if (v.isEmpty) {
                                            return global.appLocaleValues['hnt_lastName'];
                                          } else if (v.contains(RegExp('[0-9]'))) {
                                            return global.appLocaleValues['vel_character_only'];
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: global.appLocaleValues['txt_lastName'],
                                          border: nativeTheme().inputDecorationTheme.border,
                                          suffixIcon: Icon(
                                            Icons.star,
                                            size: 9,
                                            color: Colors.red,
                                          ),
                                          // labelText: global.appLocaleValues['txt_lastName'],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(global.appLocaleValues['txt_email'], style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _cEmail,
                                  readOnly: true,
                                  validator: (v) {
                                    if (v.isEmpty) {
                                      return global.appLocaleValues['hnt_email_address'];
                                    } else if (v.isNotEmpty) {
                                      if (EmailValidator.validate(v) != true) {
                                        return global.appLocaleValues['lbl_email_err_req'];
                                      }
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['txt_email'],
                                    // labelText: global.appLocaleValues['txt_email'],
                                    suffixIcon: Icon(
                                      Icons.star,
                                      size: 9,
                                      color: Colors.red,
                                    ),
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(global.appLocaleValues['lbl_contact_'], style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  // textCapitalization: TextCapitalization.sentences,
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 10,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  controller: _cMobile,
                                  validator: (v) {
                                    if (v.isEmpty) {
                                      return global.appLocaleValues['hnt_contactno'];
                                    } else if (v.isNotEmpty) {
                                      if (v.length != 10) {
                                        return global.appLocaleValues['vel_contactno'];
                                      }
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['lbl_contact_'],
                                    // labelText: global.appLocaleValues['lbl_contact_'],
                                    border: nativeTheme().inputDecorationTheme.border,
                                    suffixIcon: Icon(
                                      Icons.star,
                                      size: 9,
                                      color: Colors.red,
                                    ),
                                    counterText: '',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${global.appLocaleValues['lbl_birth_date']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _cBirthdate,
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['lbl_birth_date'],
                                    // labelText: '${global.appLocaleValues['lbl_birth_date']} (${global.appLocaleValues['lbl_optional']})',
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: (readOnly)
          ? SizedBox()
          : Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: EdgeInsets.only(bottom: 15, right: 8, left: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.cancel,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            Text(
                              ' ${global.appLocaleValues['btn_cancel']}',
                              style: Theme.of(context).primaryTextTheme.headline3,
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            readOnly = true;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.save,
                              color: Colors.white,
                            ),
                            Text(
                              ' ${global.appLocaleValues['btn_save']}',
                              style: Theme.of(context).primaryTextTheme.headline2,
                            )
                          ],
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            global.user.firstName = _cFirstName.text.trim();
                            global.user.lastName = _cLastName.text.trim();
                            global.user.mobile = int.parse(_cMobile.text.trim());
                            global.user.email = _cEmail.text.trim();
                            global.user.birthdate = (birthDate2 != null) ? DateTime.parse(birthDate2) : null;

                            await dbHelper.userUpdate(global.user);
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                builder: (context) => ProfilePersonalSettingsScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )));
                          } else {
                            _autovalidate = true;
                            setState(() {});
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future getData() async {
    try {
      if (global.user != null) {
        _cFirstName.text = global.user.firstName;
        _cLastName.text = global.user.lastName;
        _cEmail.text = global.user.email;
        _cMobile.text = global.user.mobile.toString();
        if (global.user.birthdate != null) {
          _cBirthdate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(global.user.birthdate);
          birthDate2 = global.user.birthdate.toString();
        }
      }
      //print('id: ${_business.id}');
      setState(() {});
    } catch (e) {
      print('Exception - profilePersonalSettingsScreen.dart - getData(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000),
        firstDate: DateTime(1840),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() {
          //   _date=picked;
          _cBirthdate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          birthDate2 = picked.toString().substring(0, 10);
        });
      }
    } catch (e) {
      print('Exception - productTypeScreen.dart - _selectdate(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
