// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/widgets/drawerWidget.dart';

class ProfileBusinessSettingsScreen extends BaseRoute {
  ProfileBusinessSettingsScreen({@required a, @required o}) : super(a: a, o: o, r: 'ProfileBusinessSettingsScreen');
  @override
  _ProfileBusinessSettingsScreenState createState() => _ProfileBusinessSettingsScreenState();
}

class _ProfileBusinessSettingsScreenState extends BaseRouteState {
  var _formKey = GlobalKey<FormState>();
  var _cName = TextEditingController();
  var _cStartDate = TextEditingController();
  var _cAddressLine1 = TextEditingController();
  var _cGstNo = TextEditingController();
  var _cEmail = TextEditingController();
  var _cContact1 = TextEditingController();
  var _cWebsite = TextEditingController();
  var _cregistrationNumber = TextEditingController();
  var _logoPath;
  bool _readOnly = true;
  File _image;
  bool _autovalidate = false;
  String _startDate2;
  // Business _business;

  _ProfileBusinessSettingsScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          global.appLocaleValues['tle_business_profile'],
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width - 90,
        child: DrawerWidget(a: widget.analytics, o: widget.observer, routeName: widget.routeName),
      ),
      floatingActionButton: (_readOnly)
          ? FloatingActionButton(
              child: Icon(Icons.edit),
              // backgroundColor: Colors.orangeAccent,
              elevation: 0,
              mini: true,
              onPressed: () {
                setState(() {
                  _readOnly = false;
                  _logoPath = global.business.logoPath;
                  _cName.text = global.business.name;
                  _cContact1.text = (global.business.contact1 != null) ? global.business.contact1.toString() : '';
                  _cEmail.text = global.business.email;
                  _cWebsite.text = global.business.website;
                  // =global.business.logoPath;
                  if (global.business.startDate != null) {
                    //    _cStartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(_business.startDate));
                    _cStartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(global.business.startDate);
                    _startDate2 = global.business.startDate.toString();
                  }
                  _cAddressLine1.text = global.business.addressLine1;
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
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 120,
                            height: 120,
                            child: Card(
                                color: Colors.grey[50],
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Center(
                                      child: (_logoPath != null && _logoPath != '')
                                          ? Image.file(File(_logoPath))
                                          : Icon(
                                              Icons.work,
                                              size: 80,
                                              color: Theme.of(context).primaryColorLight,
                                            ),
                                    ))),
                          ),
                          (_readOnly)
                              ? SizedBox()
                              : Padding(
                                  padding: EdgeInsets.only(left: 90, top: 80),
                                  child: FloatingActionButton(
                                    backgroundColor: Colors.grey[50],
                                    child: Icon(
                                      Icons.add_a_photo,
                                      size: 25,
                                      color: Theme.of(context).primaryColorLight,
                                    ),
                                    onPressed: () async {
                                      await openUploadPicOptions(context);
                                    },
                                  ),
                                )
                        ],
                      ),
                    ),
                    (_readOnly)
                        ? Column(
                            children: [
                              Card(
                                child: ListTile(
                                  title: Text(
                                    "${global.appLocaleValues['lbl_business_name']}",
                                    style: Theme.of(context).primaryTextTheme.headline1,
                                  ),
                                  subtitle: Text(
                                    '${global.business.name}',
                                    style: Theme.of(context).primaryTextTheme.headline3,
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  title: Text(
                                    "${global.appLocaleValues['lbl_contact_']}",
                                    style: Theme.of(context).primaryTextTheme.headline1,
                                  ),
                                  subtitle: Text(
                                    '${global.user.mobile}',
                                    style: Theme.of(context).primaryTextTheme.headline3,
                                  ),
                                ),
                              ),
                              (global.business.registrationNo != null && global.business.registrationNo != '')
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "${global.appLocaleValues['lbl_registration_no']}",
                                          style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                                        ),
                                        subtitle: Text(
                                          '${global.business.registrationNo}',
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              // (global.business.registrationNo != null && global.business.registrationNo != '')
                              //     ? Card(
                              //       child: ListTile(
                              //           title: Text(
                              //             "${global.appLocaleValues['lbl_gst_no']}",
                              //             style: Theme.of(context).primaryTextTheme.headline1,
                              //           ),
                              //           subtitle:  Text(
                              //             '${global.business.gstNo}',
                              //             style: Theme.of(context).primaryTextTheme.headline3,
                              //           ),
                              //         ),
                              //     )
                              //     : SizedBox(),
                              global.business.email != null && global.business.email != ''
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "${global.appLocaleValues['txt_email']}",
                                          style: Theme.of(context).primaryTextTheme.headline1,
                                        ),
                                        subtitle: Text(
                                          '${global.business.email}',
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              global.business.website != null && global.business.website != ''
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "${global.appLocaleValues['lbl_business_website']}",
                                          style: Theme.of(context).primaryTextTheme.headline1,
                                        ),
                                        subtitle: Text(
                                          '${global.business.website}',
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              global.business.startDate != null
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "${global.appLocaleValues['lbl_business_start_date']}",
                                          style: Theme.of(context).primaryTextTheme.headline1,
                                        ),
                                        subtitle: Text(
                                          '${DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(global.business.startDate)}',
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              global.business.addressLine1 != null && global.business.addressLine1 != ''
                                  ? Card(
                                      child: ListTile(
                                        title: Text(
                                          "${global.appLocaleValues['lbl_business_address']}",
                                          style: Theme.of(context).primaryTextTheme.headline1,
                                        ),
                                        subtitle: Text(
                                          '${global.business.addressLine1}',
                                          style: Theme.of(context).primaryTextTheme.headline3,
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(global.appLocaleValues['lbl_business_name'], style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  controller: _cName,
                                  validator: (v) {
                                    if (v.isEmpty) {
                                      return '';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: nativeTheme().inputDecorationTheme.border,
                                    suffixIcon: Icon(
                                      Icons.star,
                                      size: 9,
                                      color: Colors.red,
                                    ),
                                    hintText: global.appLocaleValues['lbl_business_name'],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(global.appLocaleValues['lbl_business_contact'], style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                  maxLength: 10,
                                  controller: _cContact1,
                                  validator: (v) {
                                    if (v.isEmpty) {
                                      return global.appLocaleValues['hnt_contactno'];
                                    } else if (v.length != 10) {
                                      return global.appLocaleValues['vel_contactno'];
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: nativeTheme().inputDecorationTheme.border,
                                    hintText: global.appLocaleValues['lbl_business_contact'],
                                    // labelText: global.appLocaleValues['lbl_business_contact'],
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
                                child: Text('${global.appLocaleValues['lbl_registration_no']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  keyboardType: TextInputType.text,
                                  controller: _cregistrationNumber,
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['lbl_registration_no'],
                                    border: nativeTheme().inputDecorationTheme.border,
                                    counterText: '',
                                  ),
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only( top: 10),
                              //   child: Text('${global.appLocaleValues['lbl_gst_no']} (${global.appLocaleValues['lbl_optional']})',style: Theme.of(context).primaryTextTheme.headline3),
                              // ),
                              // Padding(
                              //   padding: EdgeInsets.only(top: 5),
                              //   child: TextFormField(
                              //     textCapitalization: TextCapitalization.characters,
                              //     controller: _cGstNo,
                              //     textInputAction: TextInputAction.done,
                              //     onChanged: (v) {
                              //       global.business.gstNo = v;
                              //     },
                              //     validator: (v) {
                              //       if (v.isNotEmpty) {
                              //         if (v.trim().indexOf('-') == 0 || v.trim().indexOf('-') == (v.length - 1)) {
                              //           return global.appLocaleValues['lbl_gst_no_err_vld'];
                              //         }
                              //       }
                              //       return null;
                              //     },
                              //     //   inputFormatters: [FilteringTextInputFormatter(RegExp('[A-Z0-9,-]'))],
                              //     inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[A-Z0-9,-]'))],

                              //     decoration: InputDecoration(hintText: '${global.appLocaleValues['lbl_gst_no']} (${global.appLocaleValues['lbl_optional']})', border: OutlineInputBorder()),
                              //   ),
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${global.appLocaleValues['lbl_business_email']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  // textCapitalization: TextCapitalization.sentences,
                                  controller: _cEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    if (v.isNotEmpty) {
                                      if (EmailValidator.validate(v) != true) {
                                        return global.appLocaleValues['lbl_email_err_req'];
                                      }
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['lbl_business_email'],
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${global.appLocaleValues['lbl_business_website']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  // textCapitalization: TextCapitalization.sentences,
                                  controller: _cWebsite,
                                  keyboardType: TextInputType.url,
                                  // validator: (v) {
                                  //   if (v.isEmpty) {
                                  //     return 'enter _business website';
                                  //   }
                                  // },
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['lbl_business_website'],
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${global.appLocaleValues['lbl_business_start_date']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: TextFormField(
                                  // textCapitalization: TextCapitalization.sentences,
                                  readOnly: true,
                                  controller: _cStartDate,
                                  // validator: (v) {
                                  //   if (v.isEmpty) {
                                  //     return 'choose start date';
                                  //   }
                                  // },
                                  decoration: InputDecoration(
                                    hintText: global.appLocaleValues['lbl_business_start_date'],
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text('${global.appLocaleValues['lbl_business_address']} (${global.appLocaleValues['lbl_optional']})', style: Theme.of(context).primaryTextTheme.headline3),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 70),
                                child: TextFormField(
                                  textCapitalization: TextCapitalization.sentences,
                                  controller: _cAddressLine1,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: '${global.appLocaleValues['lbl_business_address']} (${global.appLocaleValues['lbl_optional']})',
                                    border: nativeTheme().inputDecorationTheme.border,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: (_readOnly)
          ? SizedBox()
          : Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.cancel, color: Theme.of(context).primaryColorDark, size: 21),
                            Text(
                              ' ${global.appLocaleValues['btn_cancel']}',
                              style: Theme.of(context).primaryTextTheme.headline3,
                            )
                          ],
                        ),
                        onPressed: () {
                          _logoPath = global.business.logoPath;
                          setState(() {
                            _readOnly = true;
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
                                size: 21,
                              ),
                              Text(' ${global.appLocaleValues['btn_save']}', style: Theme.of(context).primaryTextTheme.headline2)
                            ],
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              global.business.name = _cName.text.trim();
                              global.business.contact1 = int.parse(_cContact1.text.trim());
                              global.business.registrationNo = _cregistrationNumber.text.trim();
                              global.business.email = _cEmail.text.trim();
                              global.business.website = _cWebsite.text.trim();
                              global.business.startDate = (_startDate2 != null) ? DateTime.parse(_startDate2) : null;
                              global.business.addressLine1 = (_cAddressLine1.text.length > 0) ? _cAddressLine1.text.trim() : '';
                              global.business.logoPath = _logoPath;
                              await dbHelper.businessUpdate(global.business);
                              try {
                                if (_formKey.currentState.validate()) {
                                  global.business.name = _cName.text;
                                  global.business.contact1 = int.parse(_cContact1.text);
                                  global.business.registrationNo = _cregistrationNumber.text;
                                  global.business.email = _cEmail.text;
                                  global.business.website = _cWebsite.text;
                                  global.business.startDate = (_startDate2 != null) ? DateTime.parse(_startDate2) : null;
                                  global.business.addressLine1 = _cAddressLine1.text;
                                  global.business.logoPath = _logoPath;
                                  print('image: $_logoPath');
                                  await dbHelper.businessUpdate(global.business);

                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (context) => ProfileBusinessSettingsScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                          )));
                                } else {
                                  _autovalidate = true;
                                  setState(() {});
                                }
                              } catch (e) {
                                print('Exception - profileBusinessSettingsScreen.dart - Save(): ' + e.toString());
                              }
                            } else {
                              _autovalidate = true;
                              setState(() {});
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future getData() async {
    try {
      global.business = await dbHelper.businessGetList();

      if (global.business != null) {
        _logoPath = global.business.logoPath;
        _cName.text = global.business.name;
        _cGstNo.text = global.business.gstNo;
        _cContact1.text = global.business.contact1.toString();
        _cEmail.text = global.business.email;
        _cWebsite.text = global.business.website;
        _cregistrationNumber.text = global.business.registrationNo;
        if (global.business.startDate != null) {
          _cStartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(global.business.startDate);
          _startDate2 = global.business.startDate.toString();
        }
        _cAddressLine1.text = global.business.addressLine1;
      }
      //print('id: ${_business.id}');
      setState(() {});
    } catch (e) {
      print('Exception - profileBuisnessSettings.dart - getData(): ' + e.toString());
    }
  }

  Future getPath() async {
    try {
      _logoPath = global.businessImagesDirectoryPath;
    } catch (e) {
      print('Exception - profileBuisnessSettings.dart - getPath(): ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future openUploadPicOptions(context) async {
    try {
      //choose options for upload pic
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bcon) {
            return Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.camera_alt,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(global.appLocaleValues['txt_camera']),
                    onTap: () async {
                      await picImageCamera();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.photo_album,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(global.appLocaleValues['txt_gallery']),
                    onTap: () async {
                      await uploadLogo();
                      Navigator.pop(context);
                    },
                  ),
                  (_logoPath != null)
                      ? ListTile(
                          leading: Icon(
                            Icons.cancel,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(global.appLocaleValues['txt_remove_profile']),
                          onTap: () {
                            setState(() {
                              _logoPath = null;
                            });
                            Navigator.pop(context);
                          },
                        )
                      : SizedBox(),
                  ListTile(
                    leading: Icon(
                      Icons.cancel,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    title: Text(global.appLocaleValues['txt_cancel']),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print('Exception - profileBuisnessSettings.dart - openUploadPicOptions(): ' + e.toString());
    }
  }

  picImageCamera() async {
    // when user select camera for upload pic
    try {
      global.isAppOperation = true;
      ImagePicker _picker = ImagePicker();
      final img = await _picker.pickImage(source: ImageSource.camera);
      File imageFile = File(img.path);
      if (imageFile != null) {
        getPath();
        global.isAppOperation = true;
        File croppedFile = await ImageCropper.cropImage(
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          sourcePath: imageFile.path,
          maxWidth: 512,
          maxHeight: 512,
        );
        if (croppedFile != null) {
          setState(() {
            _image = croppedFile;
          });
          String imgTime = DateTime.now().toString();
          final File newImage = await _image.copy('$_logoPath/img$imgTime.png');
          //   print('path: ${newImage.path}');
          _logoPath = newImage.path;
        }
      }
    } catch (e) {
      print('Exception - profileBuisnessSettings.dart - picImageCamera(): ' + e.toString());
    }
  }

  Future uploadLogo() async {
    try {
      global.isAppOperation = true;
      ImagePicker _picker = ImagePicker();
      final img = await _picker.pickImage(source: ImageSource.gallery);
      File imageFile = File(img.path);
      if (imageFile != null) {
        getPath();

        setState(() {
          _image = imageFile;
        });
        String imgTime = DateTime.now().toString();
        final File newImage = await _image.copy('$_logoPath/img$imgTime.png');

        _logoPath = newImage.path;
        print('logopath: $_logoPath');
      }
      setState(() {});
    } catch (e) {
      print('Exception - profileBuisnessSettings.dart - uploadLogo(): ' + e.toString());
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    try {
      // choose dob
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1840),
        lastDate: DateTime.now(),
      );
      if (picked != null) {
        setState(() {
          //   _date=picked;
          _cStartDate.text = DateFormat(br.getSystemFlagValue(global.systemFlagNameList.dateFormat)).format(DateTime.parse(picked.toString().substring(0, 10)));
          _startDate2 = picked.toString().substring(0, 10);
        });
      }
    } catch (e) {
      print('Exception - profileBuisnessSettings.dart - _selectDate(): ' + e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
