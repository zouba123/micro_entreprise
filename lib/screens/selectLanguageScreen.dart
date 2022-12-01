// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/theme/nativeTheme.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/registrationIntroSlidesScreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SelectLanguageScreen extends BaseRoute {
  final int screenId;
  SelectLanguageScreen({a, o, this.screenId}) : super(a: a, o: o, r: 'SelectLanguageScreen');
  @override
  _SelectLanguageScreenState createState() => _SelectLanguageScreenState(this.screenId);
}

class _SelectLanguageScreenState extends BaseRouteState {
  final int screenId;
  List<SelectedLanguage> _selectedLangugeList;
  List<SelectedLanguage> _tselectedLangugeList = [];
  _SelectLanguageScreenState(this.screenId) : super();
  Future<List<dynamic>> languageList;
  bool setLanguage = false;
  dynamic oldAppLanguage;
  Future<List<dynamic>> _getLanguageList() async {
    try {
      List<dynamic> _tlist = await br.systemLanguageGetList();
      _tlist.map((e) => _tselectedLangugeList.add(SelectedLanguage(langugage: e, value: false))).toList();
      _selectedLangugeList.addAll(_tselectedLangugeList);

      if (global.appLanguage != null) {
        _selectedLangugeList.forEach((e) {
          if (e.langugage['name'] == global.appLanguage['name']) {
            e.value = true;
          }
        });
      }
      setState(() {});
      return _selectedLangugeList;
    } catch (e) {
      print("Exception - selectLanguageScreen.dart - _getLanguageList():");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _getInit();
  }

  Future _getInit() async {
    try {
      oldAppLanguage = global.appLanguage;
      _selectedLangugeList = [];
      languageList = _getLanguageList();
      setState(() {});
    } catch (e) {
      print("Exception - selectLanguageScreen.dart - _getInit():");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: setLanguage == false
          ? () async {
              if (screenId != null) {
                global.appLanguage = oldAppLanguage;
                await br.setSystemLanguage();
                Navigator.of(context).pop();
              } else {
                exitAppDialog(1);
              }
              return null;
            }
          : null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            // here the desired height
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: AppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                //    centerTitle: true,
                leading: screenId != null
                    ? BackButton(
                        color: Theme.of(context).primaryColorLight,
                        onPressed: setLanguage == false
                            ? () async {
                                global.appLanguage = oldAppLanguage;
                                await br.setSystemLanguage();
                                Navigator.of(context).pop();
                              }
                            : null,
                      )
                    : null,
                title: Text(
                  global.appLocaleValues['tle_selectLanguage'],
                  style: TextStyle(fontSize: 30, color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),
                ),
              ),
            )),
        body: WillPopScope(
          onWillPop: () {
            if (screenId != null) {
              Navigator.of(context).pop();
            }
            return null;
          },
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30,
                ),
                FutureBuilder(
                    future: languageList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData != null) {
                          return ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _selectedLangugeList.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                  child: Card(
                                    child: ListTile(
                                      title: Text("${_selectedLangugeList[index].langugage['title']}"),
                                      subtitle: Text("${_selectedLangugeList[index].langugage['name']}"),
                                      leading: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColorLight,
                                        child: Text(
                                          '${_selectedLangugeList[index].langugage['symbol']}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      trailing: (_selectedLangugeList[index].value == true)
                                          ? Icon(
                                              Icons.check,
                                              color: Theme.of(context).primaryColorLight,
                                              size: 30,
                                            )
                                          : SizedBox(),
                                      onTap: () async {
                                        _selectedLangugeList.forEach((e) {
                                          e.value = false;
                                        });
                                        _selectedLangugeList[index].value = true;
                                        global.appLanguage = _selectedLangugeList[index].langugage;
                                        await br.setSystemLanguage();
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              });
                        } else {
                          print('Data is null');
                          return null;
                        }
                      } else {
                        print("waiting");
                        return Card(
                          shape: nativeTheme().cardTheme.shape,
                          child: Text('Waiting'),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
        bottomSheet: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 20),
            child: MaterialButton(
              textColor: Colors.white,
              height: 50,
              minWidth: MediaQuery.of(context).size.width,
              color: Theme.of(context).primaryColor,
              onPressed: setLanguage == false
                  ? () async {
                      setLanguage = true;
                      setState(() {});
                      await _languageSelected();
                      setLanguage = false;
                      setState(() {});
                      if (screenId != null) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).push(PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: RegistrationIntroSlidesScreen(
                              a: widget.analytics,
                              o: widget.observer,
                            )));
                      }
                    }
                  : null,
              child: Text(
                global.appLocaleValues['btn_select'],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _languageSelected() async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.appLanguageCode, global.appLanguage['languageCode'].toString());

      await br.setSystemLanguage();
    } catch (e) {
      print('Exception - selectLanguageScreen.dart - _languageSelected(): ' + e.toString());
    }
  }
}

class SelectedLanguage {
  dynamic langugage;
  bool value = false;
  SelectedLanguage({this.langugage, this.value});
}
