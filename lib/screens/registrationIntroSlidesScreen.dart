// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:accounting_app/models/businessLayer/baseRoute.dart';
import 'package:accounting_app/screens/registrationAskPermissionsScreen.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:page_transition/page_transition.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:accounting_app/models/businessLayer/global.dart' as global;

class RegistrationIntroSlidesScreen extends BaseRoute {
  RegistrationIntroSlidesScreen({@required a, @required o}) : super(a: a, o: o, r: 'RegistrationIntroSlidesScreen');
  @override
  _RegistrationIntroSlidesScreenState createState() => _RegistrationIntroSlidesScreenState();
}

class _RegistrationIntroSlidesScreenState extends BaseRouteState {
  List<Slide> slides = [];

  _RegistrationIntroSlidesScreenState() : super();
  @override
  Widget build(BuildContext context) {
    slide(context);
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          await exitAppDialog(1);
          return null;
        },
        child: IntroSlider(
          slides: this.slides,
          colorActiveDot: Theme.of(context).primaryColor,
          colorDot: Theme.of(context).primaryColorLight,
          showSkipBtn: true,
          renderSkipBtn: Text('${global.appLocaleValues['btn_skip']}',style:  Theme.of(context).primaryTextTheme.headline3,),
         showDoneBtn: true,
        renderDoneBtn: Text('${global.appLocaleValues['btn_done']}', style:Theme.of(context).primaryTextTheme.headline2),
          onDonePress: () async {
            await _introductionDone();
            Navigator.of(context).push(PageTransition(
                type: PageTransitionType.rightToLeft,
                child: RegistrationAskPermissionsScreen(
                  a: widget.analytics,
                  o: widget.observer,
                )));
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void slide(BuildContext context) {
    slides.clear();
    slides.add( Slide(
        title: global.appLocaleValues['tle_invoices_payents'],
        foregroundImageFit: BoxFit.fill,
        styleTitle: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
        marginTitle: EdgeInsets.only(top: 40, bottom: 30),
        centerWidget: FittedBox(
          fit: BoxFit.fitHeight,
          child: Container(
            width: 150,
            height: 150,
            child: Icon(
              FontAwesomeIcons.fileInvoice,
              size: 80,
              color: Theme.of(context).primaryColorDark,
            ),
            decoration: BoxDecoration(
              borderRadius:  BorderRadius.all( Radius.circular(200.0)),
              border:  Border.all(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            margin: EdgeInsets.only(bottom: 0, top: 0),
          ),
        ),
        widgetDescription: Container(
          margin: EdgeInsets.only(top: 01),
          height: MediaQuery.of(context).size.height - 500,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                    title: Text(
                      global.appLocaleValues['txt_tax_invoices'],
                      style:Theme.of(context).primaryTextTheme.headline5
                    ),
                    leading: Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: Theme.of(context).primaryColorLight,
                    )),
                ListTile(
                    title: Text(
                      global.appLocaleValues['txt_share_print'],
                      style:Theme.of(context).primaryTextTheme.headline5
                    ),
                    leading: Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: Theme.of(context).primaryColorLight,
                    )),
                ListTile(
                    title: Text(
                      global.appLocaleValues['txt_send_payment_notification'],
                      style:Theme.of(context).primaryTextTheme.headline5
                    ),
                    leading: Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: Theme.of(context).primaryColorLight,
                    )),
                ListTile(
                    title: Text(
                      global.appLocaleValues['txt_view_customers_due'],
                      style:Theme.of(context).primaryTextTheme.headline5
                    ),
                    leading: Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: Theme.of(context).primaryColorLight,
                    ))
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        backgroundOpacity: 50));
    slides.add( Slide(
        title: global.appLocaleValues['tle_tax'],
        styleTitle: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
        marginTitle: EdgeInsets.only(top: 40, bottom: 30),
        centerWidget: Container(
          height: 150,
          width: 150,
          child: Icon(
            FontAwesomeIcons.percentage,
            size: 80,
            color: Theme.of(context).primaryColorDark,
          ),
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.all( Radius.circular(200.0)),
            border:  Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        widgetDescription: SizedBox(
          height: 160,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top: 20)),
                ListTile(
                    title: Text(
                      global.appLocaleValues['txt_setup_tax'],
                      style:Theme.of(context).primaryTextTheme.headline5
                    ),
                    leading: Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: Theme.of(context).primaryColorLight,
                    )),
                Padding(padding: const EdgeInsets.only(top: 20)),
                ListTile(
                    title: Text(
                      global.appLocaleValues['txt_apply_productwise_tax'],
                     style:Theme.of(context).primaryTextTheme.headline5
                    ),
                    leading: Icon(
                      Icons.check_circle_outline,
                      size: 25,
                      color: Theme.of(context).primaryColorLight,
                    ))
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white));

    slides.add( Slide(
      title: global.appLocaleValues['tle_security'],
      styleTitle: TextStyle(fontSize: 30, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w500),
      marginTitle: EdgeInsets.only(top: 40, bottom: 30),
      centerWidget: Container(
        padding: EdgeInsets.only(bottom: 0),
        height: 150,
        width: 150,
        child: Icon(
          Icons.security,
          size: 80,
          color: Theme.of(context).primaryColorDark,
        ),
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.all( Radius.circular(200.0)),
          border:  Border.all(
            color: Theme.of(context).primaryColor,
           width: 2,
          ),
        ),
      ),
      widgetDescription: SizedBox(
        height: 160,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.only(top: 20)),
              ListTile(
                  title: Text(
                    global.appLocaleValues['txt_backup_restore_drive'],
                   style:Theme.of(context).primaryTextTheme.headline5
                  ),
                  leading: Icon(
                    Icons.check_circle_outline,
                    size: 25,
                    color: Theme.of(context).primaryColorLight,
                  )),
              Padding(padding: const EdgeInsets.only(top: 20)),
              ListTile(
                  title: Text(
                    global.appLocaleValues['txt_no_data_sync'],
                     style:Theme.of(context).primaryTextTheme.headline5
                  ),
                  leading: Icon(
                    Icons.check_circle_outline,
                    size: 25,
                    color: Theme.of(context).primaryColorLight,
                  ))
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    ));
  }

  Future _introductionDone() async {
    try {
      await dbHelper.systemFlagUpdateValue(global.systemFlagNameList.introductionDone, 'true');
    } catch (e) {
      print('Exception - introSlides.dart - _introductionDone(): ' + e.toString());
    }
  }
}
