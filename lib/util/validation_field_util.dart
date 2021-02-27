mixin ValidationFieldUtil {
  bool validateEmailValue(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool validatePasswordValue(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(password);
  }

  bool containsUppercase(String value) {
    String pattern = r'^(?=.*?[A-Z])';
    RegExp regExp = new RegExp(pattern);
    return !regExp.hasMatch(value);
  }

  bool containsLower(String value) {
    String pattern = r'^(?=.*?[a-z])';
    RegExp regExp = new RegExp(pattern);
    return !regExp.hasMatch(value);
  }

  bool containsNumber(String value) {
    String pattern = r'^(?=.*?[0-9])';
    RegExp regExp = new RegExp(pattern);
    return !regExp.hasMatch(value);
  }

  bool containsSpecialCharacters(String value) {
    String pattern = r'^(?=.*?[!@#\$&*~])';
    RegExp regExp = new RegExp(pattern);
    return !regExp.hasMatch(value);
  }

  bool hasNDigits(int digits, String value) {
    return (value.length >= digits);
  }
}
