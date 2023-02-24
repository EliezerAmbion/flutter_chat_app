class HelperFunction {
  static String getId(String? text) {
    int underscoreIndex = text?.indexOf('_') ?? -1;
    if (underscoreIndex == -1) {
      return '';
    }
    return text!.substring(0, underscoreIndex);
  }

  static String getName(String text) {
    return text.substring(text.indexOf('_') + 1);
  }
}
