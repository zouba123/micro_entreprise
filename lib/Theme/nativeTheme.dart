// ignore_for_file: file_names, unnecessary_this, prefer_const_constructors, use_key_in_widget_constructors, no_logic_in_create_state, prefer_is_empty,  unnecessary_string_interpolations,  unnecessary_overrides, avoid_print, prefer_typing_uninitialized_variables, prefer_final_fields, sized_box_for_whitespace, deprecated_member_use, prefer_void_to_null, avoid_returning_null_for_void, constant_identifier_names, avoid_function_literals_in_foreach_calls, avoid_unnecessary_containers, prefer_adjacent_string_concatenation, prefer_if_null_operators, prefer_null_aware_operators, prefer_const_declarations, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, prefer_conditional_assignment, library_prefixes, avoid_single_cascade_in_expression_statements, prefer_collection_literals, unnecessary_const, unused_local_variable
import 'package:flutter/material.dart';

Map<int, Color> color = {
  50: Color.fromRGBO(0, 118, 188, .1),
  100: Color.fromRGBO(0, 118, 188, .2),
  200: Color.fromRGBO(0, 118, 188, .3),
  300: Color.fromRGBO(0, 118, 188, .4),
  400: Color.fromRGBO(0, 118, 188, .5),
  500: Color.fromRGBO(0, 118, 188, .6),
  600: Color.fromRGBO(0, 118, 188, .7),
  700: Color.fromRGBO(0, 118, 188, .8),
  800: Color.fromRGBO(0, 118, 188, .9),
  900: Color.fromRGBO(0, 118, 188, 1),
};

ThemeData nativeTheme() {
  return ThemeData(
    
      primaryColor: Color(0xff0d6b78),
      primaryColorLight: Color(0xFF7c7e7d),
      primaryColorDark: Color(0xFF000000),
      primarySwatch: MaterialColor(0xFF000000, color),
      primaryIconTheme: IconThemeData(color: Color(0xFF0076bc)),
      accentIconTheme: IconThemeData(color: Colors.white),
      iconTheme: IconThemeData(color: Color(0xFF0076bc)),
      textSelectionTheme: TextSelectionThemeData(cursorColor: Color(0xFF000000), selectionHandleColor: Color(0xFF000000)),
      primaryTextTheme: TextTheme(
       button: TextStyle(color: Color(0xFF7c7e7d),fontSize:12),
      headline1: TextStyle(color: Color(0xFF0076bc), fontWeight: FontWeight.normal, fontSize: 16),
      headline2: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16), 
      headline3: TextStyle(color: Color(0xFF000000), fontSize: 16), 
      headline5: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w500, fontSize: 20), 
      headline6: TextStyle(color: Color(0xFF7c7e7d), fontWeight: FontWeight.normal, fontSize: 16), 
      subtitle2: TextStyle(color: Color(0xFF7c7e7d), fontSize: 13, fontWeight: FontWeight.w500), 
      subtitle1: TextStyle(color: Color(0xFF000000), fontSize: 15, fontWeight: FontWeight.w600), 
      overline: TextStyle(color: Color(0xFF000000), fontSize: 14, fontWeight: FontWeight.w500,letterSpacing: 0), 
      bodyText1: TextStyle(color: Color(0xFF0076bc), fontSize: 15, fontWeight: FontWeight.w500),
      bodyText2: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500,letterSpacing: 0),
      caption: TextStyle(color: Color(0xFF000000), fontSize: 12, fontWeight: FontWeight.normal,letterSpacing: 0)
       ),
      scaffoldBackgroundColor: Colors.white,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF0076bc),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: Colors.white,
        titleTextStyle:  TextStyle(color: Color(0xFF0076bc), fontWeight: FontWeight.normal, fontSize: 16),
        contentTextStyle:  TextStyle(color: Color(0xFF000000), fontSize: 16), 
    
        ),
      fontFamily: 'Whitney',
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        height: 50,
        buttonColor: Color(0xFF0076bc),
        focusColor: Color(0xFF0076bc),
        highlightColor: Color(0xFF0076bc),
        hoverColor: Color(0xFF0076bc),
        splashColor: Color(0xFF0076bc),
        disabledColor: Colors.grey,
        // colorScheme: ColorScheme(
        //   onPrimary: Color(0xFF0076bc),
        //   background: Color(0xFF0076bc),
        //   brightness: Brightness.light,
        //   error: Color(0xFF0076bc),
        //   onBackground: Color(0xFF0076bc),
        //   onError: Color(0xFF0076bc),
        //   onSecondary: Color(0xFF0076bc),
        //   onSurface: Color(0xFF0076bc),
        //   primary: Color(0xFF0076bc),
        //   primaryVariant: Color(0xFF0076bc),
        //   secondary: Color(0xFF0076bc),
        //   secondaryVariant: Color(0xFF0076bc),
        //   surface: Color(0xFF0076bc),
        // ),
        shape: RoundedRectangleBorder(borderRadius:  BorderRadius.all( Radius.circular(10.0))),
      ),
      cardTheme: CardTheme(
        elevation: 0.5,
        margin: EdgeInsets.all(3),
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Color(0xFF7c7e7d), fontWeight: FontWeight.normal, fontSize: 16),
        labelStyle: TextStyle(color: Color(0xFF0076bc), fontWeight: FontWeight.normal, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(width: 0.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Color(0xFF7c7e7d)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF000000)),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[200])),

        filled: false,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      dividerTheme: DividerThemeData(color: Colors.black38),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20), 
        color: Color(0xFF0076bc),
        elevation: 0,
        actionsIconTheme: IconThemeData(color: Colors.white, size: 30),
        iconTheme: IconThemeData(color: Colors.white, size: 24),
      ),
      tabBarTheme: TabBarTheme(
       
    
        // indicator: BoxDecoration(
        //   color: Color(0xFF0076bc),
        //   borderRadius: BorderRadius.circular(10),
        //   // border: Border.all(width: 2,color:Color(0xFF0076bc), )
        // ),
        labelColor: Colors.white,
        unselectedLabelColor: Color(0xFF000000),
         labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
         unselectedLabelStyle: TextStyle( fontWeight: FontWeight.w400, fontSize: 17),
      ),
      popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedIconTheme: IconThemeData(color:Color(0xFF0076bc),

         ),
         elevation: 1,
         selectedItemColor:Color(0xFF0076bc) ,
         unselectedItemColor:Colors.white.withOpacity(0.8),
         backgroundColor: Color(0xFF000000),
         type: BottomNavigationBarType.fixed,
         selectedLabelStyle: TextStyle(color: Color(0xFF0076bc), fontWeight: FontWeight.normal, fontSize: 16),
         unselectedIconTheme:IconThemeData(color: Colors.white.withOpacity(0.8)),
unselectedLabelStyle:  TextStyle(color: Color(0xFF7c7e7d), fontWeight: FontWeight.normal, fontSize: 16), 
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFF0076bc)),
          elevation: MaterialStateProperty.all(0.5),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          padding: MaterialStateProperty.all(EdgeInsets.all(8)),
          ),

        ),
      
        
      );
      
     
}
