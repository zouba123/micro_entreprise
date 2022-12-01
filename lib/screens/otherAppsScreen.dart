// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable

import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/screens/dashboardScreen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class OtherAppsScreen extends BaseRoute {
  OtherAppsScreen({a, o}) : super(r: 'OtherAppsScreen', a: a, o: o);

  @override
  _OtherAppsScreenState createState() => _OtherAppsScreenState();
}

class _OtherAppsScreenState extends BaseRouteState {
  //double sizeContainer, logoWidth, logoHeight, textSizeAB, logoNative, textSizePB, iconSize, sizeboxTop;
  _OtherAppsScreenState() : super();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DashboardScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
        return null;
      },
      child: Scaffold(
        appBar:  AppBar(
          title: Text(
            global.appLocaleValues['tle_others_app'],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: ListView(
              padding: const EdgeInsets.all(4.0),
              children: <Widget>[
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/eventdecor144x144.png",
                    ),
                    title: Text('Event Decor'),
                    subtitle: Text(
                      'Manage all events and generate reports whenever you need them.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.eventdecor&referrer=EasyAccount');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/securewallet144x144.png",
                    ),
                    title: Text('Secure Wallet'),
                    subtitle: Text(
                      'Manage your personal and family data and day to day expenses. Get alerts on time.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.securewallet&referrer=EasyAccount');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/wordpuzzle128x128.png",
                    ),
                    title: Text('Word Puzzle'),
                    subtitle: Text(
                      'An interesting game to improve vocabulary by finding words from letters provided.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.wordpuzzle&referrer=EasyAccount');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/kidsnursery144x144.png",
                    ),
                    title: Text('Kids Nursery'),
                    subtitle: Text(
                      'A kids friendly app to learn all nursery lessons at home. All categories available.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.mathsen&referrer=EasyAccount');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/yoga4me144x144.png",
                    ),
                    title: Text('Yoga4Me - Yoga Teacher'),
                    subtitle: Text(
                      'This app provides a brief knowledge about all Yoga and Surya Namaskar positions.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.yoga4me&referrer=EasyAccount');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/kidsabcd144x144.png",
                    ),
                    title: Text('Kids ABCD (Pre-Nursery)'),
                    subtitle: Text(
                      'A best application to teach your child numbers and alphabets.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.kidsabcd&referrer=EasyAccount');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/wishkarts150x150.png",
                    ),
                    title: Text('WishKarts'),
                    subtitle: Text(
                      'On online e-commerce store. Visit once to check all products.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.wishkarts&referrer=EasyCounter');
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    leading: Image.asset(
                      "assets/images/easycounter144x144.png",
                    ),
                    title: Text('EasyCounter'),
                    subtitle: Text(
                      'An easy counter is a user-friendly counting app specially designed for chanting.',
                      textAlign: TextAlign.justify,
                    ),
                    onTap: () {
                      _onAppTap('https://play.google.com/store/apps/details?id=com.nat.easycounter&referrer=EasyAccount');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onAppTap(String appPlayStoreURL) async {
    try {
      if (await canLaunch(appPlayStoreURL)) {
        await launch(appPlayStoreURL);
      } else {
        throw 'Could not launch ' + appPlayStoreURL;
      }
    } catch (e) {
      //log(e.toString());
    }
  }
}
