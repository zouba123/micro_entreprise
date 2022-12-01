// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:accounting_app/models/accountModel.dart';
import 'package:accounting_app/models/accountSearchModel.dart';
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;
import 'package:accounting_app/screens/accountScreen.dart';
import 'package:accounting_app/screens/employeeScreen.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';

class ContactListScreen extends BaseRoute {
  final String accountType;
  final int accountCode;
  final int screenId;
  ContactListScreen({@required a, @required o, @required this.accountType, @required this.accountCode, this.screenId}) : super(a: a, o: o, r: 'ContactListScreen');
  @override
  _ContactListScreenState createState() => _ContactListScreenState(this.accountType, this.accountCode, this.screenId);
}

class SelectableContact {
  Contact contact;
  bool value;
  int screenId;

  SelectableContact({this.contact, this.value, this.screenId});
}

class _ContactListScreenState extends BaseRouteState {
//  Iterable eml;
  int accountCode;
  int screenId;
  List<SelectableContact> _contactList = [];
  List<SelectableContact> _tempList = [];
  String accountType;
  List<SelectableContact> _selectedContactsList = [];
  TextEditingController _cSearchbar =  TextEditingController();
  bool _isDataLoaded = false;
  _ContactListScreenState(this.accountType, this.accountCode, this.screenId) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((_selectedContactsList.length > 0) ? '${_selectedContactsList.length} ${global.appLocaleValues['lbl_item_selected']}' : global.appLocaleValues['tle_select_contacts'], style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          TextButton(
              child: Text(global.appLocaleValues['btn_import'], style: Theme.of(context).primaryTextTheme.headline2),
              onPressed: () async {
                await import();
              })
        ],
      ),
      body: (_isDataLoaded)
          ? Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _cSearchbar,
                    textInputAction: TextInputAction.search,
                    onChanged: (value) {
                      _searchContacts(value);
                    },
                    decoration: InputDecoration(
                      // hintText: 'Search among ${_contactList.length} contacts',
                      hintText: (global.appLanguage['name'] == 'English') ? '${global.appLocaleValues['lbl_search_contact']} ${_contactList.length}' : ' ${_contactList.length} ${global.appLocaleValues['lbl_search_contact']}',
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                (_contactList.length > 0)
                    ? Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                              itemCount: _contactList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return (_contactList[index].contact != null && _contactList[index].contact.phones.length > 0 && _contactList[index].contact.displayName != null)
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          ListTile(
                                            title: Text("${_contactList[index].contact.displayName}",style: Theme.of(context).primaryTextTheme.subtitle1),
                                            subtitle: Text("${_contactList[index].contact.phones.first.value != null ? _contactList[index].contact.phones.first.value : ''}",style: Theme.of(context).primaryTextTheme.subtitle2),
                                            leading: _contactList[index].value
                                                ? CircleAvatar(
                                                    radius: 25,
                                                    child: ClipOval(
                                                      child: Icon(Icons.check, color: Colors.white),
                                                    ),
                                                    backgroundColor: Theme.of(context).primaryColorLight)
                                                : CircleAvatar(
                                                    radius: 25,
                                                    child: ClipOval(
                                                      child: Text(
                                                        "${_contactList[index].contact.displayName != null ? _contactList[index].contact.displayName[0].toUpperCase() : ''}",
                                                        style: Theme.of(context).primaryTextTheme.headline2,
                                                      ),
                                                    ),
                                                    backgroundColor: Theme.of(context).primaryColor,
                                                  ),
                                            onTap: () {
                                              _contactList[index].value = !_contactList[index].value;
                                              if (_contactList[index].value) {
                                                _selectedContactsList.add(_contactList[index]);
                                              } else {
                                                _selectedContactsList.removeWhere((f) => f.contact.displayName == _contactList[index].contact.displayName);
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          Divider()
                                        ],
                                      )
                                    : SizedBox();
                              }),
                        ),
                      )
                    : Center(child: Text(global.appLocaleValues['txt_no_contact_found'], style: TextStyle(color: Colors.grey, fontSize: 18))),
              ],
            )
          : Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
    );
  }

  Future getContacts() async {
    try {
      PermissionStatus permissionStatus = await _getPermission();

      if (permissionStatus == PermissionStatus.granted) {
        var contacts = await ContactsService.getContacts(withThumbnails: false);
        contacts.map((f) => _contactList.add(SelectableContact(contact: f, value: false))).toList();

        for (int i = 0; i < _contactList.length; i++) {
          // remove useless contacts
          if (_contactList[i].contact == null || _contactList[i].contact.displayName == null || _contactList[i].contact.phones == null || _contactList[i].contact.phones.length < 1) {
            _contactList.removeAt(i);
          }
        }
        _tempList = _contactList.map((f) => f).toList();
        setState(() {});
      } else {
        throw PlatformException(
          code: 'PERMISSION_DENIED',
          message: 'Access to location data denied',
          details: null,
        );
      }
    } catch (e) {
      print('Exception - contactListScreen.dart - getContacts() ' + e.toString());
    }
  }

  Future import() async {
    try {
      accountCode = accountCode - 1;
      for (var i = 0; i < _selectedContactsList.length; i++) {
        if (_selectedContactsList[i].value) {
          accountCode++;
          int result = await dbHelper.accountInsert(Account.fromContactMap(_selectedContactsList[i].contact, accountType, accountCode));
          try {
            if (result > 0 && _selectedContactsList[i].contact.birthday != null) {
              DateTime _birthday = DateTime(_selectedContactsList[i].contact.birthday.year, _selectedContactsList[i].contact.birthday.month, _selectedContactsList[i].contact.birthday.day);
              String _notificationTime = br.getSystemFlagValue(global.systemFlagNameList.notificationTime);
              TimeOfDay tod = br.stringToTimeOfDay(_notificationTime);
              int notificationId = int.parse(global.moduleIds['Account'].toString() + '02' + result.toString());
              await br.scheduleNotification(notificationId, br.getNextEventDate(_birthday).add( Duration(hours: tod.hour, minutes: tod.minute)), '${_selectedContactsList[i].contact.givenName} ${_selectedContactsList[i].contact.familyName != null ? _selectedContactsList[i].contact.familyName : _selectedContactsList[i].contact.givenName}\'s Birthday',
                  'on ${DateFormat('MMMM dd').format(_birthday)}', '{"module":"Account","id":"$result"}',
                  setNextDate: true);
            }
          } catch (e) {
            print('Exception: contactListScreen - import().ScheduleBirthDayNotification(): $e');
          }
        }
      }
      if (screenId == 1) {
        AccountSearch accountSearch =  AccountSearch();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>  AccountScreen(
                   redirectToCustomersTab: (accountType == 'Customer') ? true : false,
                  a: widget.analytics,
                  o: widget.observer,
                  accountSearch: accountSearch,
                 
                )));
      } else if (screenId == 2) {
        AccountSearch accountSearch =  AccountSearch();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>  EmployeeScreen(
                  redirectToCustomersTab: (accountType == 'Employee') ? true : false,
                  a: widget.analytics,
                  o: widget.observer,
                  accountSearch: accountSearch,
                )));
      }
    } catch (e) {
      print('Exception - contactListScreen.dart - import() ' + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future _getData() async {
    try {
      await getContacts();
      _isDataLoaded = true;

      setState(() {});
    } catch (e) {
      print('Exception - contactListScreen.dart - _getData() ' + e.toString());
    }
  }

  Future<PermissionStatus> _getPermission() async {
    try {
      PermissionStatus permissionStatus = await Permission.contacts.status;
      if (permissionStatus != PermissionStatus.granted) {
        permissionStatus = await Permission.contacts.request();
      }
      return permissionStatus;
    } catch (e) {
      print('Exception - contactListScreen.dart - _getPermission() ' + e.toString());
      return null;
    }
  }

  void _searchContacts(String query) {
    try {
      _isDataLoaded = false;
      _contactList.clear();
      if (query.length > 0) {
        _contactList = _tempList
            .where((c) => (c.contact.displayName != null)
                ? c.contact.displayName.toLowerCase().contains(query.toLowerCase()) ||
                    (c.contact.phones.length > 0 && c.contact.phones.first.value.toLowerCase().contains(query.toLowerCase())) ||
                    (c.contact.phones.length > 1 && c.contact.phones.elementAt(1).value.toLowerCase().contains(query.toLowerCase())) ||
                    (c.contact.phones.length > 2 && c.contact.phones.elementAt(2).value.toLowerCase().contains(query.toLowerCase()))
                : false)
            .toList();
      } else {
        //  _contactList = _tempList.map((f) => f).toList();
        _contactList.addAll(_tempList);
      }
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      print('Exception - contactListScreen.dart - searchbar() ' + e.toString());
    }
  }
}
