// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_const_constructors

import 'dart:async';
import 'package:background_fetch/background_fetch.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/splashScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void backgroundFetchHeadlessTask(String taskId) async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int v = pref.getInt('temp');
    if (v == null) {
      v = 1;
    } else {
      v = v + 1;
    }
    pref.setInt('temp', v);
  } catch (e) {
    print('exception: backgroundFetchHeadlessTask ${e.toString()}');
  }

  BackgroundFetch.finish(taskId);
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  static dynamic analytics;
  static dynamic observer;
  final String routeName = "main";

  @override
  void initState() {
    super.initState();
    global.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: (id, title, body, payload) => onSelectNotification(payload));

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    global.flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    // initReferrerDetails();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      // screen orientation/rotation off
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      title: global.appName,
      // navigatorObservers: <NavigatorObserver>[observer],
      theme: nativeTheme(),
      home: SplashScreen(a: analytics, o: observer),
    );
  }

  Future onSelectNotification(String payload) async {
    try {
      if (payload != null) {
        global.payload = payload;
        setState(() {});
      }
    } catch (e) {
      print("Exception - main.dart - onSelectNotification(): " + e.toString());
    }
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 1,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresDeviceIdle: false,
        ), (String taskId) async {
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        int v = pref.getInt('temp');
        if (v == null) {
          v = 1;
        } else {
          v = v + 1;
        }
        pref.setInt('temp', v);
      } catch (e) {
        print('exception: backgroundFetchHeadlessTask ${e.toString()}');
      }
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError(
      (e) {
        print('[BackgroundFetch] configure ERROR: $e');
      },
    );
  }
}
