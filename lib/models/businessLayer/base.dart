// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, library_prefixes, missing_return
import 'dart:async';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:connectivity/connectivity.dart';
import 'package:accounting_app/models/businessLayer/businessRule.dart';
import 'package:accounting_app/models/businessLayer/dbHelper.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/models/businessLayer/methodResultModel.dart';
import 'package:accounting_app/models/googleHttpClientModel.dart';
import 'package:accounting_app/models/systemFlagModel.dart';
import 'package:accounting_app/screens/lockScreen.dart';
import 'package:accounting_app/screens/networkErrorScreen.dart';
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as googleDrive;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const String AD_MOB_AD_ID = 'ca-app-pub-4640362719292150/9345337593';
const String AD_MOB_APP_ID = 'ca-app-pub-4640362719292150~4476154296';
const String AD_MOB_TEST_DEVICE = 'test_device_id - run ad then check device logs for value';

class Base extends StatefulWidget {
  final dynamic analytics;
  final dynamic observer;
  final String routeName;

  // ignore: prefer_const_constructors_in_immutables
  Base({Key key, this.analytics, this.observer, this.routeName}) : super(key: key);

  @override
  BaseState createState() => BaseState();
}

class BaseState extends State<Base> with TickerProviderStateMixin, WidgetsBindingObserver {
  bool bannerAdLoaded = false;

  BusinessRule br = BusinessRule();
  DBHelper dbHelper = DBHelper(global.business);
  dynamic fileResponse;
  AnimationController _animationController;
  GoogleSignIn googleSignIn = GoogleSignIn(scopes: global.googleSignInScopeList);

  @override
  Widget build(BuildContext context) => null;

  void closeDialog() {
    Navigator.pop(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('##state: ${state.toString()}');
    if (br.getSystemFlagValue(global.systemFlagNameList.askPinAlways) == 'true' && (global.user != null && global.user.isLogin && global.user.loginPin != null)) {
      if (state == AppLifecycleState.resumed) {
        if (!global.isLockScreen && global.isUnlocked && !global.isAppOperation) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LockScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    returnScreenId: 1,
                    payload: global.payload,
                  )));
        } else if (!global.isLockScreen && !global.isAppOperation) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LockScreen(
                    a: widget.analytics,
                    o: widget.observer,
                    payload: global.payload,
                  )));
        }
        global.isAppOperation = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initObjects() {
    br = BusinessRule();
    dbHelper = DBHelper(global.business);
  }

  Future<bool> dontCloseDialog() async {
    return false;
  }

  Future logoutAppDialog() async {
    try {
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(
          global.appLocaleValues['tle_logout'],
          style: Theme.of(context).primaryTextTheme.headline1,
        ),
        content: Text(
          global.appLocaleValues['lbl_logout_message'],
          style: Theme.of(context).primaryTextTheme.headline3,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              global.appLocaleValues['btn_no'],
              style: Theme.of(context).primaryTextTheme.headline2,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              global.appLocaleValues['btn_yes'],
              style: Theme.of(context).primaryTextTheme.headline2,
            ),
            onPressed: () async {
              global.user.isLogin = false;
              await dbHelper.userUpdate(global.user);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LockScreen(
                        a: widget.analytics,
                        o: widget.observer,
                      )));
            },
          ),
        ],
      );
      showDialog(builder: (context) => dialog, context: context);
    } catch (e) {
      print('Exception - base.dart - logoutAppDialog(): ' + e.toString());
    }
  }

  Future exitAppDialog(int screenId) async {
    try {
      AlertDialog dialog = AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        title: Text(global.appLocaleValues['tle_exit'], style: Theme.of(context).primaryTextTheme.headline1),
        content: Text(
          global.appLocaleValues['lbl_exit_message'],
          style: Theme.of(context).primaryTextTheme.headline3,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_cancel'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_exit'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              Navigator.of(context).pop();
              if (screenId == 1) {
                exit(0);
              } else {
                if (br.getSystemFlagValue(global.systemFlagNameList.enableGoogleBackupRestore) == 'true' && br.getSystemFlagValue(global.systemFlagNameList.dbChanged) == 'true') {
                  await backupConfirmationDialog(context, true, true, null);
                } else {
                  exit(0);
                }
              }
            },
          ),
        ],
      );
      showDialog(builder: (context) => dialog, context: context);
    } catch (e) {
      print('Exception - base.dart - exitAppDialog(): ' + e.toString());
    }
  }

  Future backupConfirmationDialog(BuildContext context, bool _isGoogleBackupExist, bool _isAppExitAction, final _function) async {
    bool isConnected = false;
    if (_isGoogleBackupExist) {
      // show dialog if backup available
      AlertDialog dialog = AlertDialog(
        title: Text(
          global.appLocaleValues['tle_google_bacup'],
          style: TextStyle(
            color: Theme.of(context).accentColor,
          ),
        ),
        shape: nativeTheme().dialogTheme.shape,
        content: Text(
          global.appLocaleValues['tle_google_backup_desc'],
          textAlign: TextAlign.justify,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_no'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () {
              closeDialog();
              exit(0);
            },
          ),
          TextButton(
            child: Text(global.appLocaleValues['btn_yes'], style: Theme.of(context).primaryTextTheme.headline2),
            onPressed: () async {
              closeDialog();
              isConnected = await checkConnectivity();
              if (isConnected) {
                await _backUpData(true, _isAppExitAction);
                if (_function != null) {
                  await _function();
                }
                if (_isAppExitAction) {
                  Icon statusIcon;
                  if (global.googleBackupResult.statusCode == 0) {
                    statusIcon = Icon(Icons.cancel, color: Colors.red);
                  } else if (global.googleBackupResult.statusCode == 1) {
                    statusIcon = Icon(Icons.check_circle, color: Colors.green);
                  } else if (global.googleBackupResult.statusCode == 2) {
                    statusIcon = Icon(Icons.signal_wifi_off, color: Colors.grey);
                  } else {
                    statusIcon = Icon(Icons.cloud_upload, color: Colors.grey);
                  }

                  hideLoader();
                  await showStatusMessage(global.googleBackupResult.statusMessage, statusIcon);
                  exit(0);
                }
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => NetWorkErrorScreen(
                          a: widget.analytics,
                          o: widget.observer,
                        )));
              }
            },
          ),
        ],
      );

      await showDialog(context: context, builder: (_) => dialog);
    } else {
      await _backUpData(true, _isAppExitAction);
      if (_function != null) {
        await _function();
      }
    }
  }

  _backUpData(bool _isGoogleBackup, bool _isAppExitAction) async {
    try {
      if (global.googleBackupResult == null) {
        global.googleBackupResult = MethodResult();
        if (_isAppExitAction) {
          global.googleBackupResult.statusMessage = '${global.appLocaleValues['txt_taking_backup']}';
          showLoader(global.googleBackupResult.statusMessage);
        }
        if (this.mounted) {
          setState(() {});
        }
        global.googleBackupResult = await _takeGoogleBackUp();
        if (this.mounted) {
          setState(() {});
        }
        if (this.mounted) {
          setState(() {});
        }

        global.isAppStarted = false;
      }
    } catch (e) {
      print("Exception - backupAndRestoreScreen.dart - _backUpData():" + e.toString());
    }
  }

  Future<MethodResult> _takeGoogleBackUp() async {
    MethodResult result = MethodResult();
    try {
      if (br.getSystemFlagValue(global.systemFlagNameList.enableGoogleBackupRestore) == 'true') {
        bool isConnected = await checkConnectivity();
        if (isConnected) {
          bool _uploadResult = false;
          final httpClient = await handleGoogleSignIn();
          if (httpClient != null) {
            var encoder = ZipFileEncoder();
            encoder.zipDirectory(Directory(global.contentDirectoryPath), filename: global.documentsDirectoryPath + '/easyaccount.bak');
            File file = File(global.documentsDirectoryPath + '/easyaccount.bak');
            _uploadResult = await _upload(file, httpClient);
            // File _file = File(global.localBackupDirectoryPath);
            // try {
            //   if (!await _file.exists()) {
            //     await file.copy(global.localBackupDirectoryPath);
            //     _uploadResult = true;
            //   } else {
            //     await _file.delete();
            //     await file.copy(global.localBackupDirectoryPath);
            //     _uploadResult = true;
            //   }
            // } catch (e) {
            //   print(e.toString());
            // }

            if (_uploadResult) {
              result.statusCode = 1;
              result.statusMessage = '${global.appLocaleValues['txt_backup_success']}';
              await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.backUpTime, DateTime.now().toIso8601String());
              await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.dbChanged, 'false');
            } else {
              result.statusCode = 0;
              result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
            }
          } else {
            result.statusCode = 0;
            result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
            print('Google Authentication Error');
          }
        } else {
          result.statusCode = 2;
          result.statusMessage = '${global.appLocaleValues['lbl_offline']}';
        }
      }
    } catch (e) {
      result.statusCode = -1;
      result.statusMessage = '${global.appLocaleValues['txt_backup_failed']}';
      print("Exception - base.dart - _takeGoogleBackUp():" + e.toString());
    }
    return result;
  }

  Future<GoogleHttpClient> handleGoogleSignIn() async {
    try {
       if (br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail).isEmpty) {
         await googleSignIn.signIn().then((result) {
           if (result != null) {
             result.authentication.then((auth) async {
               if (auth != null && auth.accessToken.isNotEmpty) {
                 global.googleAccessToken = auth.accessToken;
               }
             });
           }
         });
         if (googleSignIn.currentUser != null && googleSignIn.currentUser.email != null && googleSignIn.currentUser.email.isNotEmpty) {
           await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.googleBackupEmail, googleSignIn.currentUser.email);
           // await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.emailForEmail, googleSignIn.currentUser.email);
         }
       } else {
         await googleSignIn.signInSilently().then((result) {
           if (result != null) {
             result.authentication.then((auth) async {
               if (auth != null && auth.accessToken.isNotEmpty) {
                 global.googleAccessToken = auth.accessToken;
               }
             });
           }
         });
       }

       if (br.getSystemFlagValue(global.systemFlagNameList.googleBackupEmail).isNotEmpty && googleSignIn.currentUser == null) {
         await googleSignIn.disconnect();
         await googleSignIn.signOut();
         await googleSignIn.signIn().then((result) {
           if (result != null) {
             result.authentication.then((auth) async {
               if (auth != null && auth.accessToken.isNotEmpty) {
                 global.googleAccessToken = auth.accessToken;
               }
             });
           }
         });
       }

       return GoogleHttpClient(await googleSignIn.currentUser.authHeaders);
    } catch (error) {
      print('Exception: backupAndRestoreScreen.dart - _handleGoogleSignIn() ' + error.toString());
      return null;
    }
  }

  Future<bool> _upload(File file, httpClient) async {
    try {
       var folderResponse;
       var fileResponse;
       String folderId;
       var drive = googleDrive.DriveApi(httpClient);
       var folder = await drive.files.list(q: "name='${global.googleDriveBackupFolder}' and mimeType='application/vnd.google-apps.folder'");
       for (var item in folder.files) {
         print(item.name);
       }

       if (folder.files.length == 0) {
         googleDrive.File googleFolder = googleDrive.File();
         googleFolder.name = global.googleDriveBackupFolder;
         googleFolder.mimeType = 'application/vnd.google-apps.folder';
         folderResponse = await drive.files.create(googleFolder);

         if (folderResponse != null) {
           folderId = folderResponse.id;
         } else {
           print('Unable to create backup folder');
         }
       } else {
         folderId = folder.files[0].id;
       }

       googleDrive.File googleFile = googleDrive.File();
       googleFile.name = p.basename(file.absolute.path);

       if (folderId != "") {
         print(file.absolute.path);
         await drive.files.list(q: "name='${p.basename(file.absolute.path)}' and '$folderId' in parents").then((response) async {
           if (response.files.length > 0) {
             fileResponse = await drive.files.update(
               googleFile,
               response.files[0].id,
               uploadMedia: googleDrive.Media(
                 file.openRead(),
                 file.lengthSync(),
               ),
             );
           } else {
             googleFile.parents = [folderId].toList();
             fileResponse = await drive.files.create(
               googleFile,
               uploadMedia: googleDrive.Media(
                 file.openRead(),
                 file.lengthSync(),
               ),
             );
           }
         }).catchError((error) async {
           print('Unable to sync backup file');
         });
       }
       if (fileResponse != null) {
         print(fileResponse.id);
         return true;
       }
    } catch (err) {
      print(err.toString());
    }
    return false;
  }

  void hideLoader() {
    Navigator.pop(context);
  }

  Future initializeSystemFlags() async {
    global.systemFlagList = await dbHelper.systemFlagGetList();
  }

  @override
  void initState() {
    super.initState();
    initObjects();
    _animationController = AnimationController(vsync: this, duration: Duration(microseconds: 3000));
  }

  Future loadsystemDirectoryPath() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      global.documentsDirectoryPath = documentsDirectory.path;
      Directory tempDirectory = await getTemporaryDirectory();
      global.tempDirectoryPath = tempDirectory.path;
      global.contentDirectoryPath = global.documentsDirectoryPath + '/Content/';
      global.accountvCardExportPath = global.contentDirectoryPath + 'vCard';
      global.accountImagesDirectoryPath = global.contentDirectoryPath + 'AccountsImages';
      global.productsImagesDirectoryPath = global.contentDirectoryPath + 'ProductsImages';
      global.businessImagesDirectoryPath = global.contentDirectoryPath + 'BusinessesImages';
      global.purchaseBillsDirectoryPath = global.contentDirectoryPath + 'PurchaseBills';
      global.expenseBillsDirectoryPath = global.contentDirectoryPath + 'ExpenseBills';
      global.localBackupDirectoryPath = '/storage/emulated/0/Download/'; //_downloadsDirectory.path;
      Directory d = Directory(global.contentDirectoryPath);
      if (!await d.exists()) {
        await d.create();
      }
      Directory accountPhotos = Directory(global.accountImagesDirectoryPath);
      if (!await accountPhotos.exists()) {
        await accountPhotos.create();
      }

      Directory businessPhotos = Directory(global.businessImagesDirectoryPath);
      if (!await businessPhotos.exists()) {
        await businessPhotos.create();
      }

      Directory purchaseBills = Directory(global.purchaseBillsDirectoryPath);
      if (!await purchaseBills.exists()) {
        await purchaseBills.create();
      }

      Directory productsPhotos = Directory(global.productsImagesDirectoryPath);
      if (!await productsPhotos.exists()) {
        await productsPhotos.create();
      }

      Directory expenseBillsDirectoryPath = Directory(global.expenseBillsDirectoryPath);
      if (!await expenseBillsDirectoryPath.exists()) {
        await expenseBillsDirectoryPath.create();
      }

      Directory accountvCardExport = Directory(global.accountvCardExportPath);
      if (!await accountvCardExport.exists()) {
        await accountvCardExport.create();
      }
    } catch (err) {
      print('loadsystemDirectoryPath() Exception: ' + err.toString());
    }
  }

  Future showInfoMessage(String title, String flagName, Icon statusIcon) async {
    SystemFlag _systemFlag = br.getSystemFlag(flagName);
    _animationController.forward();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        contentPadding: const EdgeInsets.only(bottom: 10.0, left: 24, right: 24, top: 20),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            statusIcon,
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
          ],
        ),
        content: Text(
          '${_systemFlag.description}',
          textAlign: TextAlign.justify,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('${global.appLocaleValues['btn_ok']}'),
            onPressed: () {
              closeDialog();
            },
          ),
        ],
      ),
    );
  }

  void showLoader(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: dontCloseDialog,
        child: AlertDialog(
          shape: nativeTheme().dialogTheme.shape,
          contentPadding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              Text('$message'),
            ],
          ),
        ),
      ),
    );
  }

  Widget showLoader2(String message) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
              child: Text('$message'),
            ),
          ],
        ),
      ),
    );
  }

  Future<int> showStatusMessage(String message, Icon statusIcon) async {
    _animationController.forward();
    int result = 0;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: nativeTheme().dialogTheme.shape,
        contentPadding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
        content: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: statusIcon,
              ),
              Text('$message'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(global.appLocaleValues['btn_ok']),
            onPressed: () {
              result = 1;
              closeDialog();
            },
          ),
        ],
      ),
    );
    return result;
  }

  void showToast(String message) {
    _animationController.forward();
    showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
          return SafeArea(
            child: Builder(builder: (context) {
              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).pop(true);
              });
              {
                return Padding(
                  padding: const EdgeInsets.only(top: 400),
                  child: AlertDialog(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    shape: nativeTheme().dialogTheme.shape,
                    contentPadding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$message',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          );
        },
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            backgroundColor: Colors.blue[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            contentPadding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$message'),
              ],
            ),
          );
        });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void backupStatusRefresh() {
    if (global.backupResult != null) {
      Timer.periodic(Duration(seconds: 3), (Timer t) {
        setState(() {});

        if (global.backupResult.statusCode != null && global.backupResult.statusCode >= 0) {
          t.cancel();
          //backup success
          Timer(Duration(seconds: 3), () {
            global.backupResult = null;
            setState(() {});
          });
        }
      });
    }
  }

  Future<bool> checkConnectivity() async {
    try {
      bool isConnected;
      var _connectivity = await (Connectivity().checkConnectivity());
      if (_connectivity == ConnectivityResult.mobile) {
        isConnected = true;
      } else if (_connectivity == ConnectivityResult.wifi) {
        isConnected = true;
      } else {
        isConnected = false;
      }
      return (isConnected) ? true : false;
    } catch (e) {
      print('Exception - base.dart - checkConnectivity(): ' + e.toString());
    }
    return false;
  }
}
