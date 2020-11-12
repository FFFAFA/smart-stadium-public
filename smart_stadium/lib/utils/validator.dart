class Validator {

  String validatePassword(String value) {
    if(value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6){
      return 'Password should be at least 6 characters';
    }
    return null;
  }

  String validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Please enter your E-mail address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // The email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Invalid E-mail format';
  }

  String validateUsername(String value) {
    if(value.isEmpty) {
      return 'Please enter a username';
    } else if (value.length > 24){
      return "Maximum length: 24 characters";
    }
    return null;
  }

}

