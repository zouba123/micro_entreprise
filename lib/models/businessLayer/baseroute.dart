// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
//import 'package:audioplayers/audio_cache.dart';
import 'package:accounting_app/models/businessLayer/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseRoute extends Base {
  ///a = analytics, o = observer, r = routeName
  BaseRoute({a, o, r}) : super(routeName: r, analytics: a, observer: o);

  @override
  BaseRouteState createState() => BaseRouteState();
}

class BaseRouteState extends BaseState with RouteAware {
  //AudioCache audioPlayer = AudioCache();

  BaseRouteState() : super();

  @override
  Widget build(BuildContext context) => null;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   widget.observer.subscribe(this, ModalRoute.of(context));
  // }

  @override
  void didPopNext() {
    // _setCurrentScreen();
    // _sendAnalyticsEvent();
  }

  @override
  void didPush() {
    // _setCurrentScreen();
    // _sendAnalyticsEvent();
  }

  @override
  void dispose() {
    // widget.observer.unsubscribe(this);
    super.dispose();
  }

  // void hideLoader() {
  //   Navigator.pop(context);
  // }

  @override
  void initState() {
    super.initState();
    // _setCurrentScreen();
    // _sendAnalyticsEvent();
  }

  // ignore: annotate_overrides
  play(String url) async {
    //await audioPlayer.play(url);
  }

  // Future<void> _sendAnalyticsEvent() async {
  //   await widget.observer.analytics.logEvent(
  //     name: widget.routeName,
  //     parameters: <String, dynamic>{},
  //   );
  //   //print('logEvent: $routeName succeeded');
  // }

  // Future<void> _setCurrentScreen() async {
  //   await widget.observer.analytics.setCurrentScreen(
  //     screenName: widget.routeName,
  //     screenClassOverride: widget.routeName,
  //   );
//    print('setCurrentScreen: $routeName succeeded');
  // }
}
