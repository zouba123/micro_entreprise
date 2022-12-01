// ignore_for_file: file_names

extension NativeExtensions on String {
  String intoSentanseCase() {
    try {
      String _str = this;
      _str = _str[0].toUpperCase() + _str.substring(1).toLowerCase();
      return _str;
    } catch (e) {
      // print('Exception - businessRule.dart - intoSentanseCase(): ' + e.toString());
      return '';
    }
  }
}
