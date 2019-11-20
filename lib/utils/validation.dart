class Validation {
  static bool isValidEmail(String email) {
    return email != null && email.contains('@');
  }

  static bool isValidPassword(String password) {
    return password != null && password.length > 6;
  }
}