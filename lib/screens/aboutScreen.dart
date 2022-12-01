// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends BaseRoute {
  AboutScreen({@required a, @required o}) : super(a: a, o: o, r: 'AboutUsScreen');

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends BaseRouteState {
  //double sizeContainer, logoWidth, logoHeight, textSizeAB, logoNative, textSizePB, iconSize, sizeboxTop;
  _AboutScreenState() : super();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _checkBackPress,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            global.appLocaleValues['tle_abt_us'],
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          //borderRadius:  BorderRadius.circular(10.0),
                          //border:  Border.all(color: Colors.grey[200]),
                          image: DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        subtitle: Text(
                          global.appVersion,
                          style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColorLight),
                        ),
                        title: Text(
                          "${global.appName}",
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    isThreeLine: true,
                    title: Text(
                      "${global.appLocaleValues['lbl_desc']}",
                      style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        global.appLocaleValues['txt_description'],
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          global.isAppOperation = true;
                          launch('mailto: hermi.zied@gmail.com');
                        },
                        title: Text(
                          "${global.appLocaleValues['txt_email']}",
                          style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                        ),
                        subtitle: Text(
                          'hermi.zied@gmail.com',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          _onWebsite();
                        },
                        title: Text(
                          "${global.appLocaleValues['lbl_website']}",
                          style: TextStyle(fontSize: 16.0, color: Theme.of(context).primaryColor),
                        ),
                        subtitle: Text(
                          'https://www.linkedin.com/in/hermi-zied/',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomSheet: Container(
           color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${global.appLocaleValues['fol_on']}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      child: InkWell(
                        child: Icon(
                          MdiIcons.facebook,
                          size: 60,
                          color: Colors.blue[900],
                        ),
                        onTap: () {
                          _onFacebook();
                        },
                      ),
                    ),
                    Card(
                      child: InkWell(
                        child: Icon(
                          MdiIcons.twitter,
                          size: 60,
                          color: Colors.lightBlueAccent[100],
                        ),
                        onTap: () {
                          _onTwitter();
                        },
                      ),
                    ),
                    Card(
                      child: InkWell(
                        child: Icon(
                          MdiIcons.instagram,
                          size: 60,
                          color: Colors.purple,
                        ),
                        onTap: () {
                          _onInstagram();
                        },
                      ),
                    ),
                    Card(
                      child: InkWell(
                        child: Icon(
                          MdiIcons.linkedin,
                          size: 60,
                          color: Colors.lightBlue[800],
                        ),
                        onTap: () {
                          _onLinkedIn();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkBackPress() async {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen(a: widget.analytics, o: widget.observer)));
    return false;
  }

  _onFacebook() async {
    const url = 'https://www.linkedin.com/in/hermi-zied/';
    if (await canLaunch(url)) {
      global.isAppOperation = true;
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onInstagram() async {
    const url = 'https://www.linkedin.com/in/hermi-zied/';
    if (await canLaunch(url)) {
      global.isAppOperation = true;
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onLinkedIn() async {
    const url = 'https://www.linkedin.com/in/hermi-zied/';
    if (await canLaunch(url)) {
      global.isAppOperation = true;
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onTwitter() async {
    const url = 'https://www.linkedin.com/in/hermi-zied/';
    if (await canLaunch(url)) {
      global.isAppOperation = true;
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _onWebsite() async {
    const url = 'https://www.linkedin.com/in/hermi-zied/';
    if (await canLaunch(url)) {
      global.isAppOperation = true;
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
