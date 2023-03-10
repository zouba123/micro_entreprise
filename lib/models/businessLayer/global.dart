// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, library_prefixes

import 'package:accounting_app/models/businessLayer/methodResultModel.dart';
import 'package:accounting_app/models/businessModel.dart';
import 'package:accounting_app/models/countryModel.dart';
import 'package:accounting_app/models/currencyModel.dart';
import 'package:accounting_app/models/systemFlagModel.dart';
import 'package:accounting_app/models/systemFlagNameListModel.dart';
import 'package:accounting_app/models/taxMasterModel.dart';
import 'package:accounting_app/models/userModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/drive/v3.dart' as googleDrive;

String accountImagesDirectoryPath;
bool appHapticFeedback = true;
String appName = 'Gestion Entreprise';
String playStoreURL = '';
String appStoreURL = '';
String appShareMessage = "You should try this *Accounting* app to manage your business transactions. Click on below link to Download\nFor Android https://www.linkedin.com/in/hermi-zied/\nFor IOS https://www.linkedin.com/in/hermi-zied/";
bool appSound = true;
String appVersion = '1.0';
bool availableBiometrics = false;
Business business;
dynamic appLanguage;
List<dynamic> appLanguages;
Map<String, dynamic> appLocaleValues;
String businessImagesDirectoryPath;
String contentDirectoryPath;
Currency currency = Currency('€', 'euros', 'EUR');
Country country = Country('FRANCE', '+33', 'FR');
String documentsDirectoryPath;
bool enableAd = false;
int fetchRecords = 20;
String googleDriveBackupFolder = 'AccountingAppBackup';
bool isLockScreen = false;
bool isUnlocked = false;
// bool isOtherAction = false;
String localBackupDirectoryPath;
SharedPreferences prefs;
String productsImagesDirectoryPath;
String purchaseBillsDirectoryPath;
String expenseBillsDirectoryPath;
List<SystemFlag> systemFlagList = [];
String tempDirectoryPath;
User user;
bool isAppOperation = false;
bool isAppStarted = false;
String hostName = '';
String username = '';
String password = '';
int port = 25;
String productRecipient = 'hermi.zied@gmail.com';
bool allowInsecure = true;
String dbName = "accountingApp.db";
// String globalEncryptionKey = 'TX5mt8fBq30z7xF6bkhA42K91HGQaVvM'; //Debug
String globalEncryptionKey = 'XcwkW4a0hy7OQf6lK9q853oYAHT2t1FC'; //Release
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
String payload;
Map<String, int> moduleIds = {'SaleOrder': 1010, 'Account': 1020};
MethodResult backupResult;
String accountvCardExportPath;
// ReferrerDetails referrerDetails;
SystemFlagNameList systemFlagNameList = SystemFlagNameList();
var encodedLogo;
List<TaxMaster> taxList;
List<String> googleSignInScopeList = ['email', googleDrive.DriveApi.driveFileScope, 'https://mail.google.com/'];

MethodResult googleBackupResult;
String googleAccessToken;
bool isAndroidPlatform = true;
