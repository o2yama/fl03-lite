final validator = Validator.instance;

class Validator {
  Validator._();
  static final instance = Validator._();

  bool validEmail(String email) {
    if (RegExp(r'^[0-9a-zA-Z.!#$%&*+/=?^_`'
                r'{|}~-]+@[a-zA-Z0-9-]+[a-zA-Z0-9-]')
            .hasMatch(email) &&
        email.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool validPassword(String password) {
    if (RegExp('[0-9a-zA-Z]').hasMatch(password) &&
        password.length >= 6 &&
        password.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
